import 'package:FarmControl/pages/animal/animal_list.dart';
import 'package:FarmControl/pages/login/login_page.dart';
import 'package:FarmControl/pages/settings/settings_page.dart';
import 'package:FarmControl/pages/vaccine/vaccine_list.dart';
import 'package:FarmControl/utils/ApplicationSingleton.dart';
import 'package:flutter/material.dart';
import 'package:FarmControl/utils/nav.dart';

class MyDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          _containerHead(context),
          ListTile(
            leading: Icon(Icons.list),
            title: Text("Animais", style: TextStyle(fontSize: 22),),
            onTap: (){
              Navigator.pop(context);
              push(context, AnimalList());

            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text("Vacinas", style: TextStyle(fontSize: 22)),
            onTap: (){
              Navigator.pop(context);
              push(context, VaccineList());
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Configurações", style: TextStyle(fontSize: 22)),
            onTap: (){
              Navigator.pop(context);
              push(context, SettingsPage());
            },
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.maxFinite,
            height: 1,
            color: Colors.black38,
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Sair", style: TextStyle(fontSize: 22)),
            onTap: _logout(context),
          )
        ],
      ),
    );
  }
}

_logout(BuildContext context){
  ApplicationSingleton.baseAuth.signOut();
  pushReplacement(context, LoginPage());
}

Widget _containerHead(BuildContext context){
  return GestureDetector(
    onTap: (){},
    child: Container(
        width: double.maxFinite,
        height: 200,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage('assets/images/logo.png'),
                fit: BoxFit.cover
            )
        )
    ),
  );
}
