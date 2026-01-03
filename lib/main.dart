import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'provider/lock_provider.dart';
import 'screens/dashboard.dart';
import 'screens/vault.dart';
import 'screens/gatekeeper.dart';
import 'theme/cyber_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // REQUIRED BOXES
  await Hive.openBox('vault'); // vault notes
  await Hive.openBox('auth');  // password storage

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LockProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CyberShield',
        theme: AppTheme.darkTheme,
        home: const HomeNavigation(),
      ),
    );
  }
}

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Check if Vault is unlocked
    final isUnlocked = context.watch<LockProvider>().isUnlocked;

    // Screens for navigation
    final List<Widget> screens = [
      const Dashboard(),                     // Always accessible
      isUnlocked ? const Vault() : const Gatekeeper(), // Protected
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.grey.shade900, // Dark theme
        selectedItemColor: AppTheme.accent,
        unselectedItemColor: Colors.white70,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: "Vault",
          ),
        ],
      ),
    );
  }
}
