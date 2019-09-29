import 'package:flutter/material.dart';
import 'package:my_agile_story_flutter_app/screens/home_page.dart';
import 'package:my_agile_story_flutter_app/screens/logged_in_page.dart';
import 'package:my_agile_story_flutter_app/screens/video_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:MyHomePage(),
        routes: {
          '/MyLoggedInPage' : (context) => MyLoggedInPage(),
          '/MyHomePage' : (context) => MyHomePage(),
          '/MyVideoPage' : (context) => MyVideoPage(),
        }
    );
  }
}