import 'package:flutter/material.dart';

class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SOS')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 52,
              backgroundColor: Color(0xFF0F3D5E),
              child: Icon(Icons.person, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 12),
            const Text('112'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Ligar'),
            ),
          ],
        ),
      ),
    );
  }
}
