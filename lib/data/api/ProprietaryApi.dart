

import 'package:FarmControl/data/firebase/ApiFirebase.dart';
import 'package:FarmControl/model/proprietary.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter_web/material.dart';

class ProprietaryApi extends ChangeNotifier {
  ApiFirebase _api = new ApiFirebase('proprietary');
  List<Proprietary> proprietaries;

  Future<List<Proprietary>> getProprietaries() async {
    var result = await _api.getDataCollection();
    proprietaries = result.docs
        .map((doc) => Proprietary.fromMap(doc.data(), doc.id))
        .toList();
    return proprietaries;
  }

  Stream<QuerySnapshot> getProprietariesAsStream() {
    return _api.streamDataCollection();
  }

  Future<Proprietary> getProprietaryById(String id) async {
    var doc = await _api.getDocumentById(id);
    return  Proprietary.fromMap(doc.data(), doc.id) ;
  }


  Future removeProprietary(String id) async{
    await _api.removeDocument(id);
    return ;
  }
  Future updateProprietary(Proprietary data,String id) async{
    await _api.updateDocument(data.toJson(), id) ;
    return ;
  }

  Future addProprietary(Proprietary data) async{
    var result  = await _api.addDocument(data.toJson()) ;

    return result;

  }


}