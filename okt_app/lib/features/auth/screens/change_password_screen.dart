import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alterar Password')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Palavra-passe atual'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Nova palavra-passe'),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('A palavra-passe deve conter:'),
                SizedBox(height: 8),
                Text('• Pelo menos 8 caracteres'),
                Text('• Pelo menos uma letra maiúscula'),
                Text('• Pelo menos uma letra minúscula'),
                Text('• Pelo menos um número'),
                Text('• Pelo menos um caractere especial'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirmar nova palavra-passe',
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: () {}, child: const Text('Guardar')),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: () {}, child: const Text('Cancelar')),
        ],
      ),
    );
  }
}
