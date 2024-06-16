import 'package:flutter/material.dart';
import 'package:smarthome_4/main.dart';

class SensorsValue extends StatefulWidget {
  @override
  _SensorsValueState createState() => _SensorsValueState();
}

class _SensorsValueState extends State<SensorsValue> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[200], // Màu nền cho cột
              child: Column(
                children: [
                  Image.asset(
                    'lib/assets/humidity.png', // Replace with your image asset path
                    height: 70,
                    width: 70,
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCCE5FF),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        '${DoAm.toStringAsFixed(2)}' + "%",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[200], // Màu nền cho cột
              child: Column(
                children: [
                  Image.asset(
                    'lib/assets/temperature.png', // Replace with your image asset path
                    height: 70,
                    width: 70,
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCCE5FF),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        '${NhietDo.toStringAsFixed(2)} ' + "*C",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[200], // Màu nền cho cột
              child: Column(
                children: [
                  Image.asset(
                    'lib/assets/flame.png', // Replace with your image asset path
                    height: 70,
                    width: 70,
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCCE5FF),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        '${KhiGas.toStringAsFixed(2)}' + " %",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
