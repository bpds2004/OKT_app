import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/repositories/auth_repo.dart';
import '../../../data/repositories/profile_repo.dart';

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(this._authRepository, this._profileRepository)
      : super(const AsyncValue.data(null));

  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.signIn(email: email, password: password);
    });
  }

  Future<void> registerUtente({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String nif,
    required String birthDate,
    required String address,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authResponse = await _authRepository.signUp(
        email: email,
        password: password,
      );
      final userId = authResponse.user?.id;
      if (userId == null) {
        throw Exception('Utilizador não encontrado.');
      }
      await _profileRepository.createUtenteProfile(
        userId: userId,
        name: name,
        phone: phone,
        nif: nif,
        birthDate: birthDate,
        address: address,
      );
    });
  }

  Future<void> registerUnidade({
    required String email,
    required String password,
    required String name,
    required String unitName,
    required String unitAddress,
    required String unitCode,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authResponse = await _authRepository.signUp(
        email: email,
        password: password,
      );
      final userId = authResponse.user?.id;
      if (userId == null) {
        throw Exception('Utilizador não encontrado.');
      }
      await _profileRepository.createUnidadeProfile(
        userId: userId,
        name: name,
        unitName: unitName,
        unitAddress: unitAddress,
        unitCode: unitCode,
      );
    });
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.signOut();
    });
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>(
  (ref) => AuthController(
    ref.watch(authRepoProvider),
    ref.watch(profileRepoProvider),
  ),
);

final profileRoleProvider = FutureProvider<String?>((ref) async {
  final authState = ref.watch(authStateProvider).value;
  final user = authState?.session?.user;
  if (user == null) {
    return null;
  }
  final profileRepo = ref.watch(profileRepoProvider);
  return profileRepo.fetchRole(user.id);
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authRepoProvider).authStateChanges;
});
