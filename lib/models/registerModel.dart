// class RegisterResponseModel {
//   // final bool success;
//   final String? message;
//   final RegisterRequestModel? data;

//   RegisterResponseModel({
//     // required this.success,
//     this.message,
//     this.data,
//   });

//   factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
//     return RegisterResponseModel(
//       // success: json['success'],
//       message: json['message'],
//       data: json['data'] != null
//           ? RegisterRequestModel.fromJson(json['data'])
//           : null,
//     );
//   }
// }

// class RegisterRequestModel {
//   final String name;
//   final String email;
//   final String token;

//   RegisterRequestModel({
//     required this.name,
//     required this.email,
//     required this.token,
//   });

//   factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
//     return RegisterRequestModel(
//       name: json['name'],
//       email: json['email'],
//       token: json['token'],
//     );
//   }
// }

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
  String? vpassword;

  RegisterRequestModel({
    this.name,
    this.email,
    this.password,
    this.vpassword,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'name': name?.trim(),
      'email': email?.trim(),
      'password': password?.trim(),
      'vpassword': vpassword?.trim(),
    };

    return map;
  }
}
