import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/models/utente_profile.dart';
import '../data/utente_profile_repository.dart';

final utenteProfileRepositoryProvider = Provider<UtenteProfileRepository>((ref) {
  return UtenteProfileRepository(ref.watch(firestoreProvider));
});

final utenteProfileProvider = StreamProvider<UtenteProfile?>((ref) {
  final user = ref.watch(authStateProvider).asData?.value;
  if (user == null) {
    return const Stream.empty();
  }
  return ref.watch(utenteProfileRepositoryProvider).watchProfile(user.uid);
});

class UtenteProfileController {
  UtenteProfileController(this._ref);

  final Ref _ref;

  Future<void> save(UtenteProfile profile) async {
    await _ref.read(utenteProfileRepositoryProvider).upsertProfile(profile);
  }
}

final utenteProfileControllerProvider = Provider<UtenteProfileController>(
  (ref) => UtenteProfileController(ref),
);
