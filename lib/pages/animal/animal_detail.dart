import 'dart:js_util';
import 'dart:js' as js;
import 'package:flutter_web/material.dart';
import 'package:flutter_web/rendering.dart';
import 'package:FarmControl/model/animal.dart';
import '../../utils/ApplicationSingleton.dart';
import '../../utils/Components.dart';

class AnimalDetail extends StatefulWidget {
  @override
  _AnimalDetailState createState() => _AnimalDetailState();
}

class _AnimalDetailState extends State<AnimalDetail> {
  Animal animal;
  bool isEquino = false;
  @override
  Widget build(BuildContext context) {
    animal = ApplicationSingleton.animal;
    if(animal.specie.contains('Equino')){
      isEquino = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes'),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  _body(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          animal.name, style: TextStyle(fontSize: fontGetValue(36, 40, 30), color: Colors.black),
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
                  _animalField('Data Perda: ', animal.lossDate),
                  _space(),
                  _animalField('Proprietário: ', animal.proprietary),
                  _space(),
                  _animalField('Proprietário Agro: ', animal.agroProprietary),
                  _space(),
                  Row(
                    children: <Widget>[
                      _animalField('Data Compra: ', animal.buyDate),
                      SizedBox(
                        width: 260,
                      ),
                      _animalField('Data Venda: ', animal.saleDate)
                    ],
                  )
                ]
              ),
              ),
            ),
          ),
        isEquino? RaisedButton(
          color: Colors.blue,
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
          child: Text('Genealogia', style: TextStyle(color: Colors.white, fontSize: fontGetValue(24, 26, 22)),),
        ) : _space()
      ],
    );
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
        Text(modField, style: TextStyle(fontSize: fontGetValue(26, 28, 22))),
        Text(value, style: TextStyle(fontSize: fontGetValue(26, 28, 22), fontWeight: FontWeight.bold))
      ],
    );
  }

  _space(){
    return SizedBox(
      height: 30,
    );
  }

  fontGetValue(double value, double max, double min){
    if(value < max && value > min){
      return value;
    } else if(value < min){
      return min;
    } else {
      return max;
    }
  }

}
