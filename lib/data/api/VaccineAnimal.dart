import 'package:FarmControl/data/firebase/ApiFirebase.dart';
import 'package:FarmControl/model/species.dart';
import 'package:FarmControl/model/vaccine.dart';
import 'package:FarmControl/model/vaccine_animal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VaccineAnimalApi extends ChangeNotifier {
  ApiFirebase _api = new ApiFirebase('animal');
  List<VaccineAnimal> vaccinesAnimals;

  Future<List<VaccineAnimal>> getVaccinesAnimals() async {
    var result = await _api.getDataCollection();
    vaccinesAnimals = result.documents
        .map((doc) => VaccineAnimal.fromMap(doc.data, doc.documentID))
        .toList();
    return vaccinesAnimals;
  }

  Stream<QuerySnapshot> getVaccinesAnimalsAsStream() {
    return _api.streamDataCollection();
  }

  Future<VaccineAnimal> getVaccineAnimalById(String id) async {
    var doc = await _api.getDocumentById(id);
    return  VaccineAnimal.fromMap(doc.data, doc.documentID) ;
  }


  Future removeVaccineAnimal(String id) async{
    await _api.removeDocument(id);
    return ;
  }
  Future updateVaccineAnimal(VaccineAnimal data,String id) async{
    await _api.updateDocument(data.toJson(), id) ;
    return ;
  }

  Future addVaccineAnimal(VaccineAnimal data) async{
    var result  = await _api.addDocument(data.toJson()) ;

    return result;

  }


}