class Bug {
  String id;
  String bugTitle;
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
  List<dynamic> votes;
  String timeStampISO;

  Bug (id,bugTitle,userRole,userWant,userBenefit,acceptanceCriteria,conversation,estimate,phase,percentDone,priority,sprint,projectId) {
    this.id = id;
    this.bugTitle = bugTitle;
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

  Bug.fromJson(Map json) {
    this.id = json['_id'];
    this.bugTitle = json['bugTitle'];
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
    this.votes = json['votes'];
    this.timeStampISO = json['timeStampISO'];
  }

  Bug.fromJsonNested(Map json) {
    this.id = json['bug']['_id'];
    this.bugTitle = json['bug']['bugTitle'];
    this.userRole = json['bug']['userRole'];
    this.userBenefit = json['bug']['userBenefit'];
    this.acceptanceCriteria = json['bug']['acceptanceCriteria'];
    this.conversation = json['bug']['conversation'];
    this.estimate = json['bug']['estimate'];
    this.userWant = json['bug']['userWant'];
    this.phase = json['bug']['phase'];
    this.percentDone = json['bug']['percentDone'];
    this.priority = json['bug']['priority'];
    this.sprint = json['bug']['sprint'];
    this.projectId = json['bug']['projectId'];
    this.votes = json['bug']['votes'];
    this.timeStampISO = json['bug']['timeStampISO'];
  }
}

var myBugs = [];