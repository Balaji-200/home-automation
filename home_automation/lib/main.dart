import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:home_automation/stateProvider.dart';
import 'package:provider/provider.dart';
import 'loader.dart';

void main() => runApp(ChangeNotifierProvider(
    create: (_) => AutomationStateProvider(), child: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Automation',
      theme: ThemeData(
        primaryColor: Colors.indigo,
        accentColor: Colors.yellow,
        primarySwatch: Colors.indigo,
      ),
      home: Scaffold(
          appBar: AppBar(title: Text('Home Automation')),
          body: ActionButtons()),
    );
  }
}

class ActionButtons extends StatefulWidget {
  @override
  _ActionButtonsState createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  bool noInternet = false;
  final _database = FirebaseDatabase.instance.reference();
  double _slider=0.0;

  @override
  void initState() {
    var autoStateProvider =
        Provider.of<AutomationStateProvider>(context, listen: false);
    _database.once().then((snapShot) {
      _slider = snapShot.value['slider'].toDouble();
      autoStateProvider.setLed1 = snapShot.value['led1'];
      autoStateProvider.setLed2 = snapShot.value['led2'];
      autoStateProvider.setSliderValue = _slider.toInt();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    checkInternet();
    return noInternet
        ? Loader()
        : Consumer<AutomationStateProvider>(
            builder: (context, automation, _) => Column(
              children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
                      width: size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text('Led Lights', style: TextStyle(fontSize: 32),textAlign: TextAlign.left,),
                      ),
                    ),
                  ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.lightbulb,
                                      size: size.width * 0.32,
                                      color: automation.getLed1 == 1
                                          ? Colors.yellow
                                          : Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'LED-1',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    )
                                  ],
                                ),
                                onPressed: () {
                                  _database.once().then((snapShot) {
                                    var setData =
                                        snapShot.value['led1'] == 1 ? 0 : 1;
                                    _database.child('led1').set(setData);
                                    automation.setLed1 = setData;
                                  });
                                }),
                            ElevatedButton(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.lightbulb,
                                      size: size.width * 0.32,
                                      color: automation.getLed2 == 1
                                          ? Colors.yellow
                                          : Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'LED-2',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    )
                                  ],
                                ),
                                onPressed: () {
                                  _database.once().then((snapShot) {
                                    var setData =
                                        snapShot.value['led2'] == 1 ? 0 : 1;
                                    _database.child('led2').set(setData);
                                    automation.setLed2 = setData;
                                  });
                                })
                          ],
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Container(
                    width: size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text('Led Dimmer', style: TextStyle(fontSize: 32),textAlign: TextAlign.left,),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Slider(
                    value: _slider,
                    min: 0,
                    max: 255,
                    divisions: 255,
                    activeColor: Color.lerp(Colors.greenAccent, Colors.green,
                        _slider.toInt()/ 255),
                    label: automation.getSliderValue.toString(),
                    onChanged: (double data) {
                      // print(data.toInt());
                      _database.child('slider').set(data.toInt());
                      automation.setSliderValue = data.toInt();
                      setState(() {
                        _slider = data;
                      });
                    },
                  ),
                ),
              ],
            ),
          );
  }

  void checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          noInternet = false;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        noInternet = true;
      });
    }
  }
}
