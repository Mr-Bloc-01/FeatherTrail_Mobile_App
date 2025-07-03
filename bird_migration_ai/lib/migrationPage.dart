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
    return Scaffold(
      backgroundColor: const Color(0xFF2d305b), // Dark blue background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1b1f3b), // Darker blue for the AppBar
        title: const Text(
          "Bird Migration Predictor",
          style: TextStyle(
            color: Colors.white,
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
            const Text(
              "Enter Temperature Change (°C):",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE2F1E7), // Off-white for labels
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tempController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Change in °C",
                filled: true,
                fillColor: Color(0xFF387478), // Sage green for the input field
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 15),
            const Text(
              "Enter Wind Speed Change (m/s):",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE2F1E7),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _windSpeedController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Change in m/s",
                filled: true,
                fillColor: Color(0xFF387478),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF629584), // Soft sage green button
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
                    color: Colors.white,
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
                    // Polyline Layer to Connect Markers
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: _predictedCoords.map((location) => location).toList(),
                          strokeWidth: 3.0,
                          color: const Color(0xFF629584), // Soft sage green for the polyline
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: _predictedCoords.map((location) {
                        return Marker(
                          point: location,
                          width: 40,
                          height: 40,
                          builder: (context) => const Icon(
                            Icons.location_on,
                            color: Color(0xFF196772),
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
