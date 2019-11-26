
import 'package:FarmControl/data/firebase/FirebaseAuthentication.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApplicationSingleton {
  static ApplicationSingleton _instance;
  factory ApplicationSingleton() {
    _instance ??= ApplicationSingleton._internalConstructor();
    return _instance;
  }
  ApplicationSingleton._internalConstructor();

  static Auth baseAuth;
  static FirebaseUser currentUser;

}