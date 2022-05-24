import 'package:FarmControl/data/firebase/FirebaseAuthentication.dart';
import 'package:FarmControl/pages/proprietary/proprietary_list.dart';
import 'package:FarmControl/pages/species/species_list.dart';
import 'package:FarmControl/utils/ApplicationSingleton.dart';
import 'package:FarmControl/utils/Components.dart';
import 'package:FarmControl/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:FarmControl/pages/animal/animal_register.dart';
import 'package:FarmControl/utils/nav.dart';
import 'package:FarmControl/widgets/my_drawer.dart';
//import 'package:toast/toast.dart';


class SettingsPage extends StatefulWidget {

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _valueAuth = false;
  final _newPassField1Controller = new TextEditingController();
  final _newPassField2Controller = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: _body(context),
      drawer: myDrawer(context),
      key: scaffoldKey,
    );
  }

  _body(BuildContext context) {
    if(ApplicationSingleton.currentUser == null) {
      redirectLogin(context);
    }
    else {
      return Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            listTitle("Proprietários", context, ProprietaryList(), Icons.list),
            listTitle("Espécies", context, SpecieList(), Icons.list),
            listTitle("Alterar senha", context, null, Icons.lock)
          ],
        ),
      );
    }
  }

  listTitle(String title, BuildContext context, Widget page, IconData icon){
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(Icons.arrow_right),
      onTap: ()async{
        if(page!=null){
          push(context, page);
        }
        else{
          String ret = await _dialogChangePassword();
          if(ret.isNotEmpty){
            _changePassword(ret);
          }
        }
      },
    );
  }

  void _changePassword(String password) async{
    //Create an instance of the current user.
    UserRepository user = ApplicationSingleton.baseAuth;
    //Pass in the password to updatePassword.
    user.updatePassword(password).then((_){
      alertOk(context, "Alteração de senha", "Senha alterada com sucesso!");
    }).catchError((error){
      alertOk(context, "Alteração de senha", "Não foi possível alterar a senha. Tente novamente. Erro: "+error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }

  Future<String> _dialogChangePassword(){
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)
          ),
          contentPadding: EdgeInsets.all(10.0),
          title: Center(child: Text("Alterar Senha")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _textInput("Nova senha", _newPassField1Controller),
              SizedBox(
                height: 10,
              ),
              _textInput("Repita a senha", _newPassField2Controller)
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: new Text("Cancelar"),
              onPressed: (){
                Navigator.of(context).pop("");
              },
            ),
            FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                if(_newPassField1Controller.text == _newPassField2Controller.text){
                  if(_newPassField1Controller.text.length > 5){
                    Navigator.of(context).pop(_newPassField2Controller.text);
                  }
                  else{
                    alertOk(context, "Tamanho inválido", "A senha deve conter, pelo menos, 6 caracteres.");
                    _newPassField1Controller.text = "";
                    _newPassField2Controller.text = "";
                  }
                }
                else{
                  alertOk(context, "Senhas diferentes", "Por favor, informe duas senhas iguais.");
                  _newPassField1Controller.text = "";
                  _newPassField2Controller.text = "";
                }
              },
            ),
          ],
        );
      }
    );
  }

  _textInput(String hintText,TextEditingController controller){
    return TextField(
      textInputAction: TextInputAction.done,
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }

}
