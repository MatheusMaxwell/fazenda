import 'package:FarmControl/utils/ApplicationSingleton.dart';
import 'package:FarmControl/utils/Constants.dart';
import 'package:flutter_web/material.dart';

Future push (BuildContext context, Widget page){
  return Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
    return page;
  }));
}

Future pushReplacement(BuildContext context, Widget page) {
  return Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (BuildContext context) => page));
}

navigatorReplace(BuildContext context, String page){
  if(ApplicationSingleton.baseAuth.getUser() == null)
    Navigator.of(context).pushReplacementNamed(Constants.LOGIN_PAGE);
  else
    Navigator.of(context).pushReplacementNamed(page);
}

Widget redirectLogin(BuildContext context){
  SystemChrome.setEnabledSystemUIOverlays([]);
  Future.delayed(Duration(milliseconds: 300)).then((_) {
    navigatorReplace(context, Constants.LOGIN_PAGE);
  });
  return Container();
}
