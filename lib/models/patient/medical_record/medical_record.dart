import './info.dart';
import './referral.dart';

class MedicalRecord {
  Info? medicalInfo;
  Referral? medicalReferral;

  MedicalRecord({this.medicalInfo, this.medicalReferral});

  static Map<String, MedicalRecord> medicalRecordFromJson(dynamic json) {
    final Map<String, dynamic> parsedJson = json;
    final Map<String, MedicalRecord> medicalRecordMap = {};
    parsedJson.forEach((key, value) {
      final Info medicalInfo = Info(
        date: value['info']['date'],
        diagnosis: value['info']['diagnosis'].toString(),
        prescription: value['info']['prescription'],
        purpose: value['info']['purpose'],
        symptoms: value['info']['symptoms'],
      );

      final Referral medicalReferral = Referral(
        description: value['referral']['description'],
        type: value['referral']['type'],
      );

      final MedicalRecord medicalRecord = MedicalRecord(
        medicalInfo: medicalInfo,
        medicalReferral: medicalReferral,
      );
      medicalRecordMap[key] = medicalRecord;
    });

    return medicalRecordMap;
  }
}
