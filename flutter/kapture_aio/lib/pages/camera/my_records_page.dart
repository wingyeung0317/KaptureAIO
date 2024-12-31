import 'package:flutter/material.dart';
import '../../widgets/navigation_frame.dart';
import '../../api.dart';

class MyRecordsPage extends StatefulWidget {
  List<Map<String, dynamic>> cameralist = [];

  MyRecordsPage({super.key});

  @override
  State<MyRecordsPage> createState() => _MyRecordsPageState();
}

class _MyRecordsPageState extends State<MyRecordsPage> {
  @override
  Widget build(BuildContext context) {
    return NavigationFrame(
        selectedIndex: 3,
        child: Padding(
            padding: EdgeInsets.all(10),
            child: FutureBuilder<List<dynamic>>(
              future: apiGetMyRecords(), //api function
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    //error
                    return Text("Error: ${snapshot.error}");
                  } else {
                    //success
                    return snapshot.data!.length > 0
                        ? ListView(
                            children: [
                              for (var camera in snapshot.data!)
                                createCameraRecord(camera)
                            ],
                          )
                        : Text("No records found.",
                            style: TextStyle(fontSize: 16));
                  }
                } else {
                  //loading
                  return CircularProgressIndicator();
                }
              },
            )));
  }

  Widget createCameraRecord(Map<String, dynamic> camera) {
    return Card(
      child: ListTile(
        onTap: () {
          popupReturnDialog(camera);
        },
        leading: Icon(Icons.camera_alt, size: 48),
        title:
            Text(camera["brand"], style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(camera["model"] +
            ", " +
            camera['description'] +
            ", " +
            camera["status"]),
      ),
    );
  }

  void popupReturnDialog(Map<String, dynamic> camera) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Return Camera'),
              content: Text('Do you want to return ' + camera["brand"] + '?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    returnCamera(int.parse(camera["camera_id"].toString()));
                    Navigator.pop(context, 'Confirm');
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ));
  }

  Future<void> returnCamera(int cameraId) async {
    String message = "Failed to return the camera.";

    if (await apiReturnCamera(cameraId) == true) {
      message = "The camera has been returned successfully.";

      Navigator.of(context).pushNamed("/camera/myrecords");
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
