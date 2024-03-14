class RegisterResponseModel {
  // final bool success;
  final String? message;
  final String? token;

  RegisterResponseModel({
    // required this.success,
    this.message,
    this.token,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    var data = json['data'];
    var mess = json['message'];

    // Check if data is a Map, otherwise try to use it as a String
    var token = data is Map<String, dynamic> ? data['token'] as String? : null;

    // Check if mess is a Map, otherwise try to use it as a String
    var message =
        mess is Map<String, dynamic> ? mess['message'] as String? : null;

    return RegisterResponseModel(
      token: token,
      message: message,
    );
  }
}

class RegisterRequestModel {
  String? name;
  String? email;
  String? password;
  String? confirmPassword;

  RegisterRequestModel({
    this.name,
    this.email,
    this.password,
    this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'name': name?.trim(),
      'email': email?.trim(),
      'password': password?.trim(),
      'confirmPassword': confirmPassword?.trim(),
    };

    return map;
  }
}
