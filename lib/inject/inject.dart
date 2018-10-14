// one global service locator for all

import 'package:screensee/cookie.dart';
import 'package:screensee/screenshare/resolver.dart';
import 'package:screensee/user.dart';

class Injector {
  static final Injector instance = Injector._private();
  Injector._private();
  factory Injector() => instance;

  CookieStorage _cookieStorage;
  CookieStorage get cookieStorage => _cookieStorage ??= CookieStorage();

  UserProvider _userProvider;
  UserProvider get userProvider =>
      _userProvider ??= ScreenShareUserProvider(cookieStorage);

  UrlResolver _urlResolver;
  UrlResolver get urlResolver => _urlResolver ??= YoutubeUrlResolver();
}
