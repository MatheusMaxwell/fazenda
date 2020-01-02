import 'package:flutter_web/material.dart';
import 'package:flutter_web/rendering.dart';
import '../../utils/ApplicationSingleton.dart';
import '../../widgets/my_drawer.dart';

class ReportsList extends StatefulWidget {
  @override
  _ReportsListState createState() => _ReportsListState();
}


class _ReportsListState extends State<ReportsList> {

  String propValue;
  List<DropdownMenuItem<String>> _dropDownProprietaries;

  @override
  Widget build(BuildContext context) {

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

  _body(){
    List<String> proprietariesString = new List<String>();
    proprietariesString.add('Todos');
    proprietariesString.add('Antenor');

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
          _list(),
        ],
    );
  }

  _list(){
    return Expanded(
      child: ListView(
          padding: const EdgeInsets.all(20.0),
          shrinkWrap: false,
          children: <Widget>[
            cardReport("0 - 12 M", 15, 15),
            SizedBox(
              height: 20,
            ),
            cardReport("13 - 24 M", 10, 19),
            SizedBox(
              height: 20,
            ),
            cardReport("25 - 36 M", 0, 7),
            SizedBox(
              height: 20,
            ),
            cardReport("> 36 M", 0, 36),
            SizedBox(
              height: 20,
            ),
            cardReport("Total", 25, 77),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("Macho: " + male.toString(), style: TextStyle(fontSize: 28),),
                Text("Fêmea: " + female.toString(), style: TextStyle(fontSize: 28),)
              ],
            ),
          )
        ],
      ),
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
