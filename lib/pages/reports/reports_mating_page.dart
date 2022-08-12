import 'package:flutter/material.dart';

import '../../data/api/AnimalApi.dart';
import '../../data/api/SpecieApi.dart';
import '../../model/animal.dart';
import '../../model/species.dart';
import '../../utils/ApplicationSingleton.dart';
import '../../utils/Constants.dart';
import '../../widgets/my_drawer.dart';

class MatingReports extends StatefulWidget {
  const MatingReports({Key key}) : super(key: key);

  @override
  State<MatingReports> createState() => _MatingReportsState();
}

class _MatingReportsState extends State<MatingReports> {

  var _apiAnimal = AnimalApi();
  var _apiSpecie = SpecieApi();
  List<Animal> animals = List<Animal>();
  List<Animal> animalsImmutable = List<Animal>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String specieValue = "Todas";
  List<DropdownMenuItem<String>> _dropDownSpecies;
  List<Specie> speciesDrop = List<Specie>();

  @override
  void initState() {
    super.initState();
    _getAnimals();
    getSpecies();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animais"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: _body(),
      key: scaffoldKey,
    );
  }

  _body(){
    return Column(
      children: <Widget>[
        _header(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: animals.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: _animalCard(animals[index]),
                  onTap: (){
                    ApplicationSingleton.animal = animals[index];
                    Navigator.of(context).pushNamed(Constants.ANIMAL_DETAIL_PAGE);
                  },
                );
              },
            ),
          ),
        ),
        Text("Total: ${animals.length ?? 0}", style: TextStyle(fontSize: 22),)
      ],
    );
  }

  _header(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: Column(
        children: <Widget>[
          TextField(
              textInputAction: TextInputAction.done,
              onChanged: searchAnimal,
              decoration: InputDecoration(
                hintText: "Busca",
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                prefixIcon: Icon(Icons.search),
              )
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text('Espécie', style: TextStyle(fontSize: 22),),
              SizedBox(
                width: 20,
              ),
              DropdownButton(
                hint: Text('Todos', style: TextStyle(fontSize: 26),),
                value: specieValue,
                items: _dropDownSpecies,
                onChanged: changedDropDownSpecie,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void changedDropDownSpecie(String _selected) {
    setState(() {
      specieValue = _selected;
      animals = _selected == "Todas" ? animalsImmutable : animalsImmutable.where((element) => element.specie.toLowerCase().contains(_selected.toLowerCase())).toList();
    });
  }

  searchAnimal(String text){
    setState((){
      animals = text.isNotEmpty ? animalsImmutable.where((element) => element.name.toLowerCase().contains(text.toLowerCase())).toList() : animalsImmutable;
    });
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

  getSpecies() async {
    var specs = List<Specie>();
    List<String> speciesString = new List<String>();
    speciesString.add('Todas');

    if(speciesDrop == null || speciesDrop.isEmpty){
      specs = await _apiSpecie.getSpecies();
    }
    else{
      specs = speciesDrop;
    }
    for(var p in specs){
      speciesString.add(p.specie);
    }
    setState((){
      _dropDownSpecies = getDropDownMenuItems(speciesString);
    });
  }

  Widget _animalCard(Animal animal) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0)
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Text(animal.name,
                  style: TextStyle(fontSize: 26, color: Colors.black),),
                Text("  "),
                Text(animal.specie,
                  style: TextStyle(fontSize: 22, color: Colors.grey),),
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text("Previsão de parto: "+animal.matingDate,
                  style: TextStyle(fontSize: 22, color: Colors.grey),),
                if(animal.matingBy.isNotEmpty) Text("Cobrição por: "+animal.matingBy,
                  style: TextStyle(fontSize: 22, color: Colors.grey),),
              ],
            ),
          ],
        ),
      ),
    );
  }


  _getAnimals() async {
    var anims = await _apiAnimal.getAnimals();
    var animsMatingDate = anims.where((element) => element.matingDate.isNotEmpty).toList();
    animalsImmutable = animsMatingDate;
    setState((){
      animals = animsMatingDate;
    });
  }
}
