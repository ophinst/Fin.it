class LoginResponseModel {
  final String? token;
  final String? error;

  LoginResponseModel({this.token, this.error});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    var data = json['data'] as Map<String, dynamic>;
    return LoginResponseModel(
      // token: json["token"] ?? "",
      // error: json["error"] ?? "",
      token: data['token'] as String?,
      error: json['message'] as String?,
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
