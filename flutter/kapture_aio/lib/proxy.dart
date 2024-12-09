import 'dart:io';
import 'package:http/http.dart';
import 'package:shelf/shelf_io.dart' as shelf_io; // flutter pub add shelf_proxy
import 'package:shelf_proxy/shelf_proxy.dart'; // flutter pub add shelf_proxy

final String targetUrl = 'http://localhost/'; // your API server address
void configServer(HttpServer server) {
//add neccessary properties to the response header
  server.defaultResponseHeaders
      .add('Access-Control-Allow-Origin', 'http://localhost:8080');
  server.defaultResponseHeaders.add('Access-Control-Allow-Credentials', true);
  server.defaultResponseHeaders
      .add('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  server.defaultResponseHeaders.add('Access-Control-Allow-Headers',
      'X-Requested-With, Content-Type, Accept, Origin, Authorization');
  server.defaultResponseHeaders.add('Access-Control-Max-Age', '3600');
}

void main() async {
  var reqHandle = proxyHandler(targetUrl);
  var server = await shelf_io.serve(reqHandle, 'localhost', 8081);
  configServer(server);
  print('Api Serving at http://${server.address.host}:${server.port}');
}
