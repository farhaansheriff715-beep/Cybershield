import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/lock_provider.dart';
import '../services/encryption_service.dart';
import 'vault.dart';

class Gatekeeper extends StatefulWidget {
  const Gatekeeper({super.key});

  @override
  State<Gatekeeper> createState() => _GatekeeperState();
}

class _GatekeeperState extends State<Gatekeeper> {
  final TextEditingController controller = TextEditingController();
  final EncryptionService crypto = EncryptionService();
  late Box authBox;

  @override
  void initState() {
    super.initState();
    authBox = Hive.box('auth');
  }

  void handlePassword() {
    final input = controller.text.trim();
    if (input.isEmpty) return;

    if (!authBox.containsKey('vaultPassword')) {
      authBox.put('vaultPassword', crypto.encryptText(input));
      context.read<LockProvider>().unlock();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password set! Vault unlocked.")),
      );
    } else {
      final encrypted = authBox.get('vaultPassword');
      final saved = crypto.decryptText(encrypted);

      if (saved == input) {
        context.read<LockProvider>().unlock();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vault unlocked.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Wrong password!")),
        );
      }
    }

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isUnlocked = context.watch<LockProvider>().isUnlocked;
    final hasPassword = authBox.containsKey('vaultPassword');

    if (isUnlocked) return const Vault();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cyber Shield Vault "),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.deepPurpleAccent],
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                hasPassword ? "Enter Password" : "Set Password",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(color: Colors.blueAccent),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.blueAccent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.blueAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                    const BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: handlePassword,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.black,
                  ),
                  child: Text(
                    hasPassword ? "Unlock Vault" : "Set Password",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
