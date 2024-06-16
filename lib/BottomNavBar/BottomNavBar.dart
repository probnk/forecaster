import 'package:flutter/material.dart';
import 'package:forecaster/Constants/Colors.dart';
import 'package:forecaster/Provider/themeProvider.dart';
import 'package:forecaster/Widgets/HomePage/Home.dart';
import 'package:forecaster/Widgets/Pinned/Pinned.dart';
import 'package:forecaster/Widgets/Profile/Profile.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  List _screens = [Home(),Pinned(),Profile()];

  _bottomnavbar(BuildContext context){
    return Consumer<themeProvider>(
        builder: (context,value,child){
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 70,
        color: Colors.black,
        alignment: Alignment.bottomCenter,
        padding:EdgeInsets.symmetric(vertical: 10,horizontal: 12),
        child: GNav(
            onTabChange: (index){
              setState(() {
                _selectedIndex = index;
              });
              if(index == 2){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Profile()));
              }
            },
            padding: EdgeInsets.all(10),
            gap: 10,
            curve: Curves.easeIn,
            backgroundColor: Colors.black,
            rippleColor: value.theme ? Colors.blue : Colors.red,
            textStyle: TextStyle(
                color: Colors.white,
                fontSize: 18
            ),
            tabBackgroundGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:  value.theme
                    ? [gradientLightBlue, gradientLightPurple]
                    : [gradientLightRed, gradientDarkRed]
            ),
            tabs: [
              GButton(
                  padding: EdgeInsets.all(10),
                  iconSize: 24,
                  iconColor: Colors.white,
                  iconActiveColor: Colors.white,
                  icon: LineIcons.home,
                  text: 'Home'
              ),
              GButton(
                padding: EdgeInsets.all(10),
                iconSize: 24,
                iconColor: Colors.white,
                iconActiveColor: Colors.white,
                icon: LineIcons.stackOverflow,
                text: 'Pinned',
              ),
              GButton(
                  padding: EdgeInsets.all(10),
                  iconSize: 24,
                  iconColor: Colors.white,
                  iconActiveColor: Colors.white,
                  icon: LineIcons.user,
                  text: 'Profile'
              ),
            ]
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomnavbar(context),
      body: _screens[_selectedIndex],
    );
  }
}