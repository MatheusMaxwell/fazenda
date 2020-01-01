
import 'package:FarmControl/data/api/ProprietaryApi.dart';
import 'package:FarmControl/model/proprietary.dart';
import 'package:firebase/firestore.dart';

import 'package:FarmControl/model/animal.dart';
import 'package:FarmControl/utils/ApplicationSingleton.dart';

abstract class ProprietaryContract{
  void listProprietaries(List<Proprietary> proprietaries);
  void proprietariesIsEmpty();
  void onError();
  void insertSuccess();
  void insertFailed();
  void removeSuccess();
  void removeFailed();
  void proprietaryInUse();
  void updateSuccess();
  void updateFailed();
}

class ProprietaryPresenter {
  ProprietaryContract view;
  ProprietaryPresenter(this.view);
  var _api = new ProprietaryApi();

  getProprietaries()async{
    try{
      var proprietaries = await _api.getProprietaries();
      if(proprietaries.isNotEmpty)
        view.listProprietaries(proprietaries);
      else
        view.proprietariesIsEmpty();
    }
    catch(e){
      view.onError();
    }
  }

  addProprietary(Proprietary prop)async{
    try{
      DocumentReference df = await _api.addProprietary(prop);
      if(df.id.isNotEmpty)
        view.insertSuccess();
      else
        view.insertFailed();
    }
    catch(e){
      view.onError();
    }
  }

  deleteProprietary(Proprietary prop) async{
    bool inUse = false;
    for(Animal animal in ApplicationSingleton.animals){
      if(animal.proprietary.contains(prop.name) && animal.proprietary.contains(prop.mark)){
        inUse = true;
        view.proprietaryInUse();
      }
    }
    if(!inUse){
      try{
        await _api.removeProprietary(prop.id);
        view.removeSuccess();
      }
      catch(e){
        view.removeFailed();
      }
    }
  }

  updateProprietary(Proprietary prop) async{
    try{
      await _api.updateProprietary(prop, prop.id);
      view.updateSuccess();
    }
    catch(e){
      view.updateFailed();
    }
  }
}