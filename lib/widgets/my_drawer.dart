import 'package:FarmControl/pages/animal/animal_list.dart';
import 'package:FarmControl/pages/settings/settings_page.dart';
import 'package:FarmControl/pages/vaccine/vaccine_list.dart';
import 'package:flutter/material.dart';
import 'package:FarmControl/utils/nav.dart';

class MyDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.list),
            title: Text("Animais"),
            onTap: (){
              Navigator.pop(context);
              push(context, AnimalList());

            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text("Vacinas"),
            onTap: (){
              Navigator.pop(context);
              push(context, VaccineList());
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Configurações"),
            onTap: (){
              Navigator.pop(context);
              push(context, SettingsPage());
            },
          ),
        ],
      ),
    );
  }
}
