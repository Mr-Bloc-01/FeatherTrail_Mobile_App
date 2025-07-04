import 'package:bird_migration_ai/routeWidget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FeatherTrail',
      debugShowCheckedModeBanner: false,  // remove the debug banner
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFe6e6dd)),
        useMaterial3: true,
      ),
      home: const RouteWidget(),
    );
  }
}