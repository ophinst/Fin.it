class VoucherResponse {
  String message;
  dynamic data;

  VoucherResponse({
    required this.message,
    required this.data,
  });

  factory VoucherResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] is List) {
      return VoucherResponse(
        message: json['message'],
        data: List<GetVoucherModel>.from(
            json['data'].map((x) => GetVoucherModel.fromJson(x))),
      );
    } else if (json['data'] is Map<String, dynamic>) {
      return VoucherResponse(
        message: json['message'],
        data: GetVoucherModel.fromJson(json['data']),
      );
    } else {
      throw Exception("Invalid data type for 'data' field in JSON");
    }
  }
}

class GetVoucherModel {
  final String rewardId;
  final String rewardName;
  final String rewardStock;
  final String rewardPrice;
  final String rewardDescription;
  final String rewardExpiration;
  final String rewardImage;
  final String createdAt;
  final String updatedAt;

  GetVoucherModel({
    required this.rewardId,
    required this.rewardName,
    required this.rewardStock,
    required this.rewardPrice,
    required this.rewardDescription,
    required this.rewardExpiration,
    required this.rewardImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetVoucherModel.fromJson(Map<String, dynamic> json) =>
      GetVoucherModel(
        rewardId: json['rewardId'],
        rewardName: json['rewardName'],
        rewardStock: json['rewardStock'].toString(),
        rewardPrice: json['rewardPrice'].toString(),
        rewardDescription: json['rewardDescription'],
        rewardExpiration: json['rewardExpiration'],
        rewardImage: json['rewardImage'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
      );
  Map<String, dynamic> toJson() => {
        "rewardId": rewardId,
        "rewardName": rewardName,
        "rewardStock": rewardStock,
        "rewardPrice": rewardPrice,
        "rewardDescription": rewardDescription,
        "rewardExpiration": rewardExpiration,
        "rewardImage": rewardImage,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
