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
    String foundId;
    String uid;
    String itemName;
    String itemDescription;
    DateTime foundDate;
    String foundTime;
    String category;
    String latitude;
    String longitude;
    String locationDetail;
    String owner;

    Datum({
        required this.foundId,
        required this.uid,
        required this.itemName,
        required this.itemDescription,
        required this.foundDate,
        required this.foundTime,
        required this.category,
        required this.latitude,
        required this.longitude,
        required this.locationDetail,
        required this.owner,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        foundId: json["foundId"],
        uid: json["uid"],
        itemName: json["itemName"],
        itemDescription: json["itemDescription"],
        foundDate: DateTime.parse(json["foundDate"]),
        foundTime: json["foundTime"],
        category: json["category"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        locationDetail: json["locationDetail"],
        owner: json["owner"],
    );

    Map<String, dynamic> toJson() => {
        "foundId": foundId,
        "uid": uid,
        "itemName": itemName,
        "itemDescription": itemDescription,
        "foundDate": "${foundDate.year.toString().padLeft(4, '0')}-${foundDate.month.toString().padLeft(2, '0')}-${foundDate.day.toString().padLeft(2, '0')}",
        "foundTime": foundTime,
        "category": category,
        "latitude": latitude,
        "longitude": longitude,
        "locationDetail": locationDetail,
        "owner": owner,
    };
}
