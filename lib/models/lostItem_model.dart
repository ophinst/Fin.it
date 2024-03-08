
// Class for API response containing single data object or a list of data
class FoundResponse {
  String message;
  dynamic data;

  FoundResponse({
    required this.message,
    required this.data,
  });

  factory FoundResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] is List) {
      return FoundResponse(
        message: json['message'],
        data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
      );
    } else if (json['data'] is Map<String, dynamic>) {
      return FoundResponse(
        message: json['message'],
        data: Datum.fromJson(json['data']),
      );
    } else {
      throw Exception("Invalid data type for 'data' field in JSON");
    }
  }
}

class Datum {
  String lostId;
  String uid;
  String itemName;
  String itemImage;
  String? itemDescription;
  DateTime? lostDate;
  String? lostTime;
  String category;
  String latitude;
  String longitude;
  bool? status;
  String lostOwner;

  Datum({
    required this.lostId,
    required this.uid,
    required this.itemName,
    required this.itemImage,
    this.itemDescription,
    this.lostDate,
    this.lostTime,
    required this.category,
    required this.latitude,
    required this.longitude,
    this.status,
    required this.lostOwner,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        lostId: json["lostId"],
        uid: json["uid"],
        itemName: json["itemName"],
        itemImage: json["itemImage"],
        itemDescription: json["itemDescription"],
        lostDate: json["lostDate"] != null ? DateTime.parse(json["lostDate"]) : null,
        lostTime: json["lostTime"],
        category: json["category"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        status: json["status"],
        lostOwner: json["lostOwner"],
      );

  Map<String, dynamic> toJson() => {
        "lostId": lostId,
        "uid": uid,
        "itemName": itemName,
        "itemImage": itemImage,
        "itemDescription": itemDescription,
        "lostDate": lostDate != null ? "${lostDate!.day}-${lostDate!.month}-${lostDate!.year}" : null,
        "lostTime": lostTime != null ? "${DateTime.parse(lostTime!).hour}:${DateTime.parse(lostTime!).minute}" : null,
        "category": category,
        "latitude": latitude,
        "longitude": longitude,
        "status": status,
        "lostOwner": lostOwner,
      };
}
