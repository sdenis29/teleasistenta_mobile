class CareTeam {
  String? careGiverUID;
  String? doctorUID;
  String? supervisorUID;

  CareTeam({this.careGiverUID, this.doctorUID, this.supervisorUID});

  static CareTeam careTeamFromJson(dynamic json) {
    final Map<String, dynamic> parsedJson = json;
    final CareTeam careTeam = CareTeam(
        careGiverUID: parsedJson['caregiverUID'] ?? "",
        doctorUID: parsedJson['doctorUID'] ?? "",
        supervisorUID: parsedJson['supervisorUID'] ?? "");

    return careTeam;
  }
}
