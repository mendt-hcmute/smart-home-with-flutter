import 'package:flutter/material.dart';
import 'package:smarthome_4/main.dart';

class GridWidget extends StatefulWidget {
  @override
  _GridWidgetState createState() => _GridWidgetState();
}

class _GridWidgetState extends State<GridWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey[200],
                    child: Column(
                      children: [
                        const Text(
                          'Máy lạnh',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.grey[200],
                            child: Image.asset(
                              MayLanh == "HIGH"
                                  ? 'lib/assets/air_condition_on_icon.png'
                                  : 'lib/assets/air_condition_off_icon.png',
                              height: 100,
                              width: 100,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  MayLanh = "HIGH";
                                  myDatabase.changeACToON();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MayLanh == "HIGH"
                                    ? Colors.green[600]
                                    : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Text(
                                'BẬT',
                                style: TextStyle(
                                  color: MayLanh == "HIGH"
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ), // Khoảng cách giữa các nút
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  MayLanh = "LOW";
                                  myDatabase.changeACToOFF();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MayLanh == "HIGH"
                                    ? Colors.grey
                                    : Colors.red[700],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Text(
                                'TẮT',
                                style: TextStyle(
                                  color: MayLanh == "HIGH"
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey[200],
                    child: Column(
                      children: [
                        const Text(
                          'Quạt',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.grey[200],
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    color: Colors.grey[200],
                                    child: Image.asset(
                                      QuatGio == "HIGH"
                                          ? 'lib/assets/fan_on_icon.png'
                                          : 'lib/assets/fan_off_icon.png',
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          QuatGio = "HIGH";
                                          myDatabase.changeFanToON();
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: QuatGio == "HIGH"
                                            ? Colors.green[600]
                                            : Colors.grey,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      child: Text(
                                        'BẬT',
                                        style: TextStyle(
                                          color: QuatGio == "HIGH"
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ), // Khoảng cách giữa các nút
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          QuatGio = "LOW";
                                          myDatabase.changeFanToOFF();
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: QuatGio == "HIGH"
                                            ? Colors.grey
                                            : Colors.red[700],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      child: Text(
                                        'TẮT',
                                        style: TextStyle(
                                          color: QuatGio == "HIGH"
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 0,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey[200],
                    child: Column(
                      children: [
                        const Text(
                          'Đèn 1', // Thay đổi nội dung văn bản theo yêu cầu của bạn
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.grey[200],
                            child: Image.asset(
                              Den_1 == "HIGH"
                                  ? 'lib/assets/bulb_on_icon.png'
                                  : 'lib/assets/bulb_off_icon.png',
                              height: 100,
                              width: 100,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Den_1 = "HIGH";
                                  myDatabase.changeLight1ToON();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Den_1 == "HIGH"
                                    ? Colors.green[600]
                                    : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Text(
                                'BẬT',
                                style: TextStyle(
                                  color: Den_1 == "HIGH"
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ), // Khoảng cách giữa các nút
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Den_1 = "LOW";
                                  myDatabase.changeLight1ToOFF();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Den_1 == "HIGH"
                                    ? Colors.grey
                                    : Colors.red[700],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Text(
                                'TẮT',
                                style: TextStyle(
                                  color: Den_1 == "HIGH"
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey[200],
                    child: Column(
                      children: [
                        const Text(
                          'Đèn 2', // Thay đổi nội dung văn bản theo yêu cầu của bạn
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            color: Colors.grey[200],
                            child: Image.asset(
                              Den_2 == "HIGH"
                                  ? 'lib/assets/lamp_on_icon.png'
                                  : 'lib/assets/lamp_off_icon.png',
                              height: 100,
                              width: 100,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Den_2 = "HIGH";
                                  myDatabase.changeLight2ToON();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Den_2 == "HIGH"
                                    ? Colors.green[600]
                                    : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Text(
                                'BẬT',
                                style: TextStyle(
                                  color: Den_2 == "HIGH"
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ), // Khoảng cách giữa các nút
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Den_2 = "LOW";
                                  myDatabase.changeLight2ToOFF();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Den_2 == "HIGH"
                                    ? Colors.grey
                                    : Colors.red[700],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Text(
                                'TẮT',
                                style: TextStyle(
                                  color: Den_2 == "HIGH"
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
