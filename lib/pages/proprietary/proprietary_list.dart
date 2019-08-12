import 'package:FarmControl/pages/animal/animal_list.dart';
import 'package:FarmControl/pages/animal/animal_register.dart';
import 'package:FarmControl/utils/nav.dart';
import 'package:FarmControl/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class ProprietaryList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Proprietários"),
        centerTitle: true,
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(onPressed: () => _onPressed(context, AnimalRegisterSetting()),
        child: Icon(
            Icons.add
        ),
      ),
    );
  }


  _onPressed(BuildContext context, Widget page){
    //push(context, page);
  }

  _myDrawer(BuildContext context){
    return Container(
      color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _button("Animais", AnimalList(), context),
          _button("Vacina",  AnimalList(), context),
          _button("Proprietários", ProprietaryList(), context),
          _button("Espécies",  AnimalList(), context)
        ],
      ),
    );
  }

  _button(String name, Widget page, BuildContext context){
    return RaisedButton(
      onPressed: _onPressed(context, page),
      child: Text(
        name,
        style: TextStyle(
            color: Colors.blue),
      ),
      color: Colors.white,
    );
  }

  _body() {
    return Container(
      color: Colors.white,
    );
  }


}
