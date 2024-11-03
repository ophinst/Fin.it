class RegisterResponseModel {
  final String? message;
  final String? role;
  final String? token;
  final String? name;
  final String? uid;
  RegisterResponseModel({this.role, this.message, this.token, this.name, this.uid});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    var data = json['data'];
    var mess = json['message'];

    // Check if data is a Map, otherwise try to use it as a String
    var role = data != null ? data['role'] as String? : null;
    var token = data is Map<String, dynamic> ? data['token'] as String? : null;
    var name = data != null ? data['name'] as String? : null;
    var uid = data != null ? data['uid'] as String? : null;
    // Check if mess is a Map, otherwise try to use it as a String
    var message =
        mess is Map<String, dynamic> ? mess['message'] as String? : null;

    return RegisterResponseModel(
      role: role,
      token: token,
      message: message,
      name: name,
      uid: uid,
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
