import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/tests_repo.dart';
import '../../../data/repositories/results_repo.dart';

class UnidadeTestController extends StateNotifier<AsyncValue<void>> {
  UnidadeTestController(this._testsRepository, this._resultsRepository)
      : super(const AsyncValue.data(null));

  final TestsRepository _testsRepository;
  final ResultsRepository _resultsRepository;

  Future<void> updateStatus({
    required String testId,
    required String status,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _testsRepository.updateStatus(testId: testId, status: status);
    });
  }

  Future<void> createResult({
    required String testId,
    required String summary,
    required String riskLevel,
    required List<Map<String, String>> variables,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await _resultsRepository.createResult(
        testId: testId,
        summary: summary,
        riskLevel: riskLevel,
      );
      await _resultsRepository.upsertVariables(
        testResultId: result['id'] as String,
        variables: variables,
      );
    });
  }
}

final unidadeTestControllerProvider = StateNotifierProvider<UnidadeTestController, AsyncValue<void>>(
  (ref) => UnidadeTestController(
    ref.watch(testsRepoProvider),
    ref.watch(resultsRepoProvider),
  ),
);
