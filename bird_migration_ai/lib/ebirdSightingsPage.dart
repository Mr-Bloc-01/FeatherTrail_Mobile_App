import 'package:flutter/material.dart';
import 'package:bird_migration_ai/services/ebird_service.dart';
import 'package:bird_migration_ai/services/location_service.dart';
import 'package:bird_migration_ai/constants/app_colors.dart';
import 'package:bird_migration_ai/constants/app_text_styles.dart';
import 'package:bird_migration_ai/constants/app_dimensions.dart';
import 'package:bird_migration_ai/constants/app_strings.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class EBirdSightingsPage extends StatefulWidget {
  const EBirdSightingsPage({Key? key}) : super(key: key);

  @override
  State<EBirdSightingsPage> createState() => _EBirdSightingsPageState();
}

class _EBirdSightingsPageState extends State<EBirdSightingsPage> {
  bool _loading = true;
  String? _error;
  List<dynamic> _sightings = [];
  LatLng? _userLocation;
  final TextEditingController _searchController = TextEditingController();
  String? _currentRegion;

  @override
  void initState() {
    super.initState();
    _fetchSightings();
  }

  Future<void> _fetchSightings({String? region}) async {
    setState(() {
      _loading = true;
      _error = null;
      _currentRegion = region;
    });
    try {
      List<dynamic> sightings;
      LatLng? mapCenter;
      if (region != null && region.trim().isNotEmpty) {
        // Use eBird region API
        sightings = await EBirdService.getRecentSightingsByRegion(region.trim());
        // Try to get a rough center for the region (fallback: use first sighting)
        if (sightings.isNotEmpty && sightings[0]['lat'] != null && sightings[0]['lng'] != null) {
          mapCenter = LatLng(sightings[0]['lat'].toDouble(), sightings[0]['lng'].toDouble());
        }
      } else {
        final coords = await LocationService.getCoordinates();
        if (coords == null) throw Exception('Could not get location');
        final lat = coords['latitude'] as double;
        final lng = coords['longitude'] as double;
        sightings = await EBirdService.getRecentSightings(lat, lng);
        mapCenter = LatLng(lat, lng);
      }
      setState(() {
        _userLocation = mapCenter;
        _sightings = sightings;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eBird Sightings'),
      ),
      backgroundColor: AppColors.backgroundPrimary,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search by region (city, state, country)',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingM),
                ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    _fetchSightings(region: _searchController.text);
                  },
                  child: const Icon(Icons.search),
                ),
                if (_currentRegion != null && _currentRegion!.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    tooltip: 'Clear search',
                    onPressed: () {
                      _searchController.clear();
                      _fetchSightings(region: null);
                    },
                  ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text(_error!, style: AppTextStyles.bodyLarge))
                    : _sightings.isEmpty
                        ? const Center(child: Text('No recent sightings found.'))
                        : Column(
                            children: [
                              if (_userLocation != null)
                                SizedBox(
                                  height: 250,
                                  child: FlutterMap(
                                    options: MapOptions(
                                      center: _userLocation,
                                      zoom: 10,
                                    ),
                                    children: [
                                      TileLayer(
                                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                        userAgentPackageName: 'com.example.app',
                                      ),
                                      MarkerLayer(
                                        markers: [
                                          if (_currentRegion == null || _currentRegion!.isEmpty)
                                            Marker(
                                              point: _userLocation!,
                                              width: 40,
                                              height: 40,
                                              builder: (ctx) => const Icon(Icons.person_pin_circle, color: Colors.blue, size: 36),
                                            ),
                                          ..._sightings.map((sighting) {
                                            final lat = sighting['lat']?.toDouble();
                                            final lng = sighting['lng']?.toDouble();
                                            if (lat == null || lng == null) return null;
                                            return Marker(
                                              point: LatLng(lat, lng),
                                              width: 30,
                                              height: 30,
                                              builder: (ctx) => const Icon(Icons.location_on, color: Colors.red, size: 28),
                                            );
                                          }).whereType<Marker>().toList(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: AppDimensions.spacingL),
                              Expanded(
                                child: ListView.separated(
                                  itemCount: _sightings.length,
                                  separatorBuilder: (context, index) => const Divider(),
                                  itemBuilder: (context, index) {
                                    final sighting = _sightings[index];
                                    return ListTile(
                                      leading: const Icon(Icons.emoji_nature, color: AppColors.sageGreen),
                                      title: Text(sighting['comName'] ?? 'Unknown', style: AppTextStyles.bodyLarge),
                                      subtitle: Text('Location:  [38;5;246m${sighting['locName'] ?? 'Unknown'}\nDate: ${sighting['obsDt'] ?? ''}'),
                                      isThreeLine: true,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
          ),
        ],
      ),
    );
  }
} 