// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:teleasistenta_mobile/components/reusable_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teleasistenta_mobile/screens/login_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  static String id = 'start';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          widget.title,
          style: const TextStyle(fontSize: 25),
        )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: width * 0.6,
              height: height * 0.3,
              child: SvgPicture.asset('assets/svgs/start.svg'),
            ),
            ReusableButton(
              color: Colors.red,
              onPress: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
              buttonChild: const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Conectare',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
