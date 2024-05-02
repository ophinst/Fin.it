import 'package:capstone_project/models/found_model.dart';
import 'package:capstone_project/models/place.dart';

class FoundNearItem {
  final String foundId;
  final String uid;
  final String itemName;
  final String itemDescription;
  final String foundDate;
  final String foundTime;
  final String category;
  final double latitude;
  final double longitude;
  final String locationDetail;
  final bool completionStatus;
  final bool lostUserStatus;
  final bool foundUserStatus;
  final String createdAt;
  final String updatedAt;
  final String foundOwner;
  final String type;

  FoundNearItem(
      {required this.foundId,
      required this.uid,
      required this.itemName,
      required this.itemDescription,
      required this.foundDate,
      required this.foundTime,
      required this.category,
      required this.latitude,
      required this.longitude,
      required this.locationDetail,
      required this.completionStatus,
      required this.lostUserStatus,
      required this.foundUserStatus,
      required this.createdAt,
      required this.updatedAt,
      required this.foundOwner,
      required this.type});

  factory FoundNearItem.fromJson(Map<String, dynamic> json) {
    return FoundNearItem(
      foundId: json['foundId'],
      uid: json['uid'],
      itemName: json['itemName'],
      itemDescription: json['itemDescription'],
      foundDate: json['foundDate'],
      foundTime: json['foundTime'],
      category: json['category'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      locationDetail: json['locationDetail'],
      completionStatus: json['completionStatus'],
      lostUserStatus: json['lostUserStatus'],
      foundUserStatus: json['foundUserStatus'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      foundOwner: json['foundOwner'],
      type: json['type'],
    );
  }

  GetFoundModel toGetFoundModel() {
    return GetFoundModel(
      foundId: foundId,
      uid: uid,
      itemName: itemName,
      itemDescription: itemDescription,
      foundDate: foundDate,
      foundTime: foundTime,
      category: category,
      placeLocation: PlaceLocation(
        latitude: latitude,
        longitude: longitude,
        locationDetail: locationDetail,
      ),
      foundOwner: foundOwner,
    );
  }
}

class LostNearItem {
  final String lostId;
  final String uid;
  final String itemName;
  final String itemImage;
  final String itemDescription;
  final String lostDate;
  final String lostTime;
  final String category;
  final double latitude;
  final double longitude;
  final String locationDetail;
  final bool completionStatus;
  final bool lostUserStatus;
  final bool foundUserStatus;
  final dynamic foundUserId;
  final String createdAt;
  final String updatedAt;
  final String lostOwner;
  final String type;

  LostNearItem(
      {required this.lostId,
      required this.uid,
      required this.itemName,
      required this.itemImage,
      required this.itemDescription,
      required this.lostDate,
      required this.lostTime,
      required this.category,
      required this.latitude,
      required this.longitude,
      required this.locationDetail,
      required this.completionStatus,
      required this.lostUserStatus,
      required this.foundUserStatus,
      required this.foundUserId,
      required this.createdAt,
      required this.updatedAt,
      required this.lostOwner,
      required this.type});

  factory LostNearItem.fromJson(Map<String, dynamic> json) {
    return LostNearItem(
      lostId: json['lostId'],
      uid: json['uid'],
      itemName: json['itemName'],
      itemImage: json['itemImage'],
      itemDescription: json['itemDescription'],
      lostDate: json['lostDate'],
      lostTime: json['lostTime'],
      category: json['category'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      locationDetail: json['locationDetail'],
      completionStatus: json['completionStatus'],
      lostUserStatus: json['lostUserStatus'],
      foundUserStatus: json['foundUserStatus'],
      foundUserId: json['foundUserId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      lostOwner: json['lostOwner'],
      type: json['type'],
    );
  }
}
