class LostAct {
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
  final dynamic locationDetail;
  final bool completionStatus;
  final bool lostUserStatus;
  final bool foundUserStatus;
  final String? foundUserId;
  final DateTime createdAt;
  final DateTime updatedAt;

  LostAct({
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
    this.locationDetail,
    required this.completionStatus,
    required this.lostUserStatus,
    required this.foundUserStatus,
    this.foundUserId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LostAct.fromJson(Map<String, dynamic> json) {
    return LostAct(
      lostId: json['lostId'],
      uid: json['uid'],
      itemName: json['itemName'],
      itemImage: json['itemImage'],
      itemDescription: json['itemDescription'],
      lostDate: json['lostDate'],
      lostTime: json['lostTime'],
      category: json['category'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      locationDetail: json['locationDetail'],
      completionStatus: json['completionStatus'],
      lostUserStatus: json['lostUserStatus'],
      foundUserStatus: json['foundUserStatus'],
      foundUserId: json['foundUserId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class FoundAct {
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

  FoundAct({
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
    required this.completionStatus,
    required this.lostUserStatus,
    required this.foundUserStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FoundAct.fromJson(Map<String, dynamic> json) {
    return FoundAct(
      foundId: json['foundId'],
      uid: json['uid'],
      itemName: json['itemName'],
      itemDescription: json['itemDescription'],
      foundDate: json['foundDate'],
      foundTime: json['foundTime'],
      category: json['category'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      locationDetail: json['locationDetail'],
      completionStatus: json['completionStatus'],
      lostUserStatus: json['lostUserStatus'],
      foundUserStatus: json['foundUserStatus'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
