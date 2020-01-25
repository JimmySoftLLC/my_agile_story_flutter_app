import 'package:http/http.dart' as http;
import 'dart:convert';
import 'developer.dart';
import 'user_story.dart';
import 'error.dart';
import 'project_api.dart';
import 'package:flutter/material.dart';
import 'package:my_agile_story_flutter_app/view/logged_in_page.dart';
import 'package:my_agile_story_flutter_app/view/home_page.dart';
import 'package:my_agile_story_flutter_app/view/messages.dart';
import 'url_path_api.dart';


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
    myDeveloper = new Developer.fromJsonNested(jsonDecodedData);
    myToken=jsonDecodedData['token'];
    print(myToken);
    myLastSelectedProject = -1;
    myUserStorys=[];
    getProjects(myDeveloper,-1,context,false);
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
    'x-auth-token': myToken,
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