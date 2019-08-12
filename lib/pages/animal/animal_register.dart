
import 'package:FarmControl/model/animal.dart';
import 'package:FarmControl/widgets/button_blue.dart';
import 'package:FarmControl/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';


class AnimalRegisterSetting extends StatefulWidget {
  AnimalRegisterSetting({Key key}) : super(key: key);

  @override
  AnimalRegister createState() => new AnimalRegister();

}



class AnimalRegister extends State<AnimalRegisterSetting> {
  var _animal = Animal();
  List _sexs = ["Macho", "Femea"];
  DateTime date = DateTime.now();
  List _types = ["Bovino", "Equino"];

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
          _dropDown("Espécie", _animal.name, _dropDownMenuItems, changedDropDownItem), //arrumar
          TextInput(_animal.name, "Nome", TextInputType.text),
          _dropDown("Sexo", _animal.sex, _dropDownSexItems, changedDropDownItemSex),
          _textDate("Data Nascimento"),
          _datePicker(true),
          TextInput(_animal.name, "Proprietário", TextInputType.text), //arrumar
          _textDate("Data Venda/Perda"),
          _datePicker(false),
          TextInput(_animal.agroProprietary, "Proprietário Agro",  TextInputType.text),
          BlueButton("Salvar")
        ],
      ),
    );
  }

  _textDate(String text){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(text)
        ],
      ),
    );
  }

  _dropDown(String hint, String value, List dropDown, Function onChanged){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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

  _datePicker(bool isDateBirth){
    return FlatButton(
      child: Row(
        children: <Widget>[
          Text(formatDate(date, [dd, '/', mm, '/', yyyy])),
          Icon(Icons.calendar_today)
        ],
      ),
      onPressed: () async {
        final dtPicker = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(DateTime.now().year+1));
        if(dtPicker != null && dtPicker != date){
          setState(() {
            if(isDateBirth){
              _animal.birthDate = dtPicker.toString();
            }
            else{
              _animal.lossDate = dtPicker.toString();
            }
            date = dtPicker;
          });
        }
      },
    );
  }

  void changedDropDownItem(String _selectedType) {
    print("Selected type $_selectedType, we are going to refresh the UI");
    setState(() {
      _animal.name = _selectedType; //arrumar
    });
  }

  void changedDropDownItemSex(String _selectedSex) {
    print("Selected sex $_selectedSex, we are going to refresh the UI");
    setState(() {
      _animal.sex = _selectedSex;
    });
  }
}


