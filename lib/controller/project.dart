class Project {
  String id;
  String name;
  String description;
  List<dynamic> developerIds;
  List<dynamic> userStoryIds;

  Project (id,name,description) {
    this.id = id;
    this.name = name;
    this.description = description;
  }

  Project.fromJson(Map json) {
    this.id = json['_id'];
    this.name = json['name'];
    this.description = json['description'];
    this.developerIds = json['developerIds'];
    this.userStoryIds = json['userStoryIds'];
  }
}

var myProject;
var myProjects = [];