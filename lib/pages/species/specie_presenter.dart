
import 'package:FarmControl/data/api/SpecieApi.dart';
import 'package:FarmControl/model/species.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class SpecieContract{
  void returnSpecies(List<Specie> species);
  void speciesIsEmpty();
  void onError();
  void insertSuccess();
  void insertFailed();
  void removeSuccess();
  void removeFailed();
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
      if(df.documentID.isNotEmpty)
        view.insertSuccess();
      else
        view.insertFailed();
    }
    catch(e){
      view.onError();
    }
  }

  deleteSpecie(String id)async{
    try{
      await _api.removeSpecie(id);
      view.removeSuccess();
    }
    catch(e){
      view.removeFailed();
    }
  }
}