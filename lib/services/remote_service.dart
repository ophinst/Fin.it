import 'dart:convert';
import 'package:capstone_project/models/foundItem.dart';
import 'package:capstone_project/models/loginModel.dart';
import 'package:http/http.dart' as http;

class RemoteService {
  final Map<String, String> _locationCache = {};
  final String url = "https://finit-api-ahawuso3sq-et.a.run.app/api";
  Future<List<Datum>?> getLostItems() async {
    var client = http.Client();

    var uri = Uri.parse('$url/lost');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      return foundFromJson(json).data;
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

    final apiKey = 'AIzaSyASFVu9SBYHG2TUxFRs3ArQrv8phoWMjDo';
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

  //login
  Future<LoginResponseModel> login(LoginRequestModel loginRequestModel) async {
    var uriLog = Uri.parse("$url/auth/login");

    final response = await http.post(
      uriLog,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(loginRequestModel.toJson()),
    );

    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(
        jsonDecode(response.body),
      );
    } else if (response.statusCode == 401) {
      return LoginResponseModel(
          error: 'Unauthorized: Please check your credentials');
    } else {
      print('Failed to fetch data: ${response.statusCode}');
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }
}
