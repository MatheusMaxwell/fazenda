
import 'package:FarmControl/model/animal.dart';
import 'package:FarmControl/widgets/button_blue.dart';
import 'package:FarmControl/widgets/text_input.dart';
import 'package:flutter/material.dart';


class AnimalRegisterSetting extends StatefulWidget {
  AnimalRegisterSetting({Key key}) : super(key: key);

  @override
  AnimalRegister createState() => new AnimalRegister();

}



class AnimalRegister extends State<AnimalRegisterSetting> {
  var _animal = Animal();
  List _sexs = ["Macho", "Femea"];
  List _types =
  ["Bovino", "Equino"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  List<DropdownMenuItem<String>> _dropDownSexItems;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems(_types);
    _dropDownSexItems = getDropDownMenuItems(_sexs);
    //_currentType = _dropDownMenuItems[0].value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems(List list) {
    List<DropdownMenuItem<String>> items = new List();
    for (String item in list) {
      items.add(new DropdownMenuItem(
          value: item,
          child: new Text(item)
      ));
    }
    return items;
  }
  
  

  _body(){
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro"),
      ),
      body: Column(
        children: <Widget>[
          _dropDown("Selecione o tipo", _animal.type, _dropDownMenuItems, changedDropDownItem),
          TextInput(_animal.name, "Nome", TextInputType.text),
          _dropDown("Selecione o sexo", _animal.sex, _dropDownSexItems, changedDropDownItemSex),
          TextInput(_animal.sex, "Data Nascimento", TextInputType.number),
          BlueButton("Salvar")
        ],
      ),
    );
  }

  _dropDown(String hint, String value, List dropDown, Function onChanged){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DropdownButton(
            hint: Text(hint),
            value: value,
            items: dropDown,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void changedDropDownItem(String _selectedType) {
    print("Selected type $_selectedType, we are going to refresh the UI");
    setState(() {
      _animal.type = _selectedType;
    });
  }

  void changedDropDownItemSex(String _selectedSex) {
    print("Selected sex $_selectedSex, we are going to refresh the UI");
    setState(() {
      _animal.sex = _selectedSex;
    });
  }
}


