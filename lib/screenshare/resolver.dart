import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class UrlResolver {

  Future<String> resolve(String input);
}

const YOUTUBE_RESOLVER_URL = "http://you-link.herokuapp.com/?url=";
class YoutubeUrlResolver extends UrlResolver {

  @override
  Future<String> resolve(String input) async {
    final response = await http.get(YOUTUBE_RESOLVER_URL + input);
    return json.decode(response.body)[0]["url"];
  }
}