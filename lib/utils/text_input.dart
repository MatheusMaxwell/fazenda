import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {

  var name;
  String hint;
  TextInputType inputType;


  TextInput(this.name, this.hint, this.inputType);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Form(
          key: name,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    hintText: hint,
                  ),
                  keyboardType: inputType,
                ),
              ]
          )
      ),
    );
  }
}
