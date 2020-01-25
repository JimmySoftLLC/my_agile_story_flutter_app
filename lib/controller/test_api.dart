import 'package:my_agile_story_flutter_app/controller/user_story_api.dart';
import 'package:my_agile_story_flutter_app/controller/project_api.dart';
import 'package:my_agile_story_flutter_app/controller/developer_api.dart';
import 'package:my_agile_story_flutter_app/controller/user_story.dart';
import 'package:my_agile_story_flutter_app/controller/developer.dart';
import 'package:my_agile_story_flutter_app/controller/project.dart';
import 'user_story.dart';

void testNewDeveloper(context){
  Developer myNewDeveloper = new Developer(
      'NoID',
      'newdeveloper@anywhere.com',
      '1234',
      'New',
      'Developer',
      'a developer with many skills',
      'admin');
  createNewDeveloper(myNewDeveloper,context);
}

void testNewProject(thisDeveloper,context){
  Project myNewProject = new Project(
      'NoID',
      'New Project',
      'This is the greatest project ever!');
  createNewProject(thisDeveloper, myNewProject,context);
}

void testNewUserStory(thisProject, context){
  UserStory myNewUserStory = new UserStory(
      'NoID',
      'User story new',
      'developer',
      'user story',
      'to test new user story api',
      'acceptance tests',
      'conversation',
      5,
      '0',
      50,
      1,
      1,
      "NoProjectID");
  createNewUserStory(thisProject, myNewUserStory, context);
}

void testUpdateUserStory(thisProject,context){
  UserStory myUpDatedUserStory = new UserStory(
      'id',
      'User story updated 2',
      'developer up 2',
      'user story up 2',
      'to test new user story api up 2',
      'acceptance tests up 2',
      'conversation up 2',
      52,
      '2',
      02,
      12,
      12,
      "NoProjectID");
  editUserStory(thisProject, myUpDatedUserStory,context);
}

void testUpdateProject(thisDeveloper,myProjectIndex,context){
  Project myUpdateProject = new Project(
      'id',
      'This is edit project name',
      'Edited project description');
  editProject(thisDeveloper,myUpdateProject,myProjectIndex,context);
}

void testUpdateDeveloper(context){
  Developer myUpdatedDeveloper = new Developer(
      'id',
      'flutter@anywhere.com',
      '1234',
      'New edited',
      'Developer edited',
      'a developer with many skills edited',
      'admin edited');
  editDeveloper(myUpdatedDeveloper,context);
}

void testDeleteUserStory(myUserStoryIndex,context){
  deleteUserStory(myUserStoryIndex,context);
}

void testDeleteProject(myProjectIndex,context){
  deleteProject(myProjectIndex,context);
}