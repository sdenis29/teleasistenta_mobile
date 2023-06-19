import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:teleasistenta_mobile/providers/patient_provider.dart';
import 'package:teleasistenta_mobile/screens/history_screen.dart';
import 'package:teleasistenta_mobile/screens/home_screen.dart';
import 'package:teleasistenta_mobile/screens/login_screen.dart';
import 'package:teleasistenta_mobile/screens/medical_history_screen.dart';
import 'package:teleasistenta_mobile/screens/medical_registry_screen.dart';
import 'package:teleasistenta_mobile/screens/recommendations_screen.dart';
import 'package:teleasistenta_mobile/screens/show_data.dart';
import 'package:teleasistenta_mobile/screens/treatments_screen.dart';
import 'screens/start_screen.dart';
import 'screens/add_data_screen.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  [
    Permission.location,
    Permission.bluetooth,
    Permission.bluetoothConnect,
    Permission.bluetoothScan
  ].request().then((status) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => PatientProvider(),
        )
      ],
      child: MaterialApp(
        title: 'ElderTrack',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: const MyHomePage(title: 'Welcome to ElderTrack!'),
        initialRoute: MyHomePage.id,
        routes: {
          MyHomePage.id: (context) =>
              const MyHomePage(title: 'Welcome to ElderTrack!'),
          LoginScreen.id: (context) => const LoginScreen(),
          HomeScreen.id: (context) => const HomeScreen(),
          AddDataScreen.id: (context) => const AddDataScreen(),
          ShowDataScreen.id: (context) => const ShowDataScreen(),
          MedicalHistoryScreen.id: (context) => const MedicalHistoryScreen(),
          HistoryScreen.id: (context) => HistoryScreen(),
          MedicalRegistryScreen.id: (context) => const MedicalRegistryScreen(),
          RecommendationsScreen.id: (context) => const RecommendationsScreen(),
          TreatmentsScreen.id: (context) => const TreatmentsScreen()
        },
      ),
    );
  }
}
