

import 'package:FarmControl/data/firebase/ApiFirebase.dart';
import 'package:FarmControl/model/animal.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter_web/material.dart';

class AnimalApi extends ChangeNotifier {
  ApiFirebase _api = new ApiFirebase('animal');
  List<Animal> animals;

  Future<List<Animal>> getAnimals() async {
    var result = await _api.getDataCollection();
    animals = result.docs
        .map((doc) => Animal.fromMap(doc.data(), doc.id))
        .toList();
    return animals;
  }

  Future<List<Animal>> getAnimalsByProprietary(String proprietary)async{
    var result = await _api.getDataCollection();
    animals = result.docs
        .map((doc) => Animal.fromMap(doc.data(), doc.id))
        .toList();
    return animals;
  }

  Stream<QuerySnapshot> getCategoriesAsStream() {
    return _api.streamDataCollection();
  }

  Future<Animal> getAnimalById(String id) async {
    var doc = await _api.getDocumentById(id);
    return  Animal.fromMap(doc.data(), doc.id) ;
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