
import 'package:FarmControl/data/api/AnimalApi.dart';
import 'package:FarmControl/data/api/SpecieApi.dart';
import 'package:FarmControl/model/animal.dart';
import 'package:FarmControl/model/species.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AnimalContract{
  void onError();
  void listAnimals(List<Animal> animals);
  void animalsIsEmpty();
  void insertSuccess();
  void insertFailed();
  void returnSpecies(List<Specie> species);
  void speciesNotFound();
}

class AnimalPresenter{
  AnimalContract view;
  AnimalPresenter(this.view);
  var _api = new AnimalApi();
  var _apiSpecie = new SpecieApi();


  getAnimals() async{
    try{
      var animals = await _api.getAnimals();
      if(animals.length > 0)
        view.listAnimals(animals);
      else
        view.animalsIsEmpty();
    }
    catch(e){
      view.onError();
    }
  }

  addAnimal(Animal animal) async {
    try{
      DocumentReference insert = await _api.addAnimal(animal);
      if(insert.documentID.isNotEmpty)
        view.insertSuccess();
      else
        view.insertFailed();
    }
    catch(e){
      view.onError();
    }
  }

}