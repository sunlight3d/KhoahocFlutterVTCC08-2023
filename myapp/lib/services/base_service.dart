import 'package:http/http.dart' as http;
import 'dart:convert';

class BaseService {
  final String baseUrl = 'https://randomuser.me/api';
  Future<Map<String, dynamic>> fetchGET(String path) async {
    final response = await http.get(Uri.parse(path));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
  //fetchPOST, fetchPUT, fetchDELETE,...
}
