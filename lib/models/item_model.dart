import 'dart:convert';

class ItemResponse {
  final String message;
  final List<ItemModel> data;

  ItemResponse({
    required this.message,
    required this.data,
  });

  factory ItemResponse.fromJson(String source) =>
      ItemResponse.fromMap(json.decode(source));

  factory ItemResponse.fromMap(Map<String, dynamic> map) {
    return ItemResponse(
      message: map['message'],
      data: List<ItemModel>.from(map['data']?.map((x) => ItemModel.fromMap(x))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}

class ItemModel {
  final String? foundId;
  final String? lostId;
  final String uid;
  final String itemName;
  final String? itemImage;
  final String itemDescription;
  final String? foundDate;
  final String? foundTime;
  final String? lostDate;
  final String? lostTime;
  final String category;
  final double latitude;
  final double longitude;
  final String locationDetail;
  final bool completionStatus;
  final bool lostUserStatus;
  final bool foundUserStatus;
  final String createdAt;
  final String updatedAt;
  final String? foundUserId;

  ItemModel({
    this.foundId,
    this.lostId,
    required this.uid,
    required this.itemName,
    this.itemImage,
    required this.itemDescription,
    this.foundDate,
    this.foundTime,
    this.lostDate,
    this.lostTime,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.locationDetail,
    required this.completionStatus,
    required this.lostUserStatus,
    required this.foundUserStatus,
    required this.createdAt,
    required this.updatedAt,
    this.foundUserId,
  });

  factory ItemModel.fromJson(String source) => ItemModel.fromMap(json.decode(source));

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      foundId: map['foundId'],
      lostId: map['lostId'],
      uid: map['uid'],
      itemName: map['itemName'],
      itemImage: map['itemImage'],
      itemDescription: map['itemDescription'],
      foundDate: map['foundDate'],
      foundTime: map['foundTime'],
      lostDate: map['lostDate'],
      lostTime: map['lostTime'],
      category: map['category'],
      latitude: map['latitude'].toDouble(),
      longitude: map['longitude'].toDouble(),
      locationDetail: map['locationDetail'],
      completionStatus: map['completionStatus'],
      lostUserStatus: map['lostUserStatus'],
      foundUserStatus: map['foundUserStatus'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      foundUserId: map['foundUserId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'foundId': foundId,
      'lostId': lostId,
      'uid': uid,
      'itemName': itemName,
      'itemImage': itemImage,
      'itemDescription': itemDescription,
      'foundDate': foundDate,
      'foundTime': foundTime,
      'lostDate': lostDate,
      'lostTime': lostTime,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'locationDetail': locationDetail,
      'completionStatus': completionStatus,
      'lostUserStatus': lostUserStatus,
      'foundUserStatus': foundUserStatus,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'foundUserId': foundUserId,
    };
  }

  String toJson() => json.encode(toMap());
}
