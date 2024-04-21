// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields, prefer_const_constructors_in_immutables

import 'dart:ffi';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kapture_aio/pages/camera.dart';
import 'package:kapture_aio/pages/envinfo.dart';
import 'package:kapture_aio/pages/forum.dart';
import 'package:kapture_aio/pages/login.dart';
import 'package:kapture_aio/pages/recommend.dart';
import 'localization/i18n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
    supportedLocales: I18n.supportedLocales, 
    path: 'assets/lang/langs.csv', 
    assetLoader: CsvAssetLoader(),
    child: KaptureAIO(), 
    )
  );
}

class KaptureAIO extends StatelessWidget {
  const KaptureAIO({super.key});

  @override
  Widget build(BuildContext context) {
  String appname = I18n.title;
  appname = appname=='title' ? 'KaptureAIO' : appname;
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      debugShowCheckedModeBanner: false,

      title: appname,
      home: Home(title: appname),
    );
  }
}

class Home extends StatefulWidget {
  Home({super.key, required this.title});
  final String title;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _selectedIndex = 0;
  
  String username = I18n.roleVisitor;
  String role = I18n.roleVisitor;
  bool isLogin = false;

  static List<Widget> _widgetOptions = <Widget>[
    EnvInfo(),
    Camera(),
    Recommend(),
    Forum(),
    Login(),
  ];

  String menulogin(){
    return isLogin ? I18n.logout : I18n.login;
  }

  void _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 3:
          isLogin ? _selectedIndex = index : _selectedIndex = 4;
          break;
        case 4:
          if (isLogin){
            isLogin = false;
          }
          _selectedIndex = index;
          break;
        default:
          _selectedIndex = index;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: Colors.black, foregroundColor: Colors.white,),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 280,
              child: 
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[Color.fromARGB(255, 68, 191, 248), Color.fromARGB(255, 8, 70, 121)],
                    )
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.account_circle, size: 100, color: Colors.white),
                      Text(username, style: TextStyle(color: Colors.white, fontSize: 20)), //Todo: Change to user name
                      Text(role, style: TextStyle(color: Colors.white, fontSize: 15)), //Todo: Change to user role
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            _onItemTapped(4);
                            Navigator.pop(context);
                          },
                          child: Text(menulogin()),
                        ),
                      )
                    ],
                  ),
                ),
            ),
            ListTile(
              title: Text(I18n.menuEnv),
              selected: _selectedIndex == 0,
              onTap: () {
                // Update the state of the app
                _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(I18n.menuCamera),
              selected: _selectedIndex == 1,
              onTap: () {
                // Update the state of the app
                _onItemTapped(1);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(I18n.menuRecommend),
              selected: _selectedIndex == 2,
              onTap: () {
                // Update the state of the app
                _onItemTapped(2);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(I18n.menuForum),
              selected: _selectedIndex == 3,
              onTap: () {
                // Update the state of the app
                _onItemTapped(3);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}