

import 'package:FarmControl/pages/animal/animal_list.dart';
import 'package:FarmControl/pages/login/login_page.dart';
import 'package:FarmControl/pages/settings/settings_page.dart';
import 'package:FarmControl/pages/splash_screen/splash_screen.dart';
import 'package:FarmControl/pages/vaccine/vaccine_list.dart';
import 'package:FarmControl/utils/ApplicationSingleton.dart';
import 'package:FarmControl/utils/Constants.dart';
import 'package:flutter/material.dart';

import 'data/firebase/FirebaseAuthentication.dart';

void main() => runApp(MyApp());

final routes = {
  Constants.SPLASH_SCREEN: (BuildContext context) => new Splash(),
  Constants.LOGIN_PAGE: (BuildContext context) => new LoginPage(),
  Constants.ANIMAL_LIST_PAGE: (BuildContext context) => new AnimalList(),
  Constants.VACCINE_LIST_PAGE: (BuildContext context) => new VaccineList(),
  Constants.SETTINGS_PAGE: (BuildContext context) => new SettingsPage()
};

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
      routes: routes,
    );
  }


}

