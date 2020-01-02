import 'package:FarmControl/utils/ApplicationSingleton.dart';
import 'package:FarmControl/utils/nav.dart';
import 'package:FarmControl/widgets/my_drawer.dart';
import 'package:flutter_web/material.dart';

import '../proprietary/proprietary_list.dart';
import '../species/species_list.dart';
import 'reports_list_page.dart';

class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Relatórios"),
        centerTitle: true,
      ),
      drawer: myDrawer(context),
      body: _body(context),
    );
  }

  _body(BuildContext context){
    if(ApplicationSingleton.currentUser == null) {
      redirectLogin(context);
    }
    else{
      return Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            listTitle("Bovinos", context, ReportsList()),
            listTitle("Equinos", context, ReportsList()),
          ],
        ),
      );
    }
  }

  listTitle(String title, BuildContext context, Widget page){
    return ListTile(
      leading: Icon(Icons.list),
      title: Text(title),
      trailing: Icon(Icons.arrow_right),
      onTap: (){
        ApplicationSingleton.reportsTitle = title;
        push(context, page);
      },
    );
  }
}
