import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smarthome_4/homepage/gridview.dart';
import 'package:smarthome_4/homepage/sensors_value.dart';
import 'package:smarthome_4/main.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class DieuKhien extends StatefulWidget {
  @override
  _DieuKhienState createState() => _DieuKhienState();
}

class _DieuKhienState extends State<DieuKhien> {
  bool isConnecting = false;
  bool isOn = false;
  bool isUpdating = false;
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    print("speech initialized");
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    print("start listening");
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    print("stop listening");
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    print(result);
    setState(() async {
      _lastWords = result.recognizedWords;

      if (_lastWords == "bật đèn 1" ||
          _lastWords == "Bật Đèn 1" ||
          _lastWords == "Bật đèn 1" ||
          _lastWords == "bật Đèn 1") {
        await myDatabase.changeLight1ToON();
      } else if (_lastWords == "tắt đèn 1" ||
          _lastWords == "Tắt Đèn 1" ||
          _lastWords == "Tắt đèn 1" ||
          _lastWords == "tắt Đèn 1") {
        await myDatabase.changeLight1ToOFF();
      } else if (_lastWords == "bật đèn 2" ||
          _lastWords == "Bật Đèn 2" ||
          _lastWords == "Bật đèn 2" ||
          _lastWords == "bật Đèn 2") {
        await myDatabase.changeLight2ToON();
      } else if (_lastWords == "tắt đèn 2" ||
          _lastWords == "Tắt Đèn 2" ||
          _lastWords == "Tắt đèn 2" ||
          _lastWords == "tắt Đèn 2") {
        await myDatabase.changeLight2ToOFF();
      } else if (_lastWords == "bật quạt" ||
          _lastWords == "Bật Quạt" ||
          _lastWords == "Bật quạt" ||
          _lastWords == "bật Quạt") {
        await myDatabase.changeFanToON();
      } else if (_lastWords == "tắt quạt" ||
          _lastWords == "Tắt Quạt" ||
          _lastWords == "Tắt quạt" ||
          _lastWords == "tắt Quạt") {
        await myDatabase.changeFanToOFF();
      } else if (_lastWords == "bật máy lạnh" ||
          _lastWords == "Bật Máy Lạnh" ||
          _lastWords == "Bật máy Lạnh" ||
          _lastWords == "bật Máy lạnh") {
        await myDatabase.changeACToON();
      } else if (_lastWords == "tắt máy lạnh" ||
          _lastWords == "Tắt Máy Lạnh" ||
          _lastWords == "Tắt máy Lạnh" ||
          _lastWords == "tắt Máy lạnh") {
        await myDatabase.changeACToOFF();
      } else {
        print("Lệnh không tồn tại");
      }

      if (isConnected) {
        KhiGas = (await myDatabase.findGasValue())!;
        DoAm = (await myDatabase.findHumidityValue())!;
        NhietDo = (await myDatabase.findTemperatureValue())!;
        MayLanh = (await myDatabase.findAirConditionState())!;
        QuatGio = (await myDatabase.findFanState())!;
        Den_1 = (await myDatabase.findLight1State())!;
        Den_2 = (await myDatabase.findLight2State())!;
      }

      if (!isConnected) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Lỗi'),
            content:
                const Text('Chưa kết nối với database hoặc lệnh không tồn tại'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Đóng'),
              ),
            ],
          ),
        );
      }

      isUpdating = false;
      setState(() {});
    });
  }

  void updateValues() {
    if (isConnected) {
      myDatabase.findHumidityValue().then((value) {
        setState(() {
          DoAm = value ?? 0.0;
        });
      });

      myDatabase.findTemperatureValue().then((value) {
        setState(() {
          NhietDo = value ?? 0.0;
        });
      });

      myDatabase.findGasValue().then((value) {
        setState(() {
          KhiGas = value ?? 0;
        });
      });
    } else {
      NhietDo = 0;
      DoAm = 0;
      KhiGas = 0;
    }
  }

  void startDatabaseCheckTimer() {
    const duration = Duration(minutes: 5);
    print("started timer function");
    Timer.periodic(duration, (timer) async {
      if (isConnected) {
        try {
          MayLanh = (await myDatabase.findAirConditionState())!;
          QuatGio = (await myDatabase.findFanState())!;
          double oldACMinuteValue =
              (await myDatabase.findOldEnegyOfAC(DateTime.now().day))!;
          double oldFanMinuteValue =
              (await myDatabase.findOldEnegyOfFan(DateTime.now().day))!;
          double oldLight1MinuteValue =
              (await myDatabase.findOldEnegyOfLight1(DateTime.now().day))!;
          if (MayLanh == "HIGH") {
            await myDatabase.updateEnegyOfAC(
                5, oldACMinuteValue, DateTime.now().day);
          }
          if (QuatGio == "HIGH") {
            await myDatabase.updateEnegyOfFan(
                5, oldFanMinuteValue, DateTime.now().day);
          }
          if (Den_1 == "HIGH") {
            await myDatabase.updateEnegyOfLight1(
                5, oldLight1MinuteValue, DateTime.now().day);
          }
        } catch (e) {
          print('Error: $e');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'lib/assets/background1.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    width: 120,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isConnecting = true;
                        });

                        try {
                          await myDatabase
                              .connectToDatabase()
                              .timeout(const Duration(seconds: 5));
                          setState(() {
                            isConnected = true;
                            isConnecting = false;
                          });

                          if (isConnected) {
                            KhiGas = (await myDatabase.findGasValue())!;
                            DoAm = (await myDatabase.findHumidityValue())!;
                            NhietDo =
                                (await myDatabase.findTemperatureValue())!;
                            MayLanh =
                                (await myDatabase.findAirConditionState())!;
                            QuatGio = (await myDatabase.findFanState())!;
                            Den_1 = (await myDatabase.findLight1State())!;
                            Den_2 = (await myDatabase.findLight2State())!;
                            startDatabaseCheckTimer();
                            setState(() {});
                          }
                        } catch (e) {
                          setState(() {
                            isConnecting = false;
                            isConnected = false;
                          });
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Lỗi'),
                              content: const Text(
                                  'Không kết nối được database (Timeout)'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Đóng'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (states) {
                            if (isConnected) {
                              return const Color(0xFFB9E0A5); // Màu hex #D5E8D4
                            } else {
                              return const Color(0xFFFF9999); // Màu hex #F5F5F5
                            }
                          },
                        ),
                      ),
                      child: isConnecting
                          ? const CircularProgressIndicator()
                          : Text(isConnected ? 'Đã kết nối' : 'Kết nối'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  width: 120,
                  height: 40,
                  color: Colors.grey[200],
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isUpdating = true;
                      });
                      if (isConnected) {
                        KhiGas = (await myDatabase.findGasValue())!;
                        DoAm = (await myDatabase.findHumidityValue())!;
                        NhietDo = (await myDatabase.findTemperatureValue())!;
                        MayLanh = (await myDatabase.findAirConditionState())!;
                        QuatGio = (await myDatabase.findFanState())!;
                        Den_1 = (await myDatabase.findLight1State())!;
                        Den_2 = (await myDatabase.findLight2State())!;
                        isUpdating = false;
                        setState(() {});
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Lỗi'),
                            content: const Text('Chưa kết nối với database'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Đóng'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: isUpdating
                        ? const CircularProgressIndicator()
                        : const Text('Cập nhật'),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: 120,
                  height: 40,
                  color: Colors.grey[200],
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (Mode == "Tự động") {
                          Mode = "Thủ công";
                        } else {
                          Mode = "Tự động";
                        }
                      });
                    },
                    child:
                        Text('$Mode'), // Thay đổi văn bản theo yêu cầu của bạn
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            flex: 3,
            child: SensorsValue(),
          ),
          Expanded(
            flex: 6,
            child: GridWidget(),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[200],
              child: FloatingActionButton(
                onPressed: () {
                  // If not yet listening for speech start, otherwise stop
                  if (_speechToText.isNotListening) {
                    _startListening();
                  } else {
                    _stopListening();
                  }
                },
                tooltip: 'Listen',
                child: Icon(
                  _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                // If listening is active show the recognized words
                _speechToText.isListening
                    ? '$_lastWords'
                    // If listening isn't active but could be tell the user
                    // how to start it, otherwise indicate that speech
                    // recognition is not yet ready or not supported on
                    // the target device
                    : _speechEnabled
                        ? 'Tap the microphone to start listening...'
                        : 'Speech not available',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
