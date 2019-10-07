import 'dart:convert';
import 'package:my_agile_story_flutter_app/controller/error.dart';

Function printDeveloper (myDeveloper,response) {
  print ('Developer --------------------------');
  print('status: ' + response.statusCode.toString());
  print('id: ' + myDeveloper.id);
  print('firstName: ' + myDeveloper.firstName);
  print('lastName: ' + myDeveloper.lastName);
  print('email: ' + myDeveloper.email);
  print('password: ' + myDeveloper.password);
  print('bio: ' + myDeveloper.bio);
  print('role: ' + myDeveloper.role);
  print('timeStampISO: ' + myDeveloper.timeStampISO);
  for (int i = 0; i < myDeveloper.projectIds.length; i++) {
    print(myDeveloper.projectIds[i]);
  }
  return null;
}

Function printProject (myProject,response) {
  print ('Project --------------------------');
  print('status: ' + response.statusCode.toString());
  print('id: ' + myProject.id);
  print('name: ' + myProject.name);
  print('description: ' + myProject.description);
  print('timeStampISO: ' + myProject.timeStampISO);
  for (int i = 0; i < myProject.developerIds.length; i++) {
    print('developerId: ' + myProject.developerIds[i]);
  }
  for (int i = 0; i < myProject.userStoryIds.length; i++) {
    print('userStoryId: ' + myProject.userStoryIds[i]);
  }
  return null;
}

Function printUserStory(myUserStory,response) {
  print ('UserStory --------------------------');
  print('status: ' + response.statusCode.toString());
  printUserStoryWithoutResponse (myUserStory);
  return null;
}

Function printUserStorys (myUserStorys,response) {
  print ('UserStorys --------------------------');
  print('status: ' + response.statusCode.toString());
  for (int i = 0; i < myUserStorys.length; i++) {
    printUserStoryWithoutResponse (myUserStorys[i]);
  }
  return null;
}

Function printUserStoryWithoutResponse (myUserStory) {
  print('id: ' + myUserStory.id);
  print('userStoryTitle: ' + myUserStory.userStoryTitle);
  print('userRole: ' + myUserStory.userRole);
  print('userWant: ' + myUserStory.userWant);
  print('userBenefit: ' + myUserStory.userBenefit);
  print('acceptanceCriteria: ' + myUserStory.acceptanceCriteria);
  print('conversation: ' + myUserStory.conversation);
  print('estimate: ' + myUserStory.estimate.toString());
  print('phase: ' + myUserStory.phase);
  print('percentDone: ' + myUserStory.percentDone.toString());
  print('priority: ' + myUserStory.priority.toString());
  print('sprint: ' + myUserStory.sprint.toString());
  print('timeStampISO: ' + myUserStory.timeStampISO);
  return null;
}

Function printError (response) {
  myApiError = new ApiError.fromJson(json.decode(response.body));
  print('status: ' + response.statusCode.toString());
  print('Error: ' + myApiError.error);
  return null;
}