class LoginResponseModel {
  final String? token;
  final String? error;
  final String? name;
  final String? uid;

  LoginResponseModel({this.token, this.error, this.name, this.uid});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    var data = json['data'];
    var mess = json['message'];

    // Check if data is a Map, otherwise try to use it as a String
    var token = data is Map<String, dynamic> ? data['token'] as String? : null;
    var name = data != null ? data['name'] as String? : null;
    var uid = data != null ? data['uid'] as String? : null;

    // Check if mess is a Map, otherwise try to use it as a String
    var error =
        mess is Map<String, dynamic> ? mess['message'] as String? : null;

    return LoginResponseModel(
      token: token,
      error: error,
      name: name,
      uid: uid,
    );
  }
}

class LoginRequestModel {
  String? email;
  String? password;

  LoginRequestModel({
    this.email,
    this.password,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'email': email?.trim(),
      'password': password?.trim(),
    };

    return map;
  }
}
