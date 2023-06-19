import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teleasistenta_mobile/providers/patient_provider.dart';

class MedicalRegistryScreen extends StatelessWidget {
  static String id = '/registry';
  const MedicalRegistryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyList = Provider.of<PatientProvider>(context).record;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Registru Medical'),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Title(
                                color: Colors.black,
                                child: Text(
                                  'Diagnostic:  ${e.medicalInfo!.diagnosis}',
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
                                  Flexible(
                                      child: Text(
                                          'Data:  ${e.medicalInfo!.date}')),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                      child: Text(
                                          'Simptome:  ${e.medicalInfo!.symptoms}')),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                      child: Text(
                                          'Motiv:  ${e.medicalInfo!.purpose}')),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                        'Prescriptie:  ${e.medicalInfo!.prescription}'),
                                  ),
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
