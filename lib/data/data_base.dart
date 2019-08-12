import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter/material.dart';

class MyDataBaseSQLite {

  String sql_create_db = "CREATE TABLE Proprietary(id int NOT NULL,name varchar(100),mark varchar(10),PRIMARY KEY (id));" +
                      "CREATE TABLE Species (id int NOT NULL,description varchar(50), PRIMARY KEY (id));" +
                      "CREATE TABLE Animal(id int NOT NULL,proprietary_id int,species_id int,name varchar(100),"
                        "sex varchar(10),birth_date date,loss_date date,proprietary_agro varchar(50),PRIMARY KEY (id),"
                        "FOREIGN KEY (proprietary_id) REFERENCES Proprietary(id),FOREIGN KEY (species_id) REFERENCES Species(id));" +
                      "CREATE TABLE Vaccine(id int NOT NULL,description varchar(50),vaccine_date date,PRIMARY KEY (id));" +
                      "CREATE TABLE VaccineAnimal(id int NOT NULL,animal_id int,vaccine_id int,PRIMARY KEY (id),"
                          "FOREIGN KEY (animal_id) REFERENCES Animal(id),FOREIGN KEY (vaccine_id) REFERENCES Vaccine(id));";


  void createDataBase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "/farmcontrol.db";

    var database = await openDatabase(path, version: 1,
        onUpgrade: (Database db, int version, int info) async {

        },
        onCreate: (Database db, int vetsion) async {
          await db.execute(sql_create_db);

        }
    );

  }

}