import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../main.dart';

class Light1Chart extends StatefulWidget {
  @override
  _Light1ChartState createState() => _Light1ChartState();
}

class _Light1ChartState extends State<Light1Chart> {
  List<SalesData> salesDataList = [];

  void _generateDataPoints() async {
    List<SalesData> data = [];
    for (int day = 1; day <= 30; day++) {
      double? energyValue = await myDatabase.findOldEnegyOfLight1(day);
      if (energyValue != null) {
        data.add(SalesData(day.toString(), energyValue / 60));
      }
    }
    setState(() {
      salesDataList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnected) {
      return const SizedBox();
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    height: 200, // Giảm chiều cao của biểu đồ
                    margin: const EdgeInsets.all(16),
                    child: SfCartesianChart(
                      title: const ChartTitle(text: 'Đèn 1'),
                      primaryXAxis: const CategoryAxis(),
                      primaryYAxis: const NumericAxis(
                        title: AxisTitle(text: 'Tổng thời gian (giờ)'),
                      ),
                      series: <LineSeries<SalesData, String>>[
                        LineSeries<SalesData, String>(
                          dataSource: salesDataList,
                          xValueMapper: (SalesData sales, _) => sales.hour,
                          yValueMapper: (SalesData sales, _) => sales.sales,
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: ElevatedButton(
                      onPressed: _generateDataPoints,
                      child: const Icon(Icons.refresh),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(8),
                        shape: const CircleBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SalesData {
  final String hour;
  final double sales;

  SalesData(this.hour, this.sales);
}
