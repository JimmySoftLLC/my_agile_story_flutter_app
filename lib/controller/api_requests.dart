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
    myDeveloper = new Developer.fromJson(json.decode(response.body));
    myLastSelectedProject = -1;
    myUserStorys=[];
    getProjects(myDeveloper,-1,context,false);
    } else {
      myApiError = new ApiError.fromJson(json.decode(response.body));
      messagePopup('Error!',Colors.red,myApiError.error,context);
    }
}

//void getProject(thisProject,context) async {
//  String myCurrentLocalTimeStamp = thisProject.timeStampISO;
//  var url = URL_Address + '/get/project';
//  var body = json.encode({
//    'projectId': thisProject.id,
//  });
//  Map<String,String> headers = {
//    'Content-type' : 'application/json',
//    'Accept': 'application/json, text/plain, */*',
//  };
//  http.Response response = await http.post(url, body: body, headers: headers);
//  if (response.statusCode == 200) {
//    var myTempProject = json.decode(response.body);
//    myProjects[myLastSelectedProject]=new Project.fromJson(myTempProject);
//    if (myProjects[myLastSelectedProject].timeStampISO != myCurrentLocalTimeStamp){
//      getUserStorys(myProjects[myLastSelectedProject], context, false);
//    }
//  } else {
//    myApiError = new ApiError.fromJson(json.decode(response.body));
//  }
//}

void getProjects(thisDeveloper,myProjectIndex,context,getUserStoriesToo) async {
  String myCurrentLocalTimeStamp;
  String myProjectId;
  if (getUserStoriesToo) {
    myCurrentLocalTimeStamp = myProjects[myLastSelectedProject].timeStampISO;
    myProjectId = myProjects[myLastSelectedProject].id;
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
    var myTempProjects = json.decode(response.body);
    myProjects =[];
    for (int i = 0; i < myTempProjects.length; i++) {
      myProjects.add(new Project.fromJson(myTempProjects[i])) ;
    }
    if (getUserStoriesToo) {
      for (int i =0; i < myProjects.length; i++){
        if(myProjects[i].id == myProjectId){
          myLastSelectedProject=i;
          break;
        }
      }
      if (myProjects[myLastSelectedProject].timeStampISO != myCurrentLocalTimeStamp){
        getUserStorys(myProjects[myLastSelectedProject], context, false);
      }
    } else{
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

void getUserStorys(thisProject, context, updateProjectTimeStamp) async {
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
    var myTempUserStorys = json.decode(response.body);
    myUserStorys =[];
    for (int i = 0; i < myTempUserStorys.length; i++) {
      myUserStorys.add(new UserStory.fromJson(myTempUserStorys[i])) ;
    }
    myUserStorys.sort((obj1, obj2) {return obj1.priority - obj2.priority;});
    if (updateProjectTimeStamp) {
      editProjectTimeStamp(thisProject,context);
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
    var myTempDeveloper = json.decode(response.body);
    myDeveloper = new Developer.fromJson(myTempDeveloper);
    Navigator.pushReplacementNamed(context, MyHomePage.id);
    //printDeveloper(myDeveloper,response);
  } else {
    myApiError = new ApiError.fromJson(json.decode(response.body));
    messagePopup('Error!',Colors.red,myApiError.error,context);
  }
}

void createNewProject(thisDeveloper,thisProject,context) async {
  var url = URL_Address + '/developer/project';
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
    var myTempDeveloper = json.decode(response.body);
    thisProject = new Project.fromJson(myTempDeveloper);
    //printProject(myProject,response);
    thisDeveloper.projectIds.add(thisProject.id);
    getProjects(myDeveloper,-1,context,false);
    //updateStatus('Project ' +  myProject.name + ', created successfully');
  } else {
    myApiError = new ApiError.fromJson(json.decode(response.body));
    messagePopup('Error!',Colors.red,myApiError.error,context);
  }
}

void createNewUserStory(thisProject,thisUserStory,context) async {
  var url = URL_Address + '/project/userStory';
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
    var myTempUserStory = json.decode(response.body);
    thisUserStory = new UserStory.fromJson(myTempUserStory);
    //printUserStory(myUserStory,response);
    thisProject.userStoryIds.add(thisUserStory.id);
    getUserStorys(thisProject,context,true);
  } else {
    myApiError = new ApiError.fromJson(json.decode(response.body));
    messagePopup('Error!',Colors.red,myApiError.error,context);
  }
}

void editUserStory(thisProject,thisUserStory,context) async {
  var url = URL_Address + '/put/userStory';
  var body = json.encode({
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
    var myTempUserStory = json.decode(response.body);
    thisUserStory = new UserStory.fromJson(myTempUserStory);
    //printUserStory(myUserStory,response);
    getUserStorys(thisProject,context,true);
  } else {
    myApiError = new ApiError.fromJson(json.decode(response.body));
    messagePopup('Error!',Colors.red,myApiError.error,context);
  }
}

void editProject(thisDeveloper,thisProject,myProjectIndex,context) async {
  var url = URL_Address + '/put/project';
  var body = json.encode({
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
    var myTempProject = json.decode(response.body);
    thisProject = new Project.fromJson(myTempProject);
    //printProject(myProject,response);
    getProjects(thisDeveloper, myProjectIndex,context,false);
  } else {
    myApiError = new ApiError.fromJson(json.decode(response.body));
    messagePopup('Error!',Colors.red,myApiError.error,context);
  }
}

void editProjectTimeStamp(thisProject,context) async {
  var url = URL_Address + '/put/project';
  var body = json.encode({
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
    var myTempProject = json.decode(response.body);
    myProjects[myLastSelectedProject] = new Project.fromJson(myTempProject);
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
    var myTempDeveloper = json.decode(response.body);
    myDeveloper = new Developer.fromJson(myTempDeveloper);
    //printDeveloper(myDeveloper,response);
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
      getUserStorys(myProjects[myProjectIndex],context,true);
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
        'projectId': myProjects[myProjectIndex].id
      });
      Map<String,String> headers = {
        'Content-type' : 'application/json',
        'Accept': 'application/json, text/plain, */*',
      };
      http.Response response = await http.post(url, body: body, headers: headers);
      if (response.statusCode == 200) {
        getProjects(myDeveloper, -1,context,false);
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