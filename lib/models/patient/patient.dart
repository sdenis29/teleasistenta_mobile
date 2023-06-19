import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';

import './care_team.dart';
import './personal_info.dart';
import './medical_history/medical_history.dart';
import './recommendations/recommendation.dart';
import './treatments/treatment.dart';
import './medical_record/medical_record.dart';

class Patient {
  PersonalInfo? personalInfo;
  CareTeam? careTeam;
  Map<String, MedicalHistory> medicalHistory = {};
  Map<String, MedicalRecord> medicalRecords = {};
  Map<String, Treatment> treatments = {};
  Map<String, Recommendation> recommendations = {};
  String? doctorAssigned;
  String? giverAssigned;
  String? supervisorAssigned;

  Patient({
    this.personalInfo,
    this.careTeam,
    this.doctorAssigned,
    this.giverAssigned,
    this.supervisorAssigned,
    Map<String, MedicalHistory>? medicalHistory,
    Map<String, MedicalRecord>? medicalRecords,
    Map<String, Treatment>? treatments,
    Map<String, Recommendation>? recommendations,
  })  : medicalHistory = medicalHistory ?? {},
        medicalRecords = medicalRecords ?? {},
        treatments = treatments ?? {},
        recommendations = recommendations ?? {};

  static Map<String, Treatment> parseTreatmentMap(dynamic json) {
    final Map<String, dynamic> parsedJson = json;
    final Map<String, Treatment> treatmentMap = {};

    parsedJson.forEach((key, value) {
      final Treatment treatment = Treatment(
        description: value['description'],
        remarks: value['remarks'],
        solvedDate: value['solvedDate'],
        solvedHour: value['solvedHour'],
        status: value['status'],
      );

      treatmentMap[key] = treatment;
    });

    return treatmentMap;
  }

  static Map<String, Recommendation> parseRecommendation(dynamic json) {
    final Map<String, dynamic> parsedJson = json;
    final Map<String, Recommendation> recommendationMap = {};

    parsedJson.forEach((key, value) {
      final Recommendation recommendation = Recommendation(
        duration: value['duration'],
        notes: value['notes'],
        type: value['type'],
      );

      recommendationMap[key] = recommendation;
    });

    return recommendationMap;
  }

  static Patient patientFromJson(
      dynamic json, dynamic doctors, dynamic caregiver, dynamic supervisor) {
    final Map<String, dynamic> parsedJson = json;
    final Map<String, dynamic> doctorsJson = doctors;
    final Map<String, dynamic> caregiverJson = caregiver;
    final Map<String, dynamic> supervisorJson = supervisor;
    final Map<String, dynamic>? personalInfo = parsedJson['personalInfo'];
    final Map<String, dynamic>? cTeam = parsedJson['careTeam'];
    final Map<String, dynamic>? mHistory = parsedJson['medicalHistory'];
    final Map<String, dynamic>? treatmentJson = parsedJson['treatment'];
    final Map<String, dynamic>? mRecord = parsedJson['medicalRecord'];
    final Map<String, dynamic>? recommendationJson =
        parsedJson['recommendation'];
    PersonalInfo? pInfo = personalInfo == null
        ? null
        : PersonalInfo.personalInfoFromJson(personalInfo);

    CareTeam? careTeam =
        cTeam == null ? null : CareTeam.careTeamFromJson(cTeam);

    Map<String, MedicalHistory>? medicalHistory = mHistory == null
        ? null
        : MedicalHistory.parseMedicalHistoryMap(mHistory);

    Map<String, MedicalRecord>? medicalRecord =
        mRecord == null ? null : MedicalRecord.medicalRecordFromJson(mRecord);

    Map<String, Treatment>? treatment =
        treatmentJson == null ? null : parseTreatmentMap(treatmentJson);

    Map<String, Recommendation>? recommendations = recommendationJson == null
        ? null
        : parseRecommendation(recommendationJson);

    var doctorName = "";
    var giverName = "";
    var supervisorName = "";

    if (careTeam!.doctorUID != "") {
      final doctor = doctorsJson[careTeam!.doctorUID!];
      doctorName = ' ${doctor['firstname'] ?? ""} ${doctor['lastname'] ?? ""}';
    }

    if (careTeam!.careGiverUID != "") {
      final caregiver = caregiverJson[careTeam!.careGiverUID!];
      giverName =
          ' ${caregiver['firstname'] ?? ""} ${caregiver['lastname'] ?? ""}';
    }

    if (careTeam!.supervisorUID != "") {
      final sp = supervisorJson[careTeam!.supervisorUID!];
      supervisorName = ' ${sp['firstname'] ?? ""} ${sp['lastname'] ?? ""}';
    }

    final Patient patient = Patient(
        personalInfo: pInfo,
        careTeam: careTeam,
        medicalHistory: medicalHistory,
        medicalRecords: medicalRecord,
        treatments: treatment,
        recommendations: recommendations,
        doctorAssigned: doctorName,
        giverAssigned: giverName,
        supervisorAssigned: supervisorName);

    return patient;
  }
}
