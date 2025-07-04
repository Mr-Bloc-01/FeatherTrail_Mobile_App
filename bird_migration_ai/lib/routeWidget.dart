import 'package:bird_migration_ai/birdPredictionPage.dart';
import 'package:bird_migration_ai/forumPage.dart';
import 'package:bird_migration_ai/homePage.dart';
import 'package:bird_migration_ai/migrationPage.dart';
import 'package:bird_migration_ai/uploadDataPage.dart';
import 'package:flutter/material.dart';

class RouteWidget extends StatefulWidget {
  const RouteWidget({super.key});

  @override
  State<RouteWidget> createState() => _RouteWidgetState();
}

class _RouteWidgetState extends State<RouteWidget> {
  int pageIndex = 0; // Index of the current active page

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    MigrationPage(),
    BirdPredictionPage(),
    UploadDataPage(),
    ForumPage(),
  ]; // Page options

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFe6e6dd), // Light beige background
      body: _widgetOptions.elementAt(pageIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Fixes the issue of not appearing if more than 3 items
        backgroundColor: const Color(0xFFd4d4c8), // Slightly darker beige for navigation bar
        selectedItemColor: const Color(0xFF629584), // Soft sage green for selected item
        unselectedItemColor: Colors.white70, // Soft white for unselected items
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        currentIndex: pageIndex,
        onTap: (index) {
          setState(() {
            pageIndex = index; // Set the page index to the page index they tapped on
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Migration Path",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image_outlined),
            label: "Predict Species",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_saver_on),
            label: "Report Sighting",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: "Community",
          ),
        ],
      ),
    );
  }
}
