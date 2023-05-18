import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teleasistenta_mobile/components/reusable_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String id = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Pagina pacientului',
            style: TextStyle(fontSize: 21),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              print('Logout');
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.08),
              child: Container(
                width: width * 0.6,
                height: height * 0.3,
                child: SvgPicture.asset('assets/svgs/consult.svg'),
              ),
            ),
            ReusableButton(
              onPress: () {},
              color: Colors.red,
              buttonChild: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: height * 0.02, horizontal: width * 0.08),
                child: const Text(
                  'Istoric medical',
                  style: TextStyle(fontSize: 21),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.015,
            ),
            ReusableButton(
              onPress: () {},
              color: Colors.red,
              buttonChild: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: height * 0.02, horizontal: width * 0.08),
                child: const Text(
                  'Adăugare date',
                  style: TextStyle(fontSize: 21),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.015,
            ),
            ReusableButton(
              onPress: () {},
              color: Colors.red,
              buttonChild: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: height * 0.02, horizontal: width * 0.08),
                child: const Text(
                  'Istoric medical',
                  style: TextStyle(fontSize: 21),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
