// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:forecaster/Constants/Colors.dart';
// import 'package:forecaster/Constants/api.dart';
// import 'package:forecaster/Constants/fonts.dart';
// import 'package:forecaster/Modules/CurrentWeather.dart';
// import 'package:forecaster/Modules/TodayWeather.dart';
// import 'package:forecaster/Widgets/Weather/Weather.dart';
// import 'package:intl/intl.dart';
// import 'package:weather/weather.dart';
// import '../../Animations/FadeAnimation.dart';
//
// class Home extends StatefulWidget {
//   const Home({super.key});
//
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//
//   final _controller = TextEditingController();
//   TodayWeather todayWeather = TodayWeather(
//       date: "", description: "", weatherIcon: "",
//       temperature: "", city: "", wind: "", humidity: "");
//   CurrentWeather currentWeather = CurrentWeather(
//       temp:"", minTemp: "", maxTemp: "", date: "",
//       description: "", weatherIcon: "", city: ""
//   );
//   final _wf = WeatherFactory(OpenWeatherAPIKey);
//   Weather? _weather;
//   String _city = "Islamabad";
//   @override
//   void initState() {
//     super.initState();
//     _searchWeather(_city);
//   }
//
//   _searchWeather(String city){
//     _wf.currentWeatherByCityName(_controller.text == "" ?  city : _controller.text).then((w){
//       setState(() {
//         _weather = w;
//         todayWeather = TodayWeather(
//             date: "Today ${DateTime.now().day} ${DateFormat(", EE").format(DateTime.now())}",
//             description: _weather?.weatherDescription ?? "",
//             weatherIcon: "https://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png",
//             temperature: "${_weather?.temperature?.celsius?.toStringAsFixed(1)}°C",
//             city: _weather?.areaName ?? "",
//             wind: "${_weather?.windSpeed?.toStringAsFixed(0)} m/s" ?? "",
//             humidity: "${_weather?.humidity?.toStringAsFixed(0)}%"
//         );
//         currentWeather = CurrentWeather(
//             temp: todayWeather.temperature,
//             minTemp: "${_weather?.tempMin?.celsius?.toStringAsFixed(0)}°C",
//             maxTemp: "${_weather?.tempMax?.celsius?.toStringAsFixed(0)}°C",
//             date: "${DateFormat("EEE, MMM d, HH:mm").format(DateTime.now())}",//Wed, May 26, 15:00
//             description: todayWeather.description,
//             weatherIcon: "https://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png",
//             city: todayWeather.city
//         );
//       });
//     });
//   }
//
//   _body() {
//     return ListView(
//       children: [
//         FadeAnimation(
//           delay: Duration(milliseconds: 50),
//           child: _appbar(),
//         ),
//         SizedBox(height: 15),
//         FadeAnimation(
//           delay: Duration(milliseconds: 200),
//           child: _middlebar(),
//         ),
//         SizedBox(height: 15),
//         FadeAnimation(
//           delay: Duration(milliseconds: 750),
//           child: _endbar(),
//         ),
//       ],
//     );
//   }
//
//   _appbar() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         FadeAnimation(
//           delay: Duration(milliseconds: 100),
//           child: Text(todayWeather.date,
//             style: TextStyle(
//               color: Colors.white54,
//               fontSize: 20,
//             ),
//           ),
//         ),
//         SizedBox(height: 20),
//         FadeAnimation(
//           delay: Duration(milliseconds: 150),
//           child: Card(
//             elevation: 8,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20)
//             ),
//             child: TextFormField(
//                 controller: _controller,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.grey.shade50,
//                   prefixIcon: Icon(Icons.location_on_rounded,color: Colors.grey.shade400),
//                   suffixIcon: Card(
//                     elevation: 8,
//                     color: Colors.black87,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30)
//                     ),
//                     child: IconButton(
//                         onPressed: () {
//                           setState(() {
//                             _city = _controller.text;
//                             _searchWeather(_city);
//                           });
//                         },
//                         icon: Icon(Icons.search,color:gray,size: 24,)
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20),
//                       borderSide: BorderSide(color: Colors.transparent)
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20),
//                       borderSide: BorderSide(color: Colors.transparent)
//                   ),
//                   hintText: 'Search City...',
//                   hintStyle: TextStyle(
//                       color: Colors.grey.shade400
//                   ),
//                 )
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   _middlebar(){
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         FadeAnimation(
//             delay: Duration(milliseconds: 250),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(todayWeather.temperature, style: temperature),
//                 Text(todayWeather.city, style: lightgraytext)
//               ],
//             )),
//         SizedBox(height: 8,),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Column(
//               children: [
//                 FadeAnimation(
//                     delay: Duration(milliseconds: 300),
//                     child:Container(
//                       width: 150,
//                       height: 116,
//                       decoration: BoxDecoration(
//                           image: DecorationImage(
//                               fit: BoxFit.cover,
//                               image: NetworkImage(todayWeather.weatherIcon))
//                       ),
//                     )
//                 ),
//                 FadeAnimation(
//                     delay: Duration(milliseconds: 300),
//                     child: Text(todayWeather.description, style: lightgraytext)
//                 ),
//               ],
//             ),
//             Column(
//               crossAxisAlignment:CrossAxisAlignment.start,
//               children: [
//                 FadeAnimation(
//                     delay: Duration(milliseconds: 350),
//                     child: Text("Wind", style: lightgraytext)),
//                 FadeAnimation(
//                     delay: Duration(milliseconds: 450),
//                     child: Text(todayWeather.wind, style:whitetext)),
//                 FadeAnimation(
//                     delay: Duration(milliseconds: 500),
//                     child: Text("Humidt", style: lightgraytext)),
//                 FadeAnimation(
//                     delay: Duration(milliseconds: 550),
//                     child: Text(todayWeather.humidity, style:whitetext)),
//                 FadeAnimation(
//                   delay: Duration(milliseconds: 600),
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => weather(currentWeather: currentWeather)));
//                     },
//                     child: Row(
//                       children: [
//                         Text("Detailed ", style: lightgraytext),
//                         Icon(Icons.queue_play_next,color: white54,size: 26,)
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         SizedBox(height: 14,),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             FadeAnimation(
//                 delay: Duration(milliseconds: 650),
//                 child: Text("Other City ", style: whitetext)),
//             FadeAnimation(
//                 delay: Duration(milliseconds: 700),
//                 child: Text("View All ", style: lightgraytext)),
//           ],
//         )
//       ],
//     );
//   }
//
//   Widget _endbar() {
//     return Container(
//       height: 200,
//       child: ListView.builder(
//           itemCount: 6,
//           scrollDirection: Axis.horizontal,
//           shrinkWrap: true,
//           itemBuilder: (context,index){
//             return  FadeAnimation(
//               delay: Duration(milliseconds: 300),
//               child: InkWell(
//                 onTap: () {
//                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => weather(currentWeather: currentWeather)));
//                 },
//                 child: Container(
//                   margin: EdgeInsets.all(10),
//                   padding: EdgeInsets.all(20),
//                   width: 240,
//                   decoration: BoxDecoration(
//                       color: Colors.black12,
//                       borderRadius: BorderRadius.circular(30)
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           FadeAnimation(
//                               delay: Duration(milliseconds: 850),
//                               child:Container(
//                                 width: 100,
//                                 height: 60,
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                         image: NetworkImage(todayWeather.weatherIcon))
//                                 ),
//                               )
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               FadeAnimation(
//                                   delay: Duration(milliseconds: 900),
//                                   child: Text("Location", style: smallgraytext)),
//                               FadeAnimation(
//                                   delay: Duration(milliseconds: 950),
//                                   child: Text(todayWeather.city, style: whitetext)),
//                             ],
//                           )
//                         ],
//                       ),
//                       SizedBox(height: 10,),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           FadeAnimation(
//                               delay: Duration(milliseconds: 1000),
//                               child: Text("Wind", style: smallgraytext)),
//                           FadeAnimation(
//                               delay: Duration(milliseconds: 1050),
//                               child: Text("Temp", style: smallgraytext)),
//                           FadeAnimation(
//                               delay: Duration(milliseconds: 1100),
//                               child: Text("Humidt", style: smallgraytext)),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           FadeAnimation(
//                               delay: Duration(milliseconds: 1150),
//                               child: Text(todayWeather.wind, style: whitetext)),
//                           FadeAnimation(
//                             delay: Duration(milliseconds: 1200),
//                             child: Text(todayWeather.temperature, style: whitetext),),
//                           FadeAnimation(
//                               delay: Duration(milliseconds: 1250),
//                               child: Text(todayWeather.humidity, style: whitetext)),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double _width = MediaQuery.of(context).size.width;
//     final double _height = MediaQuery.of(context).size.height;
//
//     return Container(
//         width: _width,
//         height: _height,
//         padding: EdgeInsets.all(14),
//         decoration: BoxDecoration(
//             gradient:LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [gradientLightRed,gradientDarkRed]
//             )
//         ),
//         child:SafeArea(
//           child: Scaffold(
//               backgroundColor: Colors.transparent,
//               // body: _body(),
//               body: _weather == null
//                   ? Center(child: CircularProgressIndicator(color: Colors.white,))
//                   : _body()
//           ),
//         )
//     );
//   }
// }