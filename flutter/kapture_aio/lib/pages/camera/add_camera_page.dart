import 'package:flutter/material.dart';
import '../../widgets/navigation_frame.dart';
import '../../widgets/camera_form.dart';

class AddCameraPage extends StatefulWidget {
  AddCameraPage({super.key});
  @override
  State<AddCameraPage> createState() => _AddCameraPageState();
}

class _AddCameraPageState extends State<AddCameraPage> {
  @override
  Widget build(BuildContext context) {
    return NavigationFrame(
      selectedIndex: 1,
      child: Container(width: 600, child: CameraForm(mode: 0)),
    );
  }
}
