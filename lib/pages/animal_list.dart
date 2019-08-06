import 'package:FarmControl/pages/animal_register.dart';
import 'package:FarmControl/utils/nav.dart';
import 'package:flutter/material.dart';

class AnimalList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animais"),
        centerTitle: true,
      ),
      body: _body(),
      drawer: _myDrawer(),
      floatingActionButton: FloatingActionButton(onPressed: () => _onPressed(context, AnimalRegisterSetting()),
      child: Icon(
          Icons.add
      ),
      ),
    );
  }


  _onPressed(BuildContext context, Widget page){
    push(context, page);
  }

  _myDrawer(){
    return Container(
      color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[_button("Animais"), _button("Vacina")],
      ),
    );
  }

  _button(String name){
    return RaisedButton(
      onPressed: null,
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
