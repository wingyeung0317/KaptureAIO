import 'package:kapture_aio/cookie.dart';
import 'package:flutter/material.dart';
import '../../widgets/navigation_frame.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var username = getCookie()['logged_in_user'] ?? "User";
  @override
  Widget build(BuildContext context) {
    return NavigationFrame(
        selectedIndex: 0,
        child: Container(
            child: Text("EEE4482 e-Library\nWelcome, " + username,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ))));
  }
}
