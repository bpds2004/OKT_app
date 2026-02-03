import 'package:flutter/material.dart';

class UtenteNotificationsScreen extends StatefulWidget {
  const UtenteNotificationsScreen({super.key});

  @override
  State<UtenteNotificationsScreen> createState() =>
      _UtenteNotificationsScreenState();
}

class _UtenteNotificationsScreenState
    extends State<UtenteNotificationsScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificações')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Marcar todas como lidas',
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _tabIndex = 0),
                    child: const Text('Todas'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _tabIndex = 1),
                    child: const Text('Não lidas'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Text(
                  _tabIndex == 0
                      ? 'Sem notificações no momento.'
                      : 'Sem notificações não lidas.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
