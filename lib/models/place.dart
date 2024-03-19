class PlaceLocation {
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.locationDetail,
  });
  
  final String latitude;
  final String longitude;
  final String locationDetail;


  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'locationDetail': locationDetail,
    };
  }
}
