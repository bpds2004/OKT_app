import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _language = 'Português';
  final _languages = [
    'Português',
    'English',
    'Español',
    'Français',
    'Deutsch',
    'Italiano',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escolher Idioma')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _languages.length,
                itemBuilder: (context, index) {
                  final lang = _languages[index];
                  return RadioListTile(
                    value: lang,
                    groupValue: _language,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _language = value);
                      }
                    },
                    title: Text(lang),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
