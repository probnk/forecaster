import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:forecaster/Constants/fonts.dart';
import 'package:forecaster/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants/Colors.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _allowNotifications = false;

  @override
  void initState() {
    super.initState();
    loadAllowNotifications();
  }

  Future<void> loadAllowNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _allowNotifications = prefs.getBool('allow_notifications') ?? false;
    });
  }

  _saveAllowNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('allow_notifications', value);
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
        title: Text('Notification Settings',style: whitetext,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Allow Notifications',
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
                      msg: _allowNotifications ? "Notification Turned On" : "Notification Turned Off",
                      backgroundColor: Colors.black87,
                    );
                    final service = FlutterBackgroundService();
                    var isRunning = await service.isRunning();
                    if (isRunning && !_allowNotifications) {
                      service.invoke('stopService');
                    } else {
                      await initializeServices();
                      await service.startService();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}