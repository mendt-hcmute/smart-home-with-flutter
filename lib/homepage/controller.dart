import 'package:flutter/material.dart';
import 'package:smarthome_4/homepage/control_page.dart';
import 'package:smarthome_4/homepage/electric_page.dart';

enum DisplayedWidget { dieuKhien, dienNang }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DisplayedWidget displayedWidget = DisplayedWidget.dieuKhien;

  Color getTextColor(DisplayedWidget widget) {
    return displayedWidget == widget ? Colors.white : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blue,
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          displayedWidget = DisplayedWidget.dieuKhien;
                        });
                      },
                      child: Text(
                        "Điều khiển",
                        style: TextStyle(
                          fontSize: 22,
                          color: getTextColor(DisplayedWidget.dieuKhien),
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          displayedWidget = DisplayedWidget.dienNang;
                        });
                      },
                      child: Text(
                        "Điện năng",
                        style: TextStyle(
                          fontSize: 22,
                          color: getTextColor(DisplayedWidget.dienNang),
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: () {
              switch (displayedWidget) {
                case DisplayedWidget.dieuKhien:
                  return DieuKhien();
                case DisplayedWidget.dienNang:
                  return DienNang();
              }
            }(),
          ),
        ],
      ),
    );
  }
}
