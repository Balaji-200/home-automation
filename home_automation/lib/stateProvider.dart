import 'package:flutter/cupertino.dart';

class AutomationStateProvider with ChangeNotifier {
  int led1, led2, led3, led4, slider;

  int get getLed1 => led1;

  int get getLed2 => led2;

  int get getSliderValue => slider;

  set setLed1(int data) {
    led1 = data;
    notifyListeners();
  }

  set setLed2(int data) {
    led2 = data;
    notifyListeners();
  }


  set setSliderValue(int data){
    slider = data;
    notifyListeners();
  }
}
