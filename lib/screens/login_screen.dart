import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teleasistenta_mobile/components/reusable_button.dart';

import '../components/text_field.dart';
// import 'package:teleasistenta_mobile/components/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      body: SingleChildScrollView(
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
                onChange: (p0) => {},
              ),
              CustomTextField(
                inputLabel: 'Parolă',
                icon: const Icon(Icons.password),
                obscure: true,
                suggestions: true,
                labelColor: const TextStyle(color: Colors.grey),
                onChange: (p0) => {},
              ),
              SizedBox(
                height: height * 0.05,
              ),
              ReusableButton(
                color: Colors.red,
                onPress: () => {},
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
    );
  }
}
