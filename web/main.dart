import 'package:flutter_web_ui/ui.dart' as ui;
import 'package:FarmControl/main.dart' as app;
import 'package:firebase/firebase.dart' as fb;

main() async {
  try {
    //await config();
    fb.initializeApp(
        apiKey: "AIzaSyB9dcALmEUqPc9cU6X2WfvqSR8-L8RhkK4",
        authDomain: "farmcontrol-2069e.firebaseapp.com",
        databaseURL: "https://farmcontrol-2069e.firebaseio.com",
        projectId: "farmcontrol-2069e",
        storageBucket: "farmcontrol-2069e.appspot.com",
        messagingSenderId: "411284470737",
    );
    await ui.webOnlyInitializePlatform();
    app.main();
  } on fb.FirebaseJsNotLoadedException catch (e) {
    print(e);
  }
}