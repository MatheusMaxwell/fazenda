import 'package:FarmControl/pages/animal/animal_list.dart';
import 'package:FarmControl/pages/login/login_page.dart';
import 'package:FarmControl/utils/ApplicationSingleton.dart';
import 'package:FarmControl/utils/Constants.dart';
import 'package:FarmControl/utils/MyMediaQuery.dart';
import 'package:FarmControl/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    Future.delayed(Duration(seconds: 3)).then((_) {
      _callPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    MyMediaQuery.mediaQuery = MediaQuery.of(context);
    MyMediaQuery.size = MyMediaQuery.mediaQuery.size;
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Image.asset("assets/images/splashscreen.png"),
    );
  }

  void _callPage(){
      Navigator.of(context).pushReplacementNamed(Constants.LOGIN_PAGE);
  }
}

