import 'package:FarmControl/model/proprietary.dart';
import 'package:FarmControl/pages/animal/animal_list.dart';
import 'package:FarmControl/pages/animal/animal_register.dart';
import 'package:FarmControl/pages/proprietary/proprietary_presenter.dart';
import 'package:FarmControl/utils/ApplicationSingleton.dart';
import 'package:FarmControl/utils/Components.dart';
import 'package:FarmControl/utils/Constants.dart';
import 'package:FarmControl/utils/nav.dart';
import 'package:FarmControl/widgets/cards.dart';
import 'package:FarmControl/widgets/empty_container.dart';
import 'package:FarmControl/widgets/my_drawer.dart';
import 'package:flutter_web/material.dart';



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
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  bool showButtons = false;
  var _tapPosition;
  bool isUpdate = false;
  int flagOldProp = 0;

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
      body: _body(context),
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          isUpdate = false;
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
    Proprietary prop;
    var nameController = TextEditingController();
    var markController = TextEditingController();
    if(isUpdate){
      prop = ApplicationSingleton.proprietary;
      nameController.text = prop.name;
      markController.text = prop.mark;
    }
    else{
      prop = new Proprietary();
    }
    return showDialog<Proprietary>(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Proprietário'),
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
                controller: nameController,
                autofocus: true,
              ),
              new TextField(
                decoration: new InputDecoration(
                    hintText: 'Marca'
                ),
                onChanged: (value) {
                  prop.mark = value ;
                },
                controller: markController,
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
        return emptyContainer("Nenhum proprietário encontrado");
      }
      else {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () async{
              listIsEmpty = null;
              await presenter.getProprietaries();
            },
            child: ListView.builder(
              itemCount: proprietaries.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: cardTitleSubtitle(
                      proprietaries[index].name, proprietaries[index].mark),
                  onTapDown: _storePosition,
                  onLongPress: () async{
                    String ret = await _showPopupMenu();
                    if(ret.contains('delete')) {
                      if (await alertYesOrNo(context, proprietaries[index].name,
                          "Realmente deseja deletar?")) {
                        presenter.deleteProprietary(proprietaries[index]);
                      }
                    }
                    else{
                        ApplicationSingleton.proprietary = proprietaries[index];
                        isUpdate = true;
                        newProp = await _showDialog(context);
                        if(newProp != null){
                          setState(() {
                            listIsEmpty = null;
                          });
                          presenter.updateProprietary(newProp);
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

  @override
  void removeFailed() {
    showSnackBar("Ocorreu um erro ao tentar remover o proprietário.", scaffoldKey);
  }

  @override
  void removeSuccess() {
    showSnackBar("Proprietário removido!", scaffoldKey);
    presenter.getProprietaries();
  }

  @override
  void proprietaryInUse() {
    alertOk(context, "Erro ao deletar", "Proprietário está associado a algum animal.");
  }

  @override
  void updateFailed() {
    showSnackBar("Erro ao tentar atualizar o proprietário. Tente novamente.", scaffoldKey);
  }

  @override
  void updateSuccess() {
    showSnackBar("Proprietário atualizado!", scaffoldKey);
    presenter.getProprietaries();
  }




}
