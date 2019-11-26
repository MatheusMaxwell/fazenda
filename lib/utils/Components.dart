
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Mostrar alerta na parte inferior da tela. -> final scaffoldKey = new GlobalKey<ScaffoldState>();
Function showSnackBar(String text, GlobalKey<ScaffoldState> scaffoldKey){
  scaffoldKey.currentState.showSnackBar(new SnackBar(
    content: new Text(text),
  ));
}

//Alerta botao ok
Future<void> alertOk(BuildContext context, String title, String content) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

