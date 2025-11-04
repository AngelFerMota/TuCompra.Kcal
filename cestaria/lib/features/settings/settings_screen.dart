import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cestaria/core/providers/services_providers.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Permisos y dispositivos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Consumer(
              builder: (context, ref, _) => FilledButton.icon(
                icon: const Icon(Icons.notifications_active_outlined),
                label: const Text('Permitir notificaciones'),
                onPressed: () async {
                  await ref.read(notificationsServiceProvider).requestPermissions();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Solicitud de permisos enviada (placeholder)')),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 12),
            Consumer(
              builder: (context, ref, _) => FilledButton.icon(
                icon: const Icon(Icons.nfc),
                label: const Text('Escanear NFC'),
                onPressed: () async {
                  await ref.read(nfcServiceProvider).startScan();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Escaneo NFC iniciado (placeholder)')),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
