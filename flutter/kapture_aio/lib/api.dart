import 'package:http/http.dart' as http; //flutter pub add http
import 'package:http/browser_client.dart'; //flutter pub add http
import 'dart:convert';
import '../cookie.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

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

Future<List<List<dynamic>>> apiLoadCSV(String path) async {
  final _rawData = await rootBundle.loadString(path);
  return const CsvToListConverter().convert(_rawData);
}

Future<List<dynamic>> apiFetchVisibility() async {
  final response = await http.get(Uri.parse('https://data.weather.gov.hk/weatherAPI/opendata/opendata.php?dataType=LTMV&lang=tc&rformat=csv'));
  if (response.statusCode == 200) {
    return response.body
      .replaceAll("中環", "中環,22.2821282,114.1546574")
      .replaceAll("赤鱲角", "赤鱲角,22.3071195,113.9089458")
      .replaceAll("西灣河", "西灣河,22.2817352,114.2180595")
      .replaceAll("橫瀾島", "橫瀾島,22.1833524,114.2896788")
      .split('\n').map((line) => line.split(',')).where((line) => line.length > 1).toList().sublist(1);
  } else {
    throw Exception('Failed to load weather data');
  }
}

Future<dynamic> apiFetchWeatherToday() async {
  final response = await http.get(Uri.parse('https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=rhrread&lang=tc'));
  if (response.statusCode == 200) {
    return json.decode(
      response.body
        .replaceAll('中西區"', '中西區", "lat":22.2724964, "long":114.1319545')
        .replaceAll('東區"', '東區", "lat":22.2756645, "long":114.2028506')
        .replaceAll('葵青"', '葵青", "lat":22.363876, "long":114.129635')
        .replaceAll('離島區"', '離島區", "lat":22.314978, "long":113.934996')
        .replaceAll('北區"', '北區", "lat":22.5124863, "long":114.1115507')
        .replaceAll('西貢"', '西貢", "lat":22.4080616, "long":114.2755631')
        .replaceAll('沙田"', '沙田", "lat":22.3887764, "long":114.1789305')
        .replaceAll('南區"', '南區", "lat":22.2395602, "long":114.1474741')
        .replaceAll('大埔"', '大埔", "lat":22.4767376, "long":114.1377115')
        .replaceAll('荃灣"', '荃灣", "lat":22.3707446, "long":114.0933893')
        .replaceAll('屯門"', '屯門", "lat":22.3954791, "long":113.9253176')
        .replaceAll('灣仔"', '灣仔", "lat":22.2773498, "long":114.1688423')
        .replaceAll('元朗"', '元朗", "lat":22.4458529, "long":114.0110784')
        .replaceAll('油尖旺"', '油尖旺", "lat":22.309951, "long":114.1572799')
        .replaceAll('深水埗"', '深水埗", "lat":22.3290705, "long":114.1514727')
        .replaceAll('九龍城"', '九龍城", "lat":22.3309023, "long":114.188851')
        .replaceAll('黃大仙"', '黃大仙", "lat":22.3420553, "long":114.1891031')
        .replaceAll('觀塘"', '觀塘", "lat":22.3120123, "long":114.2185557')
        .replaceAll('京士柏"', '京士柏", "lat":22.311113, "long":114.170461')
        .replaceAll('香港天文台"', '香港天文台", "lat":22.3051839, "long":114.1681542')
        .replaceAll('黃竹坑"', '黃竹坑", "lat":22.239182, "long":114.1596583')
        .replaceAll('打鼓嶺"', '打鼓嶺", "lat":22.5468779, "long":114.1539473')
        .replaceAll('流浮山"', '流浮山", "lat":22.4681911, "long":113.9741678')
        .replaceAll('將軍澳"', '將軍澳", "lat":22.3141572, "long":114.2510436')
        .replaceAll('長洲"', '長洲", "lat":22.2095524, "long":114.0189026')
        .replaceAll('赤鱲角"', '赤鱲角", "lat":22.308568651885317, "long":113.92385888779931')
        .replaceAll('青衣"', '青衣", "lat":22.3444754, "long":114.0776891')
        .replaceAll('石崗"', '石崗", "lat":22.4296185, "long":114.0753563')
        .replaceAll('荃灣可觀"', '荃灣可觀", "lat":22.383706, "long":114.108272')
        .replaceAll('荃灣城門谷"', '荃灣城門谷", "lat":22.374586, "long":114.125010')
        .replaceAll('香港公園"', '香港公園", "lat":22.276987391861073, "long":114.16084015421347')
        .replaceAll('筲箕灣"', '筲箕灣", "lat":22.2787301, "long":114.2238517')
        .replaceAll('跑馬地"', '跑馬地", "lat":22.2698928, "long":114.1788567')
        .replaceAll('赤柱"', '赤柱", "lat":22.2213361, "long":114.2031369')
        .replaceAll('啟德跑道公園"', '啟德跑道公園", "lat":22.3073347, "long":114.2120399')
        .replaceAll('元朗公園"', '元朗公園", "lat":22.441801003579574, "long":114.01876663921297')
        .replaceAll('大美督"', '大美督", "lat":22.4734477, "long":114.230512')
    );
  } else {
    throw Exception('Failed to load weather data');
  }
}

Future<dynamic> apiFetchWeatherReport() async {
  final response = await http.get(Uri.parse('https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=flw&lang=tc'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load weather report data');
  }
}

Future<dynamic> apiFetchWeatherFuture() async {
  final response = await http.get(Uri.parse('https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=fnd&lang=tc'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load future weather report data');
  }
}

Future<dynamic> apiFetchUV() async {
  final response = await http.get(Uri.parse('https://data.weather.gov.hk/weatherAPI/hko_data/regional-weather/latest_15min_uvindex_uc.csv'));
  if (response.statusCode == 200) {
    var uvvalue = response.body
      .split('\n').map((line) => line.split(',')).where((line) => line.length > 1).toList();
    print(uvvalue);
    uvvalue.sublist(1);
    return uvvalue[0][1];
  } else {
    throw Exception('Failed to load UV data');
  }
}

Future<List<List<dynamic>>> apiFetchW10o() async {
  final _w10oFile = await rootBundle.loadString('assets/data/WeatherPhoto_updated.csv');
  return const CsvToListConverter().convert(_w10oFile);
}