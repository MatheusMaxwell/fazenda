import 'package:flutter/material.dart';

class Species {
  int _id;
  String _specie;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get specie => _specie;

  set specie(String value) {
    _specie = value;
  }


}