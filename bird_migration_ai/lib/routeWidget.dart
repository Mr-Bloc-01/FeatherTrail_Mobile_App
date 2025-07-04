import 'package:bird_migration_ai/birdPredictionPage.dart';
import 'package:bird_migration_ai/forumPage.dart';
import 'package:bird_migration_ai/homePage.dart';
import 'package:bird_migration_ai/migrationPage.dart';
import 'package:bird_migration_ai/uploadDataPage.dart';
import 'package:bird_migration_ai/constants/app_colors.dart';
import 'package:bird_migration_ai/constants/app_strings.dart';
import 'package:flutter/material.dart';

class RouteWidget extends StatefulWidget {
  const RouteWidget({super.key});

  @override
  State<RouteWidget> createState() => _RouteWidgetState();
}

class _RouteWidgetState extends State<RouteWidget> {
  int _currentIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    MigrationPage(),
    BirdPredictionPage(),
    UploadDataPage(),
    ForumPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.backgroundSecondary,
        selectedItemColor: AppColors.sageGreen,
        unselectedItemColor: AppColors.textLightSecondary,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
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
            icon: Icon(Icons.forum),
            label: AppStrings.navCommunity,
          ),
        ],
      ),
    );
  }
}
