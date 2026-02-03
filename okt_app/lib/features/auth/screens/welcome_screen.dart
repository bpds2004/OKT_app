import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/tap_scale.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('mockups/logo.png', height: 140),
              const SizedBox(height: 48),
              TapScale(
                onTap: () => context.go('/login'),
                child: ElevatedButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Entrar'),
                ),
              ),
              const SizedBox(height: 16),
              TapScale(
                onTap: () => context.go('/register'),
                child: OutlinedButton(
                  onPressed: () => context.go('/register'),
                  child: const Text('Registar'),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Ao continuar, você concorda com nossos\nTermos de Privacidade',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
