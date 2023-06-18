import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teleasistenta_mobile/components/reusable_button.dart';
import 'package:teleasistenta_mobile/screens/home_screen.dart';
import 'package:teleasistenta_mobile/services/databaseService.dart';
import '../components/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Introduceți datele de conectare',
          style: TextStyle(fontSize: 21),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: width * 0.6,
                  height: height * 0.4,
                  child: SvgPicture.asset('assets/svgs/start.svg'),
                ),
                CustomTextField(
                  inputLabel: 'Email',
                  icon: const Icon(Icons.email),
                  obscure: false,
                  suggestions: true,
                  labelColor: const TextStyle(color: Colors.grey),
                  onChange: (value) {
                    email = value;
                  },
                ),
                CustomTextField(
                  inputLabel: 'Parolă',
                  icon: const Icon(Icons.password),
                  obscure: true,
                  suggestions: true,
                  labelColor: const TextStyle(color: Colors.grey),
                  onChange: (value) {
                    password = value;
                  },
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                ReusableButton(
                  color: Colors.red,
                  onPress: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final existingUser =
                          await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                      if (existingUser != null) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('uid', existingUser.user!.uid);
                        DatabaseService dbService = DatabaseService();
                        dbService.getCurrentUserData(email);
                        Navigator.pushNamed(context, HomeScreen.id);
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    } on FirebaseAuthException catch (e) {
                      print(e);
                      if (e.code == 'user-not-found') {
                        print('Nu exista cont pentru acest email');
                        setState(() {
                          showSpinner = false;
                        });
                      } else if (e.code == 'wrong-password') {
                        print('Nu exista cont pentru acest email');
                        setState(() {
                          showSpinner = false;
                        });
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    }
                  },
                  buttonChild: const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Conectare',
                      style: TextStyle(fontSize: 21),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
