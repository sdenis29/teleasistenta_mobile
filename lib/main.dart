import 'package:flutter/material.dart';
import 'package:teleasistenta_mobile/screens/login_screen.dart';
import 'screens/start_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      },
    );
  }
}
