import 'package:http/http.dart' as http;
import 'dart:convert';

class Crud {
  getRequest(String uri) async {
    try {
      var response = await http.get(Uri.parse(uri));
      if (response.statusCode == 200) {
        var respensebody = jsonDecode(response.body);
        return respensebody;
      } else {
        print("Error : ${response.statusCode}");
      }
    } catch (e) {
      print("Error catch : $e");
    }
  }

  postRequest(String url, Map data) async {
    try {
      var response = await http.post(Uri.parse(url), body: data);
      if (response.statusCode == 200) {
        var respensebody = jsonDecode(response.body);
        return respensebody;
      } else {
        print("Error : ${response.statusCode}");
      }
    } catch (e) {
      print("Error catch : $e");
    }
  }
}
