import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:screensee/cookie.dart';
import 'package:screensee/errors.dart';

class User {

  final String name;
  User(this.name);
}

abstract class UserProvider {

  Future<User> getUser();
}

class ScreenShareUserProvider extends UserProvider {

  final CookieStorage cookieStorage;
  ScreenShareUserProvider(this.cookieStorage);

  User user;

  @override
  Future<User> getUser() async {
    if (user != null) return user;

    final cookies = await cookieStorage.readCookies();
    final response = await http.get("http://185.143.145.119/b/users/init", headers: {
      "Cookie": cookies
    });

    cookieStorage.saveCookies(response);
    final userJson = json.decode(response.body);
    if (userJson["result"] != "ok") {
      throw ApiException();
    }

    user = User(userJson["data"]);
    return user;
  }
}