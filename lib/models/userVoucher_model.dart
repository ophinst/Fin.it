// class ApiResponse {
//   final String message;
//   final UserData data;

//   ApiResponse({required this.message, required this.data});

//   factory ApiResponse.fromJson(Map<String, dynamic> json) {
//     return ApiResponse(
//       message: json['message'],
//       data: UserData.fromJson(json['data']),
//     );
//   }
// }

class UserData {
  final String uid;
  final String name;
  final String email;
  final String password;
  final String? phoneNumber;
  final String? image;
  final int points;
  final String createdAt;
  final String updatedAt;
  final List<Voucher> voucher;

  UserData({
    required this.uid,
    required this.name,
    required this.email,
    required this.password,
    this.phoneNumber,
    this.image,
    required this.points,
    required this.createdAt,
    required this.updatedAt,
    required this.voucher,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    var voucherFromJson = json['voucher'] as List;
    List<Voucher> voucherList =
        voucherFromJson.map((i) => Voucher.fromJson(i)).toList();

    return UserData(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
      image: json['image'],
      points: json['points'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      voucher: voucherList,
    );
  }
}

class Voucher {
  final String rewardId;
  final String rewardName;
  final int rewardStock;
  final int rewardPrice;
  final String rewardDescription;
  final String rewardExpiration;
  final String rewardImage;
  final String createdAt;
  final String updatedAt;
  final OwnedRewardCode ownedRewardCode;

  Voucher({
    required this.rewardId,
    required this.rewardName,
    required this.rewardStock,
    required this.rewardPrice,
    required this.rewardDescription,
    required this.rewardExpiration,
    required this.rewardImage,
    required this.createdAt,
    required this.updatedAt,
    required this.ownedRewardCode,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      rewardId: json['rewardId'],
      rewardName: json['rewardName'],
      rewardStock: json['rewardStock'],
      rewardPrice: json['rewardPrice'],
      rewardDescription: json['rewardDescription'],
      rewardExpiration: json['rewardExpiration'],
      rewardImage: json['rewardImage'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      ownedRewardCode: OwnedRewardCode.fromJson(json['ownedRewardCode']),
    );
  }
}

class OwnedRewardCode {
  final List<String> rewardCode;

  OwnedRewardCode({required this.rewardCode});

  factory OwnedRewardCode.fromJson(Map<String, dynamic> json) {
    var rewardCodeFromJson = json['rewardCode'] as List;
    // Safely convert each item in the list to a string
    List<String> rewardCodeList =
        rewardCodeFromJson.map((item) => item.toString()).toList();

    return OwnedRewardCode(
      rewardCode: rewardCodeList,
    );
  }
}
