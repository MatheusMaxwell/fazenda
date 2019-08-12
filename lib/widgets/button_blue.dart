import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {

  String text;
  Function onPressed;


  BlueButton(this.text, {this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: RaisedButton(
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
            onPressed: onPressed,
          ),
        )

      ],
    );
  }
}