import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:signal/pages/green_wave_screen/GreenWaveScreen.dart';
import 'package:signal/pages/login_screen/LoginScreen.dart';
import 'package:signal/pages/path_map_screen/PathMapScreen.dart';
import 'package:signal/pages/profile_screen/ProfileScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MapController _mapController = MapController();
  final LatLng _center = LatLng(23.2599, 77.4126);

  List<Map<String, dynamic>> trafficLights = [
    {
      "name": "MP Nagar Square",
      "location": LatLng(23.2336, 77.4344),
      "status": "Red",
    },
    {
      "name": "New Market Square",
      "location": LatLng(23.2412, 77.4010),
      "status": "Green",
    },
    {
      "name": "Berasia Road Junction",
      "location": LatLng(23.2812, 77.4360),
      "status": "Yellow",
    },
    {
      "name": "Vikram Nagar Crossing",
      "location": LatLng(23.2440, 77.4350),
      "status": "Red",
    },
    {
      "name": "Arera Colony Square",
      "location": LatLng(23.2465, 77.4135),
      "status": "Green",
    },
    {
      "name": "Indrapuri Junction",
      "location": LatLng(23.2640, 77.4280),
      "status": "Red",
    },
    {
      "name": "Habibganj Chowk",
      "location": LatLng(23.1980, 77.4410),
      "status": "Yellow",
    },
    {
      "name": "Rani Kamlapati Road Junction",
      "location": LatLng(23.1970, 77.4240),
      "status": "Green",
    },
    {
      "name": "Lalghati Crossing",
      "location": LatLng(23.2320, 77.4070),
      "status": "Red",
    },
    {
      "name": "DB Mall Square",
      "location": LatLng(23.2380, 77.4190),
      "status": "Yellow",
    },
    {
      "name": "Kolar Road Junction",
      "location": LatLng(23.3010, 77.4360),
      "status": "Red",
    },
    {
      "name": "Barkheda Square",
      "location": LatLng(23.2610, 77.4090),
      "status": "Green",
    },
    {
      "name": "Bairagarh Crossing",
      "location": LatLng(23.2510, 77.3870),
      "status": "Yellow",
    },
    {
      "name": "Vikram University Square",
      "location": LatLng(23.2490, 77.3960),
      "status": "Red",
    },
    {
      "name": "Gufa Road Junction",
      "location": LatLng(23.2700, 77.4270),
      "status": "Green",
    },
    {
      "name": "Malviya Nagar Crossing",
      "location": LatLng(23.2515, 77.4085),
      "status": "Yellow",
    },
    {
      "name": "Bhojpur Square",
      "location": LatLng(23.2300, 77.4350),
      "status": "Red",
    },
    {
      "name": "Narela Junction",
      "location": LatLng(23.2400, 77.4050),
      "status": "Green",
    },
    {
      "name": "Habibganj Square",
      "location": LatLng(23.1990, 77.4400),
      "status": "Yellow",
    },
    {
      "name": "NCC Circle",
      "location": LatLng(23.2420, 77.4130),
      "status": "Red",
    },
    {
      "name": "Shyamla Hills Crossing",
      "location": LatLng(23.2590, 77.4050),
      "status": "Green",
    },
    {
      "name": "Ayodhya Bypass Junction",
      "location": LatLng(23.2800, 77.4200),
      "status": "Yellow",
    },
    {
      "name": "Raisen Road Square",
      "location": LatLng(23.2300, 77.4400),
      "status": "Red",
    },
    {
      "name": "Bawadiya Kalan Crossing",
      "location": LatLng(23.2400, 77.4300),
      "status": "Green",
    },
    {
      "name": "Shahpura Square",
      "location": LatLng(23.2500, 77.4250),
      "status": "Yellow",
    },
  ];

  bool _greenWaveActive = false;

  void _toggleGreenWave() {
    setState(() {
      _greenWaveActive = !_greenWaveActive;

      // Sample logic: all signals turn green if green wave active
      if (_greenWaveActive) {
        for (var light in trafficLights) {
          light["status"] = "Green";
        }
      } else {
        for (var light in trafficLights) {
          light["status"] = "Red"; // Reset for simplicity
        }
      }
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Red":
        return Colors.red;
      case "Green":
        return Colors.green;
      case "Yellow":
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  void _changeStatus(int index) {
    // Traffic light state cycle: Red → Green → Yellow → Red
    String current = trafficLights[index]["status"];
    String newStatus = current == "Red"
        ? "Green"
        : current == "Green"
        ? "Yellow"
        : "Red";

    setState(() {
      trafficLights[index]["status"] = newStatus; // 🔹 Local state update
    });
  }

  void _goToCenter() {
    _mapController.move(_center, 13.0);
  }

  void Logout() {
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: _center, initialZoom: 12),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.example.smart_traffic',
              ),
              MarkerLayer(
                markers: List.generate(trafficLights.length, (index) {
                  final light = trafficLights[index];
                  return Marker(
                    point: light["location"],
                    width: 100,
                    height: 100,
                    child: GestureDetector(
                      onTap: () =>
                          _changeStatus(index), // 🔹 Tap to change state
                      child: Column(
                        children: [
                          Icon(
                            Icons.traffic,
                            color: _getStatusColor(light["status"]),
                            size: 25,
                          ),
                          Container(
                            color: Colors.white.withOpacity(0.7),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            child: Text(
                              "${light["name"]}\n${light["status"]}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 5),
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search location",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.mic, color: Colors.grey),
                      onPressed: () {},
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        );
                      },
                      icon: Image.asset("assets/images/profile_pic/man.png"),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 145, // Yaha adjust kar sakte ho position
            left: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GreenWaveScreen(),
                  ),
                );
              },
              child: const Icon(Icons.alt_route),
            ),
          ),
          Positioned(
            bottom: 145, // Yaha adjust kar sakte ho position
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PathMapScreen(),
                  ),
                );
              },
              child: const Icon(Icons.alt_route),
            ),
          ),

          Positioned(
            bottom: 80, // Yaha adjust kar sakte ho position
            right: 16,
            child: FloatingActionButton(
              onPressed: _toggleGreenWave,
              backgroundColor: _greenWaveActive ? Colors.red : Colors.green,
              child: const Icon(Icons.traffic),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.center_focus_strong),
        onPressed: _goToCenter,
      ),
    );
  }
}
