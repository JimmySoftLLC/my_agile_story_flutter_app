class ApiError{
  String error;
  ApiError.fromJson(Map json) {
    this.error = json['error'];
  }
}

var myApiError;