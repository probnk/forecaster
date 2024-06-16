import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> pinnedWeatherFirebase(String city,BuildContext context) async {
  final pinnedWeather = await FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.email.toString());
  pinnedWeather
      .doc(city)
      .set({
      'city':city
      }).then((value){
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$city Weather Pinned")));  });
}

Future<void> removePinnedWeatherFirebase(String city,BuildContext context) async {
  final pinnedWeather = await FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.email.toString());
  pinnedWeather
      .doc(city)
      .delete()
      .then((value){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$city Weather Unpinned")));  });
}