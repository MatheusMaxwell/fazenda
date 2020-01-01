
import 'package:FarmControl/data/firebase/FirebaseAuthentication.dart';
import 'package:FarmControl/model/animal.dart';
import 'package:FarmControl/model/proprietary.dart';
import 'package:FarmControl/model/species.dart';

class ApplicationSingleton {
  static ApplicationSingleton _instance;
  factory ApplicationSingleton() {
    _instance ??= ApplicationSingleton._internalConstructor();
    return _instance;
  }
  ApplicationSingleton._internalConstructor();

  static UserRepository baseAuth;
  static String currentUser;
  static List<Animal> animals;
  static Animal animal;
  static Proprietary proprietary;
  static Specie specie;
}