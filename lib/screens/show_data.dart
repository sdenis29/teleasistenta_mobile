// ignore_for_file: sized_box_for_whitespace
import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:teleasistenta_mobile/components/reusable_button.dart';
import 'package:fl_chart/fl_chart.dart';

class ShowDataScreen extends StatefulWidget {
  const ShowDataScreen({super.key});
  static String id = 'show_data';

  @override
  State<ShowDataScreen> createState() => _ShowDataScreenState();
}

class _ShowDataScreenState extends State<ShowDataScreen> {
  String bloodPressure = "";
  String weight = "";
  String glucose = "";
  String bodyTemperature = "";
  String pulse = "";
  String humidity = "";
  String temperature = "";
  List<String> pulseList = [];
  final TooltipBehavior _tooltipBehavior = TooltipBehavior();
  List<PulseData> pulseObjects = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    getDataFromCache();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      getDataFromCache();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> getDataFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    bloodPressure = (prefs.getString('bloodPressure'))!;
    weight = (prefs.getString('weight'))!;
    glucose = (prefs.getString('glucose'))!;
    bodyTemperature = (prefs.getString('bodyTemperature'))!;
    pulse = prefs.getInt('pulse').toString();
    humidity = prefs.getDouble('humidity').toString();
    temperature = prefs.getDouble('temperature').toString();
    String encodedList = prefs.getString('pulseList') ?? '[]';
    pulseList = List<String>.from(json.decode(encodedList));
    PulseData.resetIndex();
    pulseObjects =
        pulseList.map((value) => PulseData.fromString(value)).toList();
    setState(() {});
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    if (value % 1 != 0) {
      return Container();
    }
    final style = TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
      fontSize: min(18, 18 * chartWidth / 300),
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(meta.formattedValue, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    final style = TextStyle(
      color: Colors.yellow,
      fontWeight: FontWeight.bold,
      fontSize: min(18, 18 * chartWidth / 300),
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(meta.formattedValue, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Transform(
          transform: Matrix4.translationValues(0.0, 0.0, 0.0),
          child: const Text(
            'Raport',
            style: TextStyle(fontSize: 21),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              child: Text(
                "Ultimele informații",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 2),
              child: Text(
                "Tensiune: $bloodPressure",
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              )),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 2),
              child: Text("Puls: $pulse",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500))),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 2),
              child: Text("Greutate: $weight",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500))),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 2),
              child: Text("Glicemie: $glucose",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500))),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 2),
              child: Text("Temperatura corporală: $bodyTemperature",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500))),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 2),
              child: Text("Umiditate: $humidity",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500))),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 2),
              child: Text("Temperatura locuinței: $temperature",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500))),
          const SizedBox(
            height: 30,
          ),
          Center(
            child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                // Chart title
                title: ChartTitle(text: 'Raport Puls'),
                // Enable legend
                legend: Legend(isVisible: false),
                // Enable tooltip
                tooltipBehavior: _tooltipBehavior,
                series: <LineSeries<PulseData, String>>[
                  LineSeries<PulseData, String>(
                      dataSource: pulseObjects,
                      xValueMapper: (PulseData pulses, _) => pulses.order,
                      yValueMapper: (PulseData pulses, _) => pulses.pulse,
                      // Enable data label
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true))
                ]),
          ),
        ],
      ),
    );
  }
}

class PulseData {
  PulseData(this.order, this.pulse);
  static int index = 0;
  final String order;
  final double pulse;

  static resetIndex() => index = 0;

  factory PulseData.fromString(String value) {
    index += 1;
    return PulseData(index.toString(), double.parse(value));
  }
}
