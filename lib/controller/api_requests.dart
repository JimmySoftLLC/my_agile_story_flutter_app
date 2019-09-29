import 'package:http/http.dart' as http;
import 'dart:convert';
import 'developer.dart';
import 'project.dart';
import 'user_story.dart';
import 'error.dart';
import 'debug_printing.dart';
import 'dom_equivalents.dart';
import 'test_api.dart';
import 'package:flutter/material.dart';
import 'package:my_agile_story_flutter_app/view/home_page.dart';

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
    printDeveloper(myDeveloper,response);

    //testNewDeveloper();

    //testNewProject(myDeveloper);

    //testUpdateProject(myDeveloper,-1);

    //testUpdateDeveloper();

    getProjects(myDeveloper,-1,context);

    } else {
    //    printError(response);
    myApiError = new ApiError.fromJson(json.decode(response.body));
    //TODO    showErrorMessage('Error',myApiError.error);
    }
}

void getProjects(thisDeveloper,myProjectIndex,context) async {
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
      printProject (myProjects[i],response);
    }

    //getUserStorys(myProjects[0]);

    //testUpdateUserStory(myProjects[0]);

    loggedinMenu(myProjectIndex,context);
  } else {
    //    printError(response);
    myApiError = new ApiError.fromJson(json.decode(response.body));
    //TODO    showErrorMessage('Error',myApiError.error);
  }
}

void getUserStorys(thisProject) async {
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

    //printUserStorys(myUserStorys, response);

    myUserStorys.sort((obj1, obj2) {return obj1.priority - obj2.priority;});

    //testDeleteUserStory(0);
    //testDeleteProject(0);

    //printUserStorys(myUserStorys, response);
    //TODO    setMyAglileStoryUserStoryStorage();
    //TODO    displayUserStories();
    //TODO    updateStatus("");

  } else {
    //printError(response);
    myApiError = new ApiError.fromJson(json.decode(response.body));
    //TODO    showErrorMessage('Error',myApiError.error);
  }
}

void createNewDeveloper(thisDeveloper,context) async {
  //TODO  updateDeveloperMessage("Creating new developer please wait");
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
    //TODO  setMyAglileStoryDeveloperStorage();
    //TODO  updateStatus("Developer created");
  } else {
    //printError(response);
    myApiError = new ApiError.fromJson(json.decode(response.body));
    //TODO    showErrorMessage('Error',myApiError.error);
  }
}

void createNewProject(thisDeveloper,thisProject,context) async {
  //TODO  updateDeveloperMessage("Creating new project please wait");
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
    myProject = new Project.fromJson(myTempDeveloper);
    //printProject(myProject,response);
    thisDeveloper.projectIds.push(myProject._id);
    getProjects(myDeveloper,-1,context);
    //updateStatus('Project ' +  myProject.name + ', created successfully');
  } else {
    //printError(response);
    myApiError = new ApiError.fromJson(json.decode(response.body));
    //TODO    showErrorMessage('Error',myApiError.error);
  }
}

void createNewUserStory(thisProject,thisUserStory) async {
  //TODO  updateDeveloperMessage("Creating new user story please wait");
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
    myUserStory = new UserStory.fromJson(myTempUserStory);
    //printUserStory(myUserStory,response);
    thisProject.userStoryIds.push(myUserStory.id);
    getUserStorys(thisProject);
  } else {
    printError(response);
    myApiError = new ApiError.fromJson(json.decode(response.body));
    //TODO    showErrorMessage('Error',myApiError.error);
  }
}

void editUserStory(thisProject,thisUserStory) async {
  //TODO  updateDeveloperMessage("Updateing user story please wait");
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
    myUserStory = new UserStory.fromJson(myTempUserStory);
    //printUserStory(myUserStory,response);
    getUserStorys(thisProject);
  } else {
    printError(response);
    myApiError = new ApiError.fromJson(json.decode(response.body));
    //TODO    showErrorMessage('Error',myApiError.error);
  }
}

void editProject(thisDeveloper,thisProject,myProjectIndex,context) async {
  //TODO  updateDeveloperMessage("Editing project please wait");
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
    myProject = new Project.fromJson(myTempProject);
    printProject(myProject,response);
    getProjects(thisDeveloper, myProjectIndex,context);
    //TODO  updateStatus("Project " + myProject.name + ", edited successfully");
  } else {
    printError(response);
    myApiError = new ApiError.fromJson(json.decode(response.body));
    //TODO    showErrorMessage('Error',myApiError.error);
  }
}

void editDeveloper(thisDeveloper) async {
  //TODO  updateEditDeveloperMessage("Editing developer please wait");
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
    printDeveloper(myDeveloper,response);
    //TODO  updateStatus("Project " + myProject.name + ", edited successfully");
  } else {
    printError(response);
    myApiError = new ApiError.fromJson(json.decode(response.body));
    //TODO    showErrorMessage('Error',myApiError.error);
  }
}

void deleteUserStory(myUserStoryIndex) async {
  if (myUserStoryIndex != -1 && myUserStorys.length > 0) {
    //TODO  updateStatus("Deleting user story please wait");
    var userStoryId = myUserStorys[myUserStoryIndex].id;
    var projectId = myUserStorys[myUserStoryIndex].projectId;
    var myProjectIndex = -1;
    for (int i = 0; i < myProjects.length; i++) {
      if (myProjects[i].id == projectId) {
        myProjectIndex = i;
        break;
      }
    }
    print('user story id' + userStoryId);
    print('project id' + projectId);
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
      print('user story deleted');
      //TODO    updateStatus("User story deleted");
      getUserStorys(myProjects[myProjectIndex]);
    } else {
      printError(response);
      myApiError = new ApiError.fromJson(json.decode(response.body));
      //TODO    showErrorMessage('Error',myApiError.error);
    }
  }
}

void deleteProject(myProjectIndex,context) async {
  if (myProjectIndex != -1 && myProjects.length > 0) {
    //TODO  updateStatus("Deleting project please wait");
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
        print('project deleted');
        getProjects(myDeveloper, -1,context);
      } else {
        printError(response);
        myApiError = new ApiError.fromJson(json.decode(response.body));
        //TODO    showErrorMessage('Error',myApiError.error);
      }
    } else {
      printError(response);
      myApiError = new ApiError.fromJson(json.decode(response.body));
      //TODO    showErrorMessage('Error',myApiError.error);
    }
  }
}