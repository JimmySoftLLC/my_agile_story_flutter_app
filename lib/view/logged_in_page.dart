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
  for (int i = 0; i< myUserStorys.length; i++) {
    if (myLastSelectedPhase == myUserStorys[i].phase) {
      print(i.toString());
      userStoryCards.add(new UserStoryCard(label: myUserStorys[i].userStoryTitle, index: i,));
    }
  }
  return userStoryCards;
}

class MyLoggedInPage extends StatefulWidget {
  static const String id ='/MyLoggedInPage';
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

  void _select(ProjectPopupMenu choice) {
    setState(() {
      _selectedChoices = choice;
      myLastSelectedProject = choice.id;
      print('you selected' + choice.id.toString());
      getUserStorys(myProjects[choice.id],context);
    });
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
          // overflow menu

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
              icon: Icon(FontAwesomeIcons.projectDiagram), onPressed: () {Navigator.pushReplacementNamed(context, NewProject.id);},),
            IconButton(
              tooltip: 'Delete project',
              icon: Icon(FontAwesomeIcons.trash), onPressed: () {},
            ),
            IconButton(
              tooltip: 'Edit project',
              icon: Icon(FontAwesomeIcons.edit), onPressed: () {
              {Navigator.pushReplacementNamed(context, EditProject.id);}
            },
            ),
            IconButton(
              tooltip: 'New user story',
              icon: Icon(FontAwesomeIcons.newspaper), onPressed: () {Navigator.pushReplacementNamed(context, NewUserStory.id);},
            ),
            IconButton(
              tooltip: 'Edit user',
              icon: Icon(FontAwesomeIcons.userEdit), onPressed: () {Navigator.pushReplacementNamed(context, EditUser.id);},
            ),
            IconButton(
              tooltip: 'Sign out',
              icon: Icon(FontAwesomeIcons.signOutAlt), onPressed: () {Navigator.pushReplacementNamed(context, MyHomePage.id);},
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

editUserStory2(index,context) {
  myLastSelectedUserStory = index;
  print("edit user story " + myLastSelectedUserStory.toString());
  Navigator.pushReplacementNamed(context, EditUserStory.id);
}

deleteUserStory(index,context) {
  print("delete user story " + index.toString());
}

moveUserStoryToSprint(index,context) {
  print("send to sprint " + index.toString());
}

class UserStoryCard extends StatelessWidget {
  UserStoryCard({ @required this.label,@required this.index});
  final String label;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Text(
              '   ' + label),
          IconButton(
            tooltip: 'Edit user story',
            icon: Icon(FontAwesomeIcons.edit), onPressed: () => editUserStory2(index,context),
          ),
          IconButton(
            tooltip: 'Delete user story',
            icon: Icon(FontAwesomeIcons.trash), onPressed: () => deleteUserStory(index,context),
          ),
          IconButton(
            tooltip: 'Send to sprint',
            icon: Icon(FontAwesomeIcons.running), onPressed: () => moveUserStoryToSprint(index,context),
          ),
        ],
      ),
      height: 100,
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}