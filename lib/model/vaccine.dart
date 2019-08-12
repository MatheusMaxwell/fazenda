import 'package:flutter/material.dart';

class Vaccine {
  int _id;
  String _label;
  String _date;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get label => _label;

  set label(String valueString){
    _label = valueString;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

}