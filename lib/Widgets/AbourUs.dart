import 'package:flutter/material.dart';
import 'package:forecaster/Constants/fonts.dart';
import '../Animations/FadeAnimation.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.grey.shade900,
        title: Center(child: Text('About Us',style: LargeText,)),
      ),
      body: Container(
        width:MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeAnimation(
                delay: Duration(milliseconds: 200),
                child: Text(
                  'About Our Weather Forecast App',
                  style:LargeWhiteText),
              ),
              SizedBox(height: 20),
              FadeAnimation(
                delay: Duration(milliseconds: 400),
                child: Container(
                  width: 330,
                  child: Text(
                    textAlign: TextAlign.center,
                    'Welcome to our weather forecast app!'
                        ' We strive to provide accurate and'
                        ' up-to-date weather information to'
                        ' help you plan your day and stay'
                        ' informed about changing weather'
                        ' conditions.',
                    style:littleGray),
                ),
              ),
              SizedBox(height: 20),
              FadeAnimation(
                delay: Duration(milliseconds: 600),
                child: Text(
                  'Developed by:',
                  style: largegraytext),
              ),
              SizedBox(height: 10),
              FadeAnimation(
                delay: Duration(milliseconds: 800),
                child: Center(
                  child: Text(
                    'Rao Muhammad Mohsin\n Muhammad Shamir\n Umar Farooq',
                    style: largegraytext),
                ),
              ),
              SizedBox(height: 20),
              FadeAnimation(
                  delay: Duration(milliseconds: 1000),
                  child: Container(
                      alignment:Alignment.topRight,child: Image.asset("assets/images/thunder4.png",width: 200,height: 200))
              ),
              SizedBox(height: 50,),
              FadeAnimation(
                delay: Duration(milliseconds: 1200),
                child: Text(
                    'Our Social Media Accounts:',
                    style: smallgraytext),
              ),

              SizedBox(height: 8,),
              FadeAnimation(
                delay: Duration(milliseconds: 1400),
                child: Padding(
                  padding: const EdgeInsets.only(left: 130),
                  child: Row(
                    children: [
                      Image.asset("assets/images/instagram.png",width: 24,height: 24),
                      SizedBox(width: 10),
                      Text("@rao_mohsin_04", style:whitetext),
                    ],
                  ),
                ),
              ),
              FadeAnimation(
                delay: Duration(milliseconds: 1500),
                child: Padding(
                  padding: const EdgeInsets.only(left: 130),
                  child: Row(
                    children: [
                      Image.asset("assets/images/instagram.png",width: 24,height: 24),
                      SizedBox(width: 10),
                      Text("@itsshamir673", style:whitetext),
                    ],
                  ),
                ),
              ),
              FadeAnimation(
                delay: Duration(milliseconds: 1600),
                child: Padding(
                  padding: const EdgeInsets.only(left: 130),
                  child: Row(
                    children: [
                      Image.asset("assets/images/instagram.png",width: 24,height: 24),
                      SizedBox(width: 10),
                      Text("@itx_umarf", style:whitetext),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
