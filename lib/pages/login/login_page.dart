import 'dart:async';
import 'package:FarmControl/data/firebase/FirebaseAuthentication.dart';
import 'package:FarmControl/pages/animal/animal_list.dart';
import 'package:FarmControl/pages/login/login_presenter.dart';
import 'package:FarmControl/utils/Components.dart';
import 'package:FarmControl/utils/Constants.dart';
import 'package:FarmControl/utils/nav.dart';
import 'package:flutter_web/material.dart';
import 'package:flutter_web/services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin implements LoginContract {

  //User Controllers and Password
  final _loginController = new TextEditingController();
  final _passwordController = new TextEditingController();
  final _recoverEmailController = new TextEditingController();
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
    MediaQueryData mediaQuery = MediaQuery.of(context);
    _loginController.text = "farmcontrol2019@gmail.com";
    _passwordController.text = "HarasAEM2307";

    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: new Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.blue,
        resizeToAvoidBottomPadding: true,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: mediaQuery.size.width <= 1000 ? mediaQuery.size.width*0.5 : mediaQuery.size.width*0.4,
                  height: mediaQuery.size.height <= 520 ? mediaQuery.size.height*0.3 : mediaQuery.size.height*0.4,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: ExactAssetImage('images/logo.png'),
                    ),
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
                      height: mediaQuery.size.height <= 520 ? mediaQuery.size.height*0.1 : mediaQuery.size.height*0.3,
                    ),
                    Container(
                      width: mediaQuery.size.width<=600 ? mediaQuery.size.width*0.8 : mediaQuery.size.width*0.5,
                      height: mediaQuery.size.height <= 650 ? mediaQuery.size.height*0.6 : mediaQuery.size.height*0.4,
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
                                    width: mediaQuery.size.width<=600 ? mediaQuery.size.width*0.730 : mediaQuery.size.width*0.475,
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
                                                        _presenter.login(_loginController.text, _passwordController.text, context);
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
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: ()async {
                                String email = await _dialogEmail();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Esqueci a senha.", style: TextStyle(color: Colors.blue, fontSize: 18, decoration: TextDecoration.underline,),)
                                ],
                              ),
                            )
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
      ),
    );
  }

  //Function to stop button animation
  void _stopAnimate(){
    _controller.stop();
  }

  Future<String> _dialogEmail(){
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)
            ),
            contentPadding: EdgeInsets.all(10.0),
            title: Center(child: Text("Recuperar senha")),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _textInput("Insira seu email", _recoverEmailController),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text("Cancelar"),
                onPressed: (){
                  Navigator.of(context).pop("");
                },
              ),
              FlatButton(
                child: new Text("Ok"),
                onPressed: () {
                  if(_recoverEmailController.text.isNotEmpty){
                    Navigator.of(context).pop(_recoverEmailController.text);
                  }
                },
              ),
            ],
          );
        }
    );
  }

  _textInput(String hintText,TextEditingController controller){
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
      ),
    );
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
      navigatorReplace(context, Constants.ANIMAL_LIST_PAGE);
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
