import 'package:FarmControl/data/firebase/ApiFirebase.dart';
import 'package:FarmControl/model/species.dart';
import 'package:FarmControl/model/vaccine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VaccineApi extends ChangeNotifier {
  ApiFirebase _api = new ApiFirebase('animal');
  List<Vaccine> vaccines;

  Future<List<Vaccine>> getVaccines() async {
    var result = await _api.getDataCollection();
    vaccines = result.documents
        .map((doc) => Vaccine.fromMap(doc.data, doc.documentID))
        .toList();
    return vaccines;
  }

  Stream<QuerySnapshot> getVaccinesAsStream() {
    return _api.streamDataCollection();
  }

  Future<Specie> getVaccineById(String id) async {
    var doc = await _api.getDocumentById(id);
    return  Specie.fromMap(doc.data, doc.documentID) ;
  }


  Future removeVaccine(String id) async{
    await _api.removeDocument(id);
    return ;
  }
  Future updateVaccine(Vaccine data,String id) async{
    await _api.updateDocument(data.toJson(), id) ;
    return ;
  }

  Future addVaccine(Vaccine data) async{
    var result  = await _api.addDocument(data.toJson()) ;

    return result;

  }


}