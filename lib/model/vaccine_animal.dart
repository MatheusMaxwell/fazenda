import 'package:flutter/material.dart';

class VaccineAnimal {
  int _id;
  int _animal_id;
  int _vaccine_id;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  int get animal_id => _animal_id;

  set animal_id(int value) {
    _animal_id = value;
  }

  int get vaccine_id => _vaccine_id;

  set vaccine_id(int value) {
    _vaccine_id = value;
  }


}