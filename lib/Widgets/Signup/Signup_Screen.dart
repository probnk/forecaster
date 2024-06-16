import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:forecaster/Provider/themeProvider.dart';
import 'package:provider/provider.dart';
import 'package:forecaster/Provider/SignupProvider.dart';
import 'package:forecaster/Widgets/Login/Login_Screen.dart';
import 'package:forecaster/Constants/Colors.dart';
import 'package:forecaster/Constants/fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Animations/FadeAnimation.dart';
import '../NoInternet/noInternet.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final List<String> textList = ["Enter your full name", "Enter your email", "Enter your password","Enter your phone number"];
  final List<IconData> _icons1 = [Icons.person, Icons.email, Icons.lock,Icons.phone_android_rounded];
  final List<IconData> _icons2 = [Icons.person, Icons.email, Icons.lock_open,Icons.phone_android_rounded];
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  final phone = TextEditingController();
  String? _uid;
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

  Future signup() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      ).then((userCredential) {
        _uid = userCredential.user!.uid;
        Fluttertoast.showToast(
          msg: 'Signup Successfully',
          backgroundColor: Colors.grey,
        );

        CollectionReference _reference =
        FirebaseFirestore.instance.collection('Users');
        _reference.doc(_uid).set({
          'Name': name.text,
          'Email': email.text,
          'Password': password.text,
          'Phone Number':phone.text
        });
      });
    } catch (e) {
      print(e);
    }
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
              colors: value.theme
                  ? [gradientLightBlue, gradientLightPurple]
                  : [gradientLightRed, gradientDarkRed]
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: ListView(
            children: [
              FadeAnimation(
                  delay: Duration(milliseconds: 200),
                  child: Image.asset("assets/images/weather.png", height: 150)),
              SizedBox(height: 14),
              FadeAnimation(
                delay: Duration(milliseconds: 400),
                child: Center(
                  child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        ColorizeAnimatedText(
                            speed:Duration(milliseconds: 500),
                            "WEATHER FORECASTS",
                            textStyle: headingWhiteText,
                            colors:[
                              white,
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
                delay: Duration(milliseconds: 600),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Card(
                      color: Colors.white.withOpacity(.3),
                      elevation: 16,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Consumer<SignupProvider>(
                              builder: (context, value, child) {
                                return ListView.builder(
                                    itemCount: _icons1.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context,index){
                                      return FadeAnimation(
                                        delay: Duration(milliseconds: 800),
                                        child: Card(
                                          elevation: 8,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          margin: EdgeInsets.only(top: 10),
                                          child: Container(
                                            height: 55,
                                            child: TextField(
                                              controller: index == 0 ? name : index == 1 ? email : index == 2 ? password : phone,
                                              obscureText: index == 2 ? value.isTrue : false,
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                suffixIcon: IconButton(
                                                  onPressed: () {
                                                    if (index == 2)
                                                      value.toggle();
                                                  },
                                                  icon: Icon(
                                                    value.isTrue ? _icons1[index] : _icons2[index],
                                                    color: Colors.grey.shade400,
                                                  ),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                  borderSide: BorderSide(color: gradientLightBlue, width: 2),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(color: Colors.transparent)
                                                ),
                                                hintText: textList[index],
                                                hintStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              keyboardType:index == 3 ? TextInputType.number : TextInputType.text,
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              },
                            ),
                            SizedBox(height: 20),
                            FadeAnimation(
                              delay: Duration(milliseconds: 1000),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text( "Already have an account?",style: smallGrayText),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                                    },
                                    child: Text(
                                      "Login Now",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FadeAnimation(
                              delay: Duration(milliseconds: 1200),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 8,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20)
                                      ),
                                      backgroundColor: value.theme ? Colors.blue.shade900 : Colors.red.shade900,
                                      padding: EdgeInsets.symmetric(horizontal: 80,vertical: 14)
                                  ),
                                  onPressed: () {
                                    if(_connectionStatus.contains(ConnectivityResult.none)){
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(
                                              builder: (context) => noInternet(navigate:SignUp())));
                                    }else{
                                      signup();
                                    }
                                  },
                                  child: Text("Signup",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20
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
              ),
              SizedBox(height: 20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     FadeAnimation(
              //         delay: Duration(milliseconds: 1400),
              //         child: Image.asset("assets/images/instagram.png", width: 24, height: 24)),
              //     SizedBox(width: 10),
              //     FadeAnimation(
              //         delay: Duration(milliseconds: 1600),
              //         child: Text("@_flutterfusion", style: whitetext)),
              //   ],
              // ),
            ],
          ),
        ),
      );
    });
  }
}