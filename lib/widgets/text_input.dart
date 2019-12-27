import 'package:flutter_web/material.dart';

class TextInput extends StatelessWidget {

  var input;
  String hint;
  TextInputType inputType;


  TextInput(this.input, this.hint, this.inputType);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Form(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: hint,
                  ),
                  keyboardType: inputType,
                  onChanged: (value) {
                    input = value;
                  },
                ),
              ]
          )
      ),
    );
  }
}
