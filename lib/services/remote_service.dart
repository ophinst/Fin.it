import 'dart:convert';
import 'package:capstone_project/models/found_model.dart';
import 'package:capstone_project/models/lost_item_model.dart';
import 'package:capstone_project/models/loginModel.dart';
import 'package:capstone_project/models/message_model.dart';
import 'package:capstone_project/models/lost_model.dart';
import 'package:capstone_project/models/registerModel.dart';
import 'package:capstone_project/models/user_model.dart';
import 'package:capstone_project/models/voucher_model.dart';
import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;
import 'dart:io';

class RemoteService {
  // final String url = "http://localhost:8080/api";
  final String url = "https://finit-api-ahawuso3sq-et.a.run.app/api";

  Future<List<List<Datum>>> getLostItems({
  required int counter,
  String? search,
  String? category,
}) async {
  String baseUrl = '$url/lost?page=$counter';
  
  if (search != null && search.isNotEmpty) {
    baseUrl += '&search=$search';
  }
  
  if (category != null && category.isNotEmpty) {
    baseUrl += '&category=$category';
  }

  final response = await http.get(Uri.parse(baseUrl));

  if (response.statusCode == 200) {
    Iterable currentList = json.decode(response.body)['data'];
    List<Datum> currentData =
        currentList.map((model) => Datum.fromJson(model)).toList();

    String nextUrl = '$url/lost?page=${counter + 1}';
    
    if (search != null && search.isNotEmpty) {
      nextUrl += '&search=$search';
    }
    
    if (category != null && category.isNotEmpty) {
      nextUrl += '&category=$category';
    }
    
    final nextResponse = await http.get(Uri.parse(nextUrl));
    if (nextResponse.statusCode == 200) {
      Iterable nextList = json.decode(nextResponse.body)['data'];
      List<Datum> nextData =
          nextList.map((model) => Datum.fromJson(model)).toList();

      return [currentData, nextData];
    } else {
      throw Exception('Failed to load next data');
    }
  } else {
    throw Exception('Failed to load data');
  }
}


  Future<List<List<GetFoundModel>>> fetchFoundItems({
  required int counter,
  String? search,
  String? category,
}) async {
  String baseUrl = '$url/found?page=$counter';
  
  if (search != null && search.isNotEmpty) {
    baseUrl += '&search=$search';
  }
  
  if (category != null && category.isNotEmpty) {
    baseUrl += '&category=$category';
  }

  final response = await http.get(Uri.parse(baseUrl));

  if (response.statusCode == 200) {
    Iterable currentList = json.decode(response.body)['data'];
    List<GetFoundModel> currentData =
        currentList.map((model) => GetFoundModel.fromJson(model)).toList();

    String nextUrl = '$url/found?page=${counter + 1}';
    
    if (search != null && search.isNotEmpty) {
      nextUrl += '&search=$search';
    }
    
    if (category != null && category.isNotEmpty) {
      nextUrl += '&category=$category';
    }
    
    final nextResponse = await http.get(Uri.parse(nextUrl));
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

  Future<dynamic> getFoundByIdJson(String itemId) async {
    var response = await http.get(Uri.parse('$url/found/$itemId'));
    if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    return {
      'status': 200,
      'data': responseData['data']
    };
  } else if (response.statusCode == 404) {
    var responseData = json.decode(response.body);
    return {
      'status': 404,
      'message': responseData['message']
    };
  } else {
    throw Exception('Failed to load data: ${response.statusCode}');
  }
}

  Future<Map<String, dynamic>> getNearItems(
      double latitude, double longitude) async {
    final uri = Uri.parse('$url/nearby/$latitude/$longitude');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load near items');
      }
    } catch (e) {
      throw Exception('Failed to load near items: $e');
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

  //reward user voucher api
  Future<Map<String, dynamic>> getMyVoucher(String? token) async {
    final usrToken = token;

    var uri = Uri.parse('$url/reward/user');
    try {
      final response = await http.get(uri, headers: {
        'Authorization':
            'Bearer $usrToken', // Use the token in the Authorization header
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception(
            'Failed to load recent activities. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load recent activities: $e');
    }
  }

  Future<Map<String, dynamic>> purchaseReward(
      String rewardId, String token) async {
    var uri = Uri.parse('$url/reward/$rewardId');

    try {
      final response = await http.patch(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        // Reward purchased successfully
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      } else if (response.statusCode == 400) {
        // Insufficient points
        final Map<String, dynamic> errorData = json.decode(response.body);
        return errorData;
      } else {
        // Handle other status codes as needed
        throw Exception('Failed to purchase reward: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to purchase reward: $e');
    }
  }

  //recent activity API
  Future<Map<String, dynamic>> getRecentAct(String? token) async {
    final usrToken = token;

    final uri = Uri.parse(
        '$url/recent'); // Ensure 'url' is defined somewhere in your code

    try {
      final response = await http.get(uri, headers: {
        'Authorization':
            'Bearer $usrToken', // Use the token in the Authorization header
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception(
            'Failed to load recent activities. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load recent activities: $e');
    }
  }

  Future<Datum?> getLostItemById(String lostId) async {
    var client = http.Client();

    var uri = Uri.parse('$url/lost/$lostId');
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

  Future<Map<String, dynamic>> getLostByIdJson(String itemId) async {
  var response = await http.get(Uri.parse('$url/lost/$itemId'));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    return {
      'status': 200,
      'data': responseData['data']
    };
  } else if (response.statusCode == 404) {
    var responseData = json.decode(response.body);
    return {
      'status': 404,
      'message': responseData['message']
    };
  } else {
    throw Exception('Failed to load data: ${response.statusCode}');
  }
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
      // Assuming the API returns a JSON object with a 'data' field containing the user details
      return RegisterResponseModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      // Unauthorized access
      return RegisterResponseModel(
          message: 'Unauthorized: Please check your credentials');
    } else if (response.statusCode == 400) {
      // Bad request
      // Attempt to parse the error message from the response body
      try {
        var responseBody = jsonDecode(response.body);
        return RegisterResponseModel(message: responseBody['message']);
      } catch (e) {
        // If parsing fails, use a generic error message
        return RegisterResponseModel(message: 'Bad request: Invalid input');
      }
    } else {
      // Other status codes indicate server errors or other issues
      // Attempt to parse the error message from the response body
      try {
        var responseBody = jsonDecode(response.body);
        return RegisterResponseModel(message: responseBody['message']);
      } catch (e) {
        // If parsing fails, use a generic error message
        return RegisterResponseModel(
            message: 'Server error: ${response.statusCode}');
      }
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

  Future<Map<String, dynamic>> getChatById(
      String token, String itemId, String receiverId) async {
    var client = http.Client();

    var uri = Uri.parse('$url/chat/$itemId/$receiverId');
    var response = await client.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      print('Failed to fetch chats: ${response.statusCode}');
      throw Exception('Failed to fetch chats: ${response.statusCode}');
    }
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

  Future<bool> deleteItem(String token, String id) async {
    final uri = Uri.parse('$url/recent/$id');
    final response = await http.delete(uri, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    });

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> saveFoundItem(String token, FoundModel foundItem) async {
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
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> saveLostItem(String token, LostModel lostItem) async {
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
        'locationDetail': lostItem.placeLocation.locationDetail.toString(),
      })
      ..files.add(await http.MultipartFile.fromPath(
        'image',
        lostItem.image,
        contentType: MediaType('image', 'jpg'),
      ));

    var response = await request.send();

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> finishLostTransaction(String token, String lostId) async {
    final uri = Uri.parse('$url/lost/$lostId');

    try {
      final response = await http.patch(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Lost transaction finished successfully');
      } else {
        print('Failed to finish lost transaction: ${response.statusCode}');
        throw Exception('Failed to finish lost transaction');
      }
    } catch (e) {
      print('Error finishing lost transaction: $e');
      throw Exception('Error finishing lost transaction: $e');
    }
  }

  Future<void> finishFoundTransaction(String token, String foundId) async {
    final uri = Uri.parse('$url/found/$foundId');

    try {
      final response = await http.patch(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Lost transaction finished successfully');
      } else {
        print('Failed to finish lost transaction: ${response.statusCode}');
        throw Exception('Failed to finish lost transaction');
      }
    } catch (e) {
      print('Error finishing lost transaction: $e');
      throw Exception('Error finishing lost transaction: $e');
    }
  }

  Future<void> updateProfilePicture(String token, File imageFile) async {
    final uri = Uri.parse('$url/user/profile');

    var request = http.MultipartRequest('PATCH', uri)
      ..headers.addAll({
        HttpHeaders.authorizationHeader: 'Bearer $token',
      })
      ..files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType:
            MediaType('image', 'jpeg'), // Adjust content type as necessary
      ));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Profile picture updated successfully');
    } else {
      print('Failed to update profile picture: ${response.statusCode}');
      throw Exception('Failed to update profile picture');
    }
  }

  Future<void> updateUserData(
      String token, String name, String phoneNumber) async {
    final uri = Uri.parse('$url/user');

    try {
      final response = await http.patch(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'phoneNumber': phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        print('User data updated successfully');
      } else {
        print('Failed to update user data: ${response.statusCode}');
        throw Exception('Failed to update user data');
      }
    } catch (e) {
      print('Error updating user data: $e');
      throw Exception('Error updating user data: $e');
    }
  }
}
