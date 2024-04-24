// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:kapture_aio/localization/i18n.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class EnvInfo extends StatefulWidget {
  const EnvInfo({super.key});

  @override
  _EnvInfoState createState() => _EnvInfoState();
}

class _EnvInfoState extends State<EnvInfo> {
  List<dynamic> _visibilitydata = [];
  var _weathertoday = json.decode('{"lightning": {"data": [],"startTime": "0001-01-01T00:00:00+08:00","endTime": "0001-01-01T00:00:00+08:00"},"rainfall": {"data": [],"startTime": "0001-01-01T00:00:00+08:00","endTime": "0001-01-01T00:00:00+08:00"},"warningMessage": ["Update failed"],"icon": [64],"iconUpdateTime": "0001-01-01T00:00:00+08:00","specialWxTips": ["Update failed", "Update failed", "Update failed"],"uvindex": {"data": [{"place": "京士柏","value": 0,"desc": "n/a"}],"recordDesc": "Update failed"},"updateTime": "0001-01-01T00:00:00+08:00","temperature": {"data": [],"recordTime": "0001-01-01T00:00:00+08:00"},"tcmessage": "","mintempFrom00To09": "","rainfallFrom00To12": "","rainfallLastMonth": "","rainfallJanuaryToLastMonth": "","humidity": {"recordTime": "0001-01-01T00:00:00+08:00","data": []}}');
  var _reporttoday = json.decode('{"generalSituation": "Update Failed","tcInfo": "","fireDangerWarning": "","forecastPeriod": "Update Failed","forecastDesc": "Update Failed","outlook": "Update Failed","updateTime": "0001-01-01T00:00:00+08:00"}');
  var _reportfuture = json.decode('{"generalSituation": "Update Failed","weatherForecast": [{"forecastDate": "Update Failed","week": "Update Failed","forecastWind": "Update Failed","forecastWeather": "Update Failed","forecastMaxtemp": {"value": 0,"unit": "C"},"forecastMintemp": {"value": 0,"unit": "C"},"forecastMaxrh": {"value": 0,"unit": "percent"},"forecastMinrh": {"value": 0,"unit": "percent"},"ForecastIcon": 0,"PSR": "Update Failed"}, {"forecastDate": "00000000","week": "Update Failed","forecastWind": "Update Failed","forecastWeather": "Update Failed","forecastMaxtemp": {"value": 0,"unit": "C"},"forecastMintemp": {"value": 0,"unit": "C"},"forecastMaxrh": {"value": 0,"unit": "percent"},"forecastMinrh": {"value": 0,"unit": "percent"},"ForecastIcon": 0,"PSR": "Update Failed"}]}');
  var _uvvalue;
  var w10o;

  // W10o stand for weatherphoto
  void _fetchW10o() async {
    var _w10oFile = await rootBundle.loadString('assets/data/WeatherPhoto_updated.csv');
    w10o = const CsvToListConverter().convert(_w10oFile);
  }

  void _fetchVisibility() async {
    final response = await http.get(Uri.parse('https://data.weather.gov.hk/weatherAPI/opendata/opendata.php?dataType=LTMV&lang=tc&rformat=csv'));
    if(response.statusCode == 200) {
      _visibilitydata = response.body
        .replaceAll("中環", "中環,22.2821282,114.1546574")
        .replaceAll("赤鱲角", "赤鱲角,22.3071195,113.9089458")
        .replaceAll("西灣河", "西灣河,22.2817352,114.2180595")
        .replaceAll("橫瀾島", "橫瀾島,22.1833524,114.2896788")
        .split('\n').map((line) => line.split(',')).where((line) => line.length > 1).toList();
      _visibilitydata.removeAt(0);
    }else{
      throw Exception('Failed to load weather data');
    }
    setState(() {});
    print(_visibilitydata);
  }
  
  void _fetchWeatherToday() async {
    // 中西區 22.2724964,114.1319545
    // 東區 22.2756645,114.2028506
    // 葵青 22.363876,114.129635
    // 離島區 22.314978,113.934996
    // 北區 22.5124863,114.1115507
    // 西貢 22.4080616,114.2755631
    // 沙田 22.3887764,114.1789305
    // 南區 22.2395602,114.1474741
    // 大埔 22.4767376,114.1377115
    // 荃灣 22.3707446,114.0933893
    // 屯門 22.3954791,113.9253176
    // 灣仔 22.2773498,114.1688423
    // 元朗 22.4458529,114.0110784
    // 油尖旺 22.309951,114.1572799
    // 深水埗 22.3290705,114.1514727
    // 九龍城 22.3309023,114.188851
    // 黃大仙 22.3420553,114.1891031
    // 觀塘 22.3120123,114.2185557
    // 京士柏 22.311113,114.170461 
    // 香港天文台 22.3051839,114.1681542
    // 黃竹坑 22.239182,114.1596583
    // 打鼓嶺 22.5468779,114.1539473
    // 流浮山 22.4681911,113.9741678
    // 將軍澳 22.3141572,114.2510436
    // 長洲 22.2095524,114.0189026
    // 赤鱲角 22.308568651885317, 113.92385888779931
    // 青衣 22.3444754,114.0776891
    // 石崗 22.4296185,114.0753563
    // 荃灣可觀 22.383706, 114.108272
    // 荃灣城門谷 22.374586, 114.125010
    // 香港公園 22.276987391861073, 114.16084015421347
    // 筲箕灣 22.2787301,114.2238517
    // 跑馬地 22.2698928,114.1788567
    // 赤柱 22.2213361,114.2031369
    // 啟德跑道公園 22.3073347,114.2120399
    // 元朗公園 22.441801003579574, 114.01876663921297
    // 大美督 22.4734477,114.230512
    final response = await http.get(Uri.parse('https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=rhrread&lang=tc'));
    if(response.statusCode == 200) {
      _weathertoday = await json.decode(
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
    }else{
      throw Exception('Failed to load weather data');
    }
    setState(() {});
    // print(_weathertoday);
    // print(_weathertoday["icon"][0]);
  }

  // fetch weather report from https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=flw&lang=tc
  void _fetchWeatherReport() async {
    final response = await http.get(Uri.parse('https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=flw&lang=tc'));
    if(response.statusCode == 200) {
      _reporttoday = await json.decode(response.body);
    }else{
      throw Exception('Failed to load weather report data');
    }
    setState(() {});
    // print(_reporttoday);
  }

  // fetch future weather report from https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=fnd&lang=tc
  void _fetchWeatherFuture() async {
    final response = await http.get(Uri.parse('https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=fnd&lang=tc'));
    if(response.statusCode == 200) {
      _reportfuture = await json.decode(response.body);
    }else{
      throw Exception('Failed to load future weather report data');
    }
    setState(() {});
    // print(_reportfuture);
  }
  
  void _fetchUV() async {
    final response = await http.get(Uri.parse('https://data.weather.gov.hk/weatherAPI/hko_data/regional-weather/latest_15min_uvindex_uc.csv'));
    if(response.statusCode == 200) {
      _uvvalue = response.body
        .split('\n').map((line) => line.split(',')).where((line) => line.length > 1).toList();
      _uvvalue.removeAt(0);
      _uvvalue = _uvvalue[0][1];
    }else{
      throw Exception('Failed to load UV data');
    }
    setState(() {});
    // print(_uvvalue);
  }

  String mode = '';

  Widget mapmarkers(){
    switch(mode){
      case 'temperature':
        return MarkerLayer(markers: [
          for (var i in _weathertoday['temperature']['data'])
            Marker(
              point: LatLng(double.parse(i['lat'].toString()), double.parse(i['long'].toString())),
              width: 300,
              child: InkWell(
                child:
                  Column(
                    children: [
                      Text(i['place'], style: TextStyle(fontSize: 16, color: Colors.deepPurple, backgroundColor: Colors.white)),
                      Text("${i['value']} °${i['unit']}", style: TextStyle(fontSize: 11, color: Colors.deepPurple, backgroundColor: Colors.white)),
                    ],
                  ),
                onTap: () {},
              )
            )
        ],);
      case 'rainfall':
        // return ListView(
        //   children: [
        //     for (var i in _weathertoday['rainfall']['data'])
        //       Text(i.toString()),
        //   ],
        // );
        return MarkerLayer(markers: [
          for (var i in _weathertoday['rainfall']['data'])
            Marker(
              point: LatLng(double.parse(i['lat'].toString()), double.parse(i['long'].toString())),
              width: 300,
              child: InkWell(
                child:
                  Column(
                    children: [
                      Text(i['place'], style: TextStyle(fontSize: 16, color: Colors.deepPurple, backgroundColor: Colors.white)),
                      Text("${i['max']} ${i['unit']}", style: TextStyle(fontSize: 11, color: Colors.deepPurple, backgroundColor: Colors.white)),
                    ],
                  ),
                onTap: () {},
              )
            )
        ],);
      case 'visibility':
        return MarkerLayer(
          markers: [
            for (var i in _visibilitydata)
              Marker(
                point: LatLng(double.parse(i[2].toString()), double.parse(i[3].toString())),
                width: 300,
                child: InkWell(
                  child:
                    Column(
                      children: [
                        Text(i[1], style: TextStyle(fontSize: 16, color: Colors.deepPurple, backgroundColor: Colors.white)),
                        Text(i[4], style: TextStyle(fontSize: 11, color: Colors.deepPurple, backgroundColor: Colors.white)),
                      ],
                    ),
                  onTap: () {},
                )
              ),
          ],
          );
      case 'photo':
        return MarkerLayer(markers: [
          for(var i in w10o)
            Marker(
              point: LatLng(double.parse(i[1].toString()), double.parse(i[2].toString())),
              width: 300,
              alignment: Alignment.centerRight,
              child: InkWell(
                child:Container(
                    decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                      color: Colors.black87,
                      width: 2,
                      ),
                    ),
                  ),
                  child:Text(i[0], style: TextStyle(fontSize: 16, color: Colors.deepPurple, backgroundColor: Colors.white)),),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(i[0]),
                        content: Column(
                          children: [
                            MarkdownBody(data: i[3])
                          ],
                        ),
                      );
                    },
                  );
                },
              )
            ),
        ],);
      default: return MarkerLayer(markers: [],);
    }
  }
  
  @override
  void initState() {
    super.initState();
    _fetchVisibility();
    _fetchWeatherToday();
    _fetchWeatherReport();
    _fetchWeatherFuture();
    _fetchUV();
    _fetchW10o();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children:[ 
          SizedBox(
            height: 250,
            child: Stack(alignment: AlignmentDirectional.bottomStart, children: [
              FlutterMap(
                key: Key('map'),
                options: MapOptions(
                  initialCenter: LatLng(22.372192, 114.164579),
                  initialZoom: 9.5,
                ),
                children: [
                  TileLayer(
                      // urlTemplate: 'http://{s}.basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}.png',
                      urlTemplate: 'http://services.arcgisonline.com/arcgis/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}.png',
                      userAgentPackageName: 'com.example.app',
                  ),
                  mapmarkers()
                ]),
              Text("${_weathertoday['updateTime'].toString().substring(11,19)}\n${_weathertoday['updateTime'].toString().substring(0,10)}", style: TextStyle(fontSize: 16, color: Colors.white, backgroundColor: Colors.black12),),
              ]
            ,),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(padding: EdgeInsets.symmetric(horizontal: 5), child:
                  SizedBox(width: 180, child: 
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _fetchWeatherToday();
                          mode = 'temperature';
                        });
                      },
                      child: Text(I18n.temperature),
                    ),),),
                Padding(padding: EdgeInsets.symmetric(horizontal: 5), child:
                  SizedBox(width: 180, child: 
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _fetchWeatherToday();
                          mode = 'rainfall';
                        });
                      },
                      child: Text(I18n.rainfall),
                    ),),),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(padding: EdgeInsets.symmetric(horizontal: 5), child:
                  SizedBox(width: 180, child: 
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _fetchVisibility();
                          mode = 'visibility';
                        });
                      },
                      child: Text(I18n.visibility),
                    ),),),
                Padding(padding: EdgeInsets.symmetric(horizontal: 5), child:
                  SizedBox(width: 180, child: 
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          mode = 'photo';
                        });
                      },
                      child: Text(I18n.weatherPhoto),
                    ),),),
              ]),
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Card(child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Weather Report', textAlign:  TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: Column(
                    children: [
                      Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                            Image.network('https://www.hko.gov.hk/images/HKOWxIconOutline/pic${_weathertoday["icon"][0]}.png', width: 16, color: Colors.black,),
                            Text('  今 日 天 氣', style: TextStyle(fontSize: 16, color: Colors.deepPurple)),
                        ]),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for(var i in _reporttoday.values)
                              Text(i.toString(), textAlign: TextAlign.left,),
                          ],
                        ),
                      ],),),
                      Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                            Image.network('https://www.hko.gov.hk/images/HKOWxIconOutline/pic${_weathertoday["icon"][0]}.png', width: 16, color: Colors.black,),
                            Text('  天 氣 警 告', style: TextStyle(fontSize: 16, color: Colors.deepPurple)),
                        ]),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Text(_weathertoday['warningMessage'].toString()==""?"無":_weathertoday['warningMessage'].toString(), textAlign: TextAlign.left,),
                          ],
                        )
                      ],),),
                      Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                            Image.network('https://www.hko.gov.hk/images/HKOWxIconOutline/pic${_weathertoday["icon"][0]}.png', width: 16, color: Colors.black,),
                            Text('  特 別 天 氣 提 示', style: TextStyle(fontSize: 16, color: Colors.deepPurple)),
                        ]),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Text(_weathertoday['specialWxTips'].toString()=="null"?"無":_weathertoday['specialWxTips'].toString(), textAlign: TextAlign.left,),
                          ],
                        ),
                      ],),),
                      Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                            Text('  紫 外 線', style: TextStyle(fontSize: 16, color: Colors.deepPurple)),
                        ]),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Text(_uvvalue.toString(), textAlign: TextAlign.left,),
                          ],
                        ),
                      ],),),
                    ]),
                  ),
                  Expanded(flex: 3, child: Card(
                    child: Column(
                      children: [
                        Text('未 來 九 日 天 氣', style: TextStyle(fontSize: 16, color: Colors.deepPurple)),
                            for(var i in _reportfuture['weatherForecast'])
                              Card(
                                child: Row(
                                  children: [
                                    Image.network('https://www.hko.gov.hk/images/HKOWxIconOutline/pic${i['ForecastIcon']}.png', width: 28, color: Colors.black,),
                                    Text("  ${i['week']}  ${i['forecastMaxtemp']['value']}°C \n  ${i['PSR']} 下雨機率"),
                                  ],
                                ),
                              )
                      ],
                    ),
                  )),
                ],
              ),
            ],
          ),
          ))
    ]);
  }
}