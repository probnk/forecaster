import 'package:flutter/cupertino.dart';

class themeProvider with ChangeNotifier{
  bool _theme = false;
  bool get theme => _theme;

   void switchTheme(bool isSetTheme) {
    _theme = isSetTheme;
    notifyListeners();
  }
}