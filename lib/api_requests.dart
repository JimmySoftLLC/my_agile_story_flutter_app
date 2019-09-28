import 'package:http/http.dart' as http;
import 'dart:convert';
import 'developer.dart';

const String URL_Address = 'https://shrouded-basin-24147.herokuapp.com';

void getDeveloper(email,password) async {
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

  myDeveloper = new Developer.fromJson(json.decode(response.body));

  print('_id: ' + myDeveloper.id);
  print('firstName: ' + myDeveloper.firstName);
  print('lastName: ' + myDeveloper.lastName);
  print('email: ' + myDeveloper.email);
  print('password: ' + myDeveloper.password);
  print('bio: ' + myDeveloper.bio);
  print('role: ' + myDeveloper.role);
  print('projectIds: ' + myDeveloper.projectIds.toString());
  print('status: ' + response.statusCode.toString());
}