
import 'package:FarmControl/model/animal.dart';
import 'package:FarmControl/model/proprietary.dart';
import 'package:FarmControl/model/species.dart';
import 'package:FarmControl/pages/animal/animal_presenter.dart';
import 'package:FarmControl/utils/Components.dart';
import 'package:FarmControl/utils/Constants.dart';
import 'package:FarmControl/widgets/button_blue.dart';
import 'package:FarmControl/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/services.dart';


class AnimalRegisterSetting extends StatefulWidget {
  AnimalRegisterSetting({Key key}) : super(key: key);

  @override
  AnimalRegister createState() => new AnimalRegister();

}



class AnimalRegister extends State<AnimalRegisterSetting> implements AnimalContract{
  var _animal = Animal();
  List _sexs = ["Macho", "Femea"];
  DateTime date = DateTime.now();
  AnimalPresenter presenter;
  List<Specie> species;
  List<Proprietary> proprietaries;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  List<DropdownMenuItem<String>> _dropDownSexItems;
  List<DropdownMenuItem<String>> _dropDownSpecies;
  List<DropdownMenuItem<String>> _dropDownProprietaries;
  bool specieReady = false;
  bool propReady = false;
  bool checkLossDate = false;
  bool updating = true;


  AnimalRegister(){
    presenter = AnimalPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _dropDownSexItems = getDropDownMenuItems(_sexs);
    presenter.getSpecies();
    presenter.getProprietaries();
  }

  @override
  Widget build(BuildContext context) {
    if(specieReady && propReady){
      proprietariesToString();
      speciesToString();
      setState(() {
        updating = false;
      });
    }
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
    if(updating){
      return Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Registro"),
        ),
        key: scaffoldKey,
        body: Column(
          children: <Widget>[
            _dropDown("Espécie", _animal.specie, _dropDownSpecies,
                changedDropDownItem), //arrumar
            textInput(true, TextInputType.text, "Nome"),
            _dropDown(
                "Sexo", _animal.sex, _dropDownSexItems, changedDropDownItemSex),
            SizedBox(
              height: 15,
            ),
            _textDate("Data Nascimento"),
            _datePicker(true),
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    "Data Venda/Perda", style: TextStyle(fontSize: 17),),
                ),
                Checkbox(
                  value: checkLossDate,
                  onChanged: (bool value) {
                    setState(() {
                      checkLossDate = value;
                    });
                  },
                ),
              ],
            ),
            // ignore: sdk_version_ui_as_code
            if(checkLossDate) _datePicker(false),
            _dropDown(
                "Proprietário", _animal.proprietary, _dropDownProprietaries,
                changedDropDownProprietary),
            _dropDown("Proprietário Agro", _animal.agroProprietary,
                _dropDownProprietaries, changedDropDownProprietaryAgro),
            textInput(false, TextInputType.number, "Código brinco"),
            BlueButton("Salvar", onPressed: onPressedButton,)
          ],
        ),
      );
    }
  }
  
  textInput(bool isName, TextInputType type, String hint){
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  hintText: hint,
                ),
                keyboardType: type,
                onChanged: (value) {
                  if(isName){
                    _animal.name = value;
                  }
                  else{
                    _animal.code = value;
                  }
                  
                },
              ),
            ]
        )
    );
  }

  onPressedButton(){
    setState(() {
      updating = true;
    });
    presenter.addAnimal(_animal);
  }

  _textDate(String text){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(text,style: TextStyle(fontSize: 17),)
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
                _animal.birthDate = formatDate(dtPicker, [dd, '/', mm, '/', yyyy]);
              }
              else{
                _animal.lossDate = formatDate(dtPicker, [dd, '/', mm, '/', yyyy]);
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
      _animal.specie = _selectedType; //arrumar
    });
  }

  void changedDropDownItemSex(String _selectedSex) {
    print("Selected sex $_selectedSex, we are going to refresh the UI");
    setState(() {
      _animal.sex = _selectedSex;
    });
  }

  void changedDropDownProprietary(String _selectedProp) {
    print("Selected sex $_selectedProp, we are going to refresh the UI");
    setState(() {
      _animal.proprietary = _selectedProp;
    });
  }

  void changedDropDownProprietaryAgro(String _selectedPropAgro) {
    print("Selected sex $_selectedPropAgro, we are going to refresh the UI");
    setState(() {
      _animal.agroProprietary = _selectedPropAgro;
    });
  }

  @override
  void animalsIsEmpty() {
    // TODO: implement animalsIsEmpty
  }

  @override
  void insertFailed() {
    alertOk(context, "Alerta", "Ocorreu um erro ao tentar inserir o animal. Tente novamente.");
  }

  @override
  void insertSuccess() {
    setState(() {
      updating = false;
    });
    showSnackBar("Animal inserido", scaffoldKey);
    SystemChrome.setEnabledSystemUIOverlays([]);
    Future.delayed(Duration(seconds: 1)).then((_) {
      Navigator.of(context).pop(true);
    });
  }

  @override
  void listAnimals(List<Animal> animals) {
    // TODO: implement listAnimals
  }

  @override
  void onError() {
    showSnackBar("Ocorreu um erro. Tente novamente.", scaffoldKey);
  }

  @override
  void returnSpecies(List<Specie> species) {
    setState(() {
      this.species = species;
      specieReady = true;
    });

  }

  @override
  void speciesNotFound() {
    setState(() {
      this.species = List<Specie>();
    });
    alertOk(context, "Alerta", "Nenhuma especie cadastrado. Por favor, cadastre em configurações.");
  }

  void speciesToString(){
    List<String> speciesString = new List<String>();
    for(var s in species){
      speciesString.add(s.specie);
    }
    setState(() {
      _dropDownSpecies = getDropDownMenuItems(speciesString);
    });
  }

  void proprietariesToString(){
    List<String> proprietariesString = new List<String>();
    for(var p in proprietaries){
      proprietariesString.add(p.name + " | " + p.mark);
    }
    setState(() {
      _dropDownProprietaries = getDropDownMenuItems(proprietariesString);
    });
  }

  @override
  void proprietaryNotFound() {
    setState(() {
      this.proprietaries = List<Proprietary>();
    });
    alertOk(context, "Alerta", "Nenhum proprietário cadastrado. Por favor, cadastre em configurações.");
  }

  @override
  void returnProprietaries(List<Proprietary> proprietaries) {
    setState(() {
      this.proprietaries = proprietaries;
      propReady = true;
    });
  }
}


