import 'package:flutter/material.dart';
import 'package:forecaster/BottomNavBar/BottomNavBar.dart';
import 'package:forecaster/Constants/fonts.dart';
import 'package:forecaster/Provider/weather_details_provider.dart';
import 'package:provider/provider.dart';
import '../../Animations/FadeAnimation.dart';
import '../../Constants/Colors.dart';

class WeatherDetails extends StatelessWidget {
  WeatherDetails({super.key});

  var _time = ["Morning","Afternoon","Evening","Night"];
  List _temperature = ["20°",'18°','16°',"14°"];
  var _icons = ["","snow_cloud","strike_cloud","rain_cloud"];
  List _percentage = ["--","25%","20%","80%"];
  List _pics = ["sunset1","drop","mark","moon phase","dew","eye"];
  List _title = ["UV Index","Humadity","High/Low","Moon Phase","Dew Point","Visibilty"];
  List _subTitle = ["5 to 10","70%","--/23","Waning Gibbous","23","9.66 km"];

  _body(BuildContext context) {
    return Column(
      children: [
        FadeAnimation(
          delay: Duration(milliseconds: 100),
          child: _appbar(context),
        ),
        FadeAnimation(
          delay: Duration(milliseconds: 450),
          child: _weatherdetails(context),
        ),
      ],
    );
  }

  _appbar(BuildContext context) {
    return Expanded(
      flex: 2,
      child: FadeAnimation(
        delay: Duration(milliseconds: 150),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)
              ),
              gradient:LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [gradientLightRed,gradientDarkRed]
              )
              ,
            boxShadow: [
              BoxShadow(
                color: black,
                spreadRadius: 3,
                blurRadius: 15
              )
            ]
          ),
          child: SafeArea(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FadeAnimation(
                    delay: Duration(milliseconds: 200),
                    child: IconButton(
                        onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavBar()));
                        },
                        icon: Icon(Icons.arrow_back,color: Colors.white,size: 24)
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      FadeAnimation(
                        delay: Duration(milliseconds: 250),
                        child: Container(
                            width: 230,
                            margin: EdgeInsets.only(left: 14),
                            child: Text("Islamabad", style:grayText)
                        ),
                      ),
                      FadeAnimation(
                        delay: Duration(milliseconds: 300),
                        child: Image(
                          image: AssetImage("assets/images/weather.png",),
                           width: 85,height: 85,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FadeAnimation(
                          delay: Duration(milliseconds: 350),
                          child: Text("18°C",style: temperature)),
                      FadeAnimation(
                          delay: Duration(milliseconds: 400),
                          child: Text("3:25 pm WIB",style: lightgraytext,))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _weatherdetails(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14,vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FadeAnimation(
                    delay: Duration(milliseconds: 500),
                    child: Text("Forecast",style: headingText,)),
                FadeAnimation(
                  delay: Duration(milliseconds: 550),
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        elevation: 8
                      ),
                      child: Text("Next Hour",style: grayText,)
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              height: 180,
              child: ListView.builder(
                  itemCount: 4,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index){
                return FadeAnimation(
                  delay: Duration(milliseconds: 600),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    padding: EdgeInsets.all(5),
                    height: 180,
                    width:130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue.shade50,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FadeAnimation(
                            delay: Duration(milliseconds: 650),
                            child: Text("${_time[index]}",style: blackText)),
                        SizedBox(height: 10),
                        FadeAnimation(
                            delay: Duration(milliseconds: 700),
                            child: Text("${_temperature[index]}",style: blackText)),
                        SizedBox(height: 10),
                        if(index == 0)
                          FadeAnimation(
                              delay: Duration(milliseconds: 750),
                              child: Icon(Icons.cloud_queue_rounded,color:Colors.orange.shade600,size: 40)),
                        if(index != 0)
                          FadeAnimation(
                              delay: Duration(milliseconds: 750),
                              child: Image(image: AssetImage("assets/images/${_icons[index]}.png"),width: 40,height: 40,color: Colors.orange.shade600)),
                        SizedBox(height: 10),
                        FadeAnimation(
                            delay: Duration(milliseconds: 800),
                            child: Text("${_percentage[index]}",style: blackText)),
                      ],
                    ),
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  _bottomSheetTips(BuildContext context) {
    return Consumer<WeatherDetailsProvider>(builder: (context,value,child){
      return value.isOpen ? Container(
        padding: const EdgeInsets.all(14),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height*.44,
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(20)
        ),
        child: FadeAnimation(
          delay: Duration(milliseconds: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 8,
                color: black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
                child: InkWell(
                  onTap: () {
                    value.isTrue();
                  },
                  child: FadeAnimation(
                    delay: Duration(milliseconds: 850),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        decoration: BoxDecoration(
                            color: black,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.keyboard_arrow_down_rounded,size: 40,color: gray),
                            Text("Hide Details",style: largegraytext)
                          ],
                        )
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FadeAnimation(
                      delay: Duration(milliseconds: 100),
                      child: Text("Weather",style: headingText)),
                  FadeAnimation(
                      delay: Duration(milliseconds: 150),
                      child: Text("Wind",style: largegraytext)),
                  FadeAnimation(
                      delay: Duration(milliseconds: 150),
                      child: Text("Precipitation",style: largegraytext)),
                ],
              ),
              SizedBox(height: 10,),
              Expanded(
                  child: GridView.builder(
                      itemCount: 6,
                      gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 2.0
                      ),
                      itemBuilder: (context,index){
                        return FadeAnimation(
                          delay: Duration(milliseconds: 200 * (index + 1)),
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: FadeAnimation(
                                delay: Duration(milliseconds: 250 * (index + 1)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(image: AssetImage("assets/images/${_pics[index]}.png"),width: 35,height: 35),
                                    SizedBox(width: 3),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("${_title[index]}",style: smallBlackText),
                                        Text("${_subTitle[index]}",style: littleGray)
                                      ],
                                    )
                                  ],
                                ),
                              )
                          ),
                        );
                      })
              )
            ],
          ),
        ),
      )
          :  InkWell(
            onTap: () {
              value.isTrue();
            },
            child: FadeAnimation(
            delay: Duration(milliseconds: 100),
              child: Card(
                elevation: 8,
                color: black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                        color: black,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child:FadeAnimation(
                      delay: Duration(milliseconds: 150),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.keyboard_arrow_up_rounded,size: 40,color: gray),
                          Text("View Details",style: largegraytext)
                        ],
                      ),
                    )
                ),
              ),
            )
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomSheet: _bottomSheetTips(context),
      body: _body(context),
    );
  }
}