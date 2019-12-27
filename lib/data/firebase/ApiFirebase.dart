import 'package:FarmControl/data/firebase/FirebaseHelper.dart';
import 'package:FarmControl/utils/ApplicationSingleton.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';


class ApiFirebase{
  final Firestore _db = firestore();
  final String path;
  CollectionReference ref;
  String userId = ApplicationSingleton.currentUser;

  ApiFirebase( this.path ) {
    ref = _db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection(){
    return ref.where("userId", "==", userId).get();
  }
  Stream<QuerySnapshot> streamDataCollection() {
    return ref.onSnapshot ;
  }
  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.doc(id).get();
  }
  Future<void> removeDocument(String id){
    return ref.doc(id).delete();
  }
  Future<DocumentReference> addDocument(Map data) {
    data["userId"] = userId;
    return ref.add(data);
  }

  Future<void> updateDocument(Map data , String id) {
    return ref.doc(id).update(data: data) ;
  }

}