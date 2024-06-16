import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:forecaster/Constants/Colors.dart';
import 'package:forecaster/Constants/api.dart';
import 'package:forecaster/Constants/fonts.dart';
import 'package:forecaster/Modules/CurrentWeather.dart';
import 'package:forecaster/Modules/TodayWeather.dart';
import 'package:forecaster/Provider/themeProvider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/weather.dart';
import '../../Animations/FadeAnimation.dart';
import '../NoInternet/noInternet.dart';
import '../Weather/Weather.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _cities = ['Toronto', 'London', 'Sydney'];
  List<Future<Weather>> _weatherFutures = [];
  bool isFar = false;
  String celsius = "°C";
  var getMaxTemp;
  int? maxTemp;
  double? Latitudes,Longitudes;
  final _controller = TextEditingController();
  TodayWeather todayWeather = TodayWeather(
      date: "",
      description: "",
      weatherIcon: "",
      temperature: "",
      city: "",
      wind: "",
      humidity: "");
  CurrentWeather currentWeather = CurrentWeather(date: "");
  final _wf = WeatherFactory(OpenWeatherAPIKey);
  Weather? _weather;
  String _city = "";
  bool isTrue = false;
  double lat = 0.0;
  double lon = 0.0;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    exactLocation().then((value) async {
      setState(() {
        lat = value.latitude;
        lon = value.longitude;
      });
      await exactLocation();
      await _searchCurrentLocationWeather(lat, lon);
      await _fetchWeatherDataForCities();
    });
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

  Future<Position> exactLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!serviceEnabled) {
      Geolocator.requestPermission();
      return Future .error("location service are disabled");
    }
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location Denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location Denied Forever");
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> searchWeather(String city) async {
    final sharedPref = await SharedPreferences.getInstance();
    bool isCelsius = sharedPref.getBool('ChangeType') ?? false;
    _wf.currentWeatherByCityName(_controller.text == "" ? city : _controller.text).then((w) {
      setState(() {
        _weather = w;
        todayWeather = TodayWeather(
          date: "Today ${DateTime.now().day} ${DateFormat(", EE").format(DateTime.now())}",
          description: _weather?.weatherDescription ?? "",
          weatherIcon: "https://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png",
          temperature: "${isCelsius?_weather
              ?.temperature?.fahrenheit?.toStringAsFixed(1)
              :_weather?.temperature?.celsius?.toStringAsFixed(1)} ${isCelsius ? "F":celsius}",
          city: _weather?.areaName ?? "",
          wind: "${_weather?.windSpeed?.toStringAsFixed(0)} m/s" ?? "",
          humidity: "${_weather?.humidity?.toStringAsFixed(0)}%",
        );
        currentWeather = CurrentWeather(
          date: "${DateFormat("EEE, MMM d, HH:mm").format(DateTime.now())}",
        );
      });
    });
  }

  Future<void> _fetchWeatherDataForCities() async {
    final sharedPref = await SharedPreferences.getInstance();
    setState(() {
      isFar = sharedPref.getBool('ChangeType') ?? false;
    });
    _weatherFutures = _cities.map((city) => _wf.currentWeatherByCityName(city)).toList();
  }

  _searchCurrentLocationWeather(double latitude, double longitude) async {
    final sharedPref = await SharedPreferences.getInstance();
    bool isCelsius = sharedPref.getBool('ChangeType') ?? false;
    _wf.currentWeatherByLocation(latitude, longitude).then((w) {
      setState(() {
        _weather = w;
        _city = _weather?.areaName ?? "";
        todayWeather = TodayWeather(
          date: "Today ${DateTime.now().day} ${DateFormat(", EE").format(DateTime.now())}",
          description: _weather?.weatherDescription ?? "",
          weatherIcon: "https://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png",
          temperature: "${isCelsius?_weather
              ?.temperature?.fahrenheit?.toStringAsFixed(1)
              :_weather?.temperature?.celsius?.toStringAsFixed(1)} ${isCelsius ? "F":celsius}",
          city: _weather?.areaName ?? "",
          wind: "${_weather?.windSpeed?.toStringAsFixed(0)} m/s" ?? "",
          humidity: "${_weather?.humidity?.toStringAsFixed(0)}%",
        );
        currentWeather = CurrentWeather(
          date: "${DateFormat("EEE, MMM d, HH:mm").format(DateTime.now())}",
        );
      });
    });
  }

  _body() {
    return ListView(
      children: [
        FadeAnimation(
          delay: Duration(milliseconds: 50),
          child: _appbar(),
        ),
        SizedBox(height: 15),
        FadeAnimation(
          delay: Duration(milliseconds: 200),
          child: _middlebar(),
        ),
        SizedBox(height: 15),
        FadeAnimation(
          delay: Duration(milliseconds: 750),
          child: _endbar(),
        ),
      ],
    );
  }

  _appbar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeAnimation(
          delay: Duration(milliseconds: 100),
          child: Text(todayWeather.date,
              style:lightgraytext
          ),
        ),
        SizedBox(height: 10),
        FadeAnimation(
          delay: Duration(milliseconds: 150),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            ),
            child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  prefixIcon: Icon(Icons.location_on_rounded,color: Colors.grey.shade400),
                  suffixIcon: Card(
                    elevation: 8,
                    color: Colors.black87,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: IconButton(
                        onPressed: () {
                          if(_controller.text == ''){
                            Fluttertoast.showToast(msg: 'Please Enter City');
                            return;
                          }
                          if(_connectionStatus.contains(ConnectivityResult.none)){
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                    builder: (context) => noInternet(navigate:Home())));
                          }else{
                            setState(() {
                              _city = _controller.text;
                              searchWeather(_city);
                            });
                          }
                        },
                        icon: Icon(Icons.search,color:gray,size: 24,)
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.transparent)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.transparent)
                  ),
                  hintText: 'Search City...',
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400
                  ),
                )
            ),
          ),
        ),
      ],
    );
  }

  _middlebar(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeAnimation(
            delay: Duration(milliseconds: 250),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(todayWeather.temperature, style: temperature),
                Text(todayWeather.city, style: lightgraytext)
              ],
            )),
        SizedBox(height: 0,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                FadeAnimation(
                    delay: Duration(milliseconds: 300),
                    child:Container(
                      width: 150,
                      height: 116,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(todayWeather.weatherIcon))
                      ),
                    )
                ),
                FadeAnimation(
                    delay: Duration(milliseconds: 300),
                    child: Text(todayWeather.description, style: lightgraytext)
                ),
              ],
            ),
            Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children: [
                FadeAnimation(
                    delay: Duration(milliseconds: 350),
                    child: Text("Wind", style: lightgraytext)),
                FadeAnimation(
                    delay: Duration(milliseconds: 450),
                    child: Text(todayWeather.wind, style:whitetext)),
                FadeAnimation(
                    delay: Duration(milliseconds: 500),
                    child: Text("Humidity", style: lightgraytext)),
                FadeAnimation(
                    delay: Duration(milliseconds: 550),
                    child: Text(todayWeather.humidity, style:whitetext)),
                FadeAnimation(
                  delay: Duration(milliseconds: 600),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(
                          builder: (context) => weather(
                            currentWeather: currentWeather,city: _city
                          )
                        )
                      );
                    },
                    child: Row(
                      children: [
                        Text("Detailed ", style: lightgraytext),
                        Icon(Icons.queue_play_next,color: white54,size: 26,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 14,),
        FadeAnimation(
            delay: Duration(milliseconds: 650),
            child: Text("Other City ", style: whitetext)),
      ],
    );
  }

  Widget _endbar() {
    return Container(
        height: 200,
        child: FutureBuilder(
          future: Future.wait(_weatherFutures),
          builder: (context,snapshot){
            if(snapshot.hasData){
              List<Weather> weatherList = snapshot.data!;
              return ListView.builder(
                  itemCount: _cities.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context,index){
                    return  FadeAnimation(
                      delay: Duration(milliseconds: 300),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(
                              builder: (context) => weather(
                                currentWeather: currentWeather,
                                city: _cities[index],
                              )
                          )
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                          width: 240,
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  FadeAnimation(
                                      delay: Duration(milliseconds: 850),
                                      child:Container(
                                        width: 100,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage("https://openweathermap.org/img/wn/${weatherList[index].weatherIcon}@4x.png"))
                                        ),
                                      )
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      FadeAnimation(
                                          delay: Duration(milliseconds: 900),
                                          child: Text("Location", style: smallgraytext)),
                                      FadeAnimation(
                                          delay: Duration(milliseconds: 950),
                                          child: Text("${weatherList[index].areaName}", style: whitetext)),
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
                                      child: Text("Wind", style: smallgraytext)),
                                  FadeAnimation(
                                      delay: Duration(milliseconds: 1050),
                                      child: Text("Temp", style: smallgraytext)),
                                  FadeAnimation(
                                      delay: Duration(milliseconds: 1100),
                                      child: Text("Humidity", style: smallgraytext)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  FadeAnimation(
                                      delay: Duration(milliseconds: 1150),
                                      child: Text("${weatherList[index].windSpeed!.toStringAsFixed(0)} m/s", style: whitetext)),
                                  FadeAnimation(
                                    delay: Duration(milliseconds: 1200),
                                    child: Text("${isFar?weatherList[index]
                                        .temperature?.fahrenheit?.toStringAsFixed(0)
                                        :weatherList[index].temperature?.celsius?.toStringAsFixed(0)} ${isFar ? "F":celsius}", style: whitetext),),
                                  FadeAnimation(
                                      delay: Duration(milliseconds: 1250),
                                      child: Text("${weatherList[index].humidity!.toStringAsFixed(0)}%", style: whitetext)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return Consumer<themeProvider>(
        builder: (context,value,child){
          return Container(
              width: _width,
              height: _height,
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                  gradient:LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: value.theme ?[gradientLightBlue, gradientLightPurple] : [gradientLightRed, gradientDarkRed]
                  )
              ),
              child:SafeArea(
                child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: _weather == null
                        ? Center(child:  Lottie.asset('assets/images/arrow_animation.json'))
                        : _body()
                ),
              )
          );
        });
  }
}