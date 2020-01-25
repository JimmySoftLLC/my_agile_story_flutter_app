import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_agile_story_flutter_app/view/video_page.dart';
import 'package:my_agile_story_flutter_app/view/login_in.dart';
import 'package:my_agile_story_flutter_app/view/register_new_developer.dart';

class MyHomePage extends StatefulWidget {
  static const String id ='/MyHomePage';
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            IconButton(
              tooltip: 'Videos',
              icon: Icon(FontAwesomeIcons.video), onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, MyVideoPage.id,(Route<dynamic> route) => false);
                },
            ),
            IconButton(
              tooltip: 'Register new user',
              icon: Icon(FontAwesomeIcons.userPlus), onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, RegistrationScreen.id,(Route<dynamic> route) => false);
                },
            ),
            IconButton(
              tooltip: 'Login',
              icon: Icon(FontAwesomeIcons.signInAlt), onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id,(Route<dynamic> route) => false);
            },
            ),
            
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
    super.deactivate();
  }
}




