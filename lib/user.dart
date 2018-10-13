import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:screensee/errors.dart';

class User {

  final String name;
  User(this.name);
}

abstract class UserProvider {

  Future<User> getUser();
}

class ScreenShareUserProvider extends UserProvider {

  @override
  Future<User> getUser() async {
    final response = await http.get("http://185.143.145.119/b/users/init");
    final userJson = json.decode(response.body);
    if (userJson["result"] != "ok") {
      throw ApiException();
    }
    return User(userJson["data"]);
  }
}