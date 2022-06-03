import 'package:FarmControl/data/api/AnimalApi.dart';
import 'package:FarmControl/data/api/ProprietaryApi.dart';
import 'package:FarmControl/data/api/SpecieApi.dart';
import 'package:FarmControl/model/animal.dart';
import 'package:FarmControl/model/proprietary.dart';
import 'package:FarmControl/model/species.dart';
import 'package:firebase/firestore.dart';
import 'package:FarmControl/utils/ApplicationSingleton.dart';

abstract class AnimalContract{
  void onError();
  void listAnimals(List<Animal> animals);
  void animalsIsEmpty();
  void insertSuccess();
  void insertFailed();
  void returnSpecies(List<Specie> species);
  void speciesNotFound();
  void returnProprietaries(List<Proprietary> proprietaries);
  void proprietaryNotFound();
  void deleteAnimalFailed();
  void deleteAnimalSuccess();
  void updateSuccess();
  void updateFailed();
}

class AnimalPresenter{
  AnimalContract view;
  AnimalPresenter(this.view);
  var _api = new AnimalApi();
  var _apiSpecie = new SpecieApi();
  var _apiProp = new ProprietaryApi();



  getAnimals() async{
    try{
      List<Animal> animals = await _api.getAnimals();
      if(animals.length > 0) {
        ApplicationSingleton.animals = animals;
        view.listAnimals(animals);
      }
      else
        view.animalsIsEmpty();
    }
    catch(e){
      print(e);
      view.onError();
    }
  }

  addAnimal(Animal animal) async {
    try{
      DocumentReference insert = await _api.addAnimal(animal);
      if(insert.id.isNotEmpty)
        view.insertSuccess();
      else
        view.insertFailed();
    }
    catch(e){
      view.onError();
    }
  }

  getSpecies()async{
    try{
      var species = await _apiSpecie.getSpecies();
      if(species.isNotEmpty)
        view.returnSpecies(species);
      else
        view.speciesNotFound();
    }
    catch(e){
      view.onError();
    }
  }

  getProprietaries()async{
    try{
      var props = await _apiProp.getProprietaries();
      if(props.isNotEmpty)
        view.returnProprietaries(props);
      else
        view.proprietaryNotFound();
    }
    catch(e){
      view.onError();
    }
  }

  deleteAnimal(String id) async{
    try{
      await _api.removeAnimal(id);
      view.deleteAnimalSuccess();
    }
    catch(e){
      view.deleteAnimalFailed();
    }
  }

  updateAnimal(Animal animal) async{
    try{
      await _api.updateAnimal(animal, animal.id);
      view.updateSuccess();
    }
    catch(e){
      view.updateFailed();
    }
  }

}