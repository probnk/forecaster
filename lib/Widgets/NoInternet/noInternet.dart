import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:forecaster/Constants/Colors.dart';
import 'package:forecaster/Constants/fonts.dart';
import 'package:forecaster/Provider/themeProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Animations/FadeAnimation.dart';

class noInternet extends StatefulWidget {
  final Widget navigate;
  noInternet({super.key, required this.navigate});

  @override
  State<noInternet> createState() => _noInternetState();
}

class _noInternetState extends State<noInternet> {

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool isSetTheme = false;

  Future<void> getInitTheme() async {
    var getThemeData = await SharedPreferences.getInstance();
    setState(() {
      isSetTheme = getThemeData.getBool('setTheme') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    getInitTheme();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      print('Couldn\'t check connectivity status: $e');
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    print('Connectivity changed: $_connectionStatus');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeAnimation(
                delay: Duration(milliseconds: 200),
                child: Image.asset("assets/images/thunder2.png",width: 200,height: 200)),
            SizedBox(height: 30),
            FadeAnimation(
                delay: Duration(milliseconds: 400),
                child: Text("Whoops!!",style: LargeText)),
            SizedBox(height: 10),
            FadeAnimation(
                delay: Duration(milliseconds: 600),
                child: Text("No Internet connection was found. Check"
                    "\n your connection or try again",
                    textAlign: TextAlign.center,
                    style: LargeGrayText)),
            SizedBox(height: 30),
            Consumer<themeProvider>(
                builder: (context,value,child){
              return  FadeAnimation(
                  delay: Duration(milliseconds: 800),
                  child: InkWell(
                    borderRadius:BorderRadius.only(
                        bottomRight: Radius.circular(40),
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(14),
                        bottomLeft: Radius.circular(14)
                    ),
                    onTap: () {
                      if(_connectionStatus.contains(ConnectivityResult.none)){
                        Fluttertoast.showToast(msg: 'Please Check Your Internet Connection');
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => widget.navigate));

                      }
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(40),
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(14),
                            bottomLeft: Radius.circular(14)
                        ),
                      ),
                      elevation: 16,
                      child: Container(
                        width: 210,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(40),
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(14),
                                bottomLeft: Radius.circular(14)
                            ),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: value.theme
                                    ? [gradientLightBlue, gradientLightPurple]
                                    : [gradientLightRed, gradientDarkRed]
                            )
                        ),
                        child: Text("Try Again",style: LargeWhiteText),
                      ),
                    ),
                  )
              );
            })
          ],
        ),
      ),
    );
  }
}
