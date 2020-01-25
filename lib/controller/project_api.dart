import 'package:http/http.dart' as http;
import 'dart:convert';
import 'developer.dart';
import 'project.dart';
import 'error.dart';
import 'user_story_api.dart';
import 'package:flutter/material.dart';
import 'package:my_agile_story_flutter_app/view/logged_in_page.dart';
import 'package:my_agile_story_flutter_app/view/messages.dart';
import 'url_path_api.dart';

void getProjects(thisDeveloper, myProjectIndex, context, checkingIfUpdateIsNeeded) async {
  String myCurrentLocalTimeStamp;
  if (checkingIfUpdateIsNeeded && myProjectIndex != -1){
    myCurrentLocalTimeStamp = myProjects[myProjectIndex].timeStampISO;
  }
  var url = URL_Address + '/get/projects';
  var body = json.encode({
    'projectIds': thisDeveloper.projectIds,
  });
  Map<String,String> headers = {
    'Content-type' : 'application/json',
    'Accept': 'application/json, text/plain, */*',
    'x-auth-token': myToken,
  };
  http.Response response = await http.post(url, body: body, headers: headers);
  if (response.statusCode == 200) {
    var jsonDecodedData = json.decode(response.body);
    myProjects =[];
    for (int i = 0; i < jsonDecodedData.length; i++) {
      myProjects.add(new Project.fromJson(jsonDecodedData[i])) ;
    }
    if (checkingIfUpdateIsNeeded && myProjectIndex != -1) {
      if(myCurrentLocalTimeStamp != myProjects[myProjectIndex].timeStampISO){
        getUserStorys(myProjects[myProjectIndex],context);
      }
    }else{
      Route _createRoute() {
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => MyLoggedInPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      }
      Navigator.of(context).pushAndRemoveUntil(_createRoute(),(Route<dynamic> PageRouteBuilder) => false);
    }
  } else {
    print('got to error screen');
    myApiError = new ApiError.fromJson(json.decode(response.body));
    messagePopup('Error!',Colors.red,myApiError.error,context);
  }
}

void editProject(thisDeveloper,thisProject,myProjectIndex,context) async {
  var url = URL_Address + '/put/project/returnProjectAndDeveloper';
  var body = json.encode({
    'developerId': thisDeveloper.id,
    'projectId': thisProject.id,
    'name': thisProject.name,
    'description': thisProject.description,
  });
  Map<String,String> headers = {
    'Content-type' : 'application/json',
    'Accept': 'application/json, text/plain, */*',
    'x-auth-token': myToken,
  };
  http.Response response = await http.post(url, body: body, headers: headers);
  if (response.statusCode == 200) {
    var jsonDecodedData = json.decode(response.body);
    thisProject = new Project.fromJsonNested(jsonDecodedData);
    thisDeveloper = new Developer.fromJsonNested(jsonDecodedData);
    getProjects(thisDeveloper, myProjectIndex,context,true);
  } else {
    myApiError = new ApiError.fromJson(json.decode(response.body));
    messagePopup('Error!',Colors.red,myApiError.error,context);
  }
}

void deleteProject(myProjectIndex,context) async {
  if (myProjectIndex != -1 && myProjects.length > 0) {
    messagePopupNoDismiss('',Colors.black,'Deleting project please wait',context);
    var url = URL_Address + '/delete/project/userStorys';
    var body = json.encode({
      'userStoryIds': myProjects[myProjectIndex].userStoryIds
    });
    Map<String,String> headers = {
      'Content-type' : 'application/json',
      'Accept': 'application/json, text/plain, */*',
      'x-auth-token': myToken,
    };
    http.Response response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      var url = URL_Address + '/delete/developer/project';
      var body = json.encode({
        'projectId': myProjects[myProjectIndex].id,
        'developerId': myDeveloper.id
      });
      Map<String,String> headers = {
        'Content-type' : 'application/json',
        'Accept': 'application/json, text/plain, */*',
      };
      http.Response response = await http.post(url, body: body, headers: headers);
      if (response.statusCode == 200) {
        var jsonDecodedData = json.decode(response.body);
        myDeveloper = new Developer.fromJson(jsonDecodedData);
        getProjects(myDeveloper, -1,context,true);
      } else {
        myApiError = new ApiError.fromJson(json.decode(response.body));
        messagePopup('Error!',Colors.red,myApiError.error,context);
      }
    } else {
      myApiError = new ApiError.fromJson(json.decode(response.body));
      messagePopup('Error!',Colors.red,myApiError.error,context);
    }
  }
}

void createNewProject(thisDeveloper,thisProject,context) async {
  var url = URL_Address + '/developer/project/returnProjectAndDeveloper';
  var body = json.encode({
    'developerId': thisDeveloper.id,
    'name': thisProject.name,
    'description': thisProject.description,
  });
  Map<String,String> headers = {
    'Content-type' : 'application/json',
    'Accept': 'application/json, text/plain, */*',
  };
  http.Response response = await http.post(url, body: body, headers: headers);
  if (response.statusCode == 200) {
    var jsonDecodedData = json.decode(response.body);
    thisProject = new Project.fromJsonNested(jsonDecodedData);
    myDeveloper = new Developer.fromJsonNested(jsonDecodedData);
    getProjects(myDeveloper,-1,context,false);
  } else {
    myApiError = new ApiError.fromJson(json.decode(response.body));
    messagePopup('Error!',Colors.red,myApiError.error,context);
  }
}

