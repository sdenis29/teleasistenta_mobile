import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teleasistenta_mobile/providers/patient_provider.dart';

class HistoryScreen extends StatelessWidget {
  static String id = '/history';
  HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyList = Provider.of<PatientProvider>(context).history;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Istoric Medical'),
      ),
      body: Card(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  height: height,
                  child: ListView(
                    children: historyList
                        .map(
                          (e) => Column(
                            children: [
                              Title(
                                color: Colors.black,
                                child: Text(
                                  'Diagnostic:  ${e.diagnosis}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      'Schema tratament:  ${e.medicationSchedule}'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Tratament:  ${e.treatment}'),
                                ],
                              ),
                              Divider(),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
