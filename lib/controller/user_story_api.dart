import 'package:http/http.dart' as http;
import 'dart:convert';
import 'project.dart';
import 'user_story.dart';
import 'error.dart';
import 'package:flutter/material.dart';
import 'package:my_agile_story_flutter_app/view/logged_in_page.dart';
import 'package:my_agile_story_flutter_app/view/messages.dart';
import 'package:my_agile_story_flutter_app/controller/debug_printing.dart';

import 'url_path_api.dart';

void getUserStorys(thisProject, context) async {
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

void createNewUserStory(thisProject,thisUserStory,context) async {
  var url = URL_Address + '/project/userStory/returnUserStoryAndProject';
  var body = json.encode({
    'projectId': thisProject.id,
    'userStoryTitle': thisUserStory.userStoryTitle,
    'userRole': thisUserStory.userRole,
    'userWant': thisUserStory.userWant,
    'userBenefit': thisUserStory.userBenefit,
    'acceptanceCriteria': thisUserStory.acceptanceCriteria,
    'conversation': thisUserStory.conversation,
    'estimate': thisUserStory.estimate,
    'phase': thisUserStory.phase,
    'percentDone': thisUserStory.percentDone,
    'priority': thisUserStory.priority,
    'sprint': thisUserStory.sprint
  });
  Map<String,String> headers = {
    'Content-type' : 'application/json',
    'Accept': 'application/json, text/plain, */*',
    'x-auth-token': myToken,
  };
  http.Response response = await http.post(url, body: body, headers: headers);
  if (response.statusCode == 200) {
    var jsonDecodedData = json.decode(response.body);
    thisUserStory = new UserStory.fromJsonNested(jsonDecodedData);
    myProjects[myLastSelectedProject] = new Project.fromJsonNested(jsonDecodedData);
    getUserStorys(myProjects[myLastSelectedProject],context);
  } else {
    myApiError = new ApiError.fromJson(json.decode(response.body));
    messagePopup('Error!',Colors.red,myApiError.error,context);
  }
}

void editUserStory(thisProject,thisUserStory,context) async {
  var url = URL_Address + '/put/userStory/returnUserStoryAndProject';
  var body = json.encode({
    'projectId': thisProject.id,
    'userStoryId': thisUserStory.id,
    'userStoryTitle': thisUserStory.userStoryTitle,
    'userRole': thisUserStory.userRole,
    'userWant': thisUserStory.userWant,
    'userBenefit': thisUserStory.userBenefit,
    'acceptanceCriteria': thisUserStory.acceptanceCriteria,
    'conversation': thisUserStory.conversation,
    'estimate': thisUserStory.estimate,
    'phase': thisUserStory.phase,
    'percentDone': thisUserStory.percentDone,
    'priority': thisUserStory.priority,
    'sprint': thisUserStory.sprint
  });
  Map<String,String> headers = {
    'Content-type' : 'application/json',
    'Accept': 'application/json, text/plain, */*',
    'x-auth-token': myToken,
  };
  http.Response response = await http.post(url, body: body, headers: headers);
  if (response.statusCode == 200) {
    var jsonDecodedData = json.decode(response.body);
    thisUserStory = new UserStory.fromJsonNested(jsonDecodedData);
    myProjects[myLastSelectedProject] = new Project.fromJsonNested(jsonDecodedData);
    getUserStorys(myProjects[myLastSelectedProject],context);
  } else {
    myApiError = new ApiError.fromJson(json.decode(response.body));
    messagePopup('Error!',Colors.red,myApiError.error,context);
  }
}

void deleteUserStory(myUserStoryIndex, context) async {
  if (myUserStoryIndex != -1 && myUserStorys.length > 0) {
    messagePopupNoDismiss('',Colors.black,'Deleting user story please wait',context);
    var userStoryId = myUserStorys[myUserStoryIndex].id;
    var projectId = myUserStorys[myUserStoryIndex].projectId;
    var myProjectIndex = -1;
    for (int i = 0; i < myProjects.length; i++) {
      if (myProjects[i].id == projectId) {
        myProjectIndex = i;
        break;
      }
    }
    var url = URL_Address + '/delete/project/userStory';
    var body = json.encode({
      'userStoryId': userStoryId,
      'projectId': projectId
    });
    Map<String,String> headers = {
      'Content-type' : 'application/json',
      'Accept': 'application/json, text/plain, */*',
      'x-auth-token': myToken,
    };
    http.Response response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      var jsonDecodedData = json.decode(response.body);
      myProjects[myProjectIndex] = new Project.fromJson(jsonDecodedData);
      getUserStorys(myProjects[myProjectIndex],context);
    } else {
      myApiError = new ApiError.fromJson(json.decode(response.body));
      messagePopup('Error!',Colors.red,myApiError.error,context);
    }
  }
}

