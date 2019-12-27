import 'package:FarmControl/data/firebase/ApiFirebase.dart';
import 'package:FarmControl/model/species.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter_web/material.dart';

class SpecieApi extends ChangeNotifier {
  ApiFirebase _api = new ApiFirebase('specie');
  List<Specie> species;

  Future<List<Specie>> getSpecies() async {
    var result = await _api.getDataCollection();
    species = result.docs
        .map((doc) => Specie.fromMap(doc.data(), doc.id))
        .toList();
    return species;
  }

  Stream<QuerySnapshot> getSpeciesAsStream() {
    return _api.streamDataCollection();
  }

  Future<Specie> getSpecieById(String id) async {
    var doc = await _api.getDocumentById(id);
    return  Specie.fromMap(doc.data(), doc.id) ;
  }


  Future removeSpecie(String id) async{
    await _api.removeDocument(id);
    return ;
  }
  Future updateSpecie(Specie data,String id) async{
    await _api.updateDocument(data.toJson(), id) ;
    return ;
  }

  Future addSpecie(Specie data) async{
    var result  = await _api.addDocument(data.toJson()) ;

    return result;

  }


}