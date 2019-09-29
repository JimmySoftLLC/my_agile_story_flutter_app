import 'package:flutter/material.dart';
import '../api_requests.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    print ('init home screen');
    super.initState();
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
            // overflow menu
          ],
        ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon: Icon(FontAwesomeIcons.video), onPressed: () {Navigator.pushReplacementNamed(context, '/MyVideoPage');},),
            IconButton(icon: Icon(FontAwesomeIcons.userPlus), onPressed: () {},),
            IconButton(icon: Icon(FontAwesomeIcons.signInAlt), onPressed: () {Navigator.pushReplacementNamed(context, '/MyLoggedInPage');},),
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




