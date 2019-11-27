import 'package:FarmControl/pages/proprietary/proprietary_list.dart';
import 'package:FarmControl/pages/species/species_list.dart';
import 'package:flutter/material.dart';
import 'package:FarmControl/pages/animal/animal_register.dart';
import 'package:FarmControl/utils/nav.dart';
import 'package:FarmControl/widgets/my_drawer.dart';

class SettingsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
        centerTitle: true,
      ),
      body: _body(context),
      drawer: myDrawer(context),
    );
  }

  _body(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          _listTItle("Proprietários", context, ProprietaryList()),
          _listTItle("Espécies", context, SpeciesList())
        ],
      ),
    );
  }
  
  _listTItle(String title, BuildContext context, Widget page){
    return ListTile(
      leading: Icon(Icons.list),
      title: Text(title),
      trailing: Icon(Icons.arrow_right),
      onTap: (){
        push(context, page);
      },
    );
  }


}
