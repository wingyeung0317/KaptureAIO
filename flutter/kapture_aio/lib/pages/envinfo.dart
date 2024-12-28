// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:kapture_aio/localization/i18n.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:kapture_aio/api.dart';

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

  void _fetchVisibility() async {
    _visibilitydata = await apiFetchVisibility();
    setState(() {});
  }

  void _fetchWeatherToday() async {
    _weathertoday = await apiFetchWeatherToday();
    setState(() {});
  }

  void _fetchWeatherReport() async {
    _reporttoday = await apiFetchWeatherReport();
    setState(() {});
  }

  void _fetchWeatherFuture() async {
    _reportfuture = await apiFetchWeatherFuture();
    setState(() {});
  }

  void _fetchUV() async {
    _uvvalue = await apiFetchUV();
    setState(() {});
  }

  void _fetchW10o() async {
    w10o = await apiFetchW10o();
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
                      urlTemplate: 'https://services.arcgisonline.com/arcgis/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}.png',
                      userAgentPackageName: 'com.example.app',
                      tileProvider: CancellableNetworkTileProvider(),
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