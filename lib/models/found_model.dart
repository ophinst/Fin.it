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