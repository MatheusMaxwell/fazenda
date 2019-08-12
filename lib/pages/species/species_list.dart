import 'package:FarmControl/pages/animal/animal_list.dart';
import 'package:FarmControl/pages/animal/animal_register.dart';
import 'package:FarmControl/utils/nav.dart';
import 'package:FarmControl/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class SpeciesList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Espécies"),
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

  _body() {
    return Container(
      color: Colors.white,
    );
  }


}
