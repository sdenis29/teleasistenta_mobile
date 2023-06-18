import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  static Map<String, String> userInfo = {};
  final _firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  DatabaseService() {
    print("DatabaseService Initialized");
  }

  Future getCurrentUserData(String email) async {
    final querySnapshot = await _firestore
        .collection('registration')
        .where('email', isEqualTo: email)
        .get();
    for (var doc in querySnapshot.docs) {
      // userInfo['firstName'] = getOrElseValue(doc, 'firstname');
      // userInfo['lastName'] = getOrElseValue(doc, 'lastname');
      userInfo['email'] = getOrElseValue(doc, 'email');
    }
  }

  String getOrElseValue(QueryDocumentSnapshot doc, String field) {
    try {
      return doc.get(field);
    } catch (e) {
      print("[DatabaseService] Field $field threw the following error: " +
          e.toString());
      return '';
    }
  }
}
