import 'package:flutter/material.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  // Sample alert data
  List<Map<String, dynamic>> alerts = [
    {
      "title": "Signal Malfunction",
      "location": "MP Nagar Crossing",
      "time": "5 min ago",
      "status": "High",
    },
    {
      "title": "Traffic Jam",
      "location": "New Market Square",
      "time": "10 min ago",
      "status": "Medium",
    },
    {
      "title": "Accident",
      "location": "Berasia Road",
      "time": "15 min ago",
      "status": "High",
    },
    {
      "title": "Maintenance Required",
      "location": "AIIMS Junction",
      "time": "20 min ago",
      "status": "Low",
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case "High":
        return Colors.red;
      case "Medium":
        return Colors.orange;
      case "Low":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Traffic Alerts"),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          final alert = alerts[index];
          return Dismissible(
            key: Key(alert["title"] + index.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                alerts.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${alert["title"]} dismissed")),
              );
            },
            background: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerRight,
              color: Colors.redAccent,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: _getStatusColor(alert["status"]),
                  child: const Icon(Icons.warning, color: Colors.white),
                ),
                title: Text(
                  alert["title"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text("${alert["location"]}\n${alert["time"]}"),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {
                    _showAlertDetails(alert);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAlertDetails(Map<String, dynamic> alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(alert["title"]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Location: ${alert["location"]}"),
            const SizedBox(height: 8),
            Text("Time: ${alert["time"]}"),
            const SizedBox(height: 8),
            Text("Priority: ${alert["status"]}"),
            const SizedBox(height: 16),
            const Text(
              "Suggested Action:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              "Dispatch traffic team to the site and monitor congestion.",
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}
