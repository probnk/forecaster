import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:forecaster/BottomNavBar/BottomNavBar.dart';
import 'package:forecaster/TemperatureTypeChanger/TemperatureTypeChanger.dart';
import 'package:forecaster/Widgets/AbourUs.dart';
import 'package:forecaster/Widgets/Login/Login_Screen.dart';
import 'package:forecaster/Widgets/NotificationTurnon/TurnonNotification.dart';
import 'package:forecaster/Widgets/Theme/Theme.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constants/Colors.dart';
import '../../Constants/fonts.dart';
import '../../Provider/themeProvider.dart';

class Profile extends StatefulWidget {
  Profile({super.key});

  List _titles = ["Temperature C/F", "Notification", "Theme", "About Us"];
  List _pics = ["temperature", "notification", "theme", "info"];

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _showLottie = true;
  String imageUrl = " ";
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? profileImageUrl;

  void _handleSignOut(BuildContext context) async {
    try{
      await _googleSignIn.signOut();
      if(_googleSignIn.currentUser== null){
        Navigator.push(context, MaterialPageRoute(builder:(context)=>Login()));
      }
      await _auth.signOut();
      if(_auth.currentUser== null){
        Navigator.push(context, MaterialPageRoute(builder:(context)=>Login()));
      }
    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchImageUrl();
    Timer(Duration(seconds: 2), () {
      setState(() {
        _showLottie = false;
      });
    });
  }

  _setPhoto() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source:ImageSource.camera);
    //Fluttertoast.showToast(msg: "${file!.path}");
    if(file == null) return;
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImage = referenceRoot.child('images');

    Reference referenceImageToUpload = referenceDirImage.child(uniqueFileName);

    try{
      await referenceImageToUpload.putFile(File(file.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
      Fluttertoast.showToast(msg: "File Uploaded");
    }catch(e){
      Fluttertoast.showToast(msg: "Error: $e");
    }

    final storeImage = await FirebaseFirestore
        .instance
        .collection(
        FirebaseAuth.instance.currentUser!.email.toString());
    storeImage.doc("Profile").set({'image':imageUrl});
  }

  Future<void> fetchImageUrl() async {
    final profileImage =
    await FirebaseFirestore.instance.collection(
        FirebaseAuth.instance.currentUser!.email.toString());
    profileImage.doc("Profile");
    QuerySnapshot querySnapshot = await profileImage.get();
    List<String> cities = [];
    for (var doc in querySnapshot.docs) {
      cities.add(doc['image']);
    }
    setState(() {
      profileImageUrl = cities.isNotEmpty ? cities[0] : null;
    });
  }

  _body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 1, child: _userDetails(context)),
        SizedBox(height: 20),
        Expanded(flex: 2, child: _buttonsList(context)),
      ],
    );
  }

  _userDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => BottomNavBar()));
                  },
                  icon: Icon(Icons.arrow_back, color: white, size: 30,)),
              Text("User Profile", style: headingWhiteText),
              Text("      ")
            ],
          ),
          SizedBox(height: 20,),
          Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      FirebaseAuth.instance.currentUser!.photoURL != null
                          ? CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage("${FirebaseAuth.instance.currentUser!.photoURL}")
                      )
                          : CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage("assets/images/profile.png")
                      ),
                      Positioned(
                          top: 80,
                          left: 200,
                          child: InkWell(
                            onTap: () {
                              _setPhoto();
                            },
                            child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: Colors.white54,
                                    shape: BoxShape.circle
                                ),
                                child: Icon(Icons.camera_alt, color: Colors.black, size: 20,)),
                          )),
                    ],
                  ),
                  SizedBox(height: 4,),
                  Text("${FirebaseAuth.instance.currentUser!.displayName ?? ""}", style: smallWhiteText,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on_rounded, color: white54, size: 20),
                      Text("Islamabad, Pakistan", style: grayText,)
                    ],
                  )
                ],
              )
          ),
        ],
      ),
    );
  }

  _buttonsList(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                offset: Offset(20, 20),
                spreadRadius: 1,
                blurRadius: 60
            )
          ]
      ),
      child: _showLottie
          ? Lottie.asset("assets/lottie/loading.json", width: 100, height: 100)
          : ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                if(index == 0){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TemperatureTypeChanger()));
                }else if(index == 1){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen()));
                }else if(index == 2){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => theme()));
                }else if(index == 3){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUsScreen()));
                }
              },
              child: Card(
                elevation: 4,
                color: black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                  margin: EdgeInsets.only(top: 11),
                  padding: EdgeInsets.all(28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset("assets/images/${widget._pics[index]}.png",
                              width: 30, height: 30),
                          SizedBox(width: 4),
                          Text(" ${widget._titles[index]}", style: whitetext,)
                        ],
                      ),
                      Icon(Icons.arrow_forward, color: white, size: 30,),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context){
    return Consumer<themeProvider>(
        builder:(context,value,child){
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: value.theme!
                  ? [gradientLightBlue, gradientLightPurple]
                  : [gradientLightRed, gradientDarkRed]
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            bottomSheet:_showLottie ?Text(""): InkWell(
              onTap: () {
                showDialog(
                    barrierColor: Colors.black54,
                    context: context,
                    builder: (context) => AlertDialog(
                      elevation: 8,
                      backgroundColor: black,
                      title: Text('Logout', style: whitetext,),
                      content: Text('Are you Really\n Want to Logout?', style: whitetext,),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel', style: whitetext,),
                        ),
                        TextButton(
                          onPressed: () {
                            _handleSignOut(context);
                          },
                          child: Text('Logout', style: whitetext,),
                        ),
                      ],
                    )
                );
              },
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: white,
                    border: Border.all(color: Colors.grey.shade400)
                ),
                child: Center(
                  child: Text("Logout", style: Gray,),
                ),
              ),
            ),
            body: SafeArea(
              child: _showLottie
                  ? Center(
                child: Lottie.asset("assets/images/cloud_animation.json", width: 200, height: 200),
              )
                  : _body(context),
            )
        ),
      );
    });
  }
}