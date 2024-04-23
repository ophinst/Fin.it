import 'package:capstone_project/models/place.dart';

class FoundModel {
  final String itemName;
  final String itemDescription;
  final String foundDate;
  final String foundTime;
  final String category;
  final PlaceLocation placeLocation;

  FoundModel({
    required this.itemName,
    required this.itemDescription,
    required this.foundDate,
    required this.foundTime,
    required this.category,
    required this.placeLocation,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'itemDescription': itemDescription,
      'foundDate': foundDate,
      'foundTime': foundTime,
      'category': category,
      ...placeLocation.toJson(),
    };
  }
}

class GetFoundModel {
  final String foundId;
  final String uid;
  final String itemName;
  final String itemDescription;
  final String foundDate;
  final String foundTime;
  final String category;
  final PlaceLocation placeLocation;
  final String foundOwner;

  GetFoundModel({
    required this.foundId,
    required this.uid,
    required this.itemName,
    required this.itemDescription,
    required this.foundDate,
    required this.foundTime,
    required this.category,
    required this.placeLocation,
    required this.foundOwner,
  });

  factory GetFoundModel.fromJson(Map<String, dynamic> json) {
    return GetFoundModel(
      foundId: json['foundId'],
      uid: json['uid'],
      itemName: json['itemName'],
      itemDescription: json['itemDescription'],
      foundDate: json['foundDate'],
      foundTime: json['foundTime'],
      category: json['category'],
      placeLocation: PlaceLocation(
        latitude: json['latitude'],
        longitude: json['longitude'],
        locationDetail: json['locationDetail'],
      ),
      foundOwner: json['foundOwner'],
    );
  }
}