import 'package:flutter/material.dart';

class Animal {

  String id;
  String speciesId;
  String specie;
  String name;
  String sex;
  String birthDate;
  String proprietaryId;
  String proprietary;
  String lossDate;
  String agroProprietary;

  Animal({this.id, this.speciesId, this.name, this.sex, this.birthDate, this.proprietaryId, this.lossDate, this.agroProprietary });

  Animal.fromMap(Map map, String id):
      id = id ?? '',
      speciesId = map['speciesId'] ?? '',
      specie = map['specie'] ?? '',
      name = map['map'] ?? '',
      sex = map['sex'] ?? '',
      birthDate = map['birthDate'] ?? '',
      proprietaryId = map['proprietaryId'] ?? '',
      proprietary = map['proprietary'] ?? '',
      lossDate = map['lossDate'] ?? '',
      agroProprietary = map['agroProprietary'] ?? '';

  toJson(){
    return{
      "speciesId": speciesId,
      "specie": specie,
      "name": name,
      "sex": sex,
      "birthDate": birthDate,
      "proprietaryId": proprietaryId,
      "proprietary": proprietary,
      "lossDate": lossDate,
      "agroProprietary": agroProprietary
    };
  }

}