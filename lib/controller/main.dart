import 'package:flutter/material.dart';
import 'package:my_agile_story_flutter_app/view/home_page.dart';
import 'package:my_agile_story_flutter_app/view/logged_in_page.dart';
import 'package:my_agile_story_flutter_app/view/video_page.dart';
import 'package:my_agile_story_flutter_app/view/login_in.dart';
import 'package:my_agile_story_flutter_app/view/register_new_developer.dart';
import 'package:my_agile_story_flutter_app/view/edit_user.dart';
import 'package:my_agile_story_flutter_app/view/new_project.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:MyHomePage(),
        routes: {
          MyLoggedInPage.id : (context) => MyLoggedInPage(),
          MyHomePage.id : (context) => MyHomePage(),
          MyVideoPage.id : (context) => MyVideoPage(),
          LoginScreen.id : (context) => LoginScreen(),
          RegistrationScreen.id : (context) => RegistrationScreen(),
          EditUser.id : (context) => EditUser(),
          NewProject.id : (context) => NewProject(),
        }
    );
  }
}