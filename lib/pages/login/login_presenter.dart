


import 'package:FarmControl/utils/ApplicationSingleton.dart';

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
  login(String email, String password) async{
    try{
      var userId = await baseAuth.signIn(email, password);
      if(userId.length > 0 && userId != null){
        ApplicationSingleton.currentUser = await baseAuth.getCurrentUser();
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