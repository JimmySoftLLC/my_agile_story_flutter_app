import 'package:flutter/material.dart';
import 'package:my_agile_story_flutter_app/controller/developer.dart';
import 'package:my_agile_story_flutter_app/view/logged_in_page.dart';
import 'package:my_agile_story_flutter_app/controller/project_api.dart';
import 'package:my_agile_story_flutter_app/controller/project.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewProject extends StatefulWidget {
  static const String id ='/NewProject';
  @override
  _NewProjectState createState() => _NewProjectState();
}

class _NewProjectState extends State<NewProject> {
  String myText = '';
  String name = '';
  String description = '';

  void validateEntries() {
    if (name == '' ) {
      setState(() {
        myText = 'Project must have a name.';
      });
    }else{
      setState(() {
        myText = 'Creating project user please wait.';
      });
      myLastSelectedProject = -1;
      Project myProject = new Project(
          'NoID',
          name,
          description,);
          createNewProject(myDeveloper,myProject,context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Project',style: TextStyle(fontSize: 17,)),
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
                  Navigator.pushNamedAndRemoveUntil(context, MyLoggedInPage.id,(Route<dynamic> route) => false);
                },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 24.0,
              ),
              TextField(
                //controller: TextEditingController()..text = '',
                onChanged: (value) {
                  name = value;
                },
                decoration: InputDecoration(
                  hintText: 'Project name',
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
              TextField(
                maxLines: 4,
                //controller: TextEditingController()..text = '',
                onChanged: (value) {
                  description = value;
                },
                decoration: InputDecoration(
                  hintText: 'Describe the project',
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
                      validateEntries();
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Create',
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
              SizedBox(
                height: 24.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}