import 'dart:convert';
import 'package:http/http.dart' as http;

class EBirdService {
  static const String _apiKey = 'akghtfou5pie';
  static const String _baseUrl = 'https://api.ebird.org/v2';

  /// Fetch recent bird sightings near the given latitude and longitude.
  static Future<List<dynamic>> getRecentSightings(double lat, double lng) async {
    final url = Uri.parse('$_baseUrl/data/obs/geo/recent?lat=$lat&lng=$lng');
    final response = await http.get(
      url,
      headers: {'X-eBirdApiToken': _apiKey},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load eBird data: ${response.statusCode}');
    }
  }

  /// Fetch recent bird sightings by region code (e.g., US-CA, US, CA-ON, etc.)
  static Future<List<dynamic>> getRecentSightingsByRegion(String regionCode) async {
    final url = Uri.parse('$_baseUrl/data/obs/$regionCode/recent');
    final response = await http.get(
      url,
      headers: {'X-eBirdApiToken': _apiKey},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load eBird data for region: ${response.statusCode}');
    }
  }
} 