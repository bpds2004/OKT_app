import 'package:flutter/material.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool shareData = true;
  bool anonAnalytics = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacidade')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Como usamos os seus dados',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Valorizamos a sua privacidade. Esta secção explica como os seus dados são recolhidos, usados e partilhados no âmbito da aplicação OKT.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            value: shareData,
            onChanged: (value) => setState(() => shareData = value),
            title: const Text('Partilhar dados com terceiros'),
            subtitle: const Text('Permitir partilha de dados anonimizados.'),
          ),
          SwitchListTile(
            value: anonAnalytics,
            onChanged: (value) => setState(() => anonAnalytics = value),
            title: const Text('Análises anónimas'),
            subtitle: const Text('Contribuir com dados anónimos.'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {},
            child: const Text('Ver política de privacidade completa'),
          ),
        ],
      ),
    );
  }
}
