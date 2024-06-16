import 'package:flutter/foundation.dart';

class SignupProvider extends ChangeNotifier {
  bool _isTrue = true;
  bool get isTrue => _isTrue;

  void toggle() {
    _isTrue = !_isTrue;
    notifyListeners();
  }
}
