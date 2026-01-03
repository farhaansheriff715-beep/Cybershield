import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../provider/lock_provider.dart';
import '../services/encryption_service.dart';

class Vault extends StatefulWidget {
  const Vault({super.key});

  @override
  State<Vault> createState() => _VaultState();
}

class _VaultState extends State<Vault> {
  late Box vaultBox;
  final TextEditingController controller = TextEditingController();
  final EncryptionService crypto = EncryptionService();

  @override
  void initState() {
    super.initState();
    vaultBox = Hive.box('vault');
  }

  @override
  Widget build(BuildContext context) {
    final isUnlocked = context.watch<LockProvider>().isUnlocked;

    // 🔒 Locked view
    if (!isUnlocked) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 50, color: Colors.red),
            SizedBox(height: 10),
            Text(
              "Vault Locked",
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          ],
        ),
      );
    }

    // 🔓 Unlocked view
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 🔒 Lock vault button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<LockProvider>().lock();
              },
              icon: const Icon(Icons.lock),
              label: const Text("Lock Vault"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ✏️ Input field
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: "Secure Note",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 10),

          // 💾 Save button
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isEmpty) return;

              vaultBox.add(crypto.encryptText(text));
              controller.clear();
              setState(() {});
            },
            child: const Text("Save"),
          ),

          const SizedBox(height: 20),

          // 📜 Notes list
          Expanded(
            child: ListView.builder(
              itemCount: vaultBox.length,
              itemBuilder: (_, i) {
                final encrypted = vaultBox.getAt(i);
                final decrypted = crypto.decryptText(encrypted ?? "");

                if (decrypted.isEmpty) return const SizedBox.shrink();

                return Card(
                  color: Colors.grey[900],
                  child: ListTile(
                    title: Text(
                      decrypted,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        vaultBox.deleteAt(i);
                        setState(() {});
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
