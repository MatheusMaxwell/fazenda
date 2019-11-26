

import 'package:FarmControl/pages/splash_screen/splash_screen.dart';
import 'package:FarmControl/utils/ApplicationSingleton.dart';
import 'package:flutter/material.dart';

import 'data/firebase/FirebaseAuthentication.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ApplicationSingleton.baseAuth = new Auth();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FarmControl",
      theme: ThemeData(
        primaryColor: Colors.blue
        ),
        home: Splash()
    );
  }


}

