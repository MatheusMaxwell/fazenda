import 'package:FarmControl/utils/MyMediaQuery.dart';
import 'package:flutter/material.dart';

Widget emptyContainer(String text){
  return Container(
      color: Colors.white,
      width: MyMediaQuery.size.width,
      height: MyMediaQuery.size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Icon(Icons.format_list_bulleted, size: 300, color: Colors.black38,),
            ),
            SizedBox(
              width: 20,
            ),
            Text(text, style: TextStyle(fontSize: 22),)
          ],
        ),
      )
  );
}