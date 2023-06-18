import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/patient/patient.dart';

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
      response.children.forEach(
        (element) {
          Map<String, dynamic> decodedData =
              jsonDecode(jsonEncode(element.value as dynamic));
          final patient = Patient.patientFromJson(decodedData);
        },
      );
    } catch (error) {
      print(error);
    }
  }
}
