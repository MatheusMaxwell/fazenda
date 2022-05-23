
import 'package:flutter/material.dart';


Widget emptyContainer(String text){
  return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
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