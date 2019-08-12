import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:FarmControl/model/animal.dart';

class AnimalData{

  Database db;

  AnimalData(Database database){
    this.db = database;
  }
  

  void insert (Animal animal) async{

    await db.rawInsert('insert into Animal()');

  }
}