import 'package:geolocator/geolocator.dart';
import '../constants/app_strings.dart';

class LocationService {
  // Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
  
  // Check location permission status
  static Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }
  
  // Request location permission
  static Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }
  
  // Get current position
  static Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
  
  // Get location coordinates as a map
  static Future<Map<String, dynamic>?> getCoordinates() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception(AppStrings.locationEnableMessage);
      }
      
      // Check permission status
      LocationPermission permission = await checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception(AppStrings.locationPermissionMessage);
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw Exception(AppStrings.locationDeniedMessage);
      }
      
      // Get current position
      Position position = await getCurrentPosition();
      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
    } catch (e) {
      throw Exception('${AppStrings.errorFetchingCoordinates}$e');
    }
  }
  
  // Validate location permission and get coordinates
  static Future<Map<String, dynamic>?> validateAndGetCoordinates() async {
    try {
      return await getCoordinates();
    } catch (e) {
      rethrow;
    }
  }
} 