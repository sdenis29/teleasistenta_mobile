import 'dart:convert';

class PersonalInfo {
  String? CNP;
  int? age;
  String? allergies;
  String? apartment;
  String? buildingNumber;
  String? city;
  String? county;
  String? email;
  String? firstName;
  String? lastName;
  String? floor;
  String? number;
  String? occupation;
  String? phoneNumber;
  String? profession;
  String? staircase;
  String? street;

  PersonalInfo({
    this.CNP,
    this.age,
    this.allergies,
    this.apartment,
    this.buildingNumber,
    this.city,
    this.county,
    this.email,
    this.firstName,
    this.lastName,
    this.floor,
    this.number,
    this.occupation,
    this.phoneNumber,
    this.profession,
    this.staircase,
    this.street,
  });

  static PersonalInfo personalInfoFromJson(dynamic json) {
    final Map<String, dynamic> parsedJson = json;
    final PersonalInfo personalInfo = PersonalInfo(
      CNP: parsedJson['CNP'],
      age: parsedJson['age'],
      allergies: parsedJson['allergies'],
      apartment: parsedJson['apartment'],
      buildingNumber: parsedJson['buildingNumber'],
      city: parsedJson['city'],
      county: parsedJson['county'],
      email: parsedJson['email'],
      firstName: parsedJson['firstname'],
      lastName: parsedJson['lastname'],
      floor: parsedJson['floor'],
      number: parsedJson['number'],
      occupation: parsedJson['occupation'],
      phoneNumber: parsedJson['phoneNumber'],
      profession: parsedJson['profession'],
      staircase: parsedJson['staircase'],
      street: parsedJson['street'],
    );

    return personalInfo;
  }
}
