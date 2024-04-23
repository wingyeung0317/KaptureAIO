// ignore_for_file: must_be_immutable, prefer_const_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, avoid_print, avoid_unnecessary_containers

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Recommend extends StatefulWidget {
  Recommend({super.key});

  @override
  _RecommendState createState() => _RecommendState();

}

class _RecommendState extends State<Recommend> {
  
  List<List<dynamic>> _data = [];
  final List<String> _locations = [];
  final TextEditingController locationController = TextEditingController();
  String dropdownValue = "";
  String selectedLocation = "香港公園";
  String selectedText = "雀鳥、蓮花、荷花等題材 \n (Photo by charlie.bb )";
  
  void _loadCSV() async {
    final _rawData = await rootBundle.loadString('assets/data/DCFeverRecommend.csv');
    List<List<dynamic>> _listData = const CsvToListConverter().convert(_rawData);
    for (var i in _listData) {
      _locations.add(i[0]);
    }
    setState(() {
      _data = _listData;
      dropdownValue = _locations.first;
      selectedText = _data[_locations.indexOf(selectedLocation)][1].toString().replaceAll('\\n', '\n');
    });
  }

  void _onSelected(String location) {
    setState(() {
      selectedLocation = location;
      selectedText = _data[_locations.indexOf(selectedLocation)][1].toString().replaceAll('\\n', '\n');
      locationController.text = selectedLocation;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCSV();
  }

  @override
  Widget build(BuildContext context) {
    print(_data);
    return ListView(
      children: [
        Column(children: [
          Text("Info from: https://www.dcfever.com/travel/hongkong.php"),
          SizedBox(
            height: 420,
            child:
              FlutterMap(
                key: Key('map'),
                options: MapOptions(
                  initialCenter: LatLng(22.372192, 114.164579),
                  initialZoom: 10.2,
                ),
                children: [
                  TileLayer(
                      urlTemplate: 'http://services.arcgisonline.com/arcgis/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}.png',
                      userAgentPackageName: 'com.example.app',
                  ),
                  
                  MarkerLayer(
                    markers: [
                    for (var i in _data)
                        Marker(
                          point: LatLng(double.parse(i[3].toString()), double.parse(i[2].toString())),
                          width: 300,
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            child:Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 3,
                                ),
                              ),
                              child:Text(i[0], style: TextStyle(fontSize: 16, color: Colors.deepPurple, backgroundColor: Colors.white)),),
                            onTap: () {
                              _onSelected(i[0]);
                            },
                          )
                        ),
                    ],
                  )
                ],
              ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: 
              DropdownMenu<String>(
                width: 300,
                initialSelection: dropdownValue,
                controller: locationController,
                requestFocusOnTap: true,
                label: const Text('Location'),
                onSelected: (String? location) {
                  setState(() {
                    _onSelected(location!);
                  });
                },
                dropdownMenuEntries:
                  _locations.map<DropdownMenuEntry<String>>((String location) {
                      return DropdownMenuEntry<String>(
                        value: location,
                        label: location,
                  );
                  }).toList(),
              ),
          ),
          Text(selectedText),
        ],)
    ]);
  }
}