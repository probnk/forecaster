import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:forecaster/BottomNavBar/BottomNavBar.dart';
import 'package:forecaster/Constants/Colors.dart';
import 'package:forecaster/Constants/fonts.dart';
import 'package:forecaster/Provider/LoginProvider.dart';
import 'package:forecaster/Provider/themeProvider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Animations/FadeAnimation.dart';
import '../NoInternet/noInternet.dart';
import '../Signup/Signup_Screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var textlist2 = ["Enter your email","Enter your password"];
  List _icons1 = [Icons.email,Icons.lock];
  List _icons2 = [Icons.email,Icons.lock_open];
  final email = TextEditingController();
  final password = TextEditingController();
  final _googlesignin = GoogleSignIn();
  final _auth = FirebaseAuth.instance;
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

  Future _handleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googlesignin.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      if (userCredential != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavBar()));
      }
    } catch (e) {
      print(e);
    }
  }

  Future SignIn(BuildContext context) async {
    try {
      FirebaseAuth _auth = await FirebaseAuth.instance;
      await _auth.signInWithEmailAndPassword(
          email: email.text,
          password: password.text);
      if (_auth.currentUser != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavBar()));
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<themeProvider>(
        builder: (context,value,index){
      return Container(
        decoration: BoxDecoration(
            gradient:LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: value.theme
                    ? [gradientLightBlue, gradientLightPurple]
                    : [gradientLightRed, gradientDarkRed]
            )
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: ListView(
            children: [
              FadeAnimation(
                  delay: Duration(milliseconds: 200),
                  child: Image.asset("assets/images/weather.png",height: 150)),
              SizedBox(height: 14),
              FadeAnimation(
                delay: Duration(milliseconds: 400),
                child: Center(
                  child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        ColorizeAnimatedText(
                            speed: Duration(milliseconds: 500),
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
                delay: Duration(milliseconds:600),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,top: 40,bottom: 40),
                  child: Center(
                    child: Card(
                      color: Colors.white.withOpacity(0.4),
                      elevation: 16,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Consumer<LoginProvider>(
                                builder: (context,value,child){
                                  return ListView.builder(
                                      itemCount: _icons1.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context,index){
                                        return FadeAnimation(
                                          delay: Duration(milliseconds: 800),
                                          child: Card(
                                            elevation: 8,
                                            margin: EdgeInsets.only(left: 10,right: 10,top: 15),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Container(
                                                height: 65,
                                                child:Column(
                                                  children: [
                                                    TextFormField(
                                                      controller: index == 0 ? email : password,
                                                      obscureText: index == 0 ? false : value.show,
                                                      decoration: InputDecoration(
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                            borderSide: BorderSide(color:gradientLightBlue,width: 2 )
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.transparent),
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        suffixIcon: IconButton(
                                                          onPressed: () {
                                                            if(index == 1)
                                                              value.ShowPassword();
                                                          },
                                                          icon: value.show && index == 1
                                                              ? Icon(_icons1[index],color: Colors.grey.shade400,)
                                                              : Icon(_icons2[index],color: Colors.grey.shade400,),
                                                        ),
                                                        hintText: "${textlist2[index]}",
                                                        hintStyle: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w400
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                            ),
                                          ),
                                        );
                                      });
                                }),
                            FadeAnimation(
                              delay: Duration(milliseconds: 1000),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text( "Do you have an account?", style: smallGrayText),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => SignUp()
                                        )
                                        );
                                      },
                                      child: Text("Signup Now", style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      )
                                  )
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
                                      backgroundColor: value.theme ? Colors.blue.shade900 :Colors.red.shade900,
                                      padding: EdgeInsets.symmetric(horizontal: 100,vertical: 14)
                                  ),
                                  onPressed: () {
                                    if(_connectionStatus.contains(ConnectivityResult.none)){
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(
                                              builder: (context) => noInternet(navigate:Login())));
                                    }else{
                                      SignIn(context);
                                    }
                                  },
                                  child: Text("Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            FadeAnimation(
                              delay: Duration(milliseconds: 1600),
                              child: Center(
                                child: Text("-----------OR-----------",style: grayText,),
                              ),
                            ),
                            SizedBox(height: 10,),
                            FadeAnimation(
                                delay: Duration(milliseconds: 2000),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white38,
                                          elevation: 8,
                                          padding: EdgeInsets.symmetric(vertical: 3,horizontal: 10),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20)
                                          )
                                      ),
                                      onPressed: () {
                                        _handleSignIn(context);
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset("assets/images/google.png",width: 50,height: 50,),
                                          Text("Google",style: whitetext,)
                                        ],
                                      )
                                  ),
                                )
                            ),
                            SizedBox(height: 20,)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // FadeAnimation(
              //   delay: Duration(milliseconds: 2200),
              //   child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Image.asset("assets/images/instagram.png",width: 24,height: 24),
              //           SizedBox(width: 10),
              //           Text("@_flutterfusion", style:whitetext),
              //         ],
              //       ),
              // ),
            ],
          ),
        ),
      );
    });
  }
}
