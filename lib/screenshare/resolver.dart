import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class UrlResolver {
  Future<String> resolve(String input);
}

const YOUTUBE_RESOLVER_URL = "http://you-link.herokuapp.com/?url=";

class YoutubeUrlResolver extends UrlResolver {
  Map<String, String> resolvedUrls = Map();

  @override
  Future<String> resolve(String input) async {
    var result = resolvedUrls[input];
    if (result != null) return result;

    final response = await http.get(YOUTUBE_RESOLVER_URL + input);
    result = json.decode(response.body)[0]["url"];
    resolvedUrls["input"] = result;
    return result;
  }
}
