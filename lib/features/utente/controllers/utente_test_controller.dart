import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/auth_repo.dart';
import '../../../data/repositories/tests_repo.dart';
import '../../../data/repositories/results_repo.dart';
import '../../../data/repositories/notifications_repo.dart';

class UtenteTestController extends StateNotifier<AsyncValue<void>> {
  UtenteTestController(
    this._authRepository,
    this._testsRepository,
    this._resultsRepository,
    this._notificationsRepository,
  ) : super(const AsyncValue.data(null));

  final AuthRepository _authRepository;
  final TestsRepository _testsRepository;
  final ResultsRepository _resultsRepository;
  final NotificationsRepository _notificationsRepository;

  Future<void> finalizeTest({
    required String healthUnitId,
    required List<int> rawData,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userId = _authRepository.currentUser?.id;
      if (userId == null) {
        throw Exception('Utilizador não autenticado');
      }

      final test = await _testsRepository.createTest(
        patientUserId: userId,
        healthUnitId: healthUnitId,
        status: 'DONE',
      );

      final summary = 'Dados recolhidos: ${rawData.length} bytes';
      final result = await _resultsRepository.createResult(
        testId: test['id'] as String,
        summary: summary,
        riskLevel: 'BAIXO',
      );

      await _resultsRepository.upsertVariables(
        testResultId: result['id'] as String,
        variables: [
          {
            'name': 'RawData',
            'significance': 'Debug',
            'recommendation': 'Rever protocolo BLE',
          },
        ],
      );

      await _notificationsRepository.createNotification(
        userId: userId,
        title: 'Teste concluído',
        message: 'O seu teste foi concluído e está disponível.',
      );
    });
  }
}

final utenteTestControllerProvider = StateNotifierProvider<UtenteTestController, AsyncValue<void>>(
  (ref) => UtenteTestController(
    ref.watch(authRepoProvider),
    ref.watch(testsRepoProvider),
    ref.watch(resultsRepoProvider),
    ref.watch(notificationsRepoProvider),
  ),
);
