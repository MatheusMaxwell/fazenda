

import 'package:FarmControl/data/firebase/ApiFirebase.dart';
import 'package:FarmControl/model/animal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AnimalApi extends ChangeNotifier {
  ApiFirebase _api = new ApiFirebase('animal');
  List<Animal> animals;

  Future<List<Animal>> getAnimals() async {
    var result = await _api.getDataCollection();
    animals = result.documents
        .map((doc) => Animal.fromMap(doc.data, doc.documentID))
        .toList();
    return animals;
  }

  Stream<QuerySnapshot> getCategoriesAsStream() {
    return _api.streamDataCollection();
  }

  Future<Animal> getAnimalById(String id) async {
    var doc = await _api.getDocumentById(id);
    return  Animal.fromMap(doc.data, doc.documentID) ;
  }


  Future removeAnimal(String id) async{
    await _api.removeDocument(id);
    return ;
  }
  Future updateAnimal(Animal data,String id) async{
    await _api.updateDocument(data.toJson(), id) ;
    return ;
  }

  Future addAnimal(Animal data) async{
    var result  = await _api.addDocument(data.toJson()) ;

    return result;

  }


}