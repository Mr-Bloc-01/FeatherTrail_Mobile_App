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
  int? _selectedMarkerIndex;
  static bool _hasShownInfoDialog = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInfoDialogOnce();
    });
    _fetchSightings();
  }

  void _showInfoDialogOnce() {
    if (!_hasShownInfoDialog) {
      _hasShownInfoDialog = true;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('eBird Coverage Notice'),
          content: const Text(
            'eBird is still growing! Some regions may not have recent bird sighting data available yet. Try searching for a different region if you get no results.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _fetchSightings({String? region}) async {
    setState(() {
      _loading = true;
      _error = null;
      _currentRegion = region;
      _selectedMarkerIndex = null;
    });
    try {
      List<dynamic> sightings;
      LatLng? mapCenter;
      if (region != null && region.trim().isNotEmpty) {
        sightings = await EBirdService.getRecentSightingsByRegion(region.trim());
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

  void _showSightingDetails(Map<String, dynamic> sighting) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(sighting['comName'] ?? 'Bird Sighting'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (sighting['sciName'] != null)
                Text('Scientific: ${sighting['sciName']}'),
              if (sighting['howMany'] != null)
                Text('Count: ${sighting['howMany']}'),
              if (sighting['locName'] != null)
                Text('Location: ${sighting['locName']}'),
              if (sighting['obsDt'] != null)
                Text('Date: ${sighting['obsDt']}'),
              if (sighting['userDisplayName'] != null)
                Text('Observer: ${sighting['userDisplayName']}'),
              if (sighting['subId'] != null)
                Text('Checklist: ${sighting['subId']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
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
                      hintText: 'Search by region code (e.g., US-CA, US, CA-ON)',
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
                                      onTap: (_, __) {
                                        setState(() {
                                          _selectedMarkerIndex = null;
                                        });
                                      },
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
                                          ..._sightings.asMap().entries.map((entry) {
                                            final index = entry.key;
                                            final sighting = entry.value;
                                            final lat = sighting['lat']?.toDouble();
                                            final lng = sighting['lng']?.toDouble();
                                            if (lat == null || lng == null) return null;
                                            return Marker(
                                              point: LatLng(lat, lng),
                                              width: 30,
                                              height: 30,
                                              builder: (ctx) => GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _selectedMarkerIndex = index;
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.location_on,
                                                  color: _selectedMarkerIndex == index ? Colors.orange : Colors.red,
                                                  size: 28,
                                                ),
                                              ),
                                            );
                                          }).whereType<Marker>().toList(),
                                        ],
                                      ),
                                      if (_selectedMarkerIndex != null && _selectedMarkerIndex! < _sightings.length)
                                        MarkerLayer(
                                          markers: [
                                            Marker(
                                              point: LatLng(
                                                _sightings[_selectedMarkerIndex!]['lat'].toDouble(),
                                                _sightings[_selectedMarkerIndex!]['lng'].toDouble(),
                                              ),
                                              width: 220,
                                              height: 100,
                                              builder: (ctx) {
                                                final sighting = _sightings[_selectedMarkerIndex!];
                                                return Card(
                                                  color: Colors.white,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: SingleChildScrollView(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            sighting['comName'] ?? '',
                                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                          if (sighting['sciName'] != null)
                                                            Text('Scientific: ${sighting['sciName']}', maxLines: 1, overflow: TextOverflow.ellipsis),
                                                          if (sighting['howMany'] != null)
                                                            Text('Count: ${sighting['howMany']}'),
                                                          if (sighting['obsDt'] != null)
                                                            Text('Date: ${sighting['obsDt']}'),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
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
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (sighting['sciName'] != null)
                                            Text('Scientific: ${sighting['sciName']}'),
                                          if (sighting['howMany'] != null)
                                            Text('Count: ${sighting['howMany']}'),
                                          Text('Location: ${sighting['locName'] ?? 'Unknown'}'),
                                          Text('Date: ${sighting['obsDt'] ?? ''}'),
                                          if (sighting['userDisplayName'] != null)
                                            Text('Observer: ${sighting['userDisplayName']}'),
                                        ],
                                      ),
                                      isThreeLine: true,
                                      onTap: () => _showSightingDetails(sighting),
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