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
      appBar: AppBar(title: const Text("CyberShield Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Device Info: $deviceInfo"),
            const SizedBox(height: 10),
            Text("Public IP: $publicIP"),
            const SizedBox(height: 20),
            const Text(
              "Security Tips",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: securityTips.length,
                itemBuilder: (_, i) => ListTile(
                  leading: const Icon(Icons.security),
                  title: Text(securityTips[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
