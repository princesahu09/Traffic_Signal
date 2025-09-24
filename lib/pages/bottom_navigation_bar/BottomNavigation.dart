import 'package:flutter/material.dart';
import 'package:signal/pages/alert_screen/AlertScreen.dart';
import 'package:signal/pages/analytics_screen/AnalyticScreen.dart';
import 'package:signal/pages/home_screen/HomeScreen.dart';
import 'package:signal/pages/video_player/VideoPlayer.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _currentIndex = 0;

  // List of your screens
  final List<Widget> _screens = [
    // Replace with your actual screens
    HomeScreen(),
    AnalyticScreen(),
    VideoPlayerScreen(),
    AlertScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Display selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.videocam), label: 'CCTV'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Switch screen on tap
          });
        },
      ),
    );
  }
}
