
import 'dart:html';

import 'package:FarmControl/model/animal.dart';
import 'package:FarmControl/model/proprietary.dart';
import 'package:FarmControl/model/species.dart';
import 'package:FarmControl/pages/animal/animal_presenter.dart';
import 'package:FarmControl/utils/ApplicationSingleton.dart';
import 'package:FarmControl/utils/Components.dart';
import 'package:FarmControl/utils/Constants.dart';
import 'package:FarmControl/utils/nav.dart';
import 'package:FarmControl/widgets/button_blue.dart';
import 'package:FarmControl/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:firebase/firebase.dart';




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
  bool checkBuyDate = false;
  bool checkSaleDate = false;
  bool updating = true;
  bool isUpdate = false;
  final nameController = TextEditingController();
  final codeController = TextEditingController();
  File mFile = null;
  bool isInitialBuild = true;

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
    if(specieReady && propReady && isInitialBuild){
      proprietariesToString();
      speciesToString();
      isInitialBuild = false;
      setState(() {
        updating = false;
      });
    }
    if(ApplicationSingleton.animal != null){
      isUpdate = true;
      _animal = ApplicationSingleton.animal;
      nameController.text = _animal.name;
      codeController.text = _animal.code;
      if(_animal.lossDate.isNotEmpty) {
        checkLossDate = true;
      }
      if(_animal.buyDate.isNotEmpty) {
        checkBuyDate = true;
      }
      if(_animal.saleDate.isNotEmpty) {
        checkSaleDate = true;
      }
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Registro"),
          centerTitle: true,
        ),
        key: scaffoldKey,
        body: _body(context),
    );
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

  _body(BuildContext context){
    if(ApplicationSingleton.currentUser == null){
      redirectLogin(context);
    }
    else {
      if (updating) {
        return Center(
            child: CircularProgressIndicator(),
        );
      }
      else {
        return ListView(
          children: <Widget>[
                _dropDown("Espécie", _animal.specie, _dropDownSpecies,
                    changedDropDownItem), //arrumar
                textInput(true, TextInputType.text, "Nome"),
                _dropDown(
                    "Sexo", _animal.sex, _dropDownSexItems,
                    changedDropDownItemSex),
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
                        "Data Perda/Morte", style: TextStyle(fontSize: 17),),
                    ),
                    Checkbox(
                      value: checkLossDate,
                      onChanged: (bool value) {
                        setState(() {
                          if(!value){
                            _animal.lossDate = "";
                          }
                          checkLossDate = value;
                        });
                      },
                    ),
                  ],
                ),
                if(checkLossDate) _datePicker(false),
                _dropDown(
                    "Proprietário", _animal.proprietary, _dropDownProprietaries,
                    changedDropDownProprietary),
                _dropDown("Proprietário Agro", _animal.agroProprietary,
                    _dropDownProprietaries, changedDropDownProprietaryAgro),
                textInput(false, TextInputType.number, "Código brinco"),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "Data Compra", style: TextStyle(fontSize: 17),),
                    ),
                    Checkbox(
                      value: checkBuyDate,
                      onChanged: (bool value) {
                        setState(() {
                          if(!value) {
                            _animal.buyDate = "";
                          }
                          checkBuyDate = value;
                        });
                      },
                    ),
                  ],
                ),
                // ignore: sdk_version_ui_as_code
                if(checkBuyDate) _datePickerOther(true),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "Data Venda", style: TextStyle(fontSize: 17),),
                    ),
                    Checkbox(
                      value: checkSaleDate,
                      onChanged: (bool value) {
                        setState(() {
                          if(!value){
                            _animal.saleDate = "";
                          }
                          checkSaleDate = value;
                        });
                      },
                    ),
                  ],
                ),
                // ignore: sdk_version_ui_as_code
                if(checkSaleDate) _datePickerOther(false),
                _fileRow(_animal.fileName),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)
                    ),
                    color: Colors.grey,
                    child: Text('Upload Genealogia/Foto.', style: TextStyle(color: Colors.white),),
                    onPressed: _startFilePicker,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Text(
                          'Salvar',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed: (){
                          setState(() {
                            updating = true;
                          });
                          onPressedButton();
                        },
                      )

                    ],
                  ),
                )
              ],
          );
        //);
      }
    }
  }

  _fileRow(String fileName){
    if(fileName != null && fileName.isNotEmpty){
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: <Widget>[
            Text('Arquivo: '+fileName, style: TextStyle(fontSize: 22),),
            SizedBox(width: 10,),
            GestureDetector(
              child: Icon(Icons.close, color: Colors.blue,),
              onTap: ()async{
                bool ret = await alertYesOrNo(context, 'Arquivo', 'Deseja realmente remover o arquivo?');
                if(ret){
                  setState(() {
                    updating = true;
                  });
                  deleteFile(fileName);
                  setState(() {
                    updating = false;
                  });
                }
              },
            ),
          ],
        ),
      );
    }
    else{
      return SizedBox();
    }

  }
  
  textInput(bool isName, TextInputType type, String hint){
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: isName ? nameController : codeController,
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

  onPressedButton()async{
    if(mFile != null){
      await _uploadFile(mFile);
    }
    if(isUpdate){
      presenter.updateAnimal(_animal);
    }
    else{
      presenter.addAnimal(_animal);
    }
  }

  deleteFile(String fileName){
    if(_animal.urlFile != null && _animal.urlFile.isNotEmpty){
      storage().refFromURL('gs://farmcontrol-2069e.appspot.com').child('files/'+fileName).delete();
    }
    _animal.fileName = '';
    _animal.urlFile = '';
    mFile = null;
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

  _startFilePicker() async {
    if(_animal.urlFile != null && _animal.urlFile.isNotEmpty){
      alertOk(context, 'Alerta', 'Remova o arquivo já existente antes de adicionar um novo.');
    }
    else{
      InputElement uploadInput = FileUploadInputElement();
      uploadInput.click();

      uploadInput.onChange.listen((e) {
        // read file content as dataURL
        final files = uploadInput.files;
        if (files.length == 1) {
          final file = files[0];
          final reader = new FileReader();

          reader.onLoadEnd.listen((e) async{
            mFile = file;
            setState(() {
              _animal.fileName = DateTime.now().toString();
            });
            alertOk(context, 'Alerta', 'Arquivo inserido!');
          });
          reader.readAsDataUrl(file);
        }
      });
    }
  }

  _uploadFile(File file) async {
    StorageReference storageRef = storage().refFromURL('gs://farmcontrol-2069e.appspot.com').child('files/'+_animal.fileName);
    UploadTask uploadTask = storageRef.put(file);
    var uploadedFileURL = await(await uploadTask.future).ref.getDownloadURL();
    _animal.urlFile = uploadedFileURL.toString();
  }



  _datePicker(bool isDateBirth){
      if(isUpdate){
        if(isDateBirth){
          date = DateTime.parse(DateFormat("dd/MM/yyyy").parse(_animal.birthDate).toString());
        }
        else{
          if(_animal.lossDate.isNotEmpty){
            date = DateTime.parse(DateFormat("dd/MM/yyyy").parse(_animal.lossDate).toString());
          }
          else{
            date = DateTime.now();
          }
        }
      }
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
              initialDate: date,
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

  _datePickerOther(bool isDateBuy){
    if(isUpdate){
      if(isDateBuy){
        if(_animal.buyDate.isNotEmpty){
          date = DateTime.parse(DateFormat("dd/MM/yyyy").parse(_animal.buyDate).toString());
        }
        else{
          date = DateTime.now();
        }
      }
      else{
        if(_animal.saleDate.isNotEmpty){
          date = DateTime.parse(DateFormat("dd/MM/yyyy").parse(_animal.saleDate).toString());
        }
        else{
          date = DateTime.now();
        }
      }
    }
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
            initialDate: date,
            firstDate: DateTime(1900),
            lastDate: DateTime(DateTime.now().year+1));
        if(dtPicker != null && dtPicker != date){
          setState(() {
            if(isDateBuy){
              _animal.buyDate = formatDate(dtPicker, [dd, '/', mm, '/', yyyy]);
            }
            else{
              _animal.saleDate = formatDate(dtPicker, [dd, '/', mm, '/', yyyy]);
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

  @override
  void deleteAnimalFailed() {}

  @override
  void deleteAnimalSuccess() {}

  @override
  void updateFailed() {
    showSnackBar("Ocorreu um erro ao tentar atualizar. Tente novamente.", scaffoldKey);
  }

  @override
  void updateSuccess() {
    setState(() {
      updating = false;
    });
    showSnackBar("Animal atualizado.", scaffoldKey);
    SystemChrome.setEnabledSystemUIOverlays([]);
    Future.delayed(Duration(seconds: 1)).then((_) {
      Navigator.of(context).pop(true);
    });
  }
}


