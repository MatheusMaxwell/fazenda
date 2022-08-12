import 'dart:js' as js;
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:FarmControl/model/animal.dart';
import 'package:jiffy/jiffy.dart';
import '../../utils/ApplicationSingleton.dart';
import '../../utils/Components.dart';

class AnimalDetail extends StatefulWidget {
  @override
  _AnimalDetailState createState() => _AnimalDetailState();
}

class _AnimalDetailState extends State<AnimalDetail> {
  Animal animal;
  bool isEquino = false;
  MediaQueryData mediaQuery;
  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    animal = ApplicationSingleton.animal;
    if(animal.specie.contains('Equino')){
      isEquino = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: _body(),
    );
  }

  _body(){
    return ListView(
      children: <Widget>[
        Center(
          child: Text(
            animal.name, style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _animalField('Código: ', animal.code),
                  _space(),
                  _animalField('Espécie: ', animal.specie),
                  _space(),
                  _animalField('Sexo: ', animal.sex),
                  _space(),
                  _animalField('Data Nascimento: ', animal.birthDate),
                  _space(),
                  _animalField('Proprietário: ', animal.proprietary),
                  _space(),
                  _animalField('Proprietário Agro: ', animal.agroProprietary),
                  if(animal.lossDate.isNotEmpty) _space(),
                  if(animal.lossDate.isNotEmpty) _animalField('Data Perda: ', animal.lossDate),
                  if(animal.buyDate.isNotEmpty) _space(),
                  if(animal.buyDate.isNotEmpty) _animalField('Data Compra: ', animal.buyDate),
                  if(animal.saleDate.isNotEmpty) _space(),
                  if(animal.saleDate.isNotEmpty) _animalField('Data Venda: ', animal.saleDate),
                  if(animal.matingDate.isNotEmpty) _space(),
                  if(animal.matingDate.isNotEmpty) _animalField('Data Cobrição: ', animal.matingDate),
                  if(animal.matingDate.isNotEmpty && animal.matingBy.isNotEmpty) _animalField('Cobrição por: ', animal.matingBy),
                  if(animal.matingDate.isNotEmpty) _space(),
                  if(animal.matingDate.isNotEmpty) _animalField('Previsão de parto: ', _prediction(animal.matingDate, animal.specie))
                ]
              ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: RaisedButton(
            color: Colors.blueGrey,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)
            ),
            onPressed: (){
              if(animal.urlFile.isEmpty){
                alertOk(context, 'Alerta', 'Este animal não possui um arquivo associado a ele.');
              }
              else{
                js.context.callMethod("open", [animal.urlFile]);
              }
            },
            child: Text('Genealogia/Foto', style: TextStyle(color: Colors.white, fontSize: fontGetValue(mediaQuery.size.width/30)),),
          ),
        )
      ],
    );
  }

  String _prediction(String matingDate, String specie){
    var days = specie.toLowerCase() == "bovino" ? 283 : 340;
    var date = Jiffy(matingDate, 'dd/MM/yyyy').add(days: days);

    return formatDate(date, [dd, '/', mm, '/', yyyy]);
  }

  _animalField(String field, String value){
    String modField = field;
    if(field.contains('Proprietário Agro: ')){
      if(isEquino){
        modField = 'Proprietário ABCCMM: ';
      }
    }
    return Row(
      children: <Widget>[
        Text(modField, style: TextStyle(fontSize: fontGetValue(mediaQuery.size.width/30), fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(fontSize: fontGetValue(mediaQuery.size.width/30)))
      ],
    );
  }

  _space(){
    return SizedBox(
      height: 30,
    );
  }

  fontGetValue(double value){
    if(value > 26){
      return 26;
    }

    return value;
  }

}
