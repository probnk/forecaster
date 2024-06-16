import 'package:flutter/cupertino.dart';

class LoginProvider extends ChangeNotifier{
  bool _show = true;
  bool get show => _show;

  void ShowPassword(){
    _show = !_show;
    notifyListeners();
  }
}