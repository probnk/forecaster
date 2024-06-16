import 'package:flutter/material.dart';
import 'package:forecaster/BottomNavBar/BottomNavBar.dart';
import 'package:forecaster/Constants/Colors.dart';
import 'package:forecaster/Constants/fonts.dart';
import 'package:forecaster/Provider/themeProvider.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/weather.dart';
import '../../Animations/FadeAnimation.dart';
import '../../Constants/api.dart';
import '../../Modules/CurrentWeather.dart';
import '../../PinnedWeather/PinnedItems.dart';
import '../../Provider/weather_details_provider.dart';

class weather extends StatefulWidget {
  final CurrentWeather currentWeather;
  final String city;
  weather({required this.currentWeather, required this.city});

  @override
  _weatherState createState() => _weatherState();
}

class _weatherState extends State<weather> {
  final _wf = WeatherFactory(OpenWeatherAPIKey);
  List<Weather> _weathers = [];
  bool isTrue = false;
  bool pinned = false;
  String celsius = "°C";
  bool isCelsius = false;

  @override
  void initState() {
    super.initState();
    _searchWeather(widget.city);
    getCityPinned(widget.city).then((value) {
      setState(() {
        pinned = value;
      });
    });
  }

  _searchWeather(String city) async {
    final sharedPref = await SharedPreferences.getInstance();
    final weatherData = await _wf.fiveDayForecastByCityName(city);
    setState(() {
      _weathers = weatherData;
      isCelsius = sharedPref.getBool('ChangeType') ?? false;
      isTrue = true;
    });
  }

  Future<void> setCityPinned(String city, bool value) async {
    final sharedPreference = await SharedPreferences.getInstance();
    sharedPreference.setBool('$city', value);
  }

  Future<bool> getCityPinned(String city) async {
    final sharedPreference = await SharedPreferences.getInstance();
    return sharedPreference.getBool('$city') ?? false;
  }

  _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: ListView(
        children: [
          FadeAnimation(
              delay: Duration(milliseconds: 200), child: _currentWeather(context)),
          SizedBox(height: 10),
          FadeAnimation(
              delay: Duration(milliseconds: 450), child: _dayWeatherDetails()),
          SizedBox(height: 20),
          FadeAnimation(
              delay: Duration(milliseconds: 550),
              child: _upcomingDaysWeatherDetails()),
        ],
      ),
    );
  }

  _currentWeather(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BottomNavBar()));
                },
                icon: Icon(Icons.arrow_back,
                    color: white, size: 30)),
            Text(widget.city, style: heading),
            Text(""),
          ],
        ),
        FadeAnimation(
            delay: Duration(milliseconds: 250),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.currentWeather.date, style: lightgraytext),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                        "${_weathers[0].weatherDescription}",
                        style: lightgraytext),
                  ],
                ),
              ],
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FadeAnimation(
                    delay: Duration(milliseconds: 300),
                    child: Container(
                      width: 70,
                      height: 60,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  "https://openweathermap.org/img/wn/${_weathers[0].weatherIcon}@4x.png"))),
                    )
                ),
                FadeAnimation(
                    delay: Duration(milliseconds: 350),
                    child: Text("${isCelsius
                        ?_weathers[0].temperature!.fahrenheit!.toStringAsFixed(0)
                        :_weathers[0].temperature!.celsius!.toStringAsFixed(0)} ${isCelsius ? "F":celsius}",
                        style: heading)),
              ],
            ),
            Text("Feel Like: ${isCelsius
                ?_weathers[0].temperature!.fahrenheit!.toStringAsFixed(0)
                :_weathers[0].temperature!.celsius!.toStringAsFixed(0)} ${isCelsius ? "F":celsius}",style: smallWhiteText,)
          ],
        ),
      ],
    );
  }

  _dayWeatherDetails() {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)),
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.white38,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Text("Today's Weather", style: LargeText),
            SizedBox(height: 16),
            Container(
              height: 260,
              child: ListView.builder(
                  itemCount: 8,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          index == 0
                              ? Text("now", style: blackText3)
                              : Text(
                              "${DateFormat("hh:00").format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour + (index * 3)))}",
                              style: blackText3),
                          SizedBox(height: 10),
                          Column(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            "https://openweathermap.org/img/wn/${_weathers[index].weatherIcon}@4x.png"))),
                              ),
                              Text(
                                  "${isCelsius
                                      ?_weathers[index].temperature!.fahrenheit!.toStringAsFixed(0)
                                      :_weathers[index].temperature!.celsius!.toStringAsFixed(0)} ${isCelsius ? "F":celsius}",
                                  style: smallBlackText3),
                            ],
                          ),
                          SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset("assets/images/drop.png",
                                  width: 24, height: 24),
                              Text(
                                  "${_weathers[index].humidity?.toStringAsFixed(0)?? ""}%",
                                  style: smallBlackText3),
                            ],
                          ),
                          SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset("assets/images/air.png",
                                  width: 24, height: 24, color: white),
                              Text(
                                  "${_weathers[index].windSpeed?.toStringAsFixed(0)?? ""}m/s",
                                  style: smallBlackText3),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  _upcomingDaysWeatherDetails() {
    return FadeAnimation(
      delay: Duration(milliseconds: 600),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(14),
          margin: EdgeInsets.only(bottom: 100),
          decoration: BoxDecoration(
              color: Colors.white38,
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Text("Upcoming's Weather", style: LargeText),
              SizedBox(height: 16),
              ListView.builder(
                  physics: ScrollPhysics(),
                  itemCount: 5,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return FadeAnimation(
                      delay: Duration(milliseconds: 650),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FadeAnimation(
                                delay: Duration(milliseconds: 250 * (index)),
                                child: Container(
                                    width: 40,
                                    child: Text(
                                      "${index == 0 ? "Today" : DateFormat("EEE").format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + (index * 8)))}",
                                      style: blackText3,
                                    ))),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset("assets/images/drop.png",
                                    width: 22, height: 22),
                                Text(
                                    "${_weathers[index+8].humidity?.toStringAsFixed(0) ?? ""}%",
                                    style: smallBlackText3),
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset("assets/images/air.png",
                                    width: 22, height: 22, color: white),
                                Text(
                                    "${_weathers[index+8].windSpeed?.toStringAsFixed(0) ?? ""}m/s",
                                    style: smallBlackText3),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              "https://openweathermap.org/img/wn/${_weathers[index].weatherIcon ?? ""}@4x.png"))),
                                ),
                                Text(
                                    "${isCelsius
                                        ?_weathers[index+5].tempFeelsLike!.fahrenheit!.toStringAsFixed(0)
                                        :_weathers[index+5].tempMin!.celsius!.toStringAsFixed(0)} ${isCelsius ? "F":celsius}",
                                    style: smallBlackText3),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  _bottomSheetTips(BuildContext context) {
    return Consumer<WeatherDetailsProvider>(builder: (context, value, child) {
      return value.isOpen
          ? Container(
        padding: const EdgeInsets.all(14),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .44,
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(20)),
        child: FadeAnimation(
          delay: Duration(milliseconds: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 8,
                color: black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
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
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 40,
                            color: gray,
                          ),
                          Text("Hide Details",
                              style: largegraytext)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FadeAnimation(
                      delay: Duration(milliseconds: 100),
                      child: Text("Weather", style: headingText)),
                  FadeAnimation(
                      delay: Duration(milliseconds: 150),
                      child: Text("Wind", style: largegraytext)),
                  FadeAnimation(
                      delay: Duration(milliseconds: 150),
                      child: Text("Precipitation", style: largegraytext)),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                    itemCount: 6,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 2.0),
                    itemBuilder: (context, index) {
                      return FadeAnimation(
                        delay: Duration(milliseconds: 200 * (index + 1)),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.shade400),
                              borderRadius:
                              BorderRadius.circular(10)),
                          child: FadeAnimation(
                            delay: Duration(milliseconds: 250 * (index + 1)),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                    "assets/images/weather.png",
                                    width: 35,
                                    height: 35),
                                SizedBox(width: 3),
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Text("Humidity",
                                        style: smallBlackText),
                                    Text("65%",
                                        style: littleGray)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      )
          : InkWell(
        onTap: () {
          value.isTrue();
        },
        child: FadeAnimation(
          delay: Duration(milliseconds: 100),
          child: Card(
            elevation: 8,
            color: black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              decoration: BoxDecoration(
                  color: black,
                  borderRadius: BorderRadius.circular(10)),
              child: FadeAnimation(
                delay: Duration(milliseconds: 150),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.keyboard_arrow_up_rounded,
                      size: 40,
                      color: gray,
                    ),
                    Text("View Details", style: largegraytext)
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
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
              colors:  value.theme
                  ? [gradientLightBlue, gradientLightPurple]
                  : [gradientLightRed, gradientDarkRed]
          ),
        ),
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            elevation: 16,
            backgroundColor: pinned? Colors.orange : Colors.red.shade900,
            tooltip: 'Pin Weather',
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            onPressed: () {
              setState(() {
                pinned =!pinned;
              });
              if (pinned) {
                setCityPinned(widget.city, true);
                pinnedWeatherFirebase(widget.city, context);
              } else {
                setCityPinned(widget.city, false);
                removePinnedWeatherFirebase(widget.city, context);
              }
            },
            child: Card(
              elevation: 0,
              color: pinned? Colors.orange : Colors.red.shade900,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    pinned =!pinned;
                  });
                  if (pinned) {
                    setCityPinned(widget.city, true);
                    pinnedWeatherFirebase(widget.city, context);
                  } else {
                    setCityPinned(widget.city, false);
                    removePinnedWeatherFirebase(widget.city, context);
                  }
                },
                icon: pinned
                    ? Icon(Icons.push_pin_rounded, color: white, size: 20)
                    : Icon(Icons.push_pin_outlined, color: Colors.white, size: 20),
              ),
            ),
          ),
          //bottomSheet: _bottomSheetTips(context),
          backgroundColor: Colors.transparent,
          body: isTrue? _body(context) : Center(child: Lottie.asset('assets/images/hand_animation.json')),
        ),
      );
    });
  }
}