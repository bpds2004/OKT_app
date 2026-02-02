import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/okt_scaffold.dart';
import '../../../data/repositories/providers.dart';

class UnidadeCreateResultScreen extends ConsumerStatefulWidget {
  const UnidadeCreateResultScreen({super.key, required this.testId});

  final String testId;

  @override
  ConsumerState<UnidadeCreateResultScreen> createState() =>
      _UnidadeCreateResultScreenState();
}

class _UnidadeCreateResultScreenState
    extends ConsumerState<UnidadeCreateResultScreen> {
  final _formKey = GlobalKey<FormState>();
  final _summaryController = TextEditingController();
  String _riskLevel = 'BAIXO';
  final List<TextEditingController> _varNameControllers = [
    TextEditingController(),
  ];
  final List<TextEditingController> _varSignificanceControllers = [
    TextEditingController(),
  ];
  final List<TextEditingController> _varRecommendationControllers = [
    TextEditingController(),
  ];

  @override
  void dispose() {
    _summaryController.dispose();
    for (final controller in _varNameControllers) {
      controller.dispose();
    }
    for (final controller in _varSignificanceControllers) {
      controller.dispose();
    }
    for (final controller in _varRecommendationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addVariable() {
    setState(() {
      _varNameControllers.add(TextEditingController());
      _varSignificanceControllers.add(TextEditingController());
      _varRecommendationControllers.add(TextEditingController());
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final result = await ref.read(resultsRepoProvider).upsertResult({
      'test_id': widget.testId,
      'summary': _summaryController.text.trim(),
      'risk_level': _riskLevel,
    });

    final variables = <Map<String, dynamic>>[];
    for (var i = 0; i < _varNameControllers.length; i++) {
      final name = _varNameControllers[i].text.trim();
      if (name.isEmpty) continue;
      variables.add({
        'test_result_id': result['id'],
        'name': name,
        'significance': _varSignificanceControllers[i].text.trim(),
        'recommendation': _varRecommendationControllers[i].text.trim(),
      });
    }
    await ref.read(resultsRepoProvider).upsertVariables(variables);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Resultado guardado.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return OktScaffold(
      title: 'Criar resultado',
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _summaryController,
              decoration: const InputDecoration(labelText: 'Resumo'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _riskLevel,
              decoration: const InputDecoration(labelText: 'Nível de risco'),
              items: const [
                DropdownMenuItem(value: 'BAIXO', child: Text('BAIXO')),
                DropdownMenuItem(value: 'MEDIO', child: Text('MEDIO')),
                DropdownMenuItem(value: 'ALTO', child: Text('ALTO')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _riskLevel = value);
              },
            ),
            const SizedBox(height: 16),
            const Text('Variáveis identificadas'),
            const SizedBox(height: 8),
            for (var i = 0; i < _varNameControllers.length; i++) ...[
              TextFormField(
                controller: _varNameControllers[i],
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _varSignificanceControllers[i],
                decoration: const InputDecoration(labelText: 'Significado'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _varRecommendationControllers[i],
                decoration: const InputDecoration(labelText: 'Recomendação'),
              ),
              const SizedBox(height: 16),
            ],
            TextButton.icon(
              onPressed: _addVariable,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar variável'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _save,
              child: const Text('Guardar resultado'),
            ),
          ],
        ),
      ),
    );
  }
}
