
import 'package:FarmControl/utils/ApplicationSingleton.dart';
import 'package:FarmControl/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:FarmControl/utils/nav.dart';


Widget myDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        _containerHead(context),
        ListTile(
          leading: Icon(Icons.list),
          title: Text("Animais", style: TextStyle(fontSize: 22),),
          onTap: () => navigatorReplace(context,Constants.ANIMAL_LIST_PAGE)
        ),
        ListTile(
          leading: Icon(Icons.list),
          title: Text("Relatórios", style: TextStyle(fontSize: 22)),
          onTap: () => navigatorReplace(context, Constants.REPORTS_PAGE)
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Configurações", style: TextStyle(fontSize: 22)),
          onTap: () => navigatorReplace(context, Constants.SETTINGS_PAGE)
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
          onTap: () => _logout(context),
        )
      ],
    ),
  );
}


_logout(BuildContext context){
  ApplicationSingleton.baseAuth.signOut();
  Navigator.of(context).pushReplacementNamed(Constants.LOGIN_PAGE);
}

Widget _containerHead(BuildContext context){
  return GestureDetector(
    onTap: (){},
    child: Container(
        width: double.maxFinite,
        height: 200,
        color: Colors.blueGrey,
        child: Column(
          children: [
            Icon(Icons.house, color: Colors.white, size: 100),
            Text('FarmControl', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),)
          ],
        ),
    ),
  );
}
