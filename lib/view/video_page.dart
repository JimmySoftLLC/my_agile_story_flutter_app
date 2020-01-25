import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_agile_story_flutter_app/view/home_page.dart';

class MyVideoPage extends StatefulWidget {
  static const String id ='MyVideoPage';
  @override
  _MyVideoPageState createState() => new _MyVideoPageState();
}

class _MyVideoPageState extends State<MyVideoPage> {
  TextEditingController textEditingControllerUrl = new TextEditingController();
  TextEditingController textEditingControllerId = new TextEditingController();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: AppBar(
          title: Text('My Agile Story Videos',style: TextStyle(fontSize: 17,)),
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
                tooltip: 'Go back',
                icon: Icon(FontAwesomeIcons.angleLeft), onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, MyHomePage.id,(Route<dynamic> route) => false);
                  },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding:EdgeInsets.symmetric(vertical: 16.0),
                      width: 300,
                      child: Text("The videos are from the JimmySoft LLC youtube channel.  You can play the entire video or just click the the clip your are interested in.",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                      maxLines: 4,),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () {
                            print('pressesed youtube button');
                          },
                          minWidth: 200.0,
                          height: 42.0,
                          child: Text(
                            'Play Entire Video',
                          ),
                        ),
                      ),
                    ),
                  ],
              )
          ),
        ),
      ),
    );
  }
}