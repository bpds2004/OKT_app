import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewTestScreen extends StatelessWidget {
  const NewTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo teste')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: const [
                  Icon(Icons.wifi, size: 40),
                  SizedBox(height: 12),
                  Text(
                    'Certifique-se de que sua máquina OncoKit esteja ligada e ao alcance do Bluetooth para iniciar a conexão.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Status da Conexão:'),
              Text('Desconectado', style: TextStyle(color: Colors.red)),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.search),
            label: const Text('Conectar Dispositivo'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'ID do Teste'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.push('/tutorial'),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }
}
