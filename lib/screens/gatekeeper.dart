import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../provider/lock_provider.dart';
import '../services/encryption_service.dart';

class Gatekeeper extends StatefulWidget {
  const Gatekeeper({super.key});

  @override
  State<Gatekeeper> createState() => _GatekeeperState();
}

class _GatekeeperState extends State<Gatekeeper> {
  final TextEditingController _controller = TextEditingController();
  final EncryptionService crypto = EncryptionService();

  late Box passwordBox;

  @override
  void initState() {
    super.initState();
    passwordBox = Hive.box('passwordBox');

    // Always lock vault on app start
    context.read<LockProvider>().lock();
  }

  void handlePassword() {
    String input = _controller.text.trim();
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password cannot be empty")),
      );
      return;
    }

    String storedEncrypted = passwordBox.get('vaultPassword') ?? "";
    String stored = crypto.decryptText(storedEncrypted);

    // First time or corrupted password
    if (stored.isEmpty) {
      passwordBox.put('vaultPassword', crypto.encryptText(input));
      context.read<LockProvider>().unlock();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password set & vault unlocked")),
      );
    } else {
      // Compare input with decrypted password
      if (input == stored) {
        context.read<LockProvider>().unlock();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vault unlocked")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Wrong password")),
        );
      }
    }

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    bool passwordSet = crypto.decryptText(passwordBox.get('vaultPassword') ?? '').isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _controller,
            obscureText: true,
            decoration: InputDecoration(
              labelText: passwordSet ? "Enter Password" : "Set Vault Password",
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: handlePassword,
            child: Text(passwordSet ? "Unlock Vault" : "Set & Unlock Vault"),
          ),
        ],
      ),
    );
  }
}
