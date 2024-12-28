import 'package:http/http.dart' as http; //flutter pub add http
import 'package:http/browser_client.dart'; //flutter pub add http
import 'dart:convert';
import '../cookie.dart';

final String API_ENDPOINT = "http://localhost:8081"; // your API server address
http.Client getCredentialsClient() {
//create a client object for HTTP request
  http.Client client = http.Client();
  if (client is BrowserClient) {
    client.withCredentials = true;
  }
  return client;
}

Future<List<dynamic>> apiGetAllCameras() async {
  var client = getCredentialsClient();
  final response = await client.get(Uri.parse(API_ENDPOINT + '/api/books/all'));
  client.close();
  List<dynamic> cameraList = [];
  if (response.statusCode == 200) {
    try {
      print(response.body); //for debug
      var jsonResponse = jsonDecode(response.body);
      cameraList = jsonResponse;
    } catch (e) {
      cameraList = [];
    }
  } else {
    throw Exception('Failed to load data');
  }
  return cameraList;
}

Future<bool> apiAddCamera(String brand, String model, String description, String status) async {
  var client = getCredentialsClient();
  final response = await client.post(
    Uri.parse(API_ENDPOINT + '/api/books/add'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'brand': brand,
      'model': model,
      'description': description,
      'status': status
    }),
  );
  client.close();
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse != false) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

Future<bool> apiUpdateCamera(int cameraId, String brand, String model, String description, String status) async {
  var client = getCredentialsClient();
  final response = await client.put(
    Uri.parse(API_ENDPOINT + '/api/books/update/' + cameraId.toString()),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'brand': brand,
      'model': model,
      'description': description,
      'status': status
    }),
  );
  client.close();
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse != false) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

Future<bool> apiDeleteCamera(int cameraId) async {
  var client = getCredentialsClient();
  final response = await client.delete(
      Uri.parse(API_ENDPOINT + '/api/books/delete/' + cameraId.toString()));
  client.close();
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse != false) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

Future<bool> apiBorrowCamera(int cameraId) async {
  var client = getCredentialsClient();
  final response = await client
      .get(Uri.parse(API_ENDPOINT + '/api/books/borrow/' + cameraId.toString()));
  client.close();
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse != false) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

Future<bool> apiReturnCamera(int cameraId) async {
  var client = getCredentialsClient();
  final response = await client
      .get(Uri.parse(API_ENDPOINT + '/api/books/return/' + cameraId.toString()));
  client.close();
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse != false) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

Future<bool> apiLogin(String username, String password) async {
  var client = getCredentialsClient();
  final response = await client.post(
    Uri.parse(API_ENDPOINT + '/api/users/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
        <String, String>{'username': username, 'password': password}),
  );
  client.close();
// print(response.body); //debug
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse != false) {
      var is_admin = int.parse(jsonResponse["is_admin"]);
      setCookie("is_admin", is_admin.toString());
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

Future<bool> apiRegister(String username, String password, String repeatedPassword) async {
  var client = getCredentialsClient();
  final response = await client.post(
    Uri.parse(API_ENDPOINT + '/api/users/register'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
      'repeated_password': repeatedPassword
    }),
  );
  client.close();
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
      if (jsonResponse != false) {
        return true;
      } else {
        return false;
      }
  } else {
    return false;
  }
}

Future<bool> apiLogout() async {
  var client = getCredentialsClient();
  final response =
      await client.get(Uri.parse(API_ENDPOINT + '/api/users/logout'));
  client.close();
// print(response.body); //debug
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse != false) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

Future<List<dynamic>> apiGetMyRecords() async {
  var client = getCredentialsClient();
  final response =
      await client.get(Uri.parse(API_ENDPOINT + '/api/users/myrecords'));
  client.close();
  List<dynamic> recordList = [];
  if (response.statusCode == 200) {
    try {
      // print(response.body); //for debug
      // print(response.headers);
      var jsonResponse = jsonDecode(response.body);
      recordList = jsonResponse;
    } catch (e) {
      recordList = [];
    }
  } else {
    throw Exception('Failed to load data');
  }
  return recordList;
}
