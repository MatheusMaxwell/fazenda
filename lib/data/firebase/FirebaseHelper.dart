import 'package:firebase/firebase.dart' as fb;

class FirebaseHelper {
  static fb.Database initDatabase() {
    try {
      if (fb.apps.isEmpty) {
        fb.initializeApp(
            apiKey: "AIzaSyB9dcALmEUqPc9cU6X2WfvqSR8-L8RhkK4",
            authDomain: "farmcontrol-2069e.firebaseapp.com",
            databaseURL: "https://farmcontrol-2069e.firebaseio.com",
            projectId: "farmcontrol-2069e",
            storageBucket: "farmcontrol-2069e.appspot.com",
            messagingSenderId: "411284470737",
        );
      }
    } on fb.FirebaseJsNotLoadedException catch (e) {
      print(e);
    }
    return fb.database();
  }
}