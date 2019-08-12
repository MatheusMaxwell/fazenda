import 'package:flutter/material.dart';

import 'package:FarmControl/pages/animal/animal_list.dart';
import 'package:FarmControl/pages/animal/animal_register.dart';
import 'package:FarmControl/utils/nav.dart';
import 'package:FarmControl/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class VaccineList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vacinas"),
        centerTitle: true,
      ),
      body: _body(),
      drawer: MyDrawer(),
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
