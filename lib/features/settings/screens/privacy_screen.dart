import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacidade')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'A OKT utiliza Supabase com Row Level Security (RLS) para garantir que cada utilizador '
          'apenas acede aos seus próprios dados. Nenhuma informação clínica é partilhada sem '
          'permissão e as credenciais sensíveis nunca são expostas no cliente.',
        ),
      ),
    );
  }
}
