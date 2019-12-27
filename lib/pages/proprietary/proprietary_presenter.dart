
import 'package:FarmControl/data/api/ProprietaryApi.dart';
import 'package:FarmControl/model/proprietary.dart';
import 'package:firebase/firestore.dart';

abstract class ProprietaryContract{
  void listProprietaries(List<Proprietary> proprietaries);
  void proprietariesIsEmpty();
  void onError();
  void insertSuccess();
  void insertFailed();
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
}