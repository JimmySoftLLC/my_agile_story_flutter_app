import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_agile_story_flutter_app/controller/user_story.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:my_agile_story_flutter_app/view/logged_in_page.dart';

List<UserStoryCard> updateUserStoryCards(String selectedPhase) {
  List<Widget> userStoryCards = <UserStoryCard>[];
  String userStoryBody;
  IconData myIcon;
  String myUserStoryTitle;
  int percentDone;
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
      myUserStoryTitle = 'S' + myUserStorys[i].sprint.toString() + ' - ' + myUserStorys[i].userStoryTitle;
      percentDone = myUserStorys[i].percentDone;
      if (percentDone < 0) {percentDone = 0;}
      if (percentDone > 100) {percentDone = 100;}
      userStoryCards.add(new UserStoryCard(
        userStoryTitle: myUserStoryTitle,
        userStoryBody: userStoryBody,
        index: i,
        phaseIcon: myIcon,
        progressValue: percentDone/100,
        progressText: percentDone.toString() + '%',));
    }
  }
  return userStoryCards;
}

class UserStoryCard extends StatelessWidget {
  UserStoryCard(
      {@required this.userStoryTitle,
        @required this.userStoryBody,
        @required this.index,
        @required this.phaseIcon,
        @required this.progressValue,
        @required this.progressText,});
  final String userStoryTitle;
  final String userStoryBody;
  final int index;
  final IconData phaseIcon;
  final double progressValue;
  final String progressText;
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      LinearPercentIndicator(
                        width: 160.0,
                        lineHeight: 14.0,
                        percent: progressValue,
                        center: Text(
                          progressText,
                          style: TextStyle(fontSize: 12.0),
                        ),
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        backgroundColor: Colors.grey,
                        progressColor: Colors.blue,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        icon: Icon(phaseIcon),
                        onPressed: () =>
                            moveUserStoryToNextPhasePressed(index, context),
                      ),
                    ],
                  ),
                ),
              ],
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

editUserStoryPressed(index, context) {
  myLastSelectedUserStory = index;
  myLastSelectedPhase = myUserStorys[index].phase;
  MyLoggedInPage.of(context).editUserStoryInContext();
}

deleteUserStoryPressed(index, context) {
  myLastSelectedUserStory = index;
  myLastSelectedPhase = myUserStorys[index].phase;
  MyLoggedInPage.of(context).deleteWarningPopupInContext('user story', myUserStorys[index].userStoryTitle,context);
}

moveUserStoryToNextPhasePressed(index, context) {
  myLastSelectedUserStory = index;
  myLastSelectedPhase = myUserStorys[index].phase;
  int myCurrentPhase = int.parse(myUserStorys[index].phase);
  if (myCurrentPhase < 3) {
    myCurrentPhase += 1;
    myUserStorys[myLastSelectedUserStory].phase = myCurrentPhase.toString();
  }
  MyLoggedInPage.of(context).moveUserStoryToNextPhaseInContext();
}