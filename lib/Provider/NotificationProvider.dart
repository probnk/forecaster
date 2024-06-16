import 'package:flutter/cupertino.dart';

class NotificationProvider with ChangeNotifier {
  double _temperature = 0.0;
  double _humidity = 0.0;
  double _windSpeed = 0.0;

  double get temperature => _temperature;
  double get humidity => _humidity;
  double get windSpeed => _windSpeed;

  void Temperature(double value) {
    _temperature = value;
    notifyListeners();
  }

  void Humidity(double value) {
    _humidity = value;
    notifyListeners();
  }

  void WindSpeed(double value) {
    _windSpeed = value;
    notifyListeners();
  }
}