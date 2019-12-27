import 'package:flutter/material.dart';

class Animal {

  String id;
  String specie;
  String name;
  String sex;
  String birthDate;
  String proprietary;
  String lossDate;
  String agroProprietary;
  String code;

  Animal({this.id, this.name, this.sex, this.birthDate, this.lossDate, this.agroProprietary });

  Animal.fromMap(Map map, String id):
      id = id ?? '',
      specie = map['specie'] ?? '',
      name = map['name'] ?? '',
      sex = map['sex'] ?? '',
      birthDate = map['birthDate'] ?? '',
      proprietary = map['proprietary'] ?? '',
      lossDate = map['lossDate'] ?? '',
      agroProprietary = map['agroProprietary'] ?? '',
      code = map['code'] ?? '';

  toJson(){
    return{
      "specie": specie,
      "name": name,
      "sex": sex,
      "birthDate": birthDate,
      "proprietary": proprietary,
      "lossDate": lossDate,
      "agroProprietary": agroProprietary,
      "code": code
    };
  }

}