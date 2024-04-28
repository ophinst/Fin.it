import 'package:capstone_project/models/place.dart';

class LostModel {
  final String image;
  final String itemName;
  final String itemDescription;
  final String lostDate;
  final String lostTime;
  final String category;
  final PlaceLocation placeLocation;

  LostModel({
    required this.image,
    required this.itemName,
    required this.itemDescription,
    required this.lostDate,
    required this.lostTime,
    required this.category,
    required this.placeLocation,
  });

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'itemName': itemName,
      'itemDescription': itemDescription,
      'lostDate': lostDate,
      'lostTime': lostTime,
      'category': category,
      'placeLocation': {
        'latitude': placeLocation.latitude,
        'longitude': placeLocation.longitude,
      },
    };
  }
}
