import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cestaria/core/providers/services_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sección de la aplicación
          const Text('Aplicación', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text('Cestaria'),
              subtitle: const Text('Versión 1.0.0 - Modo local'),
            ),
          ),
          const SizedBox(height: 24),

          // Sección de permisos
          const Text('Permisos y dispositivos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Consumer(
              builder: (context, ref, _) => FilledButton.icon(
                icon: const Icon(Icons.nfc),
                label: const Text('Escanear NFC'),
                onPressed: () async {
                  await ref.read(nfcServiceProvider).startScan();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Escaneo NFC iniciado')),
                    );
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
