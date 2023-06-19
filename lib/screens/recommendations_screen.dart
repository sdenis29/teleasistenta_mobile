import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teleasistenta_mobile/providers/patient_provider.dart';

class RecommendationsScreen extends StatelessWidget {
  static String id = '/recomandare';
  const RecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recommendation =
        Provider.of<PatientProvider>(context).recommendationList;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Recomandari'),
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
                    children: recommendation
                        .map(
                          (e) => Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Tipul recomandarii:  ${e.type}'),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Durata:  ${e.duration}'),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Observatii:  ${e.notes}'),
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
