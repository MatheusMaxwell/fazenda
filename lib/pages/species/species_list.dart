import 'package:FarmControl/model/species.dart';
import 'package:FarmControl/pages/animal/animal_list.dart';
import 'package:FarmControl/pages/animal/animal_register.dart';
import 'package:FarmControl/pages/species/specie_presenter.dart';
import 'package:FarmControl/utils/Components.dart';
import 'package:FarmControl/utils/nav.dart';
import 'package:FarmControl/widgets/cards.dart';
import 'package:FarmControl/widgets/empty_container.dart';
import 'package:FarmControl/widgets/my_drawer.dart';
import 'package:flutter_web/material.dart';

class SpecieList extends StatefulWidget {
  @override
  _SpeciesListState createState() => _SpeciesListState();
}


class _SpeciesListState extends State<SpecieList> implements SpecieContract{
  bool listIsEmpty = null;
  List<Specie> species;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  SpeciePresenter presenter;
  Specie newSpecie;

  _SpeciesListState(){
    presenter = SpeciePresenter(this);
  }

  @override
  void initState() {
    super.initState();
    presenter.getSpecies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Espécies"),
        centerTitle: true,
      ),
      key: scaffoldKey,
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          newSpecie = await _showDialog(context);
          if(newSpecie != null){
            setState(() {
              listIsEmpty = null;
            });
            presenter.addSpecie(newSpecie);
          }
        },
        child: Icon(
            Icons.add
        ),
      ),
    );
  }

  Future<Specie> _showDialog(BuildContext context) async {
    Specie specie = new Specie();

    return showDialog<Specie>(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Informe um nome para a categoria'),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new TextField(
                decoration: new InputDecoration(
                    hintText: 'Nome'
                ),
                onChanged: (value) {
                  specie.specie = value;
                },
                autofocus: true,
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(specie);
              },
            ),
            FlatButton(
              child: Text('Cancelar'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  _body() {
    if(listIsEmpty == null){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    else if(listIsEmpty){
      return emptyContainer("Nenhuma espécie encontrada");
    }
    else{
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: ListView.builder(
          itemCount: species.length,
          itemBuilder: (BuildContext context, int index){
            return Dismissible(
              key: Key(species[index].id),
              background: slideRightBackground(),
              secondaryBackground: slideLeftBackground(),
              child: GestureDetector(
                  child: cardSingleText(species[index].specie)
              ),
              // ignore: missing_return
              confirmDismiss: (direction) async{
                if(direction == DismissDirection.endToStart){
                  if(await dialogDelete(species[index].specie)){
                    presenter.deleteSpecie(species[index].id);
                  }
                }
              },
            );
          },
        ),
      );
    }
  }

  Future<bool> dialogDelete(String specie){
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Realmente deseja excluir $specie ?'),
          actions: <Widget>[
            FlatButton(
              child: Text('SIM'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              child: Text('NÃO'),
              onPressed: (){
                Navigator.of(context).pop(false);
              },
            )
          ],
        );
      },
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Editar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  @override
  void onError() {
    showSnackBar("Ocorreu um erro. Tente novamente.", scaffoldKey);
  }

  @override
  void returnSpecies(List<Specie> species) {
    setState(() {
      this.species = species;
      listIsEmpty = false;
    });
  }

  @override
  void speciesIsEmpty() {
    setState(() {
      this.species = List<Specie>();
      listIsEmpty = true;
    });
  }

  @override
  void insertFailed() {
    alertOk(context, "Alerta", "Ocorreu um erro ao tentar inserir a espécie. Tente novamente.");
  }

  @override
  void insertSuccess() {
    showSnackBar("Espécie inserida!", scaffoldKey);
    presenter.getSpecies();
  }

  @override
  void removeFailed() {
    alertOk(context, "Alerta", "Ocorreu um erro ao tentar remover essa especie. Tente novamente.");
  }

  @override
  void removeSuccess() {
    showSnackBar("Especie removida!", scaffoldKey);
    presenter.getSpecies();
  }


}
