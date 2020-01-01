import 'package:FarmControl/model/species.dart';
import 'package:FarmControl/pages/animal/animal_list.dart';
import 'package:FarmControl/pages/animal/animal_register.dart';
import 'package:FarmControl/pages/species/specie_presenter.dart';
import 'package:FarmControl/utils/ApplicationSingleton.dart';
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
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  var _tapPosition;
  bool isUpdate = false;

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
      body: _body(context),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          isUpdate = false;
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
    Specie specie;
    var textController = TextEditingController();
    if(isUpdate){
      specie = ApplicationSingleton.specie;
      textController.text = specie.specie;
    }
    else{
      specie = new Specie();
    }
    return showDialog<Specie>(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Espécie'),
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
                controller: textController,
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

  _body(BuildContext context) {
    if(ApplicationSingleton.currentUser == null){
      redirectLogin(context);
    }
    else {
      if (listIsEmpty == null) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      else if (listIsEmpty) {
        return emptyContainer("Nenhuma espécie encontrada");
      }
      else {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () async{
              listIsEmpty = null;
              await presenter.getSpecies();
            },
            child: ListView.builder(
              itemCount: species.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: cardSingleText(species[index].specie),
                  onTapDown: _storePosition,
                  onLongPress: () async{
                    String ret = await _showPopupMenu();
                    if(ret.contains('delete')) {
                      if (await alertYesOrNo(context, species[index].specie, "Realmente deseja deletar?")) {
                        presenter.deleteSpecie(species[index]);
                      }
                    }
                    else {
                      isUpdate = true;
                      ApplicationSingleton.specie = species[index];
                      newSpecie = await _showDialog(context);
                      if(newSpecie != null){
                        setState(() {
                          listIsEmpty = null;
                        });
                        presenter.addSpecie(newSpecie);
                      }
                    }
                  },
                );
              },
            ),
          ),
        );
      }
    }
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

  @override
  void specieInUse() {
    alertOk(context, "Erro ao deletar", "Espécie já associada a algum animal.");
  }

  @override
  void updateFailed() {
    showSnackBar("Erro ao atualizar a espécie. Tente novamente.", scaffoldKey);
  }

  @override
  void updateSuccess() {
    showSnackBar("Especie atualizada!", scaffoldKey);
    presenter.getSpecies();
  }


}
