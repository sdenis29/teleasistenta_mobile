// ignore_for_file: sized_box_for_whitespace
import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teleasistenta_mobile/components/reusable_button.dart';
import 'package:teleasistenta_mobile/providers/patient_provider.dart';
import 'package:teleasistenta_mobile/screens/login_screen.dart';
import 'package:teleasistenta_mobile/screens/add_data_screen.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:intl/intl.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:teleasistenta_mobile/screens/medical_history_screen.dart';
import 'package:teleasistenta_mobile/screens/show_data.dart';

const alarmMessages = {
  "humMin": "Umiditatea din locuință este extrem de scăzută",
  "humMax": "Umiditatea din locuință este prea mare",
  "tempMin": "Temperatura ambientală din locuință este extrem de scăzută",
  "tempMax": "Temperatura ambientală din locuință este prea mare",
  "gas": "Senzorul de gaz a detectat concentrații periculoase în locuință",
  "pulseMin": "Senzorul de puls a detectat bătăile inimii ca fiind scăzute",
  "pulseMax": "Senzorul de puls a detectat bătăile inimii ca fiind prea multe",
  "noPresence":
      "Senzorul de proximitate nu a putut detecta pacientul în locuință"
};

void isolateEntryPoint(String message) async {
  const hc05Device = 'MLT-BT05'; // Replace with your device name

  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  // Scan for devices
  var subscription = flutterBlue.scan().listen((scanResult) async {
    // Check if the device name matches
    if (scanResult.device.name == hc05Device) {
      // Stop scanning
      flutterBlue.stopScan();

      // Connect to the device
      await scanResult.device.connect();

      // Discover services and characteristics
      List<BluetoothService> services =
          await scanResult.device.discoverServices();
      BluetoothCharacteristic characteristic =
          services.first.characteristics.first;
      StringBuffer buffer = StringBuffer();
      for (BluetoothService service in services) {
        List<BluetoothCharacteristic> characteristics = service.characteristics;
        for (BluetoothCharacteristic c in characteristics) {
          // 0000ffe1-0000-1000-8000-00805f9b34fb
          if (c.uuid.toString() == '0000ffe1-0000-1000-8000-00805f9b34fb') {
            characteristic = c;
          }
        }
      }
      characteristic.setNotifyValue(true);
      characteristic.value.listen((value) {
        buffer.write(utf8.decode(value));
        String data = buffer.toString();
        int delimiterIndex = data.indexOf('\n');
        if (delimiterIndex != -1) {
          String line = data.substring(0, delimiterIndex);
          buffer.clear();
          buffer.write(data.substring(delimiterIndex + 1));
          processLine(line);
        }
      });
    }
  });
}

void processLine(String line) async {
  var limits = await getMedicalRanges();
  limits = jsonDecode(limits);
  print(line);
  List<String> lines = line.split(";");
  int bpm = int.parse(lines[0].split("=")[1]);
  double humidity = double.parse(lines[1].split("=")[1]);
  double temperature = double.parse(lines[2].split("=")[1]);
  bool lpg = int.parse(lines[3].split("=")[1]) > 10000 ||
          int.parse(lines[3].split("=")[1]) < -10000
      ? true
      : false;
  bool co = int.parse(lines[4].split("=")[1]) > 10000 ||
          int.parse(lines[4].split("=")[1]) < -10000
      ? true
      : false;
  bool smoke = int.parse(lines[5].split("=")[1]) > 10000 ||
          int.parse(lines[5].split("=")[1]) < -10000
      ? true
      : false;
  bool gas = lpg || co || smoke ? true : false;
  bool presence = int.parse(lines[6].split("=")[1]) == 1 ? true : false;
  await setCache(bpm, humidity, temperature);
  final prefs = await SharedPreferences.getInstance();
  final uid = prefs.getString('uid') ?? null;
  if (bpm < limits["pulseMin"] ||
      bpm > limits["pulseMax"] ||
      temperature < limits["ambientTemperatureMin"] ||
      temperature > limits["ambientTemperatureMax"] ||
      gas ||
      !presence) {
    // ignore: deprecated_member_use
    DatabaseReference ambientRef = FirebaseDatabase(
            databaseURL:
                "https://teleasistenta-83ccd-default-rtdb.europe-west1.firebasedatabase.app")
        .ref("ElderTrack/patient/$uid/ambientParameters");
    DatabaseReference pushedAmbient = ambientRef.push();
    FlutterTts flutterTts = FlutterTts();
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage("ro-RO");
    await pushedAmbient.set({
      "alarms": {},
      "datetime": {
        "date": DateFormat("dd/MM/yyyy").format(DateTime.now()),
        "hour": DateFormat("HH:mm").format(DateTime.now())
      },
      "values": {
        "pulse": bpm,
        "ambientTemperature": temperature,
        "ambientHumidity": humidity,
        "gas": gas,
        "proximity": presence
      }
    });
    if (bpm < limits["pulseMin"]) {
      await pushedAmbient
          .child("alarms")
          .push()
          .set({"description": alarmMessages["pulseMin"]});
      await flutterTts.speak(alarmMessages["pulseMin"]!);
    } else if (bpm > limits["pulseMax"]) {
      await pushedAmbient
          .child("alarms")
          .push()
          .set({"description": alarmMessages["pulseMax"]});
      await flutterTts.speak(alarmMessages["pulseMax"]!);
    }
    if (temperature < limits["ambientTemperatureMin"]) {
      await pushedAmbient
          .child("alarms")
          .push()
          .set({"description": alarmMessages["tempMin"]});
      await flutterTts.speak(alarmMessages["tempMin"]!);
    } else if (temperature > limits["ambientTemperatureMax"]) {
      await pushedAmbient
          .child("alarms")
          .push()
          .set({"description": alarmMessages["tempMax"]});
      await flutterTts.speak(alarmMessages["tempMax"]!);
    }
    if (gas) {
      await pushedAmbient
          .child("alarms")
          .push()
          .set({"description": alarmMessages["gas"]});
      await flutterTts.speak(alarmMessages["gas"]!);
    }
    if (!presence) {
      await pushedAmbient
          .child("alarms")
          .push()
          .set({"description": alarmMessages["noPresence"]});
      await flutterTts.speak(alarmMessages["noPresence"]!);
    }
  }
}

Future<void> setCache(pulse, humidity, temperature) async {
  final prefs = await SharedPreferences.getInstance();
  print("PULSE: $pulse");
  await prefs.setInt('pulse', pulse);
  await prefs.setDouble('humidity', humidity);
  await prefs.setDouble('temperature', temperature);
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String lastSavedDate = prefs.getString('last_saved_date') ?? '';
  if (currentDate != lastSavedDate) {
    await prefs.remove('pulseList');
    await prefs.setString('last_saved_date', currentDate);
  } else {
    await prefs.setString('last_saved_date', currentDate);
  }
  await prefs.reload();
  List<String> newItem = [pulse.toString()];
  String encodedList = prefs.getString('pulseList') ?? '[]';
  List<String> existingList = List<String>.from(json.decode(encodedList));
  List<String> concatenatedList = existingList + newItem;
  String newEncodedList = json.encode(concatenatedList);
  prefs.setString('pulseList', newEncodedList);
}

getMedicalRanges() async {
  final prefs = await SharedPreferences.getInstance();
  final uid = prefs.getString('uid') ?? null;
  if (uid != null) {
    await Firebase.initializeApp();
    DatabaseReference ref =
        // ignore: deprecated_member_use
        FirebaseDatabase(
                databaseURL:
                    "https://teleasistenta-83ccd-default-rtdb.europe-west1.firebasedatabase.app")
            .ref("ElderTrack/patient/$uid/normalMedicalRanges");
    DatabaseEvent event = await ref.once();
    return jsonEncode(event.snapshot.value);
  }
  return null;
}

Future<void> _run() async {
  final isolate = await FlutterIsolate.spawn(
      isolateEntryPoint, "I'm taking information from sensors");
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String id = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    _run();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Pagina pacientului',
            style: TextStyle(fontSize: 21),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _auth.signOut();
              Navigator.pushNamed(context, LoginScreen.id);
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Container(
                width: 300,
                height: 300,
                child: SvgPicture.asset('assets/svgs/consult.svg'),
              ),
            ),
            ReusableButton(
              onPress: () {
                Navigator.pushNamed(context, ShowDataScreen.id);
              },
              color: Colors.red,
              buttonChild: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Text(
                  'Vizualizare date',
                  style: TextStyle(fontSize: 21),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ReusableButton(
              onPress: () {
                Navigator.pushNamed(context, AddDataScreen.id);
              },
              color: Colors.red,
              buttonChild: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Text(
                  'Adăugare date',
                  style: TextStyle(fontSize: 21),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ReusableButton(
              onPress: () {
                Navigator.pushNamed(context, MedicalHistoryScreen.id);
              },
              color: Colors.red,
              buttonChild: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Text(
                  'Detalii pacient',
                  style: TextStyle(fontSize: 21),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
