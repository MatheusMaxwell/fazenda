import 'package:flutter/material.dart';

class Proprietary {
  String id;
  String name;
  String mark;
  String userId;

  Proprietary({this.id, this.name, this.mark, this.userId});

  Proprietary.fromMap(Map map, String id) :
      id = id ?? '',
      name = map['name'] ?? '',
      mark = map['mark'] ?? '',
      userId = map['userId'] ?? '';

  toJson(){
    return {
      "name": name,
      "mark": mark,
      "userId": userId
    };
  }


}