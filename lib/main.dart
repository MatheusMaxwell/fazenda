

import 'package:FarmControl/data/firebase/FirebaseAuthentication.dart';
import 'package:FarmControl/pages/animal/animal_list.dart';
import 'package:FarmControl/pages/animal/animal_register.dart';
import 'package:FarmControl/pages/login/login_page.dart';
import 'package:FarmControl/pages/reports/reports_page.dart';
import 'package:FarmControl/pages/settings/settings_page.dart';
import 'package:FarmControl/utils/ApplicationSingleton.dart';
import 'package:FarmControl/utils/Constants.dart';
import 'package:flutter_web/material.dart';


void main() => runApp(MyApp());

final routes = {
  //Constants.SPLASH_SCREEN: (BuildContext context) => new Splash(),
  Constants.LOGIN_PAGE: (BuildContext context) => new LoginPage(),
  Constants.ANIMAL_LIST_PAGE: (BuildContext context) => new AnimalList(),
  Constants.ANIMAL_REGISTER_PAGE: (BuildContext context) => new AnimalRegisterSetting(),
  Constants.REPORTS_PAGE: (BuildContext context) => new ReportsPage(),
  Constants.SETTINGS_PAGE: (BuildContext context) => new SettingsPage()
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ApplicationSingleton.baseAuth = new UserRepository();
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

