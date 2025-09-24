import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class PathMapScreen extends StatefulWidget {
  const PathMapScreen({super.key});

  @override
  State<PathMapScreen> createState() => _PathMapScreenState();
}

class _PathMapScreenState extends State<PathMapScreen> {
  List<LatLng> routePoints = [];
  double distanceInKm = 0.0;

  @override
  void initState() {
    super.initState();
    _getRoute();
  }

  Future<void> _getRoute() async {
    final start = LatLng(23.2599, 77.4126); // Example: Bhopal Point A
    final end = LatLng(23.2450, 77.4090); // Example: Bhopal Point B

    final url =
        "http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson";

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    final geometry = data["routes"][0]["geometry"]["coordinates"];
    final distance = data["routes"][0]["distance"]; // meters

    setState(() {
      routePoints = geometry
          .map<LatLng>((point) => LatLng(point[1], point[0]))
          .toList();
      distanceInKm = distance / 1000; // convert meters → km
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Path with Actual Distance")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(23.2599, 77.4126),
          initialZoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          PolylineLayer(
            polylines: [
              Polyline(points: routePoints, color: Colors.blue, strokeWidth: 5),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Text(
          "Actual Distance: ${distanceInKm.toStringAsFixed(2)} km",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
