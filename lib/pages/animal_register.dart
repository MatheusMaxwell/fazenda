import 'package:FarmControl/utils/text_input.dart';
import 'package:flutter/material.dart';

class AnimalRegister extends StatelessWidget {
  var _name;
  @override
  Widget build(BuildContext context) {
    return _body();
  }

  _body(){
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro"),
      ),
      body: Column(
        children: <Widget>[TextInput(_name, "Nome", TextInputType.text),TextInput(_name, "Idade", TextInputType.number)],
      ),
    );
  }

  _style(){}

  _formName(var name, String hint){
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
                  keyboardType: TextInputType.datetime,
                ),
              ]
          )
      ),
    );
  }
}


