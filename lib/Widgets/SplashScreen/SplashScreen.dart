import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:forecaster/Widgets/GetStarted/GetStarted_Screen.dart';
import 'package:forecaster/Widgets/Mainpage/MainPage.dart';
import 'package:forecaster/Widgets/NoInternet/noInternet.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Provider/themeProvider.dart';

class SplashScreen extends StatefulWidget {
  final bool isGetStarted;
  SplashScreen({super.key, required this.isGetStarted});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool? isDarkTheme;

  Future<void> initializeTheme() async {
    final themePreference = await SharedPreferences.getInstance();
    final provider = Provider.of<themeProvider>(context, listen: false);
    setState(() {
      isDarkTheme = themePreference.getBool('setTheme') ?? false;
    });
    provider.switchTheme(isDarkTheme!);
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initializeTheme();
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


  animatedLottie() {
    return AnimatedSplashScreen(
        backgroundColor: Colors.transparent,
        splash: Center(
          child: Lottie.asset('assets/images/cloud.json',),
        ),
        duration: 2000,
        //splashTransition: SplashTransition.fadeTransition,
        pageTransitionType:PageTransitionType.fade,
        //curve: Curves.bounceInOut,
        animationDuration: Duration(seconds: 4),
        splashIconSize: 400,
        nextScreen: _connectionStatus.contains(ConnectivityResult.none)
            ? noInternet(navigate:MainPage())
            : (widget.isGetStarted ? MainPage() : GetStarted())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2C2E38),
      body: animatedLottie(),
    );
  }
}
