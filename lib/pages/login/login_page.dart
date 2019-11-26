import 'dart:async';

import 'package:FarmControl/pages/animal/animal_list.dart';
import 'package:FarmControl/pages/login/login_presenter.dart';
import 'package:FarmControl/utils/Components.dart';
import 'package:FarmControl/utils/MyMediaQuery.dart';
import 'package:FarmControl/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/auth_strings.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin implements LoginContract {

  //User Controllers and Password
  final _loginController = new TextEditingController();
  final _passwordController = new TextEditingController();
  //-----------------------------------------------------

  bool _isPressed = false, _animatingReveal = false;
  int _state = 0;
  double _width = double.infinity;
  Animation _animation;
  GlobalKey _globalKey = GlobalKey();
  AnimationController _controller;



  //Password Visibility
  bool _isHidden = true;
  void _toggleVisibility(){
    setState(() {
      _isHidden = !_isHidden;
    });
  }
  //----------------------------------------

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  LoginPresenter _presenter;

  _LoginPageState(){
    _presenter = LoginPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blue,
      resizeToAvoidBottomPadding: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Image.asset("assets/images/logo.png",
                  width: 300,
                  height: 250,
                ),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 70.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MyMediaQuery.size.height*0.3,
                  ),
                  Container(
                    width: MyMediaQuery.size.width*0.9,
                    height: MyMediaQuery.size.height*0.35,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, 15.0),
                              blurRadius: 15.0),
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, -10.0),
                              blurRadius: 10.0),
                        ]),
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 40.0,),
                          buildTextField("Usuário",_loginController),
                          SizedBox(height: 20.0,),
                          buildTextField("Senha",_passwordController),
                          SizedBox(height: 20.0,),
                          Row(
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                  width: MyMediaQuery.size.width*0.77,
                                  height: 60,
                                  child: Material(
                                    child: InkWell(
                                        child: PhysicalModel(
                                            color: Colors.blue,
                                            elevation: _calculateElevation(),
                                            borderRadius: BorderRadius.circular(25.0),
                                            child: Container(
                                              key: _globalKey,
                                              height: 48.0,
                                              width: _width,
                                              child: RaisedButton(
                                                shape: new RoundedRectangleBorder( //Round up
                                                    borderRadius: new BorderRadius.circular(18)
                                                ),
                                                padding: EdgeInsets.all(0.0),
                                                color: _state==3 ? Colors.green : Colors.blue,
                                                child: _buildButtonChild(),
                                                onPressed: () {
                                                  if(_loginController.text.isEmpty || _passwordController.text.isEmpty){
                                                    alertOk(context, "Erro", "Usuário e/ou Senha em branco");
                                                  }else{
                                                    setState(() {
                                                      _isPressed = true;
                                                      _state = 1;
                                                      _animateButton();
                                                      _presenter.login(_loginController.text, _passwordController.text);
                                                    });
                                                  }
                                                },
                                              ),
                                            )
                                        )
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  //Function to stop button animation
  void _stopAnimate(){
    _controller.stop();
  }

  //Function animation button in login
  void _animateButton() {
    double initialWidth = _globalKey.currentContext.size.width;
    _controller =
        AnimationController(duration: Duration(milliseconds: 5000),vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _width = initialWidth - ((initialWidth - 48.0) * _animation.value);
        });
      });
    _controller.forward();
  }

  //Function to name button and call animation
  Widget _buildButtonChild() {
    if (_state == 0) {
      return Text(
          'Entrar',
          style: TextStyle(fontSize: 22, color: Colors.white)
      );
    } else if (_state == 1){
      return SizedBox(
        height: 36.0,
        width: 36.0,
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  //Animated effect function of pressing the button
  double _calculateElevation() {
    if (_animatingReveal) {
      return 0.0;
    } else {
      return _isPressed ? 6.0 : 4.0;
    }
  }

  //Call Contract Function - Login Failed
  @override
  loginFailed() {
    setState(() {
      _state = 0;
    });
    _stopAnimate();
    alertOk(context, "Acesso negado", "Por favor verifique o usuário e a senha.");
  }

  //Call Contract Function - Success
  @override
  loginSuccess(bool stotAnimation) {
    /*if(_flagLogin!=true){
      _flagLogin=true;
      getFile();
      saveData(_flagLogin.toString());
    }*/
    setState(() {
      _state = 3;
    });
    if(stotAnimation){
      _stopAnimate();
    }
    SystemChrome.setEnabledSystemUIOverlays([]);
    Future.delayed(Duration(seconds: 1)).then((_) {
      push(context, AnimalList());
    });

  }
  //Call Contract Function - Incorrect login
  @override
  incorrectLogin() {
    setState(() {
      _state = 0;
    });
    alertOk(context, "Alerta", "Email inválido.");
  }

  //Call Contract Function - Incorrect password
  @override
  incorrectPassword() {
    setState(() {
      _state = 0;
    });
    alertOk(context, "Alerta", "Senha inválida.");
  }

  //Call Contract Function - server error
  @override
  serverError() {
    setState(() {
      _state = 0;
    });
    alertOk(context, "Alerta", "Erro ao tentar comunicação com o servidor.");
  }

  //Function to make custom textFields
  Widget buildTextField(String hintText,TextEditingController controller){
    return TextField(
      textInputAction: TextInputAction.done,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        prefixIcon: hintText == "Usuário" ? Icon(Icons.account_circle) : Icon(Icons.lock),
        suffixIcon: hintText == "Senha" ? IconButton(
          onPressed: _toggleVisibility,
          icon: _isHidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
        ) : null,
      ),
      obscureText: hintText == "Senha" ? _isHidden : false,
    );
  }
}
