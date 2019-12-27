import 'package:FarmControl/pages/proprietary/proprietary_list.dart';
import 'package:FarmControl/pages/species/species_list.dart';
import 'package:FarmControl/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:FarmControl/pages/animal/animal_register.dart';
import 'package:FarmControl/utils/nav.dart';
import 'package:FarmControl/widgets/my_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _valueAuth = false;

  @override
  Widget build(BuildContext context) {
    _getFlagBiometrics();
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
          _listTItle("Espécies", context, SpecieList()),
          _biometricsAuth()
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

  _biometricsAuth(){
    return ListTile(
      leading: Icon(Icons.fingerprint),
      title: Text("Ativar login por biometria"),
      trailing: Switch(
        value: _valueAuth,
        onChanged: (value) {
            _saveFlagBiometricsAuth(value);
            setState(() {
              _valueAuth = value;
            });
          },
      )
    );
  }

  _saveFlagBiometricsAuth(bool value)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(Constants.PREFERENCES_BIOMETRICS, value);
  }

  _getFlagBiometrics()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var ret = prefs.getBool(Constants.PREFERENCES_BIOMETRICS);
      if(ret != null)
        _valueAuth = ret;
    });
  }
}
