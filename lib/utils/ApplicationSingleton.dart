
import 'package:FarmControl/data/firebase/FirebaseAuthentication.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter_web/material.dart';

class ApplicationSingleton {
  static ApplicationSingleton _instance;
  factory ApplicationSingleton() {
    _instance ??= ApplicationSingleton._internalConstructor();
    return _instance;
  }
  ApplicationSingleton._internalConstructor();

  static UserRepository baseAuth;
  static String currentUser;

}