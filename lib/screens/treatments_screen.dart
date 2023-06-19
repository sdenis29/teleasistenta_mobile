import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teleasistenta_mobile/providers/patient_provider.dart';

class TreatmentsScreen extends StatelessWidget {
  static String id = '/tratament';
  const TreatmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final treatments = Provider.of<PatientProvider>(context).treatmentList;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Tratamente'),
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
                    children: treatments
                        .map(
                          (e) => Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                      child:
                                          Text('Descriere:  ${e.description}')),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                      child: Text('Observatii:  ${e.remarks}')),
                                ],
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
                                          'Data administrarii:  ${e.solvedDate}')),
                                ],
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
                                          'Ora administrarii:  ${e.solvedHour}')),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(child: Text('Status:  ${e.status}')),
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
