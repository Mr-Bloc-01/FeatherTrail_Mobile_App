import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:geolocator/geolocator.dart';

class UploadDataPage extends StatefulWidget {
  const UploadDataPage({super.key});

  @override
  State<UploadDataPage> createState() => _UploadDataPageState();
}

class _UploadDataPageState extends State<UploadDataPage> {
  String? _species;
  double? _temperature;
  double? _wind_speed;
  String? _wind_direction;
  Map<String, dynamic>? _coords;

  Future<bool> uploadData() async {
    try {
      final url = Uri.parse("https://aarons-bird-migration-project.onrender.com/upload-data");
      final response = await post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "species": _species,
          "temperature": _temperature,
          "wind_speed": _wind_speed,
          "wind_direction": _wind_direction,
          "coords": _coords,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) {
            return _buildAlertDialog(
              title: "Thanks!",
              content: "Your data has been saved into our database and will be used for training our model!",
            );
          },
        );
        return true;
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return _buildAlertDialog(
              title: "Oops!",
              content: "There was an error processing your data. Please check your inputs and try again.",
            );
          },
        );
        return false;
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) {
          return _buildAlertDialog(
            title: "Oops!",
            content: "There was an issue reaching our server. Please try again later.",
          );
        },
      );
      return false;
    }
  }

  Future<void> _getCoordinates() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(
        context: context,
        builder: (context) {
          return _buildAlertDialog(
            title: "Location Required",
            content: "Please enable location services to submit your data.",
          );
        },
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showDialog(
          context: context,
          builder: (context) {
            return _buildAlertDialog(
              title: "Location Required",
              content: "You must allow location permissions to use this feature.",
            );
          },
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        builder: (context) {
          return _buildAlertDialog(
            title: "Location Required",
            content: "Location permissions have been denied forever. Please enable location permissions in settings.",
          );
        },
      );
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _coords = {
          "latitude": position.latitude,
          "longitude": position.longitude,
        };
      });
    } catch (error) {
      print("Error fetching coordinates: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    _getCoordinates();
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
          "Report Sighting",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.appBarTheme.titleTextStyle?.color ?? textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Species:",
                  style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  hintText: "Enter bird species",
                  onChanged: (text) => _species = text,
                  fillColor: cardColor,
                  textColor: textColor,
                ),
                const SizedBox(height: 16),
                Text(
                  "Temperature (°C):",
                  style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  hintText: "Enter temperature",
                  onChanged: (text) => _temperature = double.tryParse(text),
                  keyboardType: TextInputType.number,
                  fillColor: cardColor,
                  textColor: textColor,
                ),
                const SizedBox(height: 16),
                Text(
                  "Wind Speed (m/s):",
                  style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  hintText: "Enter wind speed",
                  onChanged: (text) => _wind_speed = double.tryParse(text),
                  keyboardType: TextInputType.number,
                  fillColor: cardColor,
                  textColor: textColor,
                ),
                const SizedBox(height: 16),
                Text(
                  "Wind Direction:",
                  style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  hintText: "Enter wind direction",
                  onChanged: (text) => _wind_direction = text,
                  fillColor: cardColor,
                  textColor: textColor,
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF629584), // Sage green button
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (_species?.isNotEmpty == true &&
                          _temperature != null &&
                          _wind_speed != null &&
                          _wind_direction?.isNotEmpty == true &&
                          _coords != null) {
                        uploadData();
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return _buildAlertDialog(
                              title: "Incomplete Information",
                              content: "Please fill out all fields (enter 0 if there is no wind).",
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
    Color? fillColor,
    Color? textColor,
  }) {
    return TextField(
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ?? Colors.white, // White fill for light background
        hintText: hintText,
        hintStyle: TextStyle(color: textColor ?? Colors.black54),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black87),
        ),
      ),
      style: TextStyle(color: textColor ?? Colors.black87),
    );
  }

  AlertDialog _buildAlertDialog({required String title, required String content}) {
    return AlertDialog(
      backgroundColor: const Color(0xFFd4d4c8),
      title: Text(title, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      content: Text(content, style: const TextStyle(color: Colors.black54)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("OK", style: TextStyle(color: Colors.black87)),
        ),
      ],
    );
  }
}
