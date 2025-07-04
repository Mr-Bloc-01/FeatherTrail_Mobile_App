import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/app_strings.dart';

class ApiService {
  static const String _baseUrl = 'https://aarons-bird-migration-project.onrender.com';
  
  // Bird Classification API
  static Future<Map<String, dynamic>> classifyBird(File imageFile) async {
    try {
      final url = Uri.parse('$_baseUrl/bird_detection');
      final request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
      
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        return jsonDecode(responseData);
      } else {
        throw Exception('${AppStrings.alertClassificationError}${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to classify bird: $e');
    }
  }
  
  // Migration Prediction API
  static Future<Map<String, dynamic>> predictMigration({
    required double temperatureChange,
    required double windSpeedChange,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/migration_prediction');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'change_in_temp': temperatureChange,
          'change_in_wind_speed': windSpeedChange,
        }),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(AppStrings.errorGettingResponse);
      }
    } catch (e) {
      throw Exception('Failed to predict migration: $e');
    }
  }
  
  // Upload Data API
  static Future<Map<String, dynamic>> uploadSightingData({
    required String? species,
    required double? temperature,
    required double? windSpeed,
    required String? windDirection,
    required Map<String, dynamic>? coordinates,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/upload-data');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'species': species,
          'temperature': temperature,
          'wind_speed': windSpeed,
          'wind_direction': windDirection,
          'coords': coordinates,
        }),
      );
      
      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to upload data: $e');
    }
  }
} 