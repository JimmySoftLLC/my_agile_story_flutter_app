import 'package:flutter/material.dart';
import 'package:my_agile_story_flutter_app/view/home_page.dart';
import 'package:my_agile_story_flutter_app/view/logged_in_page.dart';
import 'package:my_agile_story_flutter_app/view/video_page.dart';
import 'package:my_agile_story_flutter_app/view/login_in.dart';
import 'package:my_agile_story_flutter_app/view/register_new_developer.dart';
import 'package:my_agile_story_flutter_app/controller/api_requests.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_agile_story_flutter_app/controller/developer.dart';

class EditUser extends StatefulWidget {
  static const String id ='/EditUser';
  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  String myText = '';

  void validateEntries(context) {
    if (1==2) {
      setState(() {
        myText = 'No entries please enter email and password.';
      });
    }else{
      setState(() {
        myText = 'Registering user please wait.';
      });
      editDeveloper(myDeveloper,context);
    }
  }

  var txt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User',style: TextStyle(fontSize: 17,)),
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
            IconButton(icon: Icon(FontAwesomeIcons.angleLeft), onPressed: () {Navigator.pushReplacementNamed(context, MyLoggedInPage.id);},),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
              child: Text(
                myDeveloper.email,
                 style: TextStyle(
                   color: Colors.black38,
                 )
              ),
              decoration: myBoxDecoration(),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              controller: TextEditingController()..text = myDeveloper.password,
              onChanged: (value) {
                myDeveloper.password = value;
              },
              decoration: InputDecoration(
                hintText: 'password',
                contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 20,
                  child: TextField(
                    controller: TextEditingController()..text = myDeveloper.firstName,
                    onChanged: (value) {
                      myDeveloper.firstName = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'first name',
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex:1,
                  child: SizedBox(
                    height: 24.0,
                  ),
                ),
                Expanded(
                  flex: 20,
                  child: TextField(
                    controller: TextEditingController()..text = myDeveloper.lastName,
                    onChanged: (value) {
                      myDeveloper.lastName = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'last name',
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 24.0,
            ),
            TextField(
              maxLines: 2,
              controller: TextEditingController()..text = myDeveloper.bio,
              onChanged: (value) {
                myDeveloper.bio = value;
              },
              decoration: InputDecoration(
                hintText: 'Tell us about yourself',
                contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () {
                    validateEntries(context);
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Register',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              myText,
            ),
          ],
        ),
      ),
    );
  }
}

BoxDecoration myBoxDecoration() {
  return BoxDecoration(
    border: Border.all(
      width: 1.0,
      color: Colors.lightBlueAccent,
    ),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  );
}