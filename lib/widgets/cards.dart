import 'package:flutter_web/material.dart';

Widget cardSingleText(String text){
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0)
    ),
    child: Container(
      height: 80.0,
      child: Row(
        children: <Widget>[
          Container(
            height: 60.0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(text, style: TextStyle(fontSize: 26),),
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget cardTitleSubtitle(String title, String subtitle){
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0)
    ),
    child: Container(
      height: 80.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 60.0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: TextStyle(fontSize: 26, color: Colors.black),),
                  Text(subtitle, style: TextStyle(fontSize: 22, color: Colors.grey),),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
