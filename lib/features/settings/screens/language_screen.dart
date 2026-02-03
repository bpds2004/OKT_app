import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _language = 'pt';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _language = prefs.getString('app_language') ?? 'pt';
    });
  }

  Future<void> _updateLanguage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', value);
    setState(() {
      _language = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Idioma')),
      body: Column(
        children: [
          RadioListTile<String>(
            title: const Text('Português'),
            value: 'pt',
            groupValue: _language,
            onChanged: (value) {
              if (value != null) _updateLanguage(value);
            },
          ),
          RadioListTile<String>(
            title: const Text('English'),
            value: 'en',
            groupValue: _language,
            onChanged: (value) {
              if (value != null) _updateLanguage(value);
            },
          ),
        ],
      ),
    );
  }
}
