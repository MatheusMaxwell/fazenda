import 'package:FarmControl/data/api/AnimalApi.dart';
import 'package:FarmControl/data/api/ProprietaryApi.dart';
import 'package:FarmControl/model/animal.dart';
import 'package:FarmControl/model/proprietary.dart';
import 'package:flutter_web/material.dart';
import 'package:flutter_web/rendering.dart';
import 'package:intl/intl.dart';

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
  List<Proprietary> proprietaries = List<Proprietary>();

  @override
  Widget build(BuildContext context){
    getAnimals(propValue);
    return Scaffold(
      appBar: AppBar(
        title: Text(ApplicationSingleton.reportsTitle),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<int>(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
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

  getAnimals(String propValue)async{
    var anims = await _apiAnimal.getAnimals();
    List<Animal> ret = List<Animal>();
    if(!propValue.contains("Todos")){
      for(var a in anims){
        if(a.agroProprietary.contains(propValue)){
          ret.add(a);
        }
      }
    }
    else{
      ret = anims;
    }
    for(var a in ret){
      if(a.lossDate.isNotEmpty || a.saleDate.isNotEmpty){
        ret.remove(a);
      }
    }
    setState((){
      animals = ret;
    });

  }

  getProprietaries()async{
    var props = await _apiProp.getProprietaries();
    setState((){
      proprietaries = props;
    });
  }

  _body(){
    getProprietaries();
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
          cardReport("0 - 6 M", getQtdAnimals(true, -1, 6, "Equino"), getQtdAnimals(false, -1, 6, "Equino")),
          SizedBox(
            height: 20,
          ),
          cardReport("> 6 M", getQtdAnimals(true, 6, 1000, "Equino"), getQtdAnimals(false, 6, 1000, "Equino")),
          SizedBox(
            height: 20,
          ),
          cardReport("Total", getQtdAnimals(true, 0, 1000, "Equino"), getQtdAnimals(true, 0, 1000, "Equino")),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  int getQtdAnimals(bool isMale, int min, int max, String specie){
    int count = 0;

    for(var anim in animals){
      if(anim.specie.contains(specie)){
        var month = (DateTime.parse(DateFormat("dd/MM/yyyy").parse(anim.birthDate).toString()).difference(DateTime.now()).inDays)/30;
        month = month * -1;
        print("Animal: "+anim.name+"Month: "+month.toString());
        if( month > min && month <= max){
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
    return count;
  }

  _listBov(){
    return Expanded(
      child: ListView(
          padding: const EdgeInsets.all(20.0),
          shrinkWrap: false,
          children: <Widget>[
            cardReport("0 - 12 M", getQtdAnimals(true, -1, 12, "Bovino"), getQtdAnimals(false, -1, 12, "Bovino")),
            SizedBox(
              height: 20,
            ),
            cardReport("13 - 24 M", getQtdAnimals(true, 13, 24, "Bovino"), getQtdAnimals(false, 13, 24, "Bovino")),
            SizedBox(
              height: 20,
            ),
            cardReport("25 - 36 M", getQtdAnimals(true, 25, 36, "Bovino"), getQtdAnimals(false, 25, 36, "Bovino")),
            SizedBox(
              height: 20,
            ),
            cardReport("> 36 M", getQtdAnimals(true, 36, 1000, "Bovino"), getQtdAnimals(false, 36, 1000, "Bovino")),
            SizedBox(
              height: 20,
            ),
            cardReport("Total", getQtdAnimals(true, 0, 1000,"Bovino"), getQtdAnimals(false, 0, 1000, "Bovino")),
            SizedBox(
              height: 20,
            ),
          ],
      ),
    );
  }

  cardReport(String title, int male, int female){
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            color: Colors.blue,
            child: Center(
              child: Text(title, style: TextStyle(color: Colors.white, fontSize: 30),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text("Macho: " + male.toString(), style: TextStyle(fontSize: 28),),
                  Text("Fêmea: " + female.toString(), style: TextStyle(fontSize: 28),)
                ],
              ),
              onTap: ()async {
                if(title.contains("0 - 12")){
                  await _showPopupMenu();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future<String> _showPopupMenu() async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    return await showMenu(
      context: context,
      position: RelativeRect.fill,
      items: [
        PopupMenuItem(
          child: Text("Editar"),
          value: 'edit',
        ),
        PopupMenuItem(
          child: Text("Deletar"),
          value: 'delete',
        ),
      ],
      elevation: 8.0,
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
    });
  }
}
