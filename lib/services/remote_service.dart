import 'dart:convert';
import 'package:capstone_project/models/found_model.dart';
import 'package:capstone_project/models/lost_item_model.dart';
import 'package:capstone_project/models/loginModel.dart';
import 'package:capstone_project/models/message_model.dart';
import 'package:capstone_project/models/lost_model.dart';
import 'package:capstone_project/models/registerModel.dart';
import 'package:capstone_project/models/user_model.dart';
import 'package:capstone_project/models/voucher_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;
import 'dart:io';

class RemoteService {
  final Map<String, String> _locationCache = {};
  // final String url = "http://localhost:8080/api";
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

  Future<List<List<GetFoundModel>>> fetchFoundItems(int counter) async {
    final response = await http.get(Uri.parse('$url/found?page=$counter'));

    if (response.statusCode == 200) {
      Iterable currentList = json.decode(response.body)['data'];
      List<GetFoundModel> currentData =
          currentList.map((model) => GetFoundModel.fromJson(model)).toList();

      final nextResponse =
          await http.get(Uri.parse('$url/found?page=${counter + 1}'));
      if (nextResponse.statusCode == 200) {
        Iterable nextList = json.decode(nextResponse.body)['data'];
        List<GetFoundModel> nextData =
            nextList.map((model) => GetFoundModel.fromJson(model)).toList();

        return [currentData, nextData];
      } else {
        throw Exception('Failed to load next data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<GetFoundModel>> getFoundById(String foundId) async {
    var response = await http.get(Uri.parse('$url/found/$foundId'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['data'];
      List<GetFoundModel> data =
          list.map((model) => GetFoundModel.fromJson(model)).toList();
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  //reward api
  Future<dynamic> getVoucherList() async {
    var client = http.Client();

    var uri = Uri.parse('$url/reward');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      var lostResponse = VoucherResponse.fromJson(jsonDecode(json));
      return lostResponse.data;
    } else {
      // Handle error appropriately
      print('Failed to fetch data: ${response.statusCode}');
      return null;
    }
  }

  Future<String> getLocationName(double latitude, double longitude) async {
    final cacheKey = '$latitude,$longitude';
    String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;

    // Check if location is already in cache
    if (_locationCache.containsKey(cacheKey)) {
      return _locationCache[cacheKey]!;
    }

    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print('=================');
      print(apiKey);
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
        Uri.parse('$url/lost/$lostId');
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

Future<Message> sendMessage({
    required String chatId,
    required String token,
    String? message,
    File? imageFile,
  }) async {
    var uri = Uri.parse('$url/message/$chatId');

    var request = http.MultipartRequest('POST', uri);

    // Add message field
    if (message != null) {
      request.fields['payload'] = message;
    }

    // Add image file field
    if (imageFile != null) {
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();

      // Add image file to request
      request.files.add(
        http.MultipartFile(
          'image',
          stream,
          length,
          filename: imageFile.path.split('/').last,
        ),
      );
    }

    // Add authorization header
    request.headers.addAll({
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });

    // Send the request
    var response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 201) {
      var responseData = jsonDecode(response.body);
      return Message.fromJson(responseData['data']);
    } else {
      print('Failed to send message: ${response.statusCode}');
      throw Exception('Failed to send message: ${response.statusCode}');
    }
  }
  
  Future<void> saveFoundItem(String token, FoundModel foundItem) async {
    final foundToken = token;
    final url = Uri.https(
      'finit-api-ahawuso3sq-et.a.run.app',
      '/api/found',
    );
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $foundToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(foundItem.toJson()),
    );
    print(response.body);
    print(response.statusCode);
  }

  Future<void> saveLostItem(String token, LostModel lostItem) async {
    final lostToken = token;
    final url = Uri.https(
      'finit-api-ahawuso3sq-et.a.run.app',
      '/api/lost',
    );

    var request = http.MultipartRequest('POST', url)
      ..headers.addAll({
        'Authorization': 'Bearer $lostToken',
        'Content-Type': 'application/json',
      })
      ..fields.addAll({
        'itemName': lostItem.itemName,
        'itemDescription': lostItem.itemDescription,
        'lostDate': lostItem.lostDate,
        'lostTime': lostItem.lostTime,
        'category': lostItem.category,
        'latitude': lostItem.placeLocation.latitude.toString(),
        'longitude': lostItem.placeLocation.longitude.toString(),
        'locationDetail': lostItem.placeLocation.locationDetail,
      })
      ..files.add(await http.MultipartFile.fromPath(
        'image',
        lostItem.image,
        contentType: MediaType('image', 'jpg'),
      ));

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Upload successful");
    } else {
      print("Upload failed");
    }

    response.stream.listen((value) {
      String responseBody = String.fromCharCodes(value);
      print("Response body: $responseBody");

      Map<String, dynamic> responseJson = json.decode(responseBody);
      print("Message from server: ${responseJson['message']}");
    });
  }
}
