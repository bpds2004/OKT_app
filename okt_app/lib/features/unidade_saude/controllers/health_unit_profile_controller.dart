import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/models/health_unit_profile.dart';
import '../data/health_unit_profile_repository.dart';

final healthUnitProfileRepositoryProvider =
    Provider<HealthUnitProfileRepository>((ref) {
  return HealthUnitProfileRepository(ref.watch(firestoreProvider));
});

final healthUnitProfileProvider = StreamProvider<HealthUnitProfile?>((ref) {
  final user = ref.watch(authStateProvider).asData?.value;
  if (user == null) {
    return const Stream.empty();
  }
  return ref
      .watch(healthUnitProfileRepositoryProvider)
      .watchProfile(user.uid);
});

class HealthUnitProfileController {
  HealthUnitProfileController(this._ref);

  final Ref _ref;

  Future<void> save(HealthUnitProfile profile) async {
    await _ref.read(healthUnitProfileRepositoryProvider).upsertProfile(profile);
  }
}

final healthUnitProfileControllerProvider =
    Provider<HealthUnitProfileController>(
  (ref) => HealthUnitProfileController(ref),
);
