import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../BottomNavBar/BottomNavBar.dart';
import '../Login/Login_Screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.active){
              if(snapshot.hasData){
                return BottomNavBar();
              }
              else{
                return Login();
              }
            }
            return Center(child: CircularProgressIndicator(),);
          }
        )
    );
  }
}
