import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/Home/HomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: 'AIzaSyCcrHMmX5HD6qPonoo-b3sT1Rghjn9Uu6M',
              appId: 'com.example.todo_app',
              projectId: 'todoapp-c5faa',
              messagingSenderId: '259663342621'))
      : await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: HomeScreen.routeName,
        routes: {HomeScreen.routeName: (context) => HomeScreen()});
  }
}
