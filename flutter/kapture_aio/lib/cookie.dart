import 'dart:html';

Map<String, String> getCookie() {
  Map<String, String> cookieMap = {};
  final cookie = document.cookie!;
  final entity = cookie.split("; ").map((item) {
    final split = item.split("=");
    return MapEntry(split[0], split[1]);
  });
  cookieMap = Map.fromEntries(entity);
  return cookieMap;
}

void setCookie(String key, String value) {
  document.cookie = key + "=" + value;
}
