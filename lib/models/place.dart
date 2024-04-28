class PlaceLocation {
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    this.locationDetail,
  });
  
  final double latitude;
  final double longitude;
  final String? locationDetail;

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'locationDetail': locationDetail,
    };
  }
}