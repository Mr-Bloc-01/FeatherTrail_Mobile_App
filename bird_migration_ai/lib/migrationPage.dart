import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MigrationPage extends StatefulWidget {
  const MigrationPage({super.key});

  @override
  State<MigrationPage> createState() => _MigrationPageState();
}

class _MigrationPageState extends State<MigrationPage> {
  final TextEditingController _tempController = TextEditingController();
  final TextEditingController _windSpeedController = TextEditingController();
  List<LatLng> _predictedCoords = [];

  // Function for the HTTP request to the /migration_prediction route within the backend server
  Future<void> requestMigrationPrediction() async {
    final double _tempChange = double.tryParse(_tempController.text) ?? 0.0;
    final double _windSpeedChange = double.tryParse(_windSpeedController.text) ?? 0.0;

    final url = Uri.parse('https://aarons-bird-migration-project.onrender.com/migration_prediction');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'change_in_temp': _tempChange,
        'change_in_wind_speed': _windSpeedChange,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      final predictions = data['predictions'] as List;

      setState(() {
        _predictedCoords = predictions.map((entry) {
          final parts = entry.split("/");
          final double latitude = double.parse(parts[3]);
          final double longitude = double.parse(parts[2]);
          LatLng coords = LatLng(latitude, longitude);
          print(coords);
          return coords;
        }).toList();
      });
    } else {
      print("Error getting response");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color;
    final cardColor = theme.cardColor;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface,
        title: Text(
          "Migration Predictor",
          style: theme.appBarTheme.titleTextStyle ?? TextStyle(
            color: theme.textTheme.titleLarge?.color,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Enter Temperature Change ( 0C):",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tempController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Change in  0C",
                filled: true,
                fillColor: cardColor,
                border: const OutlineInputBorder(),
                labelStyle: TextStyle(color: textColor),
              ),
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 15),
            Text(
              "Enter Wind Speed Change (m/s):",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _windSpeedController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Change in m/s",
                filled: true,
                fillColor: cardColor,
                border: const OutlineInputBorder(),
                labelStyle: TextStyle(color: textColor),
              ),
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: requestMigrationPrediction,
                child: const Text(
                  "Get Migration Prediction",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(0, 0),
                    zoom: 2,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: _predictedCoords.map((location) => location).toList(),
                          strokeWidth: 3.0,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: _predictedCoords.map((location) {
                        return Marker(
                          point: location,
                          width: 40,
                          height: 40,
                          builder: (context) => Icon(
                            Icons.location_on,
                            color: theme.colorScheme.secondary,
                            size: 20,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
