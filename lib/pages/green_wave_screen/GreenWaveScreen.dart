// green_wave_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

/// Ready-to-paste screen for Green Wave Corridor
class GreenWaveScreen extends StatefulWidget {
  const GreenWaveScreen({super.key});

  @override
  State<GreenWaveScreen> createState() => _GreenWaveScreenState();
}

class _GreenWaveScreenState extends State<GreenWaveScreen> {
  final MapController _mapController = MapController();
  final List<LatLng> greenWaveRoute = [
    LatLng(23.2400, 77.4000),
    LatLng(23.2410, 77.4020),
    LatLng(23.2425, 77.4040),
    LatLng(23.2435, 77.4060),
    LatLng(23.2450, 77.4080),
    LatLng(23.2465, 77.4100),
    LatLng(23.2480, 77.4120),
    LatLng(23.2495, 77.4140),
  ];
  List<Map<String, dynamic>> greenWaveSignals = [];

  // Example traffic signals around Bhopal (add/replace with your full list)
  List<Map<String, dynamic>> trafficLights = [
    {
      "name": "MP Nagar Crossing",
      "location": LatLng(23.2336, 77.4344),
      "status": "Red",
    },
    {
      "name": "New Market Square",
      "location": LatLng(23.2412, 77.4010),
      "status": "Red",
    },
    {
      "name": "Berasia Road Signal",
      "location": LatLng(23.2812, 77.4360),
      "status": "Red",
    },
    {
      "name": "Vikram Nagar",
      "location": LatLng(23.2440, 77.4350),
      "status": "Red",
    },
    {
      "name": "Arera Colony",
      "location": LatLng(23.2465, 77.4135),
      "status": "Red",
    },
    {
      "name": "Indrapuri",
      "location": LatLng(23.2640, 77.4280),
      "status": "Red",
    },
    // add more signals as needed...
  ];

  // Route related
  List<LatLng> routePoints = [];
  double routeDistanceKm = 0.0;
  bool _isLoadingRoute = false;

  // Green wave state
  bool _greenWaveActive = false;
  List<int> _corridorSignalIndexes = [];

  // Buffer distance in meters to consider a signal "on the route"
  final double _onRouteBufferMeters = 150.0;

  // Time between making consecutive signals green (seconds)
  final int _greenDelaySeconds = 4;

  // Example start & end (you can let user pick these)
  LatLng startPoint = LatLng(23.2599, 77.4126); // Center Bhopal (example)
  LatLng endPoint = LatLng(23.2450, 77.4090);

  @override
  void initState() {
    super.initState();
    greenWaveSignals = List.generate(greenWaveRoute.length, (index) {
      return {
        "name": "Signal ${index + 1}",
        "location": greenWaveRoute[index],
        "status": "Red",
      };
    });

    // Optionally center map on start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(startPoint, 13.0);
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Green":
        return Colors.green;
      case "Yellow":
        return Colors.amber;
      case "Red":
      default:
        return Colors.red;
    }
  }

  /// Fetch actual road route between start & end using OSRM (geojson coordinates)
  Future<void> _fetchRouteFromOSRM(LatLng start, LatLng end) async {
    setState(() {
      _isLoadingRoute = true;
      routePoints = [];
      routeDistanceKm = 0.0;
      _corridorSignalIndexes = [];
    });

    try {
      final url =
          "https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson";
      final resp = await http.get(Uri.parse(url));
      if (resp.statusCode != 200) {
        throw Exception('Routing API error: ${resp.statusCode}');
      }
      final data = json.decode(resp.body);
      final geometry =
          data['routes'][0]['geometry']['coordinates'] as List<dynamic>;
      final distanceMeters = data['routes'][0]['distance'] as num;

      // Convert geometry coords [lon, lat] -> LatLng(lat, lon)
      final pts = geometry.map<LatLng>((c) {
        final lon = (c as List)[0] as num;
        final lat = c[1] as num;
        return LatLng(lat.toDouble(), lon.toDouble());
      }).toList();

      setState(() {
        routePoints = pts;
        routeDistanceKm = (distanceMeters.toDouble()) / 1000.0;
      });

      // After getting route, detect which signals lie along this route
      _detectSignalsOnRoute();
      // Center and zoom map to route bounds
      _zoomToRoute();
    } catch (e) {
      debugPrint("Route fetch error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Route fetch failed: $e')));
    } finally {
      setState(() {
        _isLoadingRoute = false;
      });
    }
  }

  /// Zoom map to fit route
  void _zoomToRoute() {
    if (routePoints.isEmpty) return;

    double minLat = routePoints.first.latitude;
    double maxLat = minLat;
    double minLng = routePoints.first.longitude;
    double maxLng = minLng;

    for (var p in routePoints) {
      minLat = p.latitude < minLat ? p.latitude : minLat;
      maxLat = p.latitude > maxLat ? p.latitude : maxLat;
      minLng = p.longitude < minLng ? p.longitude : minLng;
      maxLng = p.longitude > maxLng ? p.longitude : maxLng;
    }

    final bounds = LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));

    try {
      _mapController.fitCamera(
        CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(40)),
      );
    } catch (_) {
      // ignore if map controller not ready
    }
  }

  /// Detect which traffic signals are close to route (simple point-to-points minimum check)
  void _detectSignalsOnRoute() {
    if (routePoints.isEmpty) return;

    final Distance distance = const Distance();

    List<int> corridorIndexes = [];

    for (int i = 0; i < trafficLights.length; i++) {
      final LatLng sig = trafficLights[i]['location'] as LatLng;

      // compute minimum distance from this signal to any point on route (approx)
      double minDistMeters = double.infinity;
      for (final rp in routePoints) {
        final d = distance(rp, sig); // in meters
        if (d < minDistMeters) minDistMeters = d;
      }

      if (minDistMeters <= _onRouteBufferMeters) {
        corridorIndexes.add(i);
      }
    }

    setState(() {
      _corridorSignalIndexes = corridorIndexes;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${corridorIndexes.length} signals detected on corridor'),
      ),
    );
  }

  /// Start the green wave: sequentially set corridor signals to GREEN
  Future<void> _startGreenWave() async {
    if (routePoints.isEmpty || _corridorSignalIndexes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Route or corridor signals not ready. Fetch route first.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _greenWaveActive = true;
    });

    // Optional: sort detected signals by their position along the route
    // Simple approach: find index of closest route point for each signal and sort by that index
    List<Map<String, dynamic>> ordered = [];
    for (int idx in _corridorSignalIndexes) {
      final sig = trafficLights[idx]['location'] as LatLng;
      int closestRouteIndex = 0;
      double minDist = double.infinity;
      for (int i = 0; i < routePoints.length; i++) {
        final d = const Distance()(routePoints[i], sig);
        if (d < minDist) {
          minDist = d;
          closestRouteIndex = i;
        }
      }
      ordered.add({"signalIndex": idx, "routeIndex": closestRouteIndex});
    }
    ordered.sort(
      (a, b) => (a['routeIndex'] as int).compareTo(b['routeIndex'] as int),
    );
    final orderedSignalIndexes = ordered
        .map<int>((e) => e['signalIndex'] as int)
        .toList();

    // Sequentially turn them green with delay
    for (int i = 0; i < orderedSignalIndexes.length; i++) {
      if (!_greenWaveActive) break; // stop if deactivated
      final sigIdx = orderedSignalIndexes[i];
      setState(() {
        trafficLights[sigIdx]['status'] = 'Green';
      });
      // Wait some seconds before next signal
      await Future.delayed(Duration(seconds: _greenDelaySeconds));
    }

    // Optionally after sequence ends, keep them green for some time then reset
    if (_greenWaveActive) {
      await Future.delayed(const Duration(seconds: 6));
      _resetCorridorToDefault();
      setState(() {
        _greenWaveActive = false;
      });
    }
  }

  /// Stop green wave immediately and reset corridor signals to Red (or previous status)
  void _stopGreenWave() {
    setState(() {
      _greenWaveActive = false;
    });
    _resetCorridorToDefault();
  }

  void _resetCorridorToDefault() {
    setState(() {
      for (int idx in _corridorSignalIndexes) {
        trafficLights[idx]['status'] = 'Red';
      }
    });
  }

  /// Helper to pick route and start green wave in one go
  Future<void> _prepareAndStart(LatLng s, LatLng e) async {
    await _fetchRouteFromOSRM(s, e);
    await _startGreenWave();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Green Wave Corridor'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                // Reset UI state
                routePoints = [];
                routeDistanceKm = 0.0;
                _corridorSignalIndexes = [];
                _greenWaveActive = false;
                for (var s in trafficLights) {
                  s['status'] = 'Red';
                }
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: startPoint, initialZoom: 13.0),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.example.smart_traffic',
              ),

              // Route polyline
              if (routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: greenWaveRoute,
                      color: Colors.blueAccent,
                      strokeWidth: 5.0,
                    ),
                  ],
                ),

              // Markers for start/end
              MarkerLayer(
                markers: [
                  Marker(
                    point: startPoint,
                    width: 48,
                    height: 48,
                    child: const Icon(
                      Icons.circle,
                      color: Colors.green,
                      size: 28,
                    ),
                  ),
                  Marker(
                    point: endPoint,
                    width: 48,
                    height: 48,
                    child: const Icon(
                      Icons.circle,
                      color: Colors.red,
                      size: 28,
                    ),
                  ),
                ],
              ),

              // Traffic signal markers (highlight corridor signals)
              MarkerLayer(
                markers: List.generate(trafficLights.length, (i) {
                  final light = trafficLights[i];
                  final isOnCorridor = _corridorSignalIndexes.contains(i);
                  final markerColor = _getStatusColor(light['status']);
                  final borderColor = isOnCorridor
                      ? Colors.yellow
                      : Colors.white;
                  return Marker(
                    point: light['location'] as LatLng,
                    width: 90,
                    height: 90,
                    child: GestureDetector(
                      onTap: () {
                        // toggle locally on tap
                        setState(() {
                          trafficLights[i]['status'] =
                              (trafficLights[i]['status'] == 'Green')
                              ? 'Red'
                              : 'Green';
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: borderColor,
                                width: isOnCorridor ? 3 : 1,
                              ),
                            ),
                            padding: const EdgeInsets.all(2),
                            child: Icon(
                              Icons.traffic,
                              color: markerColor,
                              size: 34,
                            ),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: 70,
                            child: Text(
                              light['name'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 10),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),

          // Top info card showing route distance & detected signals
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Route Distance: ${routeDistanceKm.toStringAsFixed(2)} km',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Signals on corridor: ${_corridorSignalIndexes.length}',
                          ),
                        ],
                      ),
                    ),
                    _isLoadingRoute
                        ? const CircularProgressIndicator()
                        : ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            icon: const Icon(Icons.alt_route),
                            label: const Text('Fetch Route'),
                            onPressed: () =>
                                _fetchRouteFromOSRM(startPoint, endPoint),
                          ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom action buttons: Start/Stop Green Wave
          Positioned(
            bottom: 16,
            left: 12,
            right: 12,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Green Wave'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: _greenWaveActive
                        ? null
                        : () => _startGreenWave(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.stop),
                    label: const Text('Stop / Reset'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    onPressed: _greenWaveActive
                        ? _stopGreenWave
                        : _resetCorridorToDefault,
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
