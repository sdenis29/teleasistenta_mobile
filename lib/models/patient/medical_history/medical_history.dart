class MedicalHistory {
  bool? deleted;
  String? diagnosis;
  String? medicationSchedule;
  String? treatment;

  MedicalHistory(
      {this.deleted, this.diagnosis, this.medicationSchedule, this.treatment});

  static Map<String, MedicalHistory> parseMedicalHistoryMap(dynamic json) {
    final Map<String, dynamic>? jsonMap = json;

    final Map<String, MedicalHistory> medicalHistoryMap = {};
    if (jsonMap != null) {
      jsonMap.forEach((key, value) {
        final MedicalHistory medicalHistory = MedicalHistory(
          deleted: value['deleted'],
          diagnosis: value['diagnosis'],
          medicationSchedule: value['medicationSchedule'],
          treatment: value['treatment'],
        );

        medicalHistoryMap[key] = medicalHistory;
      });
    }

    return medicalHistoryMap;
  }
}
