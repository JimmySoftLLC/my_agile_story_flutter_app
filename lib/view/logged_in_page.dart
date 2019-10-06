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
import 'package:my_agile_story_flutter_app/view/messages.dart';
import 'package:my_agile_story_flutter_app/view/charting_view.dart';
import 'package:my_agile_story_flutter_app/view/user_story_cards.dart';
import 'dart:async';

String myLastSelectedPhase = '0';
int myLastSelectedProject = -1;
int myLastSelectedUserStory = -1;
String chartTitle = '';
Timer dudeTimer;

// runs every 1 second
void StartTimer() {
  dudeTimer = new Timer.periodic(new Duration(seconds: 3), (timer) {
    debugPrint(timer.tick.toString());
  });
}

class MyLoggedInPage extends StatefulWidget {
  static const String id = '/MyLoggedInPage';
  static _MyLoggedInPageState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<_MyLoggedInPageState>());
  @override
  _MyLoggedInPageState createState() => _MyLoggedInPageState();

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}

class _MyLoggedInPageState extends State<MyLoggedInPage> {
  List<Widget> userStoryCardsToDo = <UserStoryCard>[];
  List<Widget> userStoryCardsDoing = <UserStoryCard>[];
  List<Widget> userStoryCardsVerify = <UserStoryCard>[];
  List<Widget> userStoryCardsDone = <UserStoryCard>[];

  ProjectPopupMenu _selectedChoices;

  void _select(ProjectPopupMenu choice) {
    setState(() {
      _selectedChoices = choice;
      myLastSelectedProject = choice.id;
      chartTitle = 'Burndown for: ' + myProjects[myLastSelectedProject].name;
      messagePopupNoDismiss('',Colors.black,'Getting project please wait',context);
      getUserStorys(myProjects[choice.id], context);
    });
  }

  void editUserStoryInContext() {
    Navigator.pushReplacementNamed(context, EditUserStory.id);
  }

  void moveUserStoryToNextPhaseInContext() {
    messagePopupNoDismiss('',Colors.black,'Moving user story to next phase please wait',context);
    editUserStory(myProjects[myLastSelectedProject],
        myUserStorys[myLastSelectedUserStory], context);
  }

  void deleteWarningPopupInContext(String itemType, String itemName, context) {
    deleteWarningPopup( itemType,  itemName, context);
  }

  void changeUserStoryPriorityUsingSliderInContext() {
    messagePopupNoDismiss('',Colors.black,'Reordering user stories please wait',context);
    editUserStory(myProjects[myLastSelectedProject],
        myUserStorys[myLastSelectedUserStory], context);
  }

  @override
  void initState() {
    super.initState();
    _selectedChoices = null;

    updateProjectChoices();

    if (myLastSelectedProject > myProjects.length - 1) {
      myLastSelectedProject = myProjects.length - 1;
    }

    if (myLastSelectedProject >= 0) {
      userStoryCardsToDo = <UserStoryCard>[];
      userStoryCardsDoing = <UserStoryCard>[];
      userStoryCardsVerify = <UserStoryCard>[];
      userStoryCardsDone = <UserStoryCard>[];
      _selectedChoices = choices[myLastSelectedProject];
      userStoryCardsToDo = updateUserStoryCards('0');
      userStoryCardsDoing = updateUserStoryCards('1');
      userStoryCardsVerify = updateUserStoryCards('2');
      userStoryCardsDone = updateUserStoryCards('3');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 5,
        initialIndex: int.parse(myLastSelectedPhase),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            bottom: TabBar(
              onTap: (int index) {
                myLastSelectedPhase = index.toString();
              },

              indicatorColor: Colors.white,
              tabs: [
                Tab(icon: Icon(FontAwesomeIcons.list)),
                Tab(icon: Icon(FontAwesomeIcons.running)),
                Tab(icon: Icon(FontAwesomeIcons.check)),
                Tab(icon: Icon(FontAwesomeIcons.handsHelping)),
                Tab(icon: Icon(FontAwesomeIcons.chartBar)),
              ],
            ),
            title: Text('My Agile Story'),
          ),
          body: TabBarView(children: [
            ListView(
              padding: const EdgeInsets.all(8),
              children: userStoryCardsToDo,
            ),
            ListView(
              padding: const EdgeInsets.all(8),
              children: userStoryCardsDoing,
            ),
            ListView(
              padding: const EdgeInsets.all(8),
              children: userStoryCardsVerify,
            ),
            ListView(
              padding: const EdgeInsets.all(8),
              children: userStoryCardsDone,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        chartTitle,
                        style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold),
                      ),
                      Expanded(child: BurnDownChart.withData())
                    ],
                  ),
                ),
              ),
            ),
          ]),
          bottomNavigationBar: BottomAppBar(
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 30,
                  child: PopupMenuButton<ProjectPopupMenu>(
                    icon: Icon(FontAwesomeIcons.ellipsisV),
                    elevation: 3.2,
                    initialValue: _selectedChoices,
                    onCanceled: () {
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
                ),
                IconButton(
                  tooltip: 'Projects list',
                  icon: Icon(FontAwesomeIcons.projectDiagram),
                  onPressed: () {

                    Navigator.pushNamedAndRemoveUntil(context, NewProject.id,
                        (Route<dynamic> route) => false);
                  },
                ),
                IconButton(
                  tooltip: 'Delete project',
                  icon: Icon(FontAwesomeIcons.trash),
                  onPressed: () {
                    if (myLastSelectedProject != -1) {
                      deleteWarningPopupInContext(
                          'project', myProjects[myLastSelectedProject].name, context);
                    } else {
                      messagePopup('Note',Colors.black,
                          'No project selected to delete.   Select an existing project under the ... menu first.',context);
                    }
                  },
                ),
                IconButton(
                  tooltip: 'Edit project',
                  icon: Icon(FontAwesomeIcons.edit),
                  onPressed: () {
                    if (myLastSelectedProject != -1) {
                      Navigator.pushNamedAndRemoveUntil(context, EditProject.id,
                          (Route<dynamic> route) => false);
                    } else {
                      messagePopup('Note',Colors.black,
                          'No project selected to edit.   Select an existing project under the ... menu first.',context);
                    }
                  },
                ),
                IconButton(
                  tooltip: 'New user story',
                  icon: Icon(FontAwesomeIcons.newspaper),
                  onPressed: () {
                    if (myLastSelectedProject != -1) {
                      Navigator.pushNamedAndRemoveUntil(context,
                          NewUserStory.id, (Route<dynamic> route) => false);
                    } else {
                      messagePopup('Note',Colors.black,
                          'No project selected to add a user story to.   Create a new project or select an existing project under the ... menu first.',context);
                    }
                  },
                ),
                IconButton(
                  tooltip: 'Edit user',
                  icon: Icon(FontAwesomeIcons.userEdit),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, EditUser.id, (Route<dynamic> route) => false);
                  },
                ),
                IconButton(
                  tooltip: 'Sign out',
                  icon: Icon(FontAwesomeIcons.signOutAlt),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, MyHomePage.id,
                        (Route<dynamic> route) => false);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void deactivate() {
    super.deactivate();
  }
}

class ProjectPopupMenu {
  final String title;
  final int id;
  ProjectPopupMenu({this.title, this.id});
}

void updateProjectChoices() {
  choices = <ProjectPopupMenu>[];
  for (int i = 0; i < myProjects.length; i++) {
    choices.add(new ProjectPopupMenu(title: myProjects[i].name, id: i));
  }
}

List<ProjectPopupMenu> choices = <ProjectPopupMenu>[];