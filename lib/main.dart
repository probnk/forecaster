import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:forecaster/Constants/Colors.dart';
import 'package:forecaster/Provider/LoginProvider.dart';
import 'package:forecaster/Provider/PinnedWeatherProvider.dart';
import 'package:forecaster/Provider/SignupProvider.dart';
import 'package:forecaster/Provider/themeProvider.dart';
import 'package:forecaster/Provider/weather_details_provider.dart';
import 'package:forecaster/Widgets/SplashScreen/SplashScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Notification/NotificationController.dart';
import 'Provider/NotificationProvider.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
  ]);
  await NotificationController.initializeLocalNotifications();
  await NotificationController.initializeIsolateReceivePort();
  final sharedPreference = await SharedPreferences.getInstance();
  bool isGetStarted = sharedPreference.getBool('isGetStarted') ?? false;
  final pref = await SharedPreferences.getInstance();
  final isRunning = await pref.getBool('allow_notifications') ?? false;
  if(isRunning){
    await initializeServices();
  }
  await Firebase.initializeApp(
    options:const FirebaseOptions(
        apiKey: "AIzaSyBzKUYRV5vWo3q9hW4DMtiLAnw2UjH6d2c",
        appId: "1:70316448112:android:c30d819c9e843b95c757b5",
        messagingSenderId: "70316448112",
        projectId: "forecaster-3550a"
    )
  );
  runApp(MyApp(isGetStarted: isGetStarted));
}

Future<void> initializeServices() async {
  final services = FlutterBackgroundService();
  services.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          isForegroundMode: true,
      )
  );
 services.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  Timer.periodic(const Duration(minutes: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if(await service.isForegroundService()) {
        NotificationController.showNotification(
            title: "Weather Alert",
            body: "Click now and See the Latest Weather Update's in Our Forecaster App to plan up your Trip's",
            notificationLayout: NotificationLayout.BigPicture,
            bigPicture: "asset://assets/images/cloudy.jpg",
        );
      }
    }
  });
}


class MyApp extends StatefulWidget {
  final bool isGetStarted;
  MyApp({super.key, required this.isGetStarted});

  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _AppState();
}

class _AppState extends State<MyApp> {

  @override
  void initState() {
    NotificationController.startListeningNotificationEvents();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => SignupProvider()),
        ChangeNotifierProvider(create: (context) => PinnedWeatherProvider()),
        ChangeNotifierProvider(create: (context) => WeatherDetailsProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => themeProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(isGetStarted: widget.isGetStarted),
      ) ,
    );
  }
}