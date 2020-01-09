

import 'package:FarmControl/data/firebase/FirebaseAuthentication.dart';
import 'package:FarmControl/pages/animal/animal_list.dart';
import 'package:FarmControl/pages/animal/animal_register.dart';
import 'package:FarmControl/pages/login/login_page.dart';
import 'package:FarmControl/pages/reports/reports_page.dart';
import 'package:FarmControl/pages/settings/settings_page.dart';
import 'package:FarmControl/utils/ApplicationSingleton.dart';
import 'package:FarmControl/utils/Constants.dart';
import 'package:flutter_web/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'pages/animal/animal_detail.dart';


void main() async{
  try {
    fb.initializeApp(
      apiKey: "AIzaSyB9dcALmEUqPc9cU6X2WfvqSR8-L8RhkK4",
      authDomain: "farmcontrol-2069e.firebaseapp.com",
      databaseURL: "https://farmcontrol-2069e.firebaseio.com",
      projectId: "farmcontrol-2069e",
      storageBucket: "farmcontrol-2069e.appspot.com",
      messagingSenderId: "411284470737",
    );

  } on fb.FirebaseJsNotLoadedException catch (e) {
    print(e);
  }
  runApp(MyApp());
}

final routes = {
  //Constants.SPLASH_SCREEN: (BuildContext context) => new Splash(),
  Constants.LOGIN_PAGE: (BuildContext context) => new LoginPage(),
  Constants.ANIMAL_LIST_PAGE: (BuildContext context) => new AnimalList(),
  Constants.ANIMAL_REGISTER_PAGE: (BuildContext context) => new AnimalRegisterSetting(),
  Constants.REPORTS_PAGE: (BuildContext context) => new ReportsPage(),
  Constants.SETTINGS_PAGE: (BuildContext context) => new SettingsPage(),
  Constants.ANIMAL_DETAIL_PAGE: (BuildContext context) => new AnimalDetail()
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

