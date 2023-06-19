import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teleasistenta_mobile/models/patient/medical_history/medical_history.dart';
import 'package:teleasistenta_mobile/models/patient/medical_record/medical_record.dart';
import 'package:teleasistenta_mobile/models/patient/recommendations/recommendation.dart';
import 'package:teleasistenta_mobile/models/patient/treatments/treatment.dart';

import '../models/patient/patient.dart';

class PatientProvider with ChangeNotifier {
  Patient? _patient;
  final String teleasistentaUrl =
      "https://teleasistenta-83ccd-default-rtdb.europe-west1.firebasedatabase.app/";

  DatabaseReference ref =
      // ignore: deprecated_member_use
      FirebaseDatabase(
              databaseURL:
                  "https://teleasistenta-83ccd-default-rtdb.europe-west1.firebasedatabase.app")
          .ref("ElderTrack/patient");
  DatabaseReference refDoc =
      // ignore: deprecated_member_use
      FirebaseDatabase(
              databaseURL:
                  "https://teleasistenta-83ccd-default-rtdb.europe-west1.firebasedatabase.app")
          .ref("ElderTrack/doctor");
  DatabaseReference refGive =
      // ignore: deprecated_member_use
      FirebaseDatabase(
              databaseURL:
                  "https://teleasistenta-83ccd-default-rtdb.europe-west1.firebasedatabase.app")
          .ref("ElderTrack/caregiver");
  DatabaseReference refSup =
      // ignore: deprecated_member_use
      FirebaseDatabase(
              databaseURL:
                  "https://teleasistenta-83ccd-default-rtdb.europe-west1.firebasedatabase.app")
          .ref("ElderTrack/supervisor");

  Patient? get patient {
    return _patient;
  }

  List<MedicalHistory> get history {
    return _patient!.medicalHistory.values.toList();
  }

  List<MedicalRecord> get record {
    return _patient!.medicalRecords.values.toList();
  }

  List<Recommendation> get recommendationList {
    return _patient!.recommendations.values.toList();
  }

  List<Treatment> get treatmentList {
    return _patient!.treatments.values.toList();
  }

  Future<void> fetchPatientData() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');
    try {
      // final url = "$teleasistentaUrl/ElderTrack/patient/";
      // final response = await http.get(Uri.parse(url));
      final response = await ref.child(uid!).get();
      final doctors = await refDoc.get();
      final caregiver = await refGive.get();
      final supervisor = await refSup.get();
      Map<String, dynamic> decodedData =
          jsonDecode(jsonEncode(response.value as dynamic));
      Map<String, dynamic> docsData =
          jsonDecode(jsonEncode(doctors.value as dynamic));
      Map<String, dynamic> givesData =
          jsonDecode(jsonEncode(caregiver.value as dynamic));
      Map<String, dynamic> supervisorData =
          jsonDecode(jsonEncode(supervisor.value as dynamic));
      final patient = Patient.patientFromJson(
          decodedData, docsData, givesData, supervisorData);
      _patient = patient;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
