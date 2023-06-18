// ignore_for_file: sized_box_for_whitespace

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teleasistenta_mobile/components/reusable_button.dart';

const alarmMessages = {
  "pressureMin": "Tensiune arterială scăzută",
  "pressureMax": "Tensiune arterială crescută",
  "glucoseMin": "Glicemie scăzută",
  "glucoseMax": "Glicemie crescută",
  "tempMin": "Temperatură corporală scăzută",
  "tempMax": "Temperatură corporală crescută",
  "weightMin": "Greutate corporală scăzută",
  "weightMax": "Greutate corporală crescută"
};

class AddDataScreen extends StatefulWidget {
  const AddDataScreen({super.key});
  static String id = 'add_data';

  @override
  State<AddDataScreen> createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  final _auth = FirebaseAuth.instance;
  final tensiune = TextEditingController();
  final greutate = TextEditingController();
  final glicemie = TextEditingController();
  final temperatura = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    tensiune.dispose();
    greutate.dispose();
    glicemie.dispose();
    temperatura.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Transform(
          transform: Matrix4.translationValues(0.0, 0.0, 0.0),
          child: const Text(
            'Adăugare date',
            style: TextStyle(fontSize: 21),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: TextField(
                  controller: tensiune,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Tensiune',
                  ),
                  keyboardType: TextInputType.number),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: TextField(
                  controller: greutate,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Greutate',
                  ),
                  keyboardType: TextInputType.number),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: TextField(
                  controller: glicemie,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Glicemie',
                  ),
                  keyboardType: TextInputType.number),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: TextField(
                  controller: temperatura,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Temperatura corporală',
                  ),
                  keyboardType: TextInputType.number),
            ),
            ReusableButton(
              onPress: () async {
                bool isParamsPresent = tensiune.text.isNotEmpty &&
                    greutate.text.isNotEmpty &&
                    glicemie.text.isNotEmpty &&
                    temperatura.text.isNotEmpty;
                if (!isParamsPresent) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content:
                            Text("Completeaza toate campurile de pe ecran."),
                      );
                    },
                  );
                  return;
                }
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('bloodPressure', tensiune.text);
                await prefs.setString('weight', greutate.text);
                await prefs.setString('glucose', glicemie.text);
                await prefs.setString('bodyTemperature', temperatura.text);
                var limits = await getMedicalRanges();
                limits = jsonDecode(limits);
                bool tensiuneOk = int.parse(tensiune.text) >=
                            limits["bloodPressureMin"] &&
                        int.parse(tensiune.text) <= limits["bloodPressureMax"]
                    ? true
                    : false;
                bool greutateOk =
                    double.parse(greutate.text) >= limits["weightMin"] &&
                            double.parse(greutate.text) <= limits["weightMax"]
                        ? true
                        : false;
                bool glicemieOk =
                    int.parse(glicemie.text) >= limits["glucoseMin"] &&
                            int.parse(glicemie.text) <= limits["glucoseMax"]
                        ? true
                        : false;
                bool temperaturaOk = double.parse(temperatura.text) >=
                            limits["bodyTemperatureMin"] &&
                        double.parse(temperatura.text) <=
                            limits["bodyTemperatureMax"]
                    ? true
                    : false;
                String alertString =
                    "ALERTĂ! Următorii parametrii nu se încadreaza în limitele declarate de către medic:\n";
                if (!tensiuneOk || !greutateOk || !glicemieOk) {
                  final prefs = await SharedPreferences.getInstance();
                  final uid = prefs.getString('uid') ?? null;
                  // ignore: deprecated_member_use
                  DatabaseReference vitalRef = FirebaseDatabase(
                          databaseURL:
                              "https://teleasistenta-83ccd-default-rtdb.europe-west1.firebasedatabase.app")
                      .ref("ElderTrack/patient/$uid/vitalParameters");
                  DatabaseReference pushedVital = vitalRef.push();
                  await pushedVital.set({
                    "alarms": {},
                    "datetime": {
                      "date": DateFormat("dd/MM/yyyy").format(DateTime.now()),
                      "hour": DateFormat("HH:mm").format(DateTime.now())
                    },
                    "values": {
                      "bloodPressure": int.parse(tensiune.text),
                      "bodyTemperature": double.parse(temperatura.text),
                      "glucose": int.parse(glicemie.text),
                      "weight": double.parse(greutate.text)
                    }
                  });
                  if (!tensiuneOk) {
                    if (int.parse(tensiune.text) < limits["bloodPressureMin"]) {
                      alertString =
                          "$alertString ${alarmMessages["pressureMin"]}\n";
                      await pushedVital
                          .child("alarms")
                          .push()
                          .set({"description": alarmMessages["pressureMin"]});
                    } else {
                      alertString =
                          "$alertString ${alarmMessages["pressureMax"]}\n";
                      await pushedVital
                          .child("alarms")
                          .push()
                          .set({"description": alarmMessages["pressureMax"]});
                    }
                  }
                  if (!greutateOk) {
                    if (double.parse(greutate.text) < limits["weightMin"]) {
                      alertString =
                          "$alertString ${alarmMessages["weightMin"]}\n";
                      await pushedVital
                          .child("alarms")
                          .push()
                          .set({"description": alarmMessages["weightMin"]});
                    } else {
                      alertString =
                          "$alertString ${alarmMessages["weightMax"]}\n";
                      await pushedVital
                          .child("alarms")
                          .push()
                          .set({"description": alarmMessages["weightMax"]});
                    }
                  }
                  if (!glicemieOk) {
                    if (int.parse(glicemie.text) < limits["glucoseMin"]) {
                      alertString =
                          "$alertString ${alarmMessages["glucoseMin"]}\n";
                      await pushedVital
                          .child("alarms")
                          .push()
                          .set({"description": alarmMessages["glucoseMin"]});
                    } else {
                      alertString =
                          "$alertString ${alarmMessages["glucoseMax"]}\n";
                      await pushedVital
                          .child("alarms")
                          .push()
                          .set({"description": alarmMessages["glucoseMax"]});
                    }
                  }
                  if (!temperaturaOk) {
                    if (double.parse(temperatura.text) <
                        limits["bodyTemperatureMin"]) {
                      alertString =
                          "$alertString ${alarmMessages["tempMin"]}\n";
                      await pushedVital
                          .child("alarms")
                          .push()
                          .set({"description": alarmMessages["tempMin"]});
                    } else {
                      alertString =
                          "$alertString ${alarmMessages["tempMax"]}\n";
                      await pushedVital
                          .child("alarms")
                          .push()
                          .set({"description": alarmMessages["tempMax"]});
                    }
                  }
                  FlutterTts flutterTts = FlutterTts();
                  await flutterTts.awaitSpeakCompletion(true);
                  await flutterTts.setLanguage("ro-RO");
                  // ignore: use_build_context_synchronously
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(content: Text(alertString));
                    },
                  );
                  await flutterTts.speak(alertString);
                }
              },
              color: Colors.red,
              buttonChild: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: height * 0.021, horizontal: width * 0.065),
                child: const Text(
                  'Adăugare valori',
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
