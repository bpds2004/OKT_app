import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/auth_repo.dart';
import '../../../data/repositories/profile_repo.dart';

final authRepoProvider = Provider<AuthRepo>((ref) => AuthRepo());
final profileRepoProvider = Provider<ProfileRepo>((ref) => ProfileRepo());

final authStateProvider = StreamProvider((ref) {
  return ref.watch(authRepoProvider).authStateChanges;
});

final profileRoleProvider = FutureProvider<String?>((ref) async {
  final user = ref.watch(authRepoProvider).currentUser;
  if (user == null) return null;
  final profile = await ref.watch(profileRepoProvider).fetchProfile(user.id);
  return profile?['role'] as String?;
});

class AuthController extends StateNotifier<bool> {
  AuthController(this._authRepo) : super(false);

  final AuthRepo _authRepo;

  Future<void> signOut() async {
    state = true;
    await _authRepo.signOut();
    state = false;
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(ref.watch(authRepoProvider));
});
