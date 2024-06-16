import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:forecaster/Provider/themeProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants/Colors.dart';
import '../../Constants/fonts.dart';

class theme extends StatefulWidget {
  const theme({super.key});

  @override
  State<theme> createState() => _themeState();
}

class _themeState extends State<theme> {
  late themeProvider _themeProvider;
  List color1 = [gradientLightRed,gradientLightBlue];
  List color2 = [gradientDarkRed,gradientLightPurple];
  List themeText = ["Ember Fall","Lavender Sky"];
  bool isSetTheme = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeProvider = Provider.of<themeProvider>(context);
  }

  @override
  void initState() {
    super.initState();
    getInitTheme(){
    }
  }

  Future<void> getInitTheme() async {
    var getThemeData = await SharedPreferences.getInstance();
    setState(() {
      isSetTheme = getThemeData.getBool('setTheme') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: Colors.grey.shade900,
        title: Center(child: Text('Theme Setting',style: LargeText,)),
      ),
      backgroundColor: Colors.grey.shade900,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          Container(
              width: 300,
              margin: EdgeInsets.only(left: 20),
              child: Text(
                "Choose the theme that speaks to your soul! Elevate your app experience with a touch of personal flair",
                style: littleGray,)),
          SizedBox(height: 20,),
          ListView.builder(
            itemCount: 2,
            shrinkWrap: true,
            itemBuilder: (context,index){
              return InkWell(
                radius: 65,
                borderRadius: BorderRadius.circular(20),
                onTap: () async{
                  var setTheme = await SharedPreferences.getInstance();
                  if(index == 0){
                    setState(() {
                      isSetTheme = false;
                    });
                  }
                  if(index == 1){
                    setState(() {
                      isSetTheme = true;
                    });
                  }
                  setTheme.setBool('setTheme',isSetTheme);
                  _themeProvider.switchTheme(isSetTheme);
                  Fluttertoast.showToast(msg: 'Theme Set to ${themeText[index]}');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                        gradient:LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [color1[index],color2[index]]
                        )
                    ),
                    child:  Center(child: Text("${themeText[index]}",style: whitetext,)),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}