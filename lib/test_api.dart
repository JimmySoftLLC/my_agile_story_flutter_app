import 'api_requests.dart';
import 'developer.dart';
import 'project.dart';
import 'user_story.dart';

void testNewDeveloper(){
  Developer myNewDeveloper = new Developer(
      'NoID',
      'newdeveloper@anywhere.com',
      '1234',
      'New',
      'Developer',
      'a developer with many skills',
      'admin');
  createNewDeveloper(myNewDeveloper);
}

void testNewProject(thisDeveloper){
  Project myNewProject = new Project(
      'NoID',
      'New Project',
      'This is the greatest project ever!');
  createNewProject(thisDeveloper, myNewProject);
}

void testNewUserStory(thisProject){
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
  createNewUserStory(thisProject, myNewUserStory);
}

void testUpdateUserStory(thisProject){
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
  editUserStory(thisProject, myUpDatedUserStory);
}

void testUpdateProject(thisDeveloper,myProjectIndex){
  Project myUpdateProject = new Project(
      'id',
      'This is edit project name',
      'Edited project description');
  editProject(thisDeveloper,myUpdateProject,myProjectIndex);
}

//testUpdateDeveloper(myDeveloper);

void testUpdateDeveloper(){
  Developer myUpdatedDeveloper = new Developer(
      'id',
      'flutter@anywhere.com',
      '1234',
      'New edited',
      'Developer edited',
      'a developer with many skills edited',
      'admin edited');
  editDeveloper(myUpdatedDeveloper);
}

void testDeleteUserStory(myUserStoryIndex){
  deleteUserStory(myUserStoryIndex);
}

void testDeleteProject(myProjectIndex){
  deleteProject(myProjectIndex);
}