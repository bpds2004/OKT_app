import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Termos e Condições')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aceitação dos Termos e Condições',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            const Text(
              'Bem-vindo à aplicação OKT. Ao aceder e utilizar os nossos serviços, concorda em ficar vinculado aos seguintes termos e condições. Se não concordar com qualquer parte destes termos, não poderá utilizar os nossos serviços.',
            ),
            const SizedBox(height: 12),
            const Text(
              '1. Utilização da Aplicação\n2. Privacidade de Dados\n3. Segurança da Conta\n4. Alterações aos Termos',
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
