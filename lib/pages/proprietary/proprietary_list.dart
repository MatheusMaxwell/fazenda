import 'package:FarmControl/model/proprietary.dart';
import 'package:FarmControl/pages/animal/animal_list.dart';
import 'package:FarmControl/pages/animal/animal_register.dart';
import 'package:FarmControl/pages/proprietary/proprietary_presenter.dart';
import 'package:FarmControl/utils/Components.dart';
import 'package:FarmControl/utils/nav.dart';
import 'package:FarmControl/widgets/cards.dart';
import 'package:FarmControl/widgets/empty_container.dart';
import 'package:FarmControl/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class ProprietaryList extends StatefulWidget {
  @override
  _ProprietaryListState createState() => _ProprietaryListState();
}

class _ProprietaryListState extends State<ProprietaryList> implements ProprietaryContract {

  bool listIsEmpty = null;
  List<Proprietary> proprietaries;
  Proprietary newProp;
  ProprietaryPresenter presenter;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  _ProprietaryListState(){
    presenter = ProprietaryPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    presenter.getProprietaries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Proprietários"),
        centerTitle: true,
      ),
      body: _body(),
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          newProp = await _showDialog(context);
          if(newProp != null){
            setState(() {
              listIsEmpty = null;
            });
            presenter.addProprietary(newProp);
          }
        },
        child: Icon(
            Icons.add
        ),
      ),
    );
  }

  Future<Proprietary> _showDialog(BuildContext context) async {
    Proprietary prop = new Proprietary();

    return showDialog<Proprietary>(
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
                  prop.name = value;
                },
                autofocus: true,
              ),
              new TextField(
                decoration: new InputDecoration(
                    hintText: 'Marca'
                ),
                onChanged: (value) {
                  prop.mark = value ;
                },
                autofocus: true,
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(prop);
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
      return emptyContainer("Nenhum proprietário encontrado");
    }
    else{
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: ListView.builder(
          itemCount: proprietaries.length,
          itemBuilder: (BuildContext context, int index){
            return GestureDetector(
              child: cardTitleSubtitle(proprietaries[index].name, proprietaries[index].mark),
            );
          },
        ),
      );
    }
  }

  @override
  void listProprietaries(List<Proprietary> proprietaries) {
    setState(() {
      this.proprietaries = proprietaries;
      listIsEmpty = false;
    });
  }

  @override
  void proprietariesIsEmpty() {
    setState(() {
      this.proprietaries = List<Proprietary>();
      listIsEmpty = true;
    });
  }

  @override
  void onError() {
    setState(() {
      listIsEmpty = true;
    });
    alertOk(context, "Alerta", "Ocorreu um erro. Por favor, tente novamente.");
  }

  @override
  void insertFailed() {
    showSnackBar("Ocorreu um erro ao tentar inserir.", scaffoldKey);
  }

  @override
  void insertSuccess() {
    showSnackBar("Proprietario adicionado!", scaffoldKey);
    presenter.getProprietaries();
  }




}
