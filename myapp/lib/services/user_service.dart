import 'package:http/http.dart' as http;
import 'package:myapp/models/location.dart';
import 'package:myapp/models/picture.dart';
import 'package:myapp/models/user.dart';
import 'dart:convert';

import 'package:myapp/services/base_service.dart';

class UserService extends BaseService{
  UserService() : super();
  Future<User> fetchUserData() async {
    final response = await fetchGET('${baseUrl}'); //users, /products/...
    User user = User.empty;
    if (response != null) {
      // Kiểm tra xem response có giá trị không null
      if(response['results'] is List && response['results'].length > 0) {
        Map<String, dynamic> dictionary = response['results'][0];
        user = User.fromJson(dictionary);
      }
      return user;
    } else {
      throw Exception('Failed to fetch user data'); // Ném một Exception nếu response null
    }
  }

}
