import 'package:bird_migration_ai/birdPredictionPage.dart';
import 'package:bird_migration_ai/forumPage.dart';
import 'package:bird_migration_ai/homePage.dart';
import 'package:bird_migration_ai/migrationPage.dart';
import 'package:bird_migration_ai/uploadDataPage.dart';
import 'package:bird_migration_ai/ebirdSightingsPage.dart';
import 'package:bird_migration_ai/constants/app_colors.dart';
import 'package:bird_migration_ai/constants/app_strings.dart';
import 'package:bird_migration_ai/main.dart';
import 'package:flutter/material.dart';

class RouteWidget extends StatefulWidget {
  const RouteWidget({super.key});

  @override
  State<RouteWidget> createState() => _RouteWidgetState();
}

class _RouteWidgetState extends State<RouteWidget> {
  int _currentIndex = 0;

  static final List<Widget> _pages = <Widget>[
    HomePage(),
    MigrationPage(),
    BirdPredictionPage(),
    UploadDataPage(),
    EBirdSightingsPage(),
    ForumPage(),
  ];

  static final List<String> _titles = <String>[
    AppStrings.titleHome,
    AppStrings.titleMigration,
    AppStrings.titleSpecies,
    AppStrings.titleReport,
    'eBird',
    AppStrings.titleCommunity,
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeMode,
      builder: (context, mode, _) {
        return Scaffold(
          body: _pages[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
            currentIndex: _currentIndex,
            onTap: (index) {
              // If the last icon (theme toggle) is tapped, toggle theme instead of changing page
              if (index == 6) {
                ThemeController.toggleTheme();
              } else {
                setState(() {
                  _currentIndex = index;
                });
              }
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: AppStrings.navHome,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: AppStrings.navMigration,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.image_outlined),
                label: AppStrings.navPredict,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.data_saver_on),
                label: AppStrings.navReport,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.public),
                label: 'eBird',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.forum),
                label: AppStrings.navCommunity,
              ),
             BottomNavigationBarItem(
               icon: Icon(Icons.brightness_6),
               label: 'Theme',
             ),
            ],
          ),
        );
      },
    );
  }
}
