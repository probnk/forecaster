import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:forecaster/Animations/FadeAnimation.dart';
import 'package:forecaster/Constants/fonts.dart';
import 'package:forecaster/Provider/themeProvider.dart';
import 'package:forecaster/Widgets/Mainpage/MainPage.dart';
import 'package:forecaster/Widgets/NoInternet/noInternet.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constants/Colors.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
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

  _images(String url, double width, double height){
    return  Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            offset: Offset(20, 30),
            spreadRadius: 20,
            blurRadius: 20,
          ),
        ],
      ),
      child: Image.asset("assets/images/$url.png",width: width,height: height,),
    );
  }

  @override
  Widget build(BuildContext context) {
      return Consumer<themeProvider>(
          builder: (context,value,child){
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:value.theme ?[gradientLightBlue, gradientLightPurple] : [gradientLightRed, gradientDarkRed],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10,right: 10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeAnimation(
                        delay: Duration(milliseconds: 400),
                        child: Padding(
                            padding: const EdgeInsets.only(top: 10,left: 20),
                            child: _images("moon2", 100.0, 100.0)
                        ),
                      ),
                      SizedBox(height: 20,),
                      FadeAnimation(
                          delay: Duration(milliseconds: 600),
                          child: Center(child:  _images("weather", 200.0, 200.0),)),
                      FadeAnimation(
                        delay: Duration(milliseconds: 800),
                        child: Center(
                          child: AnimatedTextKit(
                              isRepeatingAnimation: false,
                              animatedTexts: [
                                ColorizeAnimatedText(
                                    "WEATHER\nFORECASTS",
                                    textStyle: heading,
                                    colors:[
                                      white,
                                      gradientLightBlue,
                                      gradientPurple,
                                      gradientPink,
                                      gradientDarkRed
                                    ]
                                )
                              ]
                          ),
                        ),
                      ),
                      FadeAnimation(
                          delay: Duration(milliseconds: 1000),
                          child: Center(child:  _images("rain", 100.0, 100.0),)),
                      SizedBox(height: 10,),
                      FadeAnimation(
                        delay: Duration(milliseconds: 1200),
                        child: Center(
                          child: AnimatedTextKit(
                              isRepeatingAnimation: false,
                              animatedTexts: [
                                TyperAnimatedText(
                                  "Search Your Location Weather\nRight now to Plan your vacation's",
                                  textStyle: smallWhiteText,
                                ),
                              ]
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      FadeAnimation(
                        delay: Duration(milliseconds: 1400),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  backgroundColor: Colors.red.shade900,
                                  padding: EdgeInsets.symmetric(horizontal: 100,vertical: 14)
                              ),
                              onPressed: () async {
                                final sharedPreference = await SharedPreferences.getInstance();
                                sharedPreference.setBool('isGetStarted', true);
                                if(_connectionStatus.contains(ConnectivityResult.none)) {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                          builder: (context) => noInternet(navigate:MainPage())));
                                }else{
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                          builder: (context) => MainPage()));
                                }
                              },
                              child: AnimatedTextKit(
                                  isRepeatingAnimation: false,
                                  animatedTexts: [
                                    ColorizeAnimatedText(
                                        speed: Duration(milliseconds: 300),
                                        "SignUp Now",
                                        textStyle: smallWhiteText,
                                        colors: [
                                          white,
                                          white,
                                          gradientLightBlue,
                                          gradientPurple,
                                          gradientPink,
                                          gradientDarkRed
                                        ]
                                    ),
                                    ColorizeAnimatedText(
                                        "Login Now",
                                        textStyle: smallWhiteText,
                                        colors: [
                                          white,
                                          white,
                                          gradientLightBlue,
                                          gradientPurple,
                                          gradientPink,
                                          gradientDarkRed
                                        ]
                                    ),
                                    ColorizeAnimatedText(
                                        "Get Started",
                                        textStyle: smallWhiteText,
                                        colors: [
                                          white,
                                          white,
                                          gradientLightBlue,
                                          gradientPurple,
                                          gradientPink,
                                          gradientDarkRed
                                        ]
                                    ),
                                  ]
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
    }
  }