import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:cestaria/core/providers/services_providers.dart';
import 'package:cestaria/features/auth/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sección de cuenta
          const Text('Cuenta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Usuario'),
              subtitle: Text(user?.email ?? 'No autenticado'),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.tonalIcon(
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar sesión'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red[100],
              foregroundColor: Colors.red[900],
            ),
            onPressed: () => _showLogoutDialog(context, ref),
          ),
          const SizedBox(height: 24),

          // Sección de permisos
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
                      const SnackBar(content: Text('Solicitud de permisos enviada')),
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

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              Navigator.pop(context);
              
              try {
                // Cerrar sesión
                await ref.read(authServiceProvider).signOut();
                
                // Navegar al login
                if (context.mounted) {
                  context.go('/login');
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al cerrar sesión: $e')),
                  );
                }
              }
            },
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}
