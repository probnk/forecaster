import 'package:flutter/cupertino.dart';

class PinnedWeatherProvider extends ChangeNotifier{
  bool _isPinned = false;
  bool get isPinned => _isPinned;

  void isPinnedToggle(){
    _isPinned = !_isPinned;
    notifyListeners();
  }
}