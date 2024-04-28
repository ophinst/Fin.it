class LostResponse {
  String message;
  dynamic data;

  LostResponse({
    required this.message,
    required this.data,
  });

  factory LostResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] is List) {
      return LostResponse(
        message: json['message'],
        data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
      );
    } else if (json['data'] is Map<String, dynamic>) {
      return LostResponse(
        message: json['message'],
        data: Datum.fromJson(json['data']),
      );
    } else {
      throw Exception("Invalid data type for 'data' field in JSON");
    }
  }
}

class Datum {
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
  final bool status;
  final String lostOwner;

  Datum({
    required this.lostId,
    required this.uid,
    required this.itemName,
    required this.itemImage,
    required this.itemDescription,
    required this.lostDate,
    required this.lostTime,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.lostOwner,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
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
      status: json['completionStatus'],
      lostOwner: json['lostOwner'],
    );
  }
}
