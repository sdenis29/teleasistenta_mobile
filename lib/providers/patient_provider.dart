import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

class Patients with ChangeNotifier {
  List<String> _patients = [];
  final String teleasistentaUrl =
      "https://teleasistenta-83ccd-default-rtdb.europe-west1.firebasedatabase.app/";

  DatabaseReference ref =
      // ignore: deprecated_member_use
      FirebaseDatabase(
              databaseURL:
                  "https://teleasistenta-83ccd-default-rtdb.europe-west1.firebasedatabase.app")
          .ref("ElderTrack/patient");

  List<String> get patients {
    return [..._patients];
  }

  String findById(String userId) {
    return _patients.firstWhere((element) => element == userId);
  }

  Future<void> fetchPatients() async {
    try {
      // final url = "$teleasistentaUrl/ElderTrack/patient/";
      // final response = await http.get(Uri.parse(url));
      final response = await ref.get();
      print("I'm here");
      response.children.forEach(
        (element) {
          print("-----------Patient-----------");
          print(element.key);
          print(element.value);
          print("-----------------------------");
        },
      );
    } catch (error) {
      print("Or here?");
      print(error);
    }
  }
}
