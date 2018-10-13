import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

const KEY_COOKIES = "cookies";

class CookieStorage {

  saveCookies(Response response) async {
    final setCookieHeader = "set-cookie";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_COOKIES, response.headers[setCookieHeader]);
  }

  Future<String> readCookies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_COOKIES);
  }
}
