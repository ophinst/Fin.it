import 'package:capstone_project/models/foundItem.dart';
import 'package:http/http.dart' as http;

class RemoteService {
  Future<List<Datum>?> getDatum() async {
    var client = http.Client();

    var uri = Uri.parse('https://finit-api-ahawuso3sq-et.a.run.app/api/lost');
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
}
