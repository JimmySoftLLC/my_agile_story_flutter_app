import 'package:flutter/material.dart';
import '../api_requests.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Choice {
  const Choice({this.title,});
  final String title;
}

List<Choice> choices = <Choice>[
  Choice(title: '1'),
  Choice(title: '2'),
  Choice(title: '3'),
];

class MyLoggedInPage extends StatefulWidget {
  @override
  _MyLoggedInPageState createState() => _MyLoggedInPageState();
}

class _MyLoggedInPageState extends State<MyLoggedInPage> {

  @override
  void initState() {
    print ('init home screen');
    super.initState();
  }

  Choice _selectedChoice = choices[0]; // The app's "state".

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    print ('home screen built');
    //loginDeveloper('flutter@anywhere.com','1234');
    return Scaffold(
      appBar: AppBar(
        title: Text('My Agile Story',style: TextStyle(fontSize: 17,)),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(icon: Icon(FontAwesomeIcons.chartBar), onPressed: () {},),
          IconButton(icon: Icon(FontAwesomeIcons.list), onPressed: () {},),
          IconButton(icon: Icon(FontAwesomeIcons.running), onPressed: () {},),
          IconButton(icon: Icon(FontAwesomeIcons.check), onPressed: () {},),
          IconButton(icon: Icon(FontAwesomeIcons.handsHelping), onPressed: () {},),
          // overflow menu

        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            PopupMenuButton<Choice>(
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return choices.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: Text(choice.title),
                  );
                }).toList();
              },
            ),
            IconButton(icon: Icon(FontAwesomeIcons.projectDiagram), onPressed: () {},),
            IconButton(icon: Icon(FontAwesomeIcons.trash), onPressed: () {},),
            IconButton(icon: Icon(FontAwesomeIcons.edit), onPressed: () {},),
            IconButton(icon: Icon(FontAwesomeIcons.newspaper), onPressed: () {},),
            IconButton(icon: Icon(FontAwesomeIcons.userEdit), onPressed: () {},),
            IconButton(icon: Icon(FontAwesomeIcons.signOutAlt), onPressed: () {Navigator.pushReplacementNamed(context, '/MyHomePage');},),

          ],
        ),
      ),
      body: Center(
          child: Container(
          )
      ),
    );
  }

  @override
  void deactivate() {
    print ('home screen deactivated');
    super.deactivate();
  }
}



//              onPressed: () {
//                Navigator.pushNamed(context, '/first');
//              },
