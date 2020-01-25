import 'package:flutter/material.dart';
import 'package:my_agile_story_flutter_app/controller/user_story_api.dart';
import 'package:my_agile_story_flutter_app/controller/project_api.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_agile_story_flutter_app/controller/developer.dart';
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
import 'package:flutter/scheduler.dart';

String myLastSelectedPhase = '0';
int myLastSelectedProject = -1;
int myLastSelectedUserStory = -1;
var myLastScrollPosition = [0.0,0.0,0.0,0.0];

class MyLoggedInPage extends StatefulWidget {
  static const String id = '/MyLoggedInPage';
  static _MyLoggedInPageState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<_MyLoggedInPageState>());
  @override
  _MyLoggedInPageState createState() => _MyLoggedInPageState();
}

class _MyLoggedInPageState extends State<MyLoggedInPage> with WidgetsBindingObserver{
  List<Widget> userStoryCardsToDo = <UserStoryCard>[];
  List<Widget> userStoryCardsDoing = <UserStoryCard>[];
  List<Widget> userStoryCardsVerify = <UserStoryCard>[];
  List<Widget> userStoryCardsDone = <UserStoryCard>[];
  ProjectPopupMenu _selectedChoices;
  Timer needsUpdateTimer;
  ScrollController _scrollController0;
  ScrollController _scrollController1;
  ScrollController _scrollController2;
  ScrollController _scrollController3;
  String chartTitle;

  AppLifecycleState _notification;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });
  }

  void _select(ProjectPopupMenu choice) {
    setState(() {
      _selectedChoices = choice;
      myLastSelectedProject = choice.id;
      messagePopupNoDismiss('',Colors.black,'Getting project please wait',context);
      getUserStorys(myProjects[choice.id], context);
    });
  }

  void editUserStoryInContext() {
    updateScrollPositions();
    Navigator.pushReplacementNamed(context, EditUserStory.id);
  }

  void moveUserStoryToNextPhaseInContext() {
    updateScrollPositions();
    messagePopupNoDismiss('',Colors.black,'Moving user story to next phase please wait',context);
    editUserStory(myProjects[myLastSelectedProject],
        myUserStorys[myLastSelectedUserStory], context);
  }

  void deleteWarningPopupInContext(String itemType, String itemName, context) {
    updateScrollPositions();
    deleteWarningPopup( itemType,  itemName, context);
  }

  void changeUserStoryPriorityUsingSliderInContext() {
    updateScrollPositions();
    messagePopupNoDismiss('',Colors.black,'Reordering user stories please wait',context);
    editUserStory(myProjects[myLastSelectedProject],
        myUserStorys[myLastSelectedUserStory], context);
  }

  void updateProjectInContext(){
    if(myLastSelectedProject != -1 && _notification.toString() != 'AppLifecycleState.paused') {
      updateScrollPositions();
      getProjects(myDeveloper,myLastSelectedProject,context,true);
    }
  }

  void updateScrollPositions() {
    if (myLastSelectedProject >= 0) {
      if (_scrollController0.hasClients) {myLastScrollPosition[0]=_scrollController0.offset;}
      if (_scrollController1.hasClients) {myLastScrollPosition[1]=_scrollController1.offset;}
      if (_scrollController2.hasClients) {myLastScrollPosition[2]=_scrollController2.offset;}
      if (_scrollController3.hasClients) {myLastScrollPosition[3]=_scrollController3.offset;}
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController0 = new ScrollController();
    _scrollController1 = new ScrollController();
    _scrollController2 = new ScrollController();
    _scrollController3 = new ScrollController();
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
      chartTitle = myProjects[myLastSelectedProject].name;
    }else{
      chartTitle='';
    }
    needsUpdateTimer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      updateProjectInContext();
    });
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (myLastSelectedProject >= 0) {
          if (_scrollController0.hasClients) {_scrollController0.jumpTo(myLastScrollPosition[0].toDouble());}
          if (_scrollController1.hasClients) {_scrollController1.jumpTo(myLastScrollPosition[1].toDouble());}
          if (_scrollController2.hasClients) {_scrollController2.jumpTo(myLastScrollPosition[2].toDouble());}
          if (_scrollController3.hasClients) {_scrollController3.jumpTo(myLastScrollPosition[3].toDouble());}
        }
      });
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
              controller: _scrollController0,
              padding: const EdgeInsets.all(8),
              children: userStoryCardsToDo,
            ),
            ListView(
              controller: _scrollController1,
              padding: const EdgeInsets.all(8),
              children: userStoryCardsDoing,
            ),
            ListView(
              controller: _scrollController2,
              padding: const EdgeInsets.all(8),
              children: userStoryCardsVerify,
            ),
            ListView(
              controller: _scrollController3,
              padding: const EdgeInsets.all(8),
              children: userStoryCardsDone,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: BurnDownChart(createBurnDownDataSet(),true,chartTitle)
            ),
          ]),
          bottomNavigationBar: BottomAppBar(
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 40,
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
                  tooltip: 'New bug',
                  icon: Icon(FontAwesomeIcons.bug),
                  onPressed: () {
                    if (myLastSelectedProject != -1) {
                      Navigator.pushNamedAndRemoveUntil(context,
                          NewUserStory.id, (Route<dynamic> route) => false);
                    } else {
                      messagePopup('Note',Colors.black,
                          'No project selected to add a bug to.   Create a new project or select an existing project under the ... menu first.',context);
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
    WidgetsBinding.instance.removeObserver(this);
    needsUpdateTimer?.cancel();
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