import 'package:flutter/cupertino.dart';

class WeatherDetailsProvider extends ChangeNotifier{
  bool _isOpen = false;
  bool get isOpen => _isOpen;

  void isTrue(){
    _isOpen = !_isOpen;
    notifyListeners();
  }
}