import 'package:http/http.dart' as http;
import 'dart:convert';
import 'developer.dart';
import 'project.dart';
import 'user_story.dart';
import 'error.dart';
import 'package:flutter/material.dart';
import 'package:my_agile_story_flutter_app/view/logged_in_page.dart';
import 'package:my_agile_story_flutter_app/view/home_page.dart';
import 'package:my_agile_story_flutter_app/view/messages.dart';
import 'package:my_agile_story_flutter_app/view/user_story_cards.dart';
import 'package:my_agile_story_flutter_app/controller/debug_printing.dart';

const String URL_Address = 'https://shrouded-basin-24147.herokuapp.com';

void loginDeveloper(email,password,context) async {
  var url = URL_Address + '/get/developer';
  var body = json.encode({
    'email': email,
    'password':password
  });
  Map<String,String> headers = {
    'Content-type' : 'application/json',
    'Accept': 'application/json, text/plain, */*',
  };
  http.Response response = await http.post(url, body: body, headers: headers);
  if (response.statusCode == 200) {
    var jsonDecodedData = json.decode(response.body);
    myDeveloper = new Developer.fromJson(jsonDecodedData);
    myLastSelectedProject = -1;
    myUserStorys=[];
    getProjects(myDeveloper,-1,context,false);
  } else {
      myApiError = new ApiError.fromJson(json.decode(response.body));
      messagePopup('Error!',Colors.red,myApiError.error,context);
  }
}

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
    myApiError = new ApiError.fromJson(json.decode(response.body));
    messagePopup('Error!',Colors.red,myApiError.error,context);
  }
}

void getUserStorys(thisProject, context) async {
  var url = URL_Address + '/get/userStorys';
  var body = json.encode({
    'userStoryIds': thisProject.userStoryIds,
  });
  Map<String,String> headers = {
    'Content-type' : 'application/json',
    'Accept': 'application/json, text/plain, */*',
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

void createNewDeveloper(thisDeveloper,context) async {
  var url = URL_Address + '/developer';
  var body = json.encode({
    'email': thisDeveloper.email,
    'password': thisDeveloper.password,
    'firstName': thisDeveloper.firstName,
    'lastName': thisDeveloper.lastName,
    'bio': thisDeveloper.bio,
    'role': thisDeveloper.role,
  });
  Map<String,String> headers = {
    'Content-type' : 'application/json',
    'Accept': 'application/json, text/plain, */*',
  };
  http.Response response = await http.post(url, body: body, headers: headers);
  if (response.statusCode == 200) {
    var jsonDecodedData = json.decode(response.body);
    myDeveloper = new Developer.fromJson(jsonDecodedData);
    Navigator.pushReplacementNamed(context, MyHomePage.id);
  } else {
    myApiError = new ApiError.fromJson(json.decode(response.body));
    messagePopup('Error!',Colors.red,myApiError.error,context);
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

void editDeveloper(thisDeveloper, context) async {
  var url = URL_Address + '/put/developer';
  var body = json.encode({
    'developerId': thisDeveloper.id,
    'firstName':thisDeveloper.firstName,
    'lastName': thisDeveloper.lastName,
    'email': thisDeveloper.email,
    'password': thisDeveloper.password,
    'bio':thisDeveloper.bio,
    'role': thisDeveloper.role
  });
  Map<String,String> headers = {
    'Content-type' : 'application/json',
    'Accept': 'application/json, text/plain, */*',
  };
  http.Response response = await http.post(url, body: body, headers: headers);
  if (response.statusCode == 200) {
    var jsonDecodedData = json.decode(response.body);
    myDeveloper = new Developer.fromJson(jsonDecodedData);
    Navigator.pushReplacementNamed(context, MyLoggedInPage.id);
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