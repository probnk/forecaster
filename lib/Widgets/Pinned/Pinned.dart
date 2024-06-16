import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forecaster/Animations/FadeAnimation.dart';
import 'package:forecaster/Constants/fonts.dart';
import 'package:forecaster/Provider/themeProvider.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/weather.dart';
import '../../Constants/Colors.dart';
import '../../Constants/api.dart';
import '../../Modules/CurrentWeather.dart';
import '../NoInternet/noInternet.dart';
import '../Weather/Weather.dart';

class Pinned extends StatefulWidget {
  Pinned({Key? key}) : super(key: key);

  @override
  _PinnedState createState() => _PinnedState();
}

class _PinnedState extends State<Pinned> {
  bool _showLottie = true;
  bool isCelsius = false;
  String celsius = "°C";
  final _wf = WeatherFactory(OpenWeatherAPIKey);
  List<String> _pinnedCities = [];
  List<Weather> _weatherList = [];
  CurrentWeather currentWeather = CurrentWeather(date: "");
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initializeData();
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


  Future<void> initializeData() async {
    await fetchPinnedWeatherDetails();
    await fetchWeatherDataForCities();
    setState(() {
      _showLottie = false;
    });
  }

  Future<void> fetchPinnedWeatherDetails() async {
    final pinnedWeather =
    await FirebaseFirestore.instance.collection(
        FirebaseAuth.instance.currentUser!.email.toString());
    QuerySnapshot querySnapshot = await pinnedWeather.get();
    List<String> cities = [];
    for (var doc in querySnapshot.docs) {
      cities.add(doc['city']);
    }
    setState(() {
      _pinnedCities = cities;
    });
  }

  Future<void> fetchWeatherDataForCities() async {
    List<Future<Weather>> weatherFutures =
    _pinnedCities.map((city) => _wf.currentWeatherByCityName(city)).toList();
    List<Weather> weatherList = await Future.wait(weatherFutures);
    var sharedPref = await SharedPreferences.getInstance();
    setState(() {
      _weatherList = weatherList;
      isCelsius=sharedPref.getBool('ChangeType') ?? false;
    });
  }

  Widget _endbar() {
    return ListView.builder(
        itemCount: _pinnedCities.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Weather _weather = _weatherList[index];
          return FadeAnimation(
            delay: Duration(milliseconds: 300),
            child: InkWell(
              onTap: () {
                setState(() {
                  currentWeather = CurrentWeather(date: "${DateFormat("EEE, MMM d, HH:mm").format(DateTime.now())}");
                });
                if(_connectionStatus.contains(ConnectivityResult.none)) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(
                          builder: (context) => noInternet(navigate:weather(
                              currentWeather: currentWeather,
                              city: _pinnedCities[index]))));
                }else{
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(
                      builder: (context) => weather(
                        currentWeather: currentWeather,
                        city: _pinnedCities[index],
                      )
                    )
                  );
                }
              },
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                width: 240,
                decoration: BoxDecoration(
                    color: Colors.black12, borderRadius: BorderRadius.circular(30)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FadeAnimation(
                          delay: Duration(milliseconds: 850),
                          child: Container(
                            width: 100,
                            height: 60,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://openweathermap.org/img/wn/${_weather.weatherIcon}@4x.png")),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeAnimation(
                              delay: Duration(milliseconds: 900),
                              child: Text("Location", style: smallgraytext),
                            ),
                            FadeAnimation(
                              delay: Duration(milliseconds: 950),
                              child: Text("${_weather.areaName}", style: whitetext),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FadeAnimation(
                          delay: Duration(milliseconds: 1000),
                          child: Text("Wind", style: smallgraytext),
                        ),
                        FadeAnimation(
                          delay: Duration(milliseconds: 1050),
                          child: Text("Temp", style: smallgraytext),
                        ),
                        FadeAnimation(
                          delay: Duration(milliseconds: 1100),
                          child: Text("Humidity", style: smallgraytext),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FadeAnimation(
                          delay: Duration(milliseconds: 1150),
                          child: Text("${_weather.windSpeed!.toStringAsFixed(0)} m/s", style: whitetext),
                        ),
                        FadeAnimation(
                          delay: Duration(milliseconds: 1200),
                          child: Text("${isCelsius?_weather
                              .temperature?.fahrenheit?.toStringAsFixed(1)
                              :_weather.temperature?.celsius?.toStringAsFixed(1)} ${isCelsius ? "F":celsius}",
                              style: whitetext),
                        ),
                        FadeAnimation(
                          delay: Duration(milliseconds: 1250),
                          child: Text("${_weather.humidity!.toStringAsFixed(0)}%", style: whitetext),
                        ),
                      ],
                    )
                  ],
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
      return  Container(
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
          appBar: AppBar(
            elevation: 10,
            backgroundColor: value.theme ? Colors.blue.shade400:Color(0xffb80c09),
            title: Center(child: Text("Pinned Weather", style: headingWhiteText,)),
          ),
          backgroundColor: Colors.transparent,
          body: _showLottie
              ? Center(child: Lottie.asset("assets/images/shiftAnimation.json",width: 200,height: 200))
              : _endbar(),
        ),
      );
    });
  }
}
