import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/unidade_test_controller.dart';

class UnidadeCreateResultScreen extends ConsumerStatefulWidget {
  const UnidadeCreateResultScreen({super.key, required this.testId});

  final String testId;

  @override
  ConsumerState<UnidadeCreateResultScreen> createState() => _UnidadeCreateResultScreenState();
}

class _UnidadeCreateResultScreenState extends ConsumerState<UnidadeCreateResultScreen> {
  final _summaryController = TextEditingController();
  final _riskController = TextEditingController(text: 'BAIXO');
  final _variableNameController = TextEditingController();
  final _variableSignificanceController = TextEditingController();
  final _variableRecommendationController = TextEditingController();

  final List<Map<String, String>> _variables = [];

  @override
  void dispose() {
    _summaryController.dispose();
    _riskController.dispose();
    _variableNameController.dispose();
    _variableSignificanceController.dispose();
    _variableRecommendationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(unidadeTestControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Criar Resultado')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _summaryController,
              decoration: const InputDecoration(labelText: 'Resumo'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _riskController,
              decoration: const InputDecoration(labelText: 'Risco (BAIXO/MEDIO/ALTO)'),
            ),
            const SizedBox(height: 16),
            const Text('Variáveis identificadas'),
            TextField(
              controller: _variableNameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _variableSignificanceController,
              decoration: const InputDecoration(labelText: 'Significado'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _variableRecommendationController,
              decoration: const InputDecoration(labelText: 'Recomendação'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _variables.add({
                    'name': _variableNameController.text,
                    'significance': _variableSignificanceController.text,
                    'recommendation': _variableRecommendationController.text,
                  });
                  _variableNameController.clear();
                  _variableSignificanceController.clear();
                  _variableRecommendationController.clear();
                });
              },
              child: const Text('Adicionar variável'),
            ),
            const SizedBox(height: 8),
            ..._variables.map(
              (variable) => ListTile(
                title: Text(variable['name'] ?? ''),
                subtitle: Text(variable['significance'] ?? ''),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () async {
                      await ref.read(unidadeTestControllerProvider.notifier).createResult(
                            testId: widget.testId,
                            summary: _summaryController.text,
                            riskLevel: _riskController.text,
                            variables: _variables,
                          );
                      if (context.mounted) {
                        context.go('/unidade/teste-realizado');
                      }
                    },
              child: state.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Guardar resultado'),
            ),
          ],
        ),
      ),
    );
  }
}
