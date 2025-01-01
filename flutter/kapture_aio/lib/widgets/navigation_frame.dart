import 'package:flutter/material.dart';
import '../api.dart';

class NavigationFrame extends StatefulWidget {
  Widget child;
  int selectedIndex = 0;
  NavigationFrame(
      {super.key, required this.child, required this.selectedIndex});
  @override
  State<NavigationFrame> createState() => _NavigationFrameState();
}

class _NavigationFrameState extends State<NavigationFrame> {
  Future<void> logout() async {
    apiLogout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(children: [
      NavigationRail(
        backgroundColor: Colors.grey.shade100,
        selectedIndex: widget.selectedIndex,
        groupAlignment: -1.0,
        onDestinationSelected: (int index) {
          setState(() {
            widget.selectedIndex = index;
            switch (index) {
              case 0:
                Navigator.of(context).pushNamed("/camera/home");
                break;
              case 1:
                Navigator.of(context).pushNamed("/camera/add");
                break;
              case 2:
                Navigator.of(context).pushNamed("/camera/cameralist");
                break;
              case 3:
                Navigator.of(context).pushNamed("/camera/myrecords");
                break;
              case 4:
                logout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/camera', (Route<dynamic> route) => false);
                break;
              case 5:
                Navigator.of(context).pushNamed("/camera/phpbb");
                break;
              default:
                Navigator.of(context).pushNamed("/camera");
            }
          });
        },
        labelType: NavigationRailLabelType.all,
        destinations: const <NavigationRailDestination>[
          NavigationRailDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: Text('Home'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.add_a_photo_outlined),
            selectedIcon: Icon(Icons.add_a_photo),
            label: Text('Add Camera'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.camera_alt_outlined),
            selectedIcon: Icon(Icons.camera_alt),
            label: Text('Camera List'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: Text('My Records'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.logout_outlined),
            selectedIcon: Icon(Icons.logout),
            label: Text('Logout'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.forum),
            selectedIcon: Icon(Icons.forum_outlined),
            label: Text('PhpBB'),
          ),
        ],
      ), //Container 1
      Expanded(child: Center(child: widget.child))
    ]));
  }
}
