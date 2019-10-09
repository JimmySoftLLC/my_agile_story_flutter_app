class Developer {
  String id;
  String email;
  String password;
  String firstName;
  String lastName;
  String bio;
  String role;
  String timeStampISO;
  List<dynamic> projectIds;

  Developer (id,email,password,firstName,lastName,bio,role) {
    this.id = id;
    this.email = email;
    this.password = password;
    this.firstName = firstName;
    this.lastName = lastName;
    this.bio = bio;
    this.role = role;
  }

  Developer.fromJson(Map json) {
    this.id = json['_id'];
    this.email = json['email'];
    this.password = json['password'];
    this.firstName = json['firstName'];
    this.lastName = json['lastName'];
    this.bio = json['bio'];
    this.role = json['role'];
    this.projectIds = json['projectIds'];
    this.timeStampISO = json['timeStampISO'];
  }

  Developer.fromJsonNested(Map json) {
    this.id = json['developer']['_id'];
    this.email = json['developer']['email'];
    this.password = json['developer']['password'];
    this.firstName = json['developer']['firstName'];
    this.lastName = json['developer']['lastName'];
    this.bio = json['developer']['bio'];
    this.role = json['developer']['role'];
    this.projectIds = json['developer']['projectIds'];
    this.timeStampISO = json['developer']['timeStampISO'];
  }
}

var myDeveloper;