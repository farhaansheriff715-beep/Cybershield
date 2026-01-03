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

  // Initialize Hive and boxes
  await Hive.initFlutter();
  await Hive.openBox('vault');
  await Hive.openBox('passwordBox');
  await Hive.openBox('settingsBox');

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
    final List<Widget> _screens = [
      const Dashboard(),
      Builder(
        builder: (context) {
          final isUnlocked = context.watch<LockProvider>().isUnlocked;
          return isUnlocked ? const Vault() : const Gatekeeper();
        },
      ),
    ];

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
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
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
