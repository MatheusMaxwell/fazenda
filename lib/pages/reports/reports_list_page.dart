import 'dart:html';
import 'dart:js' as js;
import 'package:FarmControl/data/api/AnimalApi.dart';
import 'package:FarmControl/data/api/ProprietaryApi.dart';
import 'package:FarmControl/model/Matrix.dart';
import 'package:FarmControl/model/animal.dart';
import 'package:FarmControl/model/proprietary.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pdf/widgets.dart' as pdfLib;


import '../../utils/ApplicationSingleton.dart';
import '../../widgets/my_drawer.dart';

class ReportsList extends StatefulWidget {
  @override
  _ReportsListState createState() => _ReportsListState();
}

class _ReportsListState extends State<ReportsList> {


  String propValue = "Todos";
  List<DropdownMenuItem<String>> _dropDownProprietaries;
  var _apiAnimal = AnimalApi();
  var _apiProp = ProprietaryApi();
  List<Animal> animals = List<Animal>();
  List<Animal> animalsImmutable = List<Animal>();
  List<Proprietary> proprietaries = List<Proprietary>();
  int matrixRow = 0;
  Matrix matrix = Matrix();
  bool refreshing = true;
  bool isPropAgro = false;

  @override
  void initState() {
    ApplicationSingleton.matrixDocument = List<Matrix>();
    getAnimals();
    getProprietaries();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    if(refreshing){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    else {
      return Scaffold(
        appBar: AppBar(
          title: Text(ApplicationSingleton.reportsTitle),
          centerTitle: true,
          backgroundColor: Colors.blueGrey,
          actions: <Widget>[
            PopupMenuButton<int>(
              icon: Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 1) {
                  _generatePdf(context);
                }
              },
              itemBuilder: (context) =>
              [
                PopupMenuItem(
                  value: 1,
                  child: Text("Visualizar relatório"),
                ),
              ],
            ),
          ],
        ),
        body: _body(),
      );
    }
  }

  getAnimals()async{
    var anims = await _apiAnimal.getAnimals();
    animalsImmutable = anims;
    //List<Animal> ret = List<Animal>();
    // if(!propValue.contains("Todos")){
    //   for(var a in anims){
    //     if(a.agroProprietary.contains(propValue)){
    //       ret.add(a);
    //     }
    //   }
    // }
    // else{
    //   ret = anims;
    // }
    // for(var a in anims){
    //   if(a.lossDate.isNotEmpty || a.saleDate.isNotEmpty){
    //     anims.remove(a);
    //   }
    // }
    setState((){
      animals = anims.where((element) => element.lossDate.isEmpty && element.saleDate.isEmpty).toList();
      refreshing = false;
    });

  }

  getProprietaries()async{
    var props = await _apiProp.getProprietaries();
    setState((){
      proprietaries = props;
    });
  }

  _body(){
    List<String> proprietariesString = new List<String>();
    proprietariesString.add('Todos');
    for(var p in proprietaries){
      proprietariesString.add(p.name);
    }
    _dropDownProprietaries = getDropDownMenuItems(proprietariesString);
    return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Text('Proprietário', style: TextStyle(fontSize: 26),),
                SizedBox(
                  width: 20,
                ),
                DropdownButton(
                  hint: Text('Todos', style: TextStyle(fontSize: 26),),
                  value: propValue,
                  items: _dropDownProprietaries,
                  onChanged: changedDropDownProprietary,
                ),
                Text(" Agro?", style: TextStyle(fontSize: 26)),
                Checkbox(
                  value: isPropAgro,
                  onChanged: (bool value) {
                    setState(() {
                      isPropAgro = value;
                      changedDropDownProprietary(propValue);
                    });
                  },
                ),
              ],
            ),
          ),
          ApplicationSingleton.reportsTitle.contains("Bovinos") ? _listBov() : _listEquine(),
        ],
    );
  }

  _listEquine(){
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        shrinkWrap: false,
        children: <Widget>[
          cardReport("0 - 6 M", getQtdAnimals(true, 0, 6, "Equino"), getQtdAnimals(false, 0, 6, "Equino")),
          SizedBox(
            height: 20,
          ),
          cardReport("> 6 M", getQtdAnimals(true, 6, 1000, "Equino"), getQtdAnimals(false, 6, 1000, "Equino")),
          SizedBox(
            height: 20,
          ),
          cardReport("Total", getQtdAnimals(true, 0, 1000, "Equino"), getQtdAnimals(false, 0, 1000, "Equino")),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  _listBov(){
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        shrinkWrap: false,
        children: <Widget>[
          cardReport("0 - 12 M", getQtdAnimals(true, -1, 13, "Bovino"), getQtdAnimals(false, -1, 13, "Bovino")),
          SizedBox(
            height: 20,
          ),
          cardReport("13 - 24 M", getQtdAnimals(true, 12.99, 25, "Bovino"), getQtdAnimals(false, 12.99, 25, "Bovino")),
          SizedBox(
            height: 20,
          ),
          cardReport("25 - 36 M", getQtdAnimals(true, 24.99, 36, "Bovino"), getQtdAnimals(false, 24.99, 36, "Bovino")),
          SizedBox(
            height: 20,
          ),
          cardReport("> 36 M", getQtdAnimals(true, 35.99, 10000, "Bovino"), getQtdAnimals(false, 35.99, 1000, "Bovino")),
          SizedBox(
            height: 20,
          ),
          cardReport("Total", getQtdAnimals(true, -1, 10000,"Bovino"), getQtdAnimals(false, -1, 1000, "Bovino")),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  int getQtdAnimals(bool isMale, double min, double max, String specie){
    int count = 0;

    for(var anim in animals){
      if(anim.specie.contains(specie)){
        //var month = (DateTime.parse(DateFormat("dd/MM/yyyy").parse(anim.birthDate).toString()).difference(DateTime.now()).inDays)/30;
        var today = Jiffy(DateTime.now());
        var month = Jiffy(anim.birthDate, 'dd/MM/yyyy').diff(today, Units.MONTH);
        month = month * -1;
        if( month > min && month < max){
          if(anim.lossDate.isEmpty && anim.saleDate.isEmpty){
            if(isMale){
              if(anim.sex.contains("Macho")){
                count = count + 1;
              }
            }
            else{
              if(anim.sex.contains("Femea")){
                count = count + 1;
              }
            }
          }
        }
      }
    }
    createMatrix(isMale, count);
    return count;
  }


  createMatrix(bool isMale, int qtd){
    if(isMale) {
      matrix.m = qtd;
    }
    else {
      matrix.f = qtd;
      if(ApplicationSingleton.matrixDocument.length < 5 && animals.isNotEmpty){
        ApplicationSingleton.matrixDocument.add(matrix);
        print("["+matrix.m.toString()+"]["+matrix.f.toString()+"]");
      }
    }
  }


  cardReport(String title, int male, int female){
    return GestureDetector(
      onTap: ()async {
        if(title.contains("0 - 12 M")){
          await _showDialog();
        }
        if(title.contains("13 - 24 M")){
          await _showDialogTwo();
        }
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              color: Colors.blueGrey,
              child: Center(
                child: Text(title, style: TextStyle(color: Colors.white, fontSize: 30),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  if(male != -1) Text("Macho: " + male.toString(), style: TextStyle(fontSize: 28),),
                  Text("Fêmea: " + female.toString(), style: TextStyle(fontSize: 28),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showDialog() async{
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)
          ),
          contentPadding: EdgeInsets.all(0.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "x ",
                          style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold,)
                        ),
                      ],
                    ),
                  color: Colors.blueGrey,
                  width: double.infinity,
                ),
                onTap: () => Navigator.of(context).pop(),
              ),
              SizedBox(
                height: 10,
              ),
              cardReport("0 - 2 M", -1, getQtdAnimals(false, 0, 2, "Bovino")),
              cardReport("3 - 8 M", -1, getQtdAnimals(false, 3, 8, "Bovino")),
              cardReport("9 - 12 M", -1, getQtdAnimals(false, 9, 12, "Bovino")),
              cardReport("Total", -1, getQtdAnimals(false, 0, 12, "Bovino"))
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDialogTwo() async{
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
          ),
          contentPadding: EdgeInsets.all(0.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                          "x ",
                          style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold,)
                      ),
                    ],
                  ),
                  color: Colors.blueGrey,
                  width: double.infinity,
                ),
                onTap: () => Navigator.of(context).pop(),
              ),
              SizedBox(
                height: 10,
              ),
              cardReport("13 - 18 M", getQtdAnimals(true, 13, 18, "Bovino"), getQtdAnimals(false, 13, 18, "Bovino")),
              cardReport("19 - 24 M", getQtdAnimals(true, 19, 24, "Bovino"), getQtdAnimals(false, 19, 24, "Bovino")),
              cardReport("Total", getQtdAnimals(true, 13, 24, "Bovino"), getQtdAnimals(false, 13, 24, "Bovino"))
            ],
          ),
        );
      },
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

  void changedDropDownProprietary(String _selectedProp) {
    setState(() {
      propValue = _selectedProp;
      if(_selectedProp == "Todos"){
        animals = animalsImmutable;
      }
      else{
        if(isPropAgro){
          animals = animalsImmutable.where((element) => element.agroProprietary.toLowerCase().contains(_selectedProp.toLowerCase()) && element.lossDate.isEmpty && element.saleDate.isEmpty).toList();
        }
        else{
          animals = animalsImmutable.where((element) => element.proprietary.toLowerCase().contains(_selectedProp.toLowerCase()) && element.lossDate.isEmpty && element.saleDate.isEmpty).toList();
        }
      }
    });
  }

  _generatePdf(context) async {
    final pdfLib.Document pdf = pdfLib.Document();
    var matrixes = ApplicationSingleton.matrixDocument;
    pdf.addPage(
      pdfLib.MultiPage(
        build: (context) => [
          pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
            <String>['0 - 12M', '13 - 24M', '25 - 36M', '> 36M', 'TOTAL'],
            <String>[matrixes[0].m.toString(), matrixes[1].m.toString(), matrixes[2].m.toString(), matrixes[3].m.toString(), matrixes[4].m.toString()],
            <String>[matrixes[0].f.toString(), matrixes[1].f.toString(), matrixes[2].f.toString(), matrixes[3].f.toString(), matrixes[4].f.toString()]
          ]),
        ],
      ),
    );

    /*final String path = 'document.pdf';
    final File file = File(pdf.document.page(0).contents[0].buf.output(), path);
    _uploadFile(file);*/
  }

  _uploadFile(File file) async {
    StorageReference storageRef = storage().refFromURL('gs://farmcontrol-2069e.appspot.com').child('reports/'+DateTime.now().toString()+".pdf");
    UploadTask uploadTask = storageRef.put(file);
    var uploadedFileURL = await(await uploadTask.future).ref.getDownloadURL();
    js.context.callMethod("open", [uploadedFileURL.toString()]);
  }

}
