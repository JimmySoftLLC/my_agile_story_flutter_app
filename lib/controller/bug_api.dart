import 'package:http/http.dart' as http;
import 'dart:convert';
import 'project.dart';
import 'user_story.dart';
import 'bug.dart';
import 'error.dart';
import 'package:flutter/material.dart';
import 'package:my_agile_story_flutter_app/view/logged_in_page.dart';
import 'package:my_agile_story_flutter_app/view/messages.dart';
import 'package:my_agile_story_flutter_app/controller/debug_printing.dart';
import 'url_path_api.dart';

void getBugs(thisProject, context) async {
  var url = URL_Address + '/get/userStorys';
  var body = json.encode({
    'userStoryIds': thisProject.userStoryIds,
  });
  Map<String,String> headers = {
    'Content-type' : 'application/json',
    'Accept': 'application/json, text/plain, */*',
    'x-auth-token': myToken,
  };
  http.Response response = await http.post(url, body: body, headers: headers);
  if (response.statusCode == 200) {
    var jsonDecodedData = json.decode(response.body);
    myUserStorys =[];
    for (int i = 0; i < jsonDecodedData.length; i++) {
      myUserStorys.add(new UserStory.fromJson(jsonDecodedData[i])) ;
    }
    myUserStorys.sort((obj1, obj2) {return obj1.priority - obj2.priority;});
    Route _createRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => MyLoggedInPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      );
    }
    Navigator.of(context).pushAndRemoveUntil(_createRoute(),(Route<dynamic> PageRouteBuilder) => false);
  } else {
    myApiError = new ApiError.fromJson(json.decode(response.body));
    messagePopup('Error!',Colors.red,myApiError.error,context);
  }
}

void createNewBug(thisProject,thisBug,context) async {
  var url = URL_Address + '/project/bug/returnBugAndProject';
  var body = json.encode({
    'projectId': thisProject.id,
    'userStoryTitle': thisBug.userStoryTitle,
    'userRole': thisBug.userRole,
    'userWant': thisBug.userWant,
    'userBenefit': thisBug.userBenefit,
    'acceptanceCriteria': thisBug.acceptanceCriteria,
    'conversation': thisBug.conversation,
    'estimate': thisBug.estimate,
    'phase': thisBug.phase,
    'percentDone': thisBug.percentDone,
    'priority': thisBug.priority,
    'sprint': thisBug.sprint
  });
  Map<String,String> headers = {
    'Content-type' : 'application/json',
    'Accept': 'application/json, text/plain, */*',
    'x-auth-token': myToken,
  };
  http.Response response = await http.post(url, body: body, headers: headers);
  if (response.statusCode == 200) {
    var jsonDecodedData = json.decode(response.body);
    thisBug = new Bug.fromJsonNested(jsonDecodedData);
    myProjects[myLastSelectedProject] = new Project.fromJsonNested(jsonDecodedData);
    getBugs(myProjects[myLastSelectedProject],context);
  } else {
    myApiError = new ApiError.fromJson(json.decode(response.body));
    messagePopup('Error!',Colors.red,myApiError.error,context);
  }
}