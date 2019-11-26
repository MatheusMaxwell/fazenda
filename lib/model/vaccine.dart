import 'package:flutter/material.dart';

class Vaccine {
  String id;
  String label;
  String date;
  String userId;

  Vaccine({this.id, this.label, this.date, this.userId});

  Vaccine.fromMap(Map map, String id):
      id = id ?? '',
      label = map['label'] ?? '',
      date = map['date'] ?? '',
      userId = map['userId']?? '';

  toJson(){
    return{
      "label": label,
      "date": date
    };
  }

}