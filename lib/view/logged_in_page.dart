import 'package:flutter/material.dart';
import 'package:my_agile_story_flutter_app/controller/api_requests.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_agile_story_flutter_app/controller/user_story.dart';
import 'package:my_agile_story_flutter_app/view/home_page.dart';
import 'package:my_agile_story_flutter_app/view/new_project.dart';
import 'package:my_agile_story_flutter_app/view/edit_user.dart';
import 'package:my_agile_story_flutter_app/controller/project.dart';
import 'package:my_agile_story_flutter_app/view/edit_project.dart';
import 'package:my_agile_story_flutter_app/view/new_user_story.dart';
import 'package:my_agile_story_flutter_app/view/edit_user_story.dart';

String myLastSelectedPhase = '0';
int myLastSelectedProject = -1;
int myLastSelectedUserStory = -1;

class ProjectPopupMenu {
  final String title;
  final int id;
  ProjectPopupMenu({
    this.title,
    this.id
  });
}

void updateProjectChoices (){
  choices = <ProjectPopupMenu>[];
  for (int i = 0; i< myProjects.length; i++) {
    choices.add(new ProjectPopupMenu(title: myProjects[i].name,id: i));
  }
}

List<ProjectPopupMenu> choices = <ProjectPopupMenu>[
];

List<UserStoryCard> updateUserStoryCards (number){
  List<Widget> userStoryCards = <UserStoryCard>[];
  String userStoryBody;
  for (int i = 0; i< myUserStorys.length; i++) {
    if (myLastSelectedPhase == myUserStorys[i].phase) {
      userStoryBody ='As a ' + myUserStorys[i].userRole + ', I want ' + myUserStorys[i].userWant + ' so that ' + myUserStorys[i].userBenefit;
      print(i.toString());
      userStoryCards.add(new UserStoryCard(userStoryTitle: myUserStorys[i].userStoryTitle,userStoryBody: userStoryBody, index: i,));
    }
  }
  return userStoryCards;
}

class MyLoggedInPage extends StatefulWidget {
  static const String id ='/MyLoggedInPage';
  static _MyLoggedInPageState of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<_MyLoggedInPageState>());
  @override
  _MyLoggedInPageState createState() => _MyLoggedInPageState();
}

class _MyLoggedInPageState extends State<MyLoggedInPage> {
  List<Widget> userStoryCards = <UserStoryCard>[];
  ProjectPopupMenu _selectedChoices;

  @override
  void initState() {
    //print ('init logged in screen');
    _selectedChoices = null;
    updateProjectChoices();
    if (myLastSelectedProject > myProjects.length - 1) {
      myLastSelectedProject = myProjects.length - 1;
    }
    if (myLastSelectedProject >= 0 ) {
      print('update user storys');
      _selectedChoices = choices[myLastSelectedProject];
      userStoryCards = updateUserStoryCards(myUserStorys.length);
    }
    super.initState();
  }

  printAccessedFromOutside(){
    print('Dude you got in!');
  }

  void _select(ProjectPopupMenu choice) {
    setState(() {
      _selectedChoices = choice;
      myLastSelectedProject = choice.id;
      print('you selected' + choice.id.toString());
      getUserStorys(myProjects[choice.id],context);
    });
  }

  RichText myRichText(String itemType ,String itemName){
    var text = new RichText(
      text: new TextSpan(
        // Note: Styles for TextSpans must be explicitly defined.
        // Child text spans will inherit styles from parent
        style: new TextStyle(
          fontSize: 14.0,
          color: Colors.black,
        ),
        children: <TextSpan>[
          new TextSpan(text: 'You are about to delete '+ itemType +', ',style: new TextStyle(fontSize: 17)),
          new TextSpan(text: itemName, style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
          new TextSpan(text: '.  This process is irreversable are you sure?',style: new TextStyle(fontSize: 17)),
        ],
      ),
    );
    return text;
  }

  void _deleteWarningPopup(String itemType ,String itemName) {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('Delete Warning !',
              style:  TextStyle(color: Colors.red)),
          content: myRichText(itemType, itemName),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: const Text('DELETE'),
              onPressed: () {
                switch(itemType) {
                  case 'user story': {
                    print('user story delete');
                    deleteUserStory(myLastSelectedUserStory, context);
                  }
                  break;
                  case 'project': {
                    print('project delete');
                    deleteProject(myLastSelectedProject, context);
                    myLastSelectedProject = -1;
                  }
                  break;
                  default: {
                  }
                  break;
                }
              },
            )
          ],
        );
      },
    );
  }

  void _messagePopup(String message) {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(
            'Note',

              ),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: const Text('OK',
                style:  TextStyle(
                  fontSize: 17,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //print ('logged in screen built');
    return Scaffold(
      appBar: AppBar(
        title: Text('My Agile Story',style: TextStyle(fontSize: 17,)),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            tooltip: 'Burn down chart',
            icon: Icon(FontAwesomeIcons.chartBar), onPressed: () {
              //TODO burndown chart
              },
          ),
          IconButton(
            tooltip: 'To do',
            icon: Icon(FontAwesomeIcons.list), onPressed: () {
            myLastSelectedPhase = '0';
            Navigator.pushReplacementNamed(context, MyLoggedInPage.id);
          },
          ),
          IconButton(
            tooltip: 'Sprint',
            icon: Icon(FontAwesomeIcons.running), onPressed: () {
            myLastSelectedPhase = '1';
            Navigator.pushReplacementNamed(context, MyLoggedInPage.id);
          },
          ),
          IconButton(
            tooltip: 'Verify',
            icon: Icon(FontAwesomeIcons.check), onPressed: () {
            myLastSelectedPhase = '2';
            Navigator.pushReplacementNamed(context, MyLoggedInPage.id);
          },
          ),
          IconButton(
            tooltip: 'Done',
            icon: Icon(FontAwesomeIcons.handsHelping), onPressed: () {
            myLastSelectedPhase = '3';
            Navigator.pushReplacementNamed(context, MyLoggedInPage.id);
          },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            PopupMenuButton<ProjectPopupMenu>(
              elevation: 3.2,
              initialValue: _selectedChoices,
              onCanceled: () {
                print('user canceled popup');
              },
              tooltip: 'Projects list',
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return choices.map((ProjectPopupMenu choice) {
                  return PopupMenuItem<ProjectPopupMenu>(
                    value: choice,
                    child: Text(choice.title),
                  );
                }).toList();
              },
            ),
            IconButton(
              tooltip: 'Projects list',
              icon: Icon(FontAwesomeIcons.projectDiagram), onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, NewProject.id,(Route<dynamic> route) => false);
                },),
            IconButton(
              tooltip: 'Delete project',
              icon: Icon(FontAwesomeIcons.trash), onPressed: () {
                  if (myLastSelectedProject != -1) {
                    _deleteWarningPopup('project',myProjects[myLastSelectedProject].name);
                  }else{
                    _messagePopup('No project selected to delete.   Select an existing project under the ... menu first.');
                  }
                },
            ),
            IconButton(
              tooltip: 'Edit project',
              icon: Icon(FontAwesomeIcons.edit), onPressed: () {
              if (myLastSelectedProject != -1) {
                Navigator.pushNamedAndRemoveUntil(context, EditProject.id,(Route<dynamic> route) => false);
              }else{
                _messagePopup('No project selected to edit.   Select an existing project under the ... menu first.');
              }
            },
            ),
            IconButton(
              tooltip: 'New user story',
              icon: Icon(FontAwesomeIcons.newspaper), onPressed: () {
                  if (myLastSelectedProject != -1) {
                    Navigator.pushNamedAndRemoveUntil(context, NewUserStory.id,(Route<dynamic> route) => false);
                  }else{
                    _messagePopup('No project selected to add a user story to.   Create a new project or select an existing project under the ... menu first.');
                  }
                },
            ),
            IconButton(
              tooltip: 'Edit user',
              icon: Icon(FontAwesomeIcons.userEdit), onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, EditUser.id,(Route<dynamic> route) => false);
                },
            ),
            IconButton(
              tooltip: 'Sign out',
              icon: Icon(FontAwesomeIcons.signOutAlt), onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, MyHomePage.id,(Route<dynamic> route) => false);
                },
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: userStoryCards,
      )
    );
  }

  @override
  void deactivate() {
    //print ('logged in  deactivated');
    super.deactivate();
  }
}

editUserStoryPressed(index,context) {
  myLastSelectedUserStory = index;
  Navigator.pushReplacementNamed(context, EditUserStory.id);
}

deleteUserStoryPressed(index,context) {
  myLastSelectedUserStory = index;
  MyLoggedInPage.of(context)._deleteWarningPopup('user story',myUserStorys[index].userStoryTitle);
}

moveUserStoryToNextPhasePressed(index,context) {
  myLastSelectedUserStory = index;
  print("send to sprint " + index.toString());
  int myCurrentPhase = int.parse(myUserStorys[myLastSelectedUserStory].phase);
  if ( myCurrentPhase < 3){
    myCurrentPhase +=1;
    myUserStorys[myLastSelectedUserStory].phase =myCurrentPhase.toString();
  }
  editUserStory(myProjects[myLastSelectedProject], myUserStorys[myLastSelectedUserStory],context);
}

class UserStoryCard extends StatelessWidget {
  UserStoryCard({ @required this.userStoryTitle,@required this.userStoryBody,@required this.index});
  final String userStoryTitle;
  final String userStoryBody;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 60,
            child: Container(
              padding: new EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      userStoryTitle,
                  style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                      userStoryBody),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 60,
            child:  Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    tooltip: 'Edit user story',
                    icon: Icon(FontAwesomeIcons.edit), onPressed: () => editUserStoryPressed(index,context),
                  ),
                  IconButton(
                    tooltip: 'Delete user story',
                    icon: Icon(FontAwesomeIcons.trash), onPressed: () => deleteUserStoryPressed(index,context),
                  ),
                  IconButton(
                    tooltip: 'Send to sprint',
                    icon: Icon(FontAwesomeIcons.running), onPressed: () => moveUserStoryToNextPhasePressed(index,context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      height: 130,
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}