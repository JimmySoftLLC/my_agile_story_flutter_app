import 'package:flutter/material.dart';
import 'package:my_agile_story_flutter_app/controller/project.dart';
import 'package:my_agile_story_flutter_app/view/logged_in_page.dart';
import 'package:my_agile_story_flutter_app/controller/user_story_api.dart';
import 'package:my_agile_story_flutter_app/controller/user_story.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class EditUserStory extends StatefulWidget {
  static const String id ='/EditUserStory';
  @override
  _EditUserStoryState createState() => _EditUserStoryState();
}

class _EditUserStoryState extends State<EditUserStory> {
  String myText = '';
  double myRadius = 14.0;
  int myRadioValue = int.parse(myUserStorys[myLastSelectedUserStory].phase);

  void validateEntries() {
    setState(() {
      myText = 'Saving user story user please wait.';
    });
    if (myLastSelectedProject >= 0 && myLastSelectedProject < myProjects.length){
      if (myLastSelectedUserStory >= 0 && myLastSelectedUserStory < myUserStorys.length){
        editUserStory(myProjects[myLastSelectedProject], myUserStorys[myLastSelectedUserStory],context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User Story',style: TextStyle(fontSize: 17,)),
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
                controller: TextEditingController()..text = myUserStorys[myLastSelectedUserStory].userStoryTitle,
                onChanged: (value) {
                  myUserStorys[myLastSelectedUserStory].userStoryTitle = value;
                },
                decoration: InputDecoration(
                  hintText: 'User Story title',
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Text(
                      'As a',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: TextField(
                      controller: TextEditingController()..text = myUserStorys[myLastSelectedUserStory].userRole,
                      onChanged: (value) {
                        myUserStorys[myLastSelectedUserStory].userRole = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'role',
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Text(
                      ', I want',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: TextField(
                      controller: TextEditingController()..text = myUserStorys[myLastSelectedUserStory].userWant,
                      onChanged: (value) {
                        myUserStorys[myLastSelectedUserStory].userWant = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'goal',
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Text(
                      'so that',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: TextField(
                      controller: TextEditingController()..text = myUserStorys[myLastSelectedUserStory].userBenefit,
                      onChanged: (value) {
                        myUserStorys[myLastSelectedUserStory].userBenefit = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'reason',
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                maxLines: 4,
                controller: TextEditingController()..text = myUserStorys[myLastSelectedUserStory].acceptanceCriteria,
                onChanged: (value) {
                  myUserStorys[myLastSelectedUserStory].acceptanceCriteria = value;
                },
                decoration: InputDecoration(
                  hintText: 'Acceptance criteria',
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                maxLines: 4,
                controller: TextEditingController()..text = myUserStorys[myLastSelectedUserStory].conversation,
                onChanged: (value) {
                  myUserStorys[myLastSelectedUserStory].conversation = value;
                },
                decoration: InputDecoration(
                  hintText: 'Conversation',
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 10,
                    child: Text(
                      'Estimate',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 13,
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(),
                      controller: TextEditingController()..text = myUserStorys[myLastSelectedUserStory].estimate.toString(),
                      onChanged: (value) {
                        myUserStorys[myLastSelectedUserStory].estimate  = int.parse(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'points',
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Text(
                      'Complete',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 13,
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(),
                      controller: TextEditingController()..text = myUserStorys[myLastSelectedUserStory].percentDone.toString(),
                      onChanged: (value) {
                        myUserStorys[myLastSelectedUserStory].percentDone  = int.parse(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'percent',
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 6.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 10,
                    child: Text(
                      'Priority',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 13,
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(),
                      controller: TextEditingController()..text = myUserStorys[myLastSelectedUserStory].priority.toString(),
                      onChanged: (value) {
                        myUserStorys[myLastSelectedUserStory].priority  = int.parse(value);
                      },
                      decoration: InputDecoration(
                        hintText: '1-10',
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Text(
                      'Sprint',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 13,
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(),
                      controller: TextEditingController()..text = myUserStorys[myLastSelectedUserStory].sprint.toString(),
                      onChanged: (value) {
                        myUserStorys[myLastSelectedUserStory].sprint  = int.parse(value);
                      },
                      decoration: InputDecoration(
                        hintText: '1,2,3...',
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(myRadius)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ListTile(
                title: const Text('To Do'),
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                leading: Radio(
                  value: 0,
                  groupValue: myRadioValue,
                  onChanged: (value) {
                    myUserStorys[myLastSelectedUserStory].phase = '0';
                    setState(() { myRadioValue = value; });
                  },
                ),
              ),
              ListTile(
                title: const Text('Doing'),
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                leading: Radio(
                  value: 1,
                  groupValue: myRadioValue,
                  onChanged: (value) {
                    myUserStorys[myLastSelectedUserStory].phase = '1';
                    setState(() { myRadioValue = value; });
                  },
                ),
              ),
              ListTile(
                title: const Text('Verify') ,
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                leading: Radio(
                  value: 2,
                  groupValue: myRadioValue,
                  onChanged: (value) {
                    myUserStorys[myLastSelectedUserStory].phase = '2';
                    setState(() { myRadioValue = value; });
                  },
                ),
              ),
              ListTile(
                title: const Text('Done'),
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                leading: Radio(
                  value: 3,
                  groupValue: myRadioValue,
                  onChanged: (value) {
                    myUserStorys[myLastSelectedUserStory].phase = '3';
                    setState(() { myRadioValue = value; });
                  },
                ),
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
                      'Save changes',
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