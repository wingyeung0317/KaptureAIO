// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields, prefer_const_constructors_in_immutables
import 'package:kapture_aio/constant/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kapture_aio/pages/camera.dart';
import 'package:kapture_aio/pages/envinfo.dart';
import 'package:kapture_aio/pages/forum/forum.dart';
import 'package:kapture_aio/pages/login.dart';
import 'package:kapture_aio/pages/recommend.dart';
import 'package:kapture_aio/localization/i18n.dart';

var ctx;
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
      initialRoute: '/',
      routes: {
        '/': (context) => Home(title: appname),
        '/env': (context) => EnvInfo(),
        '/cam': (context) => Camera(),
        '/r7d': (context) => Recommend(),
        '/forum': (context) => ForumPage(),
        '/login': (context) => LoginPage(updateHomeState: ctx),
      },
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
  void updateHomeState() {
    setState(() {
      // update your state here
    });
  }

  String menulogin(){
    return globals.isLoggedIn ? I18n.logout : I18n.login;
  }

  void _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 3:
          globals.isLoggedIn ? globals.pageIndex = index : globals.pageIndex = 4;
          break;
        case 4:
          if (globals.isLoggedIn){
            globals.isLoggedIn = false;
            globals.resetUser();
          }
          globals.pageIndex = index;
          break;
        default:
          globals.pageIndex = index;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    List<Widget> _widgetOptions = <Widget>[
      EnvInfo(),
      Camera(),
      Recommend(),
      ForumPage(),
      LoginPage(updateHomeState: updateHomeState),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: Colors.black, foregroundColor: Colors.white,),
      body: Center(
        child: _widgetOptions[globals.pageIndex],
      ),
      drawer: Drawer(
        child: ListView(
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
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(globals.userimg),
                      ),
                      Text(globals.displayname, style: TextStyle(color: Colors.white, fontSize: 20)), //Todo: Change to user name
                      Text(globals.role, style: TextStyle(color: Colors.white, fontSize: 15)), //Todo: Change to user role
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
              selected: globals.pageIndex == 0,
              onTap: () {
                // Update the state of the app
                _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(I18n.menuCamera),
              selected: globals.pageIndex == 1,
              onTap: () {
                // Update the state of the app
                _onItemTapped(1);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(I18n.menuRecommend),
              selected: globals.pageIndex == 2,
              onTap: () {
                // Update the state of the app
                _onItemTapped(2);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(I18n.menuForum),
              selected: globals.pageIndex == 3,
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