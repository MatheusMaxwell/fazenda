import 'package:flutter/material.dart';

class Animal {

  String _type;
  String _name;
  String _sex;
  String _birthDate;
  String _proprietary;
  String _markProprietary;
  String _lossDate;
  String _agroProprietary;

  String get type => _type;

  set type(String value) {
    _type = value;
  }

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

  String get markProprietary => _markProprietary;

  set markProprietary(String value) {
    _markProprietary = value;
  }

  String get proprietary => _proprietary;

  set proprietary(String value) {
    _proprietary = value;
  }

  String get birthDate => _birthDate;

  set birthDate(String value) {
    _birthDate = value;
  }

  String get sex => _sex;

  set sex(String value) {
    _sex = value;
  }


}