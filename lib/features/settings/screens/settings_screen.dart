import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Definições')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: const Text('Idioma'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/idioma'),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Privacidade'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/privacidade'),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Alterar password'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/alterar-password'),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Tutorial'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/tutorial'),
            ),
          ),
        ],
      ),
    );
  }
}
