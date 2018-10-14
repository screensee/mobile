import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:screensee/errors.dart';

abstract class UrlResolver {
  Future<String> resolve(String input);
}

const YOUTUBE_RESOLVER_URL = "http://you-link.herokuapp.com/?url=";

class YoutubeUrlResolver extends UrlResolver {
  Map<String, String> resolvedUrls = Map();

  @override
  Future<String> resolve(String input) async {
    try {
      input = input.replaceAll("youtu.be/", "www.youtube.com/watch?v=");

      var result = resolvedUrls[input];
      if (result != null) return result;

      final response = await http.get(YOUTUBE_RESOLVER_URL + input);
      result = json.decode(response.body)[0]["url"];
      if (result == null) {
        throw ResolverException();
      }
      resolvedUrls["input"] = result;
      return result;
    } catch (e) {
      throw ResolverException();
    }
  }
}
