import 'package:FarmControl/utils/ApplicationSingleton.dart';
import 'package:FarmControl/utils/nav.dart';
import 'package:FarmControl/widgets/my_drawer.dart';
import 'package:flutter_web/material.dart';

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
      ),
      drawer: myDrawer(context),
      body: _body(context),
    );
  }

  _body(BuildContext context){
    if(ApplicationSingleton.currentUser == null)
      redirectLogin(context);
  }
}
