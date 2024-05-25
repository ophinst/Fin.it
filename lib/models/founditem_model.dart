
class FoundItem {
  String? foundId;
  String? itemName;
  String? itemDescription;
  String? foundDate;
  String? foundTime;
  double? latitude;
  double? longitude;
  String? locationDetail;
  String? foundOwner;

  FoundItem({
    this.foundId,
    this.itemName,
    this.itemDescription,
    this.foundDate,
    this.foundTime,
    this.latitude,
    this.longitude,
    this.locationDetail,
    this.foundOwner,
  });

  factory FoundItem.fromJson(Map<String, dynamic> json) {
    return FoundItem(
      foundId: json['foundId'],
      itemName: json['itemName'],
      itemDescription: json['itemDescription'],
      foundDate: json['foundDate'],
      foundTime: json['foundTime'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      locationDetail: json['locationDetail'],
      foundOwner: json['foundOwner'],
    );
  }
}