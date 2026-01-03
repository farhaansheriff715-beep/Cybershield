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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vault"),
        actions: [
          // 🔐 Lock Vault Button
          IconButton(
            icon: const Icon(Icons.lock),
            tooltip: "Lock Vault",
            onPressed: () {
              context.read<LockProvider>().lock();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Vault locked")),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Input for new note
            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Secure Note",
                labelStyle: const TextStyle(color: Colors.blueAccent),
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final text = controller.text.trim();
                  if (text.isEmpty) return;

                  vaultBox.add(crypto.encryptText(text));
                  controller.clear();
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.save),
                label: const Text(
                  "Save",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

            ),
            const SizedBox(height: 20),

            // Vault Notes List
            Expanded(
              child: ListView.builder(
                itemCount: vaultBox.length,
                itemBuilder: (_, i) {
                  final encrypted = vaultBox.getAt(i);
                  final decrypted = crypto.decryptText(encrypted);

                  if (decrypted.isEmpty) return const SizedBox.shrink();

                  return Card(
                    elevation: 3,
                    color: Colors.grey.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 6),
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
      ),
    );
  }
}
