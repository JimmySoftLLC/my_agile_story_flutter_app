class Project {
  String id;
  String name;
  String description;
  List<dynamic> developerIds;
  List<dynamic> userStoryIds;
  String timeStampISO;

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
    this.timeStampISO = json['timeStampISO'];
  }

  Project.fromJsonNested(Map json) {
    this.id = json['project']['_id'];
    this.name = json['project']['name'];
    this.description = json['project']['description'];
    this.developerIds = json['project']['developerIds'];
    this.userStoryIds = json['project']['userStoryIds'];
    this.timeStampISO = json['project']['timeStampISO'];
  }
}

var myProjects = [];