import 'package:flutter/material.dart';
import 'package:my_agile_story_flutter_app/controller/api_requests.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_agile_story_flutter_app/view/home_page.dart';
import 'package:my_agile_story_flutter_app/view/logged_in_page.dart';
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
    //print ('init home screen');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print ('home screen built');
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
            IconButton(icon: Icon(FontAwesomeIcons.video), onPressed: () {Navigator.pushReplacementNamed(context, MyVideoPage.id);},),
            IconButton(icon: Icon(FontAwesomeIcons.userPlus), onPressed: () {Navigator.pushReplacementNamed(context, RegistrationScreen.id);},),
            IconButton(icon: Icon(FontAwesomeIcons.signInAlt), onPressed: () {Navigator.pushReplacementNamed(context, LoginScreen.id);},),
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
    //print ('home screen deactivated');
    super.deactivate();
  }
}




