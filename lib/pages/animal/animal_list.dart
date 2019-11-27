import 'package:FarmControl/model/animal.dart';
import 'package:FarmControl/model/species.dart';
import 'package:FarmControl/pages/animal/animal_presenter.dart';
import 'package:FarmControl/pages/animal/animal_register.dart';
import 'package:FarmControl/pages/proprietary/proprietary_list.dart';
import 'package:FarmControl/utils/Constants.dart';
import 'package:FarmControl/utils/nav.dart';
import 'package:FarmControl/widgets/cards.dart';
import 'package:FarmControl/widgets/empty_container.dart';
import 'package:FarmControl/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

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
      ),
      body: _body(),
      drawer: myDrawer(context),
      floatingActionButton: FloatingActionButton(onPressed: () => _onPressed(context),
        child: Icon(
            Icons.add
        ),
      ),
    );
  }

  _onPressed(BuildContext context){
    Navigator.of(context).pushNamed(Constants.ANIMAL_REGISTER_PAGE);
  }

  _body(){
    if(listIsEmpty == null){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    else if(listIsEmpty){
      return emptyContainer("Nenhum animal encontrado");
    }
    else{
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: ListView.builder(
          itemCount: animals.length,
          itemBuilder: (BuildContext context, int index){
            return GestureDetector(
              child: cardTitleSubtitle(animals[index].name, animals[index].specie),
            );
          },
        ),
      );
    }
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
    setState(() {
      this.animals = animals;
      listIsEmpty = false;
    });
  }

  @override
  void insertFailed() {
    // TODO: implement insertFailed
  }

  @override
  void insertSuccess() {
    // TODO: implement insertSuccess
  }



  @override
  void onError() {
    // TODO: implement onError
  }

  @override
  void returnSpecies(List<Specie> species) {
    // TODO: implement returnSpecie
  }

  @override
  void speciesNotFound() {
    // TODO: implement specieNotFound
  }
}

