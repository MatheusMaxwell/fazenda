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
