import 'package:flutter/material.dart';
import 'package:forecaster/Constants/Colors.dart';
import 'package:forecaster/Constants/fonts.dart';

import '../../Animations/FadeAnimation.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  var items = ["Islamabad","Lahore","Karachi","Mianwali"];
  String _dropdownvalue = "Select City";
  bool isTrue = false;

  @override
  Widget build(BuildContext context) {
    String city = items[0];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FadeAnimation(
            delay: Duration(milliseconds: 100),
            child: Text("${isTrue ? _dropdownvalue : city}",style: headingWhiteText,)),
        FadeAnimation(
          delay: Duration(milliseconds: 150),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40)
            ),
            color: Colors.black,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14,vertical: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30)
              ),
              child: FadeAnimation(
                delay: Duration(milliseconds: 50),
                child: DropdownButton<String>(
                  value: _dropdownvalue,
                  dropdownColor: Colors.black,
                  icon: const Icon(Icons.menu,color: white,),
                  items: [
                    DropdownMenuItem(
                      value: "Select City",
                      child: Text("Select City  ",style: smallWhiteText,),
                    ),
                    ...items.map((String items) {
                      return DropdownMenuItem<String>(
                        value: items,
                        child: Text(items,style: smallWhiteText,),
                      );
                    }).toList(),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      isTrue = true;
                      _dropdownvalue = newValue!;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}