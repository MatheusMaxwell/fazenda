
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Mostrar alerta na parte inferior da tela. -> final scaffoldKey = new GlobalKey<ScaffoldState>();
Function showSnackBar(String text, GlobalKey<ScaffoldState> scaffoldKey){
  ScaffoldMessenger.of(scaffoldKey.currentContext).showSnackBar(
    SnackBar(content: Text(text))
  );
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
          MaterialButton(
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

//Alerta botao ok
Future<bool> alertYesOrNo(BuildContext context, String name, String content) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(name),
        content: Text(content),
        actions: <Widget>[
          MaterialButton(
            child: Text('Sim'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          MaterialButton(
            child: Text('Não'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
    },
  );
}

