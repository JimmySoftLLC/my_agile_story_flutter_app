class UserStory {
  String id;
  String userStoryTitle;
  String userRole;
  String userWant;
  String userBenefit;
  String acceptanceCriteria;
  String conversation;
  int estimate;
  String phase;
  int percentDone;
  int priority;
  int sprint;
  String projectId;
  String timeStampISO;

  UserStory (id,userStoryTitle,userRole,userWant,userBenefit,acceptanceCriteria,conversation,estimate,phase,percentDone,priority,sprint,projectId) {
    this.id = id;
    this.userStoryTitle = userStoryTitle;
    this.userRole = userRole;
    this.userWant = userWant;
    this.userBenefit = userBenefit;
    this.acceptanceCriteria = acceptanceCriteria;
    this.conversation = conversation;
    this.estimate = estimate;
    this.phase = phase;
    this.percentDone = percentDone;
    this.priority = priority;
    this.sprint = sprint;
    this.projectId = projectId;
  }

  UserStory.fromJson(Map json) {
    this.id = json['_id'];
    this.userStoryTitle = json['userStoryTitle'];
    this.userRole = json['userRole'];
    this.userBenefit = json['userBenefit'];
    this.acceptanceCriteria = json['acceptanceCriteria'];
    this.conversation = json['conversation'];
    this.estimate = json['estimate'];
    this.userWant = json['userWant'];
    this.phase = json['phase'];
    this.percentDone = json['percentDone'];
    this.priority = json['priority'];
    this.sprint = json['sprint'];
    this.projectId = json['projectId'];
    this.timeStampISO = json['timeStampISO'];
  }

  UserStory.fromJsonNested(Map json) {
    this.id = json['userStory']['_id'];
    this.userStoryTitle = json['userStory']['userStoryTitle'];
    this.userRole = json['userStory']['userRole'];
    this.userBenefit = json['userStory']['userBenefit'];
    this.acceptanceCriteria = json['userStory']['acceptanceCriteria'];
    this.conversation = json['userStory']['conversation'];
    this.estimate = json['userStory']['estimate'];
    this.userWant = json['userStory']['userWant'];
    this.phase = json['userStory']['phase'];
    this.percentDone = json['userStory']['percentDone'];
    this.priority = json['userStory']['priority'];
    this.sprint = json['userStory']['sprint'];
    this.projectId = json['userStory']['projectId'];
    this.timeStampISO = json['userStory']['timeStampISO'];
  }
}

var myUserStorys = [];