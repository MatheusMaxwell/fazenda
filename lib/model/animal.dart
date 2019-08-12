import 'package:flutter/material.dart';

class Animal {

  int _id;
  int _species_id;
  String _name;
  String _sex;
  String _birthDate;
  int _proprietry_id;
  String _lossDate;
  String _agroProprietary;


  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get agroProprietary => _agroProprietary;

  set agroProprietary(String value) {
    _agroProprietary = value;
  }

  String get lossDate => _lossDate;

  set lossDate(String value) {
    _lossDate = value;
  }


  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get birthDate => _birthDate;

  set birthDate(String value) {
    _birthDate = value;
  }

  String get sex => _sex;

  set sex(String value) {
    _sex = value;
  }

  int get species_id => _species_id;

  set species_id(int value) {
    _species_id = value;
  }

  int get proprietry_id => _proprietry_id;

  set proprietry_id(int value) {
    _proprietry_id = value;
  }


}