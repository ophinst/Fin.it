import 'dart:convert';
import 'package:capstone_project/models/lostItem_model.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

class RemoteService {
  final Map<String, String> _locationCache = {};

  // Future<List<Datum>?> getLostItems() async {
  //   var client = http.Client();

  //   var uri = Uri.parse('https://finit-api-ahawuso3sq-et.a.run.app/api/lost');
  //   var response = await client.get(uri);
  //   if (response.statusCode == 200) {
  //     var json = response.body;
  //     // print(foundFromJson(json).data);
  //     return foundFromJson(json).data;
  //   } else {
  //     // Handle error appropriately
  //     print('Failed to fetch data: ${response.statusCode}');
  //     return null;
  //   }
  // }

  Future<dynamic> getLostItems() async {
  var client = http.Client();

  var uri = Uri.parse('https://finit-api-ahawuso3sq-et.a.run.app/api/lost');
  var response = await client.get(uri);
  if (response.statusCode == 200) {
    var json = response.body;
    var foundResponse = FoundResponse.fromJson(jsonDecode(json));
    return foundResponse.data;
  } else {
    // Handle error appropriately
    print('Failed to fetch data: ${response.statusCode}');
    return null;
  }
}

  Future<String> getLocationName(double latitude, double longitude) async {
    final cacheKey = '$latitude,$longitude';

    // Check if location is already in cache
    if (_locationCache.containsKey(cacheKey)) {
      return _locationCache[cacheKey]!;
    }

    String apiKey = '';

    // apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    apiKey = Platform.environment['GOOGLE_MAPS_API_KEY'] ?? '';

    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      final results = decodedResponse['results'];
      if (results != null && results.isNotEmpty) {
        final locationName = results[0]['formatted_address'];
        // Store location in cache
        _locationCache[cacheKey] = locationName;
        return locationName;
      }
    }
    return 'Location address not found';
  }

  Future<Datum?> getLostItemById(String lostId) async {
  var client = http.Client();

  var uri = Uri.parse('https://finit-api-ahawuso3sq-et.a.run.app/api/lost/$lostId');
  var response = await client.get(uri);
  if (response.statusCode == 200) {
    var json = response.body;
    print('Response: $json');
    var foundResponse = FoundResponse.fromJson(jsonDecode(json));
    // If data is a list, return the first item (assuming lostId is unique)
    if (foundResponse.data is List<Datum>) {
      List<Datum> dataList = foundResponse.data;
      if (dataList.isNotEmpty) {
        return dataList.first;
      }
    }
    // If data is a single Datum object, return it directly
    if (foundResponse.data is Datum) {
      return foundResponse.data;
    }
  } else {
    // Handle error appropriately
    print('Failed to fetch data: ${response.statusCode}');
  }
  return null;
}
}
