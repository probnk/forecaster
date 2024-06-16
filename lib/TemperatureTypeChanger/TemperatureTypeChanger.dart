import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constants/Colors.dart';
import '../Constants/fonts.dart';

class TemperatureTypeChanger extends StatefulWidget {
  const TemperatureTypeChanger({super.key});

  @override
  State<TemperatureTypeChanger> createState() => _TemperatureTypeChangerState();
}

class _TemperatureTypeChangerState extends State<TemperatureTypeChanger> {
  bool _allowNotifications = false;

  @override
  void initState() {
    super.initState();
    loadAllowNotifications();
  }

  Future<void> loadAllowNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _allowNotifications = prefs.getBool('ChangeType') ?? false;
    });
  }

  _saveAllowNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('ChangeType', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        elevation: 8,
        backgroundColor: Colors.grey.shade800,
        title: Text('Temperature Settings',style: whitetext,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Temperature Type',
                    style:whitetext
                ),
                Card(
                  elevation: 8,
                  color:_allowNotifications ? Colors.black : Colors.grey.shade600,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Container(
                    width: 60,
                    height: 36,
                    child: Switch(
                      activeColor: Color(0xff39FF14),
                      activeTrackColor: Colors.black,
                      inactiveThumbColor: Colors.black,
                      inactiveTrackColor: Colors.grey.shade600,
                      value: _allowNotifications,
                      onChanged: (value) async{
                        setState(() {
                          _allowNotifications = value;
                        });
                        _saveAllowNotifications(value);
                        Fluttertoast.showToast(
                          textColor: white,
                          fontSize: 16,
                          msg: _allowNotifications ? "Temperature Type: Fahrenheit" : "Temperature Type: Celsius",
                          backgroundColor: Colors.black87,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              width: 255,
              child: Text(
                  'Switch the toggle button to see the temperature reading\'s in Fahrenheit',
                  textAlign: TextAlign.center,
                  style:smallGrayText
              ),
            ),
          ],
        ),
      ),
    );
  }
}