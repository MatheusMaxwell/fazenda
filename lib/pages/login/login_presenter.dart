import 'package:FarmControl/utils/ApplicationSingleton.dart';
import 'package:firebase/firebase.dart';
import 'package:FarmControl/data/firebase/FirebaseAuthentication.dart';
import 'package:flutter/material.dart';

abstract class LoginContract{
  loginSuccess(bool stopAnimation);
  loginFailed();
  incorrectLogin();
  incorrectPassword();
  serverError();
}

class LoginPresenter{
  LoginContract view;
  var baseAuth = ApplicationSingleton.baseAuth;
  LoginPresenter(this.view);
  login(String email, String password, BuildContext buildContext) async{
    try{
      UserCredential user = await baseAuth.signInWithCredentials(email, password);
      if(user.user.uid != null){
        ApplicationSingleton.currentUser = await baseAuth.getUser();
        view.loginSuccess(true);
      }
      else{
        view.loginFailed();
      }
    }
    catch(e){
      if(e.toString().toUpperCase().contains("PASSWORD"))
        view.incorrectPassword();
      else if(e.toString().toUpperCase().contains("EMAIL"))
        view.incorrectLogin();
      else
        view.serverError();
    }

  }
}