class Project {
  String id;
  String name;
  String description;
  List<dynamic> userStoryIds;
  List<dynamic> bugIds;
  List<dynamic> developers;
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
    this.userStoryIds = json['userStoryIds'];
    this.bugIds = json['bugIds'];
    this.developers = json['developers'];
    this.timeStampISO = json['timeStampISO'];
  }

  Project.fromJsonNested(Map json) {
    this.id = json['project']['_id'];
    this.name = json['project']['name'];
    this.description = json['project']['description'];
    this.userStoryIds = json['project']['userStoryIds'];
    this.bugIds = json['project']['bugIds'];
    this.developers = json['project']['developers'];
    this.timeStampISO = json['project']['timeStampISO'];
  }
}

var myProjects = [];