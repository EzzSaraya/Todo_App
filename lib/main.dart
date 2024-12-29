import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Auth/Login/login_screen.dart';
import 'package:todo_app/Auth/register/registerscreen.dart';
import 'package:todo_app/Home/HomeScreen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:todo_app/mythemedata.dart';
import 'package:todo_app/provider/listProvider.dart';
import 'package:todo_app/provider/userProvider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  navigatorKey:
  navigatorKey;
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: 'AIzaSyCcrHMmX5HD6qPonoo-b3sT1Rghjn9Uu6M',
              appId: 'com.example.todo_app',
              projectId: 'todoapp-c5faa',
              messagingSenderId: '259663342621'))
      : await Firebase.initializeApp();
  //await FirebaseFirestore.instance.disableNetwork();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ListProvider(),
      ),
      ChangeNotifierProvider(create: (context) => UserProvider())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: MyThemeData.LightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: RegisterScreen.routeName,
        routes: {
          LoginScreen.routeName: (context) => LoginScreen(),
          RegisterScreen.routeName: (context) => RegisterScreen(),
          HomeScreen.routeName: (context) => HomeScreen()
        });
  }
}
