import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../services/ip_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String deviceInfo = "Loading...";
  String publicIP = "Loading...";

  final List<String> securityTips = [
    "Use strong, unique passwords.",
    "Enable two-factor authentication.",
    "Keep your software updated.",
    "Be cautious of phishing attempts.",
    "Regularly backup your data.",
  ];

  @override
  void initState() {
    super.initState();
    fetchDeviceInfo();
    fetchIP();
  }

  Future<void> fetchDeviceInfo() async {
    final plugin = DeviceInfoPlugin();
    try {
      final android = await plugin.androidInfo;
      setState(() {
        deviceInfo =
        "${android.model} | Android ${android.version.release}";
      });
    } catch (_) {
      setState(() => deviceInfo = "Unknown Device");
    }
  }

  Future<void> fetchIP() async {
    final ip = await IpService.fetchPublicIP();
    setState(() => publicIP = ip);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CyberShield Dashboard"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurpleAccent, Colors.blueAccent],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Device & IP info cards
            Row(
              children: [
                Expanded(
                  child: _infoCard("Device Info", deviceInfo, Colors.blueAccent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _infoCard("Public IP", publicIP, Colors.deepPurpleAccent),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Security Tips header
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Security Tips",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent[100],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Security Tips list
            Expanded(
              child: ListView.builder(
                itemCount: securityTips.length,
                itemBuilder: (_, i) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blueAccent, Colors.deepPurpleAccent],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 6,
                        offset: Offset(2, 2),
                      )
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.security, color: Colors.white),
                    title: Text(
                      securityTips[i],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 6,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
