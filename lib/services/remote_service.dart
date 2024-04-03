import 'dart:convert';
import 'package:capstone_project/models/chat_model.dart';
import 'package:capstone_project/models/lost_item_model.dart';
import 'package:capstone_project/models/loginModel.dart';
import 'package:capstone_project/models/message_model.dart';
import 'package:capstone_project/models/registerModel.dart';
import 'package:capstone_project/models/user_model.dart';

import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

class RemoteService {
  final Map<String, String> _locationCache = {};
  final String url = "https://finit-api-ahawuso3sq-et.a.run.app/api";

  Future<dynamic> getLostItems() async {
    var client = http.Client();

    var uri = Uri.parse('$url/lost');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      var lostResponse = LostResponse.fromJson(jsonDecode(json));
      return lostResponse.data;
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

    var uri =
        Uri.parse('https://finit-api-ahawuso3sq-et.a.run.app/api/lost/$lostId');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      print('Response: $json');
      var lostResponse = LostResponse.fromJson(jsonDecode(json));
      // If data is a list, return the first item (assuming lostId is unique)
      if (lostResponse.data is List<Datum>) {
        List<Datum> dataList = lostResponse.data;
        if (dataList.isNotEmpty) {
          return dataList.first;
        }
      }
      // If data is a single Datum object, return it directly
      if (lostResponse.data is Datum) {
        return lostResponse.data;
      }
    } else {
      // Handle error appropriately
      print('Failed to fetch data: ${response.statusCode}');
    }
    return null;
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
    } else if (response.statusCode == 400) {
      return LoginResponseModel(error: 'Please Input your credential');
    } else {
      print('Failed to fetch data: ${response.statusCode}');
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }

  //register
  Future<RegisterResponseModel> register(
      RegisterRequestModel registerRequestModel) async {
    var uriReg = Uri.parse('$url/auth/register');

    final response = await http.post(
      uriReg,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(registerRequestModel.toJson()),
    );

    if (response.statusCode == 201) {
      return RegisterResponseModel.fromJson(
        jsonDecode(response.body),
      );
    } else if (response.statusCode == 401) {
      return RegisterResponseModel(
          message: 'Unauthorized: Please check your credentials');
    } else if (response.statusCode == 400) {
      return RegisterResponseModel(message: 'Please Input your credential');
    } else {
      print('Failed to fetch data: ${response.statusCode}');
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }

  Future<User?> getUserById(String userId) async {
    var client = http.Client();

    var uri = Uri.parse('$url/user/$userId');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      var userData = jsonDecode(json)['data'];
      if (userData != null) {
        return User.fromJson(userData);
      }
    } else {
      print('Failed to fetch user data: ${response.statusCode}');
    }
    return null;
  }

  // Future<List<Chat>> getChats(String userId, String token) async {
  //   var client = http.Client();

  //   var uri = Uri.parse('$url/chat/$userId');
  //   var response = await client.get(
  //     uri,
  //     headers: {
  //       HttpHeaders.authorizationHeader: 'Bearer $token',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     var jsonData = jsonDecode(response.body);
  //     var chatData = jsonData['data'] as List<dynamic>;
  //     return chatData.map((json) => Chat.fromJson(json)).toList();
  //   } else {
  //     print('Failed to fetch chats: ${response.statusCode}');
  //     throw Exception('Failed to fetch chats: ${response.statusCode}');
  //   }
  // }

  Future<Map<String, dynamic>> getChats(String token) async {
  var client = http.Client();

  var uri = Uri.parse('$url/chat');
  var response = await client.get(
    uri,
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    var jsonData = jsonDecode(response.body);
    return jsonData;
  } else {
    print('Failed to fetch chats: ${response.statusCode}');
    throw Exception('Failed to fetch chats: ${response.statusCode}');
  }
}

Future<List<Message>> getMessages(String chatId) async {
  var client = http.Client();

  var uri = Uri.parse('$url/message/$chatId');
  var response = await client.get(uri);

  if (response.statusCode == 200) {
    var jsonData = jsonDecode(response.body);
    var messageData = jsonData['data'] as List<dynamic>;
    return messageData.map((json) => Message.fromJson(json)).toList();
  } else {
    print('Failed to fetch messages: ${response.statusCode}');
    throw Exception('Failed to fetch messages: ${response.statusCode}');
  }
}

}
