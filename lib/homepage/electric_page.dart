import 'package:flutter/material.dart';
import 'package:smarthome_4/charts/air_condition_chart.dart';
import 'package:smarthome_4/charts/fan_chart.dart';
import 'package:smarthome_4/charts/light1_chart.dart';

class DienNang extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: AirConditionChart(),
          ),
          Expanded(
            child: FanChart(),
          ),
          Expanded(
            child: Light1Chart(),
          ),
        ],
      ),
    );
  }
}
