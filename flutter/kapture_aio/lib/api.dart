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

Future<List<dynamic>> apiGetAllBooks() async {
  var client = getCredentialsClient();
  final response = await client.get(Uri.parse(API_ENDPOINT + '/api/books/all'));
  client.close();
  List<dynamic> bookList = [];
  if (response.statusCode == 200) {
    try {
      print(response.body); //for debug
      var jsonResponse = jsonDecode(response.body);
      bookList = jsonResponse;
    } catch (e) {
      bookList = [];
    }
  } else {
    throw Exception('Failed to load data');
  }
  return bookList;
}

Future<bool> apiAddBook(String title, String authors, String publishers,
    String date, String isbn) async {
  var client = getCredentialsClient();
  final response = await client.post(
    Uri.parse(API_ENDPOINT + '/api/books/add'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
      'authors': authors,
      'publishers': publishers,
      'date': date,
      'isbn': isbn
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

Future<bool> apiUpdateBook(int bookId, String title, String authors,
    String publishers, String date, String isbn) async {
  var client = getCredentialsClient();
  final response = await client.put(
    Uri.parse(API_ENDPOINT + '/api/books/update/' + bookId.toString()),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
      'authors': authors,
      'publishers': publishers,
      'date': date,
      'isbn': isbn
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

Future<bool> apiDeleteBook(int bookId) async {
  var client = getCredentialsClient();
  final response = await client.delete(
      Uri.parse(API_ENDPOINT + '/api/books/delete/' + bookId.toString()));
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
  List<dynamic> bookList = [];
  if (response.statusCode == 200) {
    try {
      // print(response.body); //for debug
      // print(response.headers);
      var jsonResponse = jsonDecode(response.body);
      bookList = jsonResponse;
    } catch (e) {
      bookList = [];
    }
  } else {
    throw Exception('Failed to load data');
  }
  return bookList;
}

Future<bool> apiBorrowBook(int bookId) async {
  var client = getCredentialsClient();
  final response = await client
      .get(Uri.parse(API_ENDPOINT + '/api/books/borrow/' + bookId.toString()));
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

Future<bool> apiReturnBook(int bookId) async {
  var client = getCredentialsClient();
  final response = await client
      .get(Uri.parse(API_ENDPOINT + '/api/books/return/' + bookId.toString()));
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
