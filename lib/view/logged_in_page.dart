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
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:my_agile_story_flutter_app/controller/charting.dart';

String myLastSelectedPhase = '0';
int myLastSelectedProject = -1;
int myLastSelectedUserStory = -1;
String chartTitle = '';

class MyLoggedInPage extends StatefulWidget {
  static const String id = '/MyLoggedInPage';
  static _MyLoggedInPageState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<_MyLoggedInPageState>());
  @override
  _MyLoggedInPageState createState() => _MyLoggedInPageState();
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
      getUserStorys(myProjects[choice.id], context);
    });
  }

  void _editUserStory() {
    Navigator.pushReplacementNamed(context, EditUserStory.id);
  }

  void _moveUserStoryToNextPhase() {
    editUserStory(myProjects[myLastSelectedProject],
        myUserStorys[myLastSelectedUserStory], context);
  }

  void _deleteWarningPopup(String itemType, String itemName) {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('Delete Warning !', style: TextStyle(color: Colors.red)),
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
                switch (itemType) {
                  case 'user story':
                    {
                      print('user story delete');
                      deleteUserStory(myLastSelectedUserStory, context);
                    }
                    break;
                  case 'project':
                    {
                      print('project delete');
                      deleteProject(myLastSelectedProject, context);
                      myLastSelectedProject = -1;
                    }
                    break;
                  default:
                    {}
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
              child: const Text(
                'OK',
                style: TextStyle(
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
  void initState() {
    super.initState();
    //print ('init logged in screen');
    _selectedChoices = null;

    updateProjectChoices();

    if (myLastSelectedProject > myProjects.length - 1) {
      myLastSelectedProject = myProjects.length - 1;
    }

    if (myLastSelectedProject >= 0) {
      print('update user storys');
      _selectedChoices = choices[myLastSelectedProject];
      userStoryCardsToDo = updateUserStoryCards('0');
      userStoryCardsDoing = updateUserStoryCards('1');
      userStoryCardsVerify = updateUserStoryCards('2');
      userStoryCardsDone = updateUserStoryCards('3');
    }
  }

  @override
  Widget build(BuildContext context) {
    //print ('logged in screen built');
    return MaterialApp(
      home: DefaultTabController(
        length: 5,
        initialIndex: int.parse(myLastSelectedPhase),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            bottom: TabBar(
              onTap: (int index) {
                myLastSelectedPhase = index.toString();
                print('tab index is $index');
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
                      _deleteWarningPopup(
                          'project', myProjects[myLastSelectedProject].name);
                    } else {
                      _messagePopup(
                          'No project selected to delete.   Select an existing project under the ... menu first.');
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
                      _messagePopup(
                          'No project selected to edit.   Select an existing project under the ... menu first.');
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
                      _messagePopup(
                          'No project selected to add a user story to.   Create a new project or select an existing project under the ... menu first.');
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
    //print ('logged in  deactivated');
    super.deactivate();
  }
}

editUserStoryPressed(index, context) {
  myLastSelectedPhase = myUserStorys[index].phase;
  myLastSelectedUserStory = index;
  MyLoggedInPage.of(context)._editUserStory();
}

deleteUserStoryPressed(index, context) {
  myLastSelectedUserStory = index;
  myLastSelectedPhase = myUserStorys[index].phase;
  MyLoggedInPage.of(context)._deleteWarningPopup('user story', myUserStorys[index].userStoryTitle);
}

moveUserStoryToNextPhasePressed(index, context) {
  myLastSelectedUserStory = index;
  print("send to sprint " + index.toString());
  myLastSelectedPhase = myUserStorys[index].phase;
  int myCurrentPhase = int.parse(myUserStorys[myLastSelectedUserStory].phase);
  if (myCurrentPhase < 3) {
    myCurrentPhase += 1;
    myUserStorys[myLastSelectedUserStory].phase = myCurrentPhase.toString();
  }
  MyLoggedInPage.of(context)._moveUserStoryToNextPhase();
}

class UserStoryCard extends StatelessWidget {
  UserStoryCard(
      {@required this.userStoryTitle,
      @required this.userStoryBody,
      @required this.index,
      @required this.phase});
  final String userStoryTitle;
  final String userStoryBody;
  final int index;
  final IconData phase;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 50,
            child: Container(
              padding: new EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(userStoryTitle,
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(userStoryBody),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 50,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    tooltip: 'Edit user story',
                    icon: Icon(FontAwesomeIcons.edit),
                    onPressed: () => editUserStoryPressed(index, context),
                  ),
                  IconButton(
                    tooltip: 'Delete user story',
                    icon: Icon(FontAwesomeIcons.trash),
                    onPressed: () => deleteUserStoryPressed(index, context),
                  ),
                  IconButton(
                    tooltip: 'Send to sprint',
                    icon: Icon(phase),
                    onPressed: () =>
                        moveUserStoryToNextPhasePressed(index, context),
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

RichText myRichText(String itemType, String itemName) {
  var text = new RichText(
    text: new TextSpan(
      // Note: Styles for TextSpans must be explicitly defined.
      // Child text spans will inherit styles from parent
      style: new TextStyle(
        fontSize: 14.0,
        color: Colors.black,
      ),
      children: <TextSpan>[
        new TextSpan(
            text: 'You are about to delete ' + itemType + ', ',
            style: new TextStyle(fontSize: 17)),
        new TextSpan(
            text: itemName,
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        new TextSpan(
            text: '.  This process is irreversable are you sure?',
            style: new TextStyle(fontSize: 17)),
      ],
    ),
  );
  return text;
}

class BurnDownChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  BurnDownChart(this.seriesList, {this.animate});

  factory BurnDownChart.withData() {
    return new BurnDownChart(
      _createBurnDownDataSet(),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.OrdinalComboChart(seriesList,
        animate: animate,
        // Configure the default renderer as a bar renderer.
        defaultRenderer: new charts.BarRendererConfig(
            groupingType: charts.BarGroupingType.stacked),
        // Custom renderer configuration for the line series. This will be used for
        // any series that does not define a rendererIdKey.
        customSeriesRenderers: [
          new charts.LineRendererConfig(
              // ID used to link series to this renderer.
              customRendererId: 'customLine')
        ]);
  }
}

/// Sample ordinal data type.
class GraphData {
  final String sprint;
  final double points;
  GraphData(this.sprint, this.points);
}

/// Create series list with multiple series
List<charts.Series<GraphData, String>> _createBurnDownDataSet() {
  generateBurnChartData();
  List<GraphData> sprintData = [];
  List<GraphData> toDoData = [];
  List<GraphData> velocityData = [];

  if (burndown.length > 1){
    for (int i = 0; i < burndown.length; i++) {
      sprintData.add(new GraphData('S'+ i.toString(), sprints[i].toDouble()));
    }

    for (int i = 0; i < burndown.length; i++) {
      toDoData.add(new GraphData('S'+ i.toString(), todo[i].toDouble()));
    }

    for (int i = 0; i < burndown.length; i++) {
      velocityData.add(new GraphData('S'+ i.toString(), burndown[i]));
    }
  }

  return [
    new charts.Series<GraphData, String>(
        id: 'Sprint',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (GraphData sprint, _) => sprint.sprint,
        measureFn: (GraphData sprint, _) => sprint.points,
        data: sprintData),
    new charts.Series<GraphData, String>(
        id: 'ToDo',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (GraphData sprint, _) => sprint.sprint,
        measureFn: (GraphData sprint, _) => sprint.points,
        data: toDoData),
    new charts.Series<GraphData, String>(
        id: 'Velocity',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (GraphData sprint, _) => sprint.sprint,
        measureFn: (GraphData sprint, _) => sprint.points,
        data: velocityData)
      // Configure our custom line renderer for this series.
      ..setAttribute(charts.rendererIdKey, 'customLine'),
  ];
}

//**************
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

List<UserStoryCard> updateUserStoryCards(selectedPhase) {
  List<Widget> userStoryCards = <UserStoryCard>[];
  String userStoryBody;
  IconData myIcon;
  for (int i = 0; i < myUserStorys.length; i++) {
    if (selectedPhase == myUserStorys[i].phase) {
      switch (myUserStorys[i].phase) {
        case '0':
          {
            myIcon = FontAwesomeIcons.running;
          }
          break;
        case '1':
          {
            myIcon = FontAwesomeIcons.check;
          }
          break;
        case '2':
          {
            myIcon = FontAwesomeIcons.handsHelping;
          }
          break;
        case '3':
          {}
          break;
        default:
          {}
          break;
      }
      userStoryBody = 'As a ' +
          myUserStorys[i].userRole +
          ', I want ' +
          myUserStorys[i].userWant +
          ' so that ' +
          myUserStorys[i].userBenefit;
      userStoryCards.add(new UserStoryCard(
          userStoryTitle: myUserStorys[i].userStoryTitle,
          userStoryBody: userStoryBody,
          index: i,
          phase: myIcon));
    }
  }
  return userStoryCards;
}
