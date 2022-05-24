import 'package:FarmControl/data/api/ProprietaryApi.dart';
import 'package:FarmControl/data/api/SpecieApi.dart';
import 'package:FarmControl/model/animal.dart';
import 'package:FarmControl/model/proprietary.dart';
import 'package:FarmControl/model/species.dart';
import 'package:FarmControl/pages/animal/animal_presenter.dart';
import 'package:FarmControl/utils/ApplicationSingleton.dart';
import 'package:FarmControl/utils/Components.dart';
import 'package:FarmControl/utils/Constants.dart';
import 'package:FarmControl/utils/nav.dart';
import 'package:FarmControl/widgets/cards.dart';
import 'package:FarmControl/widgets/empty_container.dart';
import 'package:FarmControl/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart';


class AnimalList extends StatefulWidget {
  @override
  _AnimalListState createState() => _AnimalListState();
}

class _AnimalListState extends State<AnimalList> implements AnimalContract{
  bool listIsEmpty = null;
  List<Animal> animals;
  List<Specie> species;
  AnimalPresenter presenter;
  List<String> animalsString = new List<String>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  var _tapPosition;
  String fileName = null;
  var _apiSpecie = SpecieApi();
  List<Specie> speciesDrop = List<Specie>();
  List<DropdownMenuItem<String>> _dropDownProprietaries;
  String specieValue = "Todas";
  String searchField = "";
  int totalAnimal = 0;

  _AnimalListState(){
    presenter = AnimalPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    presenter.getAnimals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animais"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: _body(context),
      key: scaffoldKey,
      drawer: myDrawer(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onPressed(context),
        backgroundColor: Colors.blueGrey,
        child: Icon(
            Icons.add
        ),
      ),
    );
  }

  _onPressed(BuildContext context){
    ApplicationSingleton.animal = null;
    Navigator.of(context).pushNamed(Constants.ANIMAL_REGISTER_PAGE).then((val)=>val?presenter.getAnimals():null);
  }

  _body(BuildContext context){
    if(ApplicationSingleton.currentUser == null) {
      redirectLogin(context);
    }
    else {
      if (listIsEmpty == null) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      else if (listIsEmpty) {
        return emptyContainer("Nenhum animal encontrado");
      }
      else {
        _initProprietaries();
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () async{
              listIsEmpty = null;
              await presenter.getAnimals();
            },
            child: Column(
              children: <Widget>[
                _header(),
                Expanded(
                  child: ListView.builder(
                    itemCount: animals.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: cardTitleSubtitle(animals[index].name, animals[index].specie),
                        onTapDown: _storePosition,
                        onTap: (){
                          ApplicationSingleton.animal = animals[index];
                          Navigator.of(context).pushNamed(Constants.ANIMAL_DETAIL_PAGE);
                        },
                        onLongPress: () async{
                          String ret = await _showPopupMenu();
                          if(ret.contains('delete')) {
                            bool response = await alertYesOrNo(context, animals[index].name, "Realmente deseja deletar?");
                            if(response) {
                              fileName = animals[index].fileName;
                              presenter.deleteAnimal(animals[index].id);
                            }
                          }
                          else {
                            ApplicationSingleton.animal = animals[index];
                            Navigator.of(context).pushNamed(Constants.ANIMAL_REGISTER_PAGE).then((val)=>val?presenter.getAnimals():null);
                          }
                        },
                      );
                    },
                  ),
                ),
                Text("Total: $totalAnimal", style: TextStyle(fontSize: 22),)
              ],
            ),
          ),
        );
      }
    }
  }

  _header(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
            children: <Widget>[
              Text('Espécie', style: TextStyle(fontSize: 22),),
              SizedBox(
                width: 20,
              ),
              DropdownButton(
                hint: Text('Todos', style: TextStyle(fontSize: 26),),
                value: specieValue,
                items: _dropDownProprietaries,
                onChanged: changedDropDownSpecie,
              ),
            ],
          ),
        ],
      ),
    );
  }

  searchAnimal(String text) {
    setState(() {
      searchField = text;
      presenter.getAnimals();
    });
  }

  void changedDropDownSpecie(String _selected) {
    setState(() {
      specieValue = _selected;
      presenter.getAnimals();
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

  getSpecies()async{
    var specs = await _apiSpecie.getSpecies();
    setState((){
      speciesDrop = specs;
    });
  }

  deleteFile(String fileName){
    storage().refFromURL('gs://farmcontrol-2069e.appspot.com').child('files/'+fileName).delete();
  }

  Future<String> _showPopupMenu() async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    return await showMenu(
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
      ),
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

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  _initProprietaries(){
    getSpecies();
    List<String> speciesString = new List<String>();
    speciesString.add('Todas');
    for(var p in speciesDrop){
      speciesString.add(p.specie);
    }
    _dropDownProprietaries = getDropDownMenuItems(speciesString);
  }


  @override
  void animalsIsEmpty() {
    setState(() {
      this.animals = List<Animal>();
      listIsEmpty = true;
    });
  }

  @override
  void listAnimals(List<Animal> animals) {
    List<Animal> anims = List<Animal>();
    if(searchField.isNotEmpty){
      for(var a in animals){
        if(a.name.toUpperCase().contains(searchField.toUpperCase())){
          anims.add(a);
        }
      }
    }
    else if(!specieValue.contains("Todas")){
      for(var a in animals){
        if(a.specie.contains(specieValue)){
          anims.add(a);
        }
      }
    }
    else{
      anims = animals;
    }
    setState(() {
      this.animals = anims;
      totalAnimal = anims.length;
      listIsEmpty = false;
    });
  }

  @override
  void insertFailed() {
    showSnackBar("Não foi possível inserir o animal. Tente novamente.", scaffoldKey);
  }
  @override
  void insertSuccess() {
    showSnackBar("Animal inserido", scaffoldKey);
    listIsEmpty = null;
    presenter.getAnimals();
  }

  @override
  void onError() {
    showSnackBar("Algo de errado aconteceu. Por favor, tente novamente.", scaffoldKey);
  }

  @override
  void deleteAnimalFailed() {
    showSnackBar("Não foi possível deletar o animal. Tente novamente.", scaffoldKey);
  }

  @override
  void deleteAnimalSuccess() {
    if(fileName != null && fileName.isNotEmpty){
      deleteFile(fileName);
    }
    showSnackBar("Animal deletado.", scaffoldKey);
    listIsEmpty = null;
    presenter.getAnimals();
  }

  @override
  void returnSpecies(List<Specie> species) {}
  @override
  void speciesNotFound() {}
  @override
  void proprietaryNotFound() {}
  @override
  void returnProprietaries(List<Proprietary> proprietaries) {}
  @override
  void updateFailed() {}
  @override
  void updateSuccess() {}


}

