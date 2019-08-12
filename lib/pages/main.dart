
import 'package:FarmControl/pages/animal/animal_list.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FarmControl",
      theme: ThemeData(
        primaryColor: Colors.blue
        ),
        home: AnimalList()
    );
  }


}

