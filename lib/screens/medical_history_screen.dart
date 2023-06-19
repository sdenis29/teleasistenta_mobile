import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teleasistenta_mobile/components/reusable_button.dart';
import 'package:teleasistenta_mobile/models/patient/patient.dart';
import 'package:teleasistenta_mobile/providers/patient_provider.dart';
import 'package:teleasistenta_mobile/screens/history_screen.dart';
import 'package:teleasistenta_mobile/screens/medical_registry_screen.dart';
import 'package:teleasistenta_mobile/screens/recommendations_screen.dart';
import 'package:teleasistenta_mobile/screens/treatments_screen.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key});
  static String id = '/medicalHistory';

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  var _isInit = false;
  var _isLoading = false;
  var _expanded = false;
  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<PatientProvider>(context).fetchPatientData().then((_) {
        _isLoading = false;
      });
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final patient = Provider.of<PatientProvider>(context).patient;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Istoric medical'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Card(
              margin: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                          '${patient!.personalInfo!.firstName} ${patient!.personalInfo!.lastName}'),
                      trailing: IconButton(
                        icon: Icon(
                            _expanded ? Icons.expand_less : Icons.expand_more),
                        onPressed: () {
                          setState(() {
                            _expanded = !_expanded;
                          });
                        },
                      ),
                    ),
                    if (_expanded)
                      Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                          height: 100,
                          child: ListView(
                            children: patient!
                                .personalInfo!.personalInfo.entries
                                .map(
                                  (e) => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [Text('${e.key} : ${e.value}')],
                                  ),
                                )
                                .toList(),
                          )),
                    ListTile(
                      title: Text('Medic: ${patient!.doctorAssigned}'),
                    ),
                    ListTile(
                      title: Text('Ingrijitor: ${patient!.giverAssigned}'),
                    ),
                    ListTile(
                      title: Text('Supervisor: ${patient!.supervisorAssigned}'),
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    ReusableButton(
                      onPress: () {
                        Navigator.pushNamed(context, HistoryScreen.id);
                      },
                      color: Colors.red,
                      buttonChild: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: height * 0.021,
                            horizontal: width * 0.065),
                        child: const Text(
                          'Istoric Medical',
                          style: TextStyle(fontSize: 21),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ReusableButton(
                      onPress: () {
                        Navigator.pushNamed(context, MedicalRegistryScreen.id);
                      },
                      color: Colors.red,
                      buttonChild: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: height * 0.021,
                            horizontal: width * 0.065),
                        child: const Text(
                          'Registru Medical',
                          style: TextStyle(fontSize: 21),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ReusableButton(
                      onPress: () {
                        Navigator.pushNamed(context, RecommendationsScreen.id);
                      },
                      color: Colors.red,
                      buttonChild: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: height * 0.021,
                            horizontal: width * 0.065),
                        child: const Text(
                          'Recomandari',
                          style: TextStyle(fontSize: 21),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ReusableButton(
                      onPress: () {
                        Navigator.pushNamed(context, TreatmentsScreen.id);
                      },
                      color: Colors.red,
                      buttonChild: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: height * 0.021,
                            horizontal: width * 0.065),
                        child: const Text(
                          'Tratamente',
                          style: TextStyle(fontSize: 21),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
