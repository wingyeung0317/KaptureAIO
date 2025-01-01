import 'package:flutter/material.dart';
import '../../widgets/camera_form.dart';
import '../../widgets/navigation_frame.dart';
import '../../api.dart';
import '../../cookie.dart';

class CameralistPage extends StatefulWidget {
  List<Map<String, dynamic>> cameralist = [
    {
      "brand": "Canon",
      "model": "EOS 5D",
      "description": "Full-frame DSLR",
      "status": "1",
    },
    {
      "brand": "Nikon",
      "model": "D850",
      "description": "High-resolution DSLR",
      "status": "0",
    },
    {
      "brand": "Sony",
      "model": "A7 III",
      "description": "Mirrorless camera",
      "status": "1",
    },
  ];
  CameralistPage({super.key});
  @override
  State<CameralistPage> createState() => _CameralistPageState();
}

class _CameralistPageState extends State<CameralistPage> {
  @override
  Widget build(BuildContext context) {
    return NavigationFrame(
      selectedIndex: 2,
      child: Padding(
          padding: EdgeInsets.all(10),
          child: FutureBuilder<List<dynamic>>(
            //List<dynamic> is json data
            future: apiGetAllCameras(), //<<<< try your api function
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  //error
                  return Text("Error: ${snapshot.error}");
                } else {
                  //success
                  return createCameraLists(snapshot.data!);
                }
              } else {
                //loading
                return CircularProgressIndicator();
              }
            },
          )),
    );
  }

  Widget createCameraLists(List<dynamic> cameras) {
    return ListView(
        children: [for (var camera in cameras!) createSingleCameraRecord(camera)]);
  }

  Widget createSingleCameraRecord(Map<String, dynamic> camera) {
    Map<String, String> cookieMap = getCookie();
    int is_admin = int.parse(cookieMap['is_admin']!);
    return Card(
      child: ListTile(
        enabled: int.parse(camera["status"]) == 1 ? true : false, //check status
        onTap: () {
          popupBorrowDialog(camera);
        },
        leading: Icon(Icons.camera_alt, size: 48),
        title:
            Text(camera["brand"], style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(camera["model"] +
            ", " +
            camera['description'] +
            ", " +
            camera["status"]),
        trailing: is_admin == 1
            ? Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    popupUpdateDialog(camera);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    popupDeleteDialog(camera);
                  },
                ),
              ])
            : Container(width: 50),
      ),
    );
  }

  void popupBorrowDialog(Map<String, dynamic> camera) {
    final now = DateTime.now();
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Reserve Camera'),
              content: Container(
                  height: 150,
                  child: Column(
                    children: [
                      Text(
                          'Do you want to reserve the camera with following details?'),
                      Container(height: 30),
                      Container(
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Date: " + now.toString()),
                              Text("Brand: " + camera["brand"]),
                              Text("Model: " + camera["model"]),
                              Text("Description: " + camera["description"]),
                              Text("Borrower: " + "Me"),
                            ],
                          ))
                    ],
                  )),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    borrowCamera(int.parse(camera["camera_id"]));
                    Navigator.pop(context, 'Yes');
                  },
                  child: const Text('Yes'),
                ),
              ],
            ));
  }

  void popupUpdateDialog(Map<String, dynamic> camera) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Update Camera'),
              content: Container(
                  width: 400,
                  height: 400,
                  child: SingleChildScrollView(
                      child: CameraForm(
                          mode: 1, cameraId: int.parse(camera['camera_id'])))),
            ));
  }

  void popupDeleteDialog(Map<String, dynamic> camera) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Delete Camera'),
              content:
                  Text('Do you really want to delete ' + camera["brand"] + '?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    deleteCamera(int.parse(camera["camera_id"]));
                    Navigator.pop(context, 'Confirm');
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ));
  }

  Future<void> deleteCamera(int cameraId) async {
    String message = "Failed to delete the camera.";
    if (await apiDeleteCamera(cameraId) == true) {
      message = "The camera has been deleted successfully.";
      Navigator.of(context).pushNamed("/camera/cameralist");
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> borrowCamera(int cameraId) async {
    String message = "Failed to borrow the camera.";
    if (await apiBorrowCamera(cameraId) == true) {
      message = "The camera has been borrowed successfully.";
      Navigator.of(context).pushNamed("/camera/cameralist");
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
