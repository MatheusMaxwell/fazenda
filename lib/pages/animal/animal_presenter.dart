import 'package:FarmControl/data/api/AnimalApi.dart';
import 'package:FarmControl/data/api/ProprietaryApi.dart';
import 'package:FarmControl/data/api/SpecieApi.dart';
import 'package:FarmControl/model/animal.dart';
import 'package:FarmControl/model/proprietary.dart';
import 'package:FarmControl/model/species.dart';
import 'package:firebase/firebase.dart';
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
      // List<Animal> animals = [Animal(id: "01", specie: "Bovino", name: "Teste", sex: "Macho", birthDate: "10/12/1996", lossDate: "", agroProprietary: "Matheus"),
      //                        Animal(id: "02", specie: "Bovino", name: "Abc", sex: "Femea", birthDate: "10/12/1996", lossDate: "", agroProprietary: "Matheus")];
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

  getSpeciesAndReturn()async{
    try{
      //var species = [Specie(id: "0", specie: "Bovino", userId: "YHIIobcpVoNCbMht9Pq2uhoy8V32"), Specie(id: "1", specie: "Equino", userId: "YHIIobcpVoNCbMht9Pq2uhoy8V32")];
      var species = await _apiSpecie.getSpecies();
      ApplicationSingleton.species = species;
      return species;
    }
    catch(e){
      view.onError();
    }
  }

  getProprietariesAndReturn()async{
    try{
      var props = await _apiProp.getProprietaries();
      ApplicationSingleton.proprietaries = props;
      return props;
    }
    catch(e){
      view.onError();
    }
  }

  getSpecies()async{
    try{
      //var species = [Specie(id: "0", specie: "Bovino", userId: "YHIIobcpVoNCbMht9Pq2uhoy8V32"), Specie(id: "1", specie: "Equino", userId: "YHIIobcpVoNCbMht9Pq2uhoy8V32")];
      var species = ApplicationSingleton.species != null && ApplicationSingleton.species.isNotEmpty ? ApplicationSingleton.species : await _apiSpecie.getSpecies();
      if(species.isEmpty){
        view.speciesNotFound();
      }
      else{
        view.returnSpecies(species);
      }
    }
    catch(e){
      view.onError();
    }
  }

  getProprietaries()async{
    try{
      var props = ApplicationSingleton.proprietaries != null && ApplicationSingleton.proprietaries.isNotEmpty ? ApplicationSingleton.proprietaries : await _apiProp.getProprietaries();
      if(props.isEmpty){
        view.proprietaryNotFound();
      }
      else{
        view.returnProprietaries(props);
      }
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