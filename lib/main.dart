import 'package:flutter/material.dart';
import 'package:smarthome_4/database/mongo.dart';
import 'package:smarthome_4/homepage/controller.dart';

DatabaseManager myDatabase = DatabaseManager();
String MayLanh = 'LOW';
String QuatGio = 'LOW';
String QuatHut = 'LOW';
String Coi = 'LOW';
String Den_1 = 'LOW';
String Den_2 = 'LOW';
double DoAm = 0;
double NhietDo = 0;
int KhiGas = 0;
String Mode = "Tự động";
bool isConnected = false;
double minuteValue = 0;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
