
import 'package:FarmControl/data/api/SpecieApi.dart';
import 'package:FarmControl/model/species.dart';
import 'package:FarmControl/model/animal.dart';
import 'package:FarmControl/utils/ApplicationSingleton.dart';
import 'package:firebase/firestore.dart';

abstract class SpecieContract{
  void returnSpecies(List<Specie> species);
  void speciesIsEmpty();
  void onError();
  void insertSuccess();
  void insertFailed();
  void removeSuccess();
  void removeFailed();
  void specieInUse();
  void updateFailed();
  void updateSuccess();
}

class SpeciePresenter{
  SpecieContract view;
  SpeciePresenter(this.view);
  var _api = SpecieApi();

  getSpecies()async{
    try{
      var species = await _api.getSpecies();
      if(species.isNotEmpty)
        view.returnSpecies(species);
      else
        view.speciesIsEmpty();
    }
    catch(e){
      view.onError();
    }
  }

  addSpecie(Specie specie)async{
    try{
      DocumentReference df = await _api.addSpecie(specie);
      if(df.id.isNotEmpty)
        view.insertSuccess();
      else
        view.insertFailed();
    }
    catch(e){
      view.onError();
    }
  }

  deleteSpecie(Specie specie)async{
    bool inUse = false;
    for(Animal animal in ApplicationSingleton.animals){
      if(animal.specie.contains(specie.specie)){
        inUse = true;
        view.specieInUse();
      }
    }
    if(!inUse){
      try{
        await _api.removeSpecie(specie.id);
        view.removeSuccess();
      }
      catch(e){
        view.removeFailed();
      }
    }

  }

  updateSpecie(Specie specie) async {
    try{
      await _api.updateSpecie(specie, specie.id);
      view.updateSuccess();
    }
    catch(e){
      view.updateFailed();
    }
  }
}