class Developer {
  String id;
  String firstName;
  String lastName;
  String email;
  String password;
  String bio;
  String role;
  List<dynamic> projectIds;

  Developer.fromJson(Map json) {
    this.id = json['_id'];
    this.firstName = json['firstName'];
    this.lastName = json['lastName'];
    this.email = json['email'];
    this.password = json['password'];
    this.bio = json['bio'];
    this.role = json['role'];
    this.projectIds = json['projectIds'];
  }
}

var myDeveloper;