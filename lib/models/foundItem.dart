// To parse this JSON data, do
//
//     final found = foundFromJson(jsonString);

import 'dart:convert';

Found foundFromJson(String str) => Found.fromJson(json.decode(str));

String foundToJson(Found data) => json.encode(data.toJson());

class Found {
    String message;
    List<Datum> data;

    Found({
        required this.message,
        required this.data,
    });

    factory Found.fromJson(Map<String, dynamic> json) => Found(
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String lostId;
    String uid;
    String itemName;
    String itemImage;
    String category;
    String latitude;
    String longitude;
    String lostOwner;

    Datum({
        required this.lostId,
        required this.uid,
        required this.itemName,
        required this.itemImage,
        required this.category,
        required this.latitude,
        required this.longitude,
        required this.lostOwner,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        lostId: json["lostId"],
        uid: json["uid"],
        itemName: json["itemName"],
        itemImage: json["itemImage"],
        category: json["category"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        lostOwner: json["lostOwner"],
    );

    Map<String, dynamic> toJson() => {
        "lostId": lostId,
        "uid": uid,
        "itemName": itemName,
        "itemImage": itemImage,
        "category": category,
        "latitude": latitude,
        "longitude": longitude,
        "lostOwner": lostOwner,
    };
}
