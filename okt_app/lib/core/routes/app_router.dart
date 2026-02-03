import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/welcome_screen.dart';
import '../../features/utente/screens/utente_home_screen.dart';
import '../../features/unidade_saude/screens/unidade_home_screen.dart';
import '../../features/utente/screens/utente_notifications_screen.dart';
import '../../features/unidade_saude/screens/unidade_notifications_screen.dart';
import '../../features/utente/screens/utente_reports_screen.dart';
import '../../features/unidade_saude/screens/unidade_reports_screen.dart';
import '../../features/utente/screens/report_detail_screen.dart';
import '../../features/unidade_saude/screens/report_detail_unidade_screen.dart';
import '../../features/utente/screens/utente_profile_screen.dart';
import '../../features/unidade_saude/screens/unidade_profile_screen.dart';
import '../../features/utente/screens/utente_edit_profile_screen.dart';
import '../../features/unidade_saude/screens/unidade_edit_profile_screen.dart';
import '../../features/utente/screens/new_test_screen.dart';
import '../../features/unidade_saude/screens/new_test_unidade_screen.dart';
import '../../features/utente/screens/test_done_screen.dart';
import '../../features/unidade_saude/screens/test_done_unidade_screen.dart';
import '../../features/utente/screens/tutorial_screen.dart';
import '../../features/utente/screens/sos_screen.dart';
import '../../features/unidade_saude/screens/pacientes_screen.dart';
import '../../features/auth/screens/settings_screen.dart';
import '../../features/auth/screens/privacy_screen.dart';
import '../../features/auth/screens/terms_screen.dart';
import '../../features/auth/screens/language_screen.dart';
import '../../features/auth/screens/change_password_screen.dart';
import '../providers.dart';
import '../models/app_user.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final appUser = ref.watch(appUserProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable:
        GoRouterRefreshStream(ref.watch(authStateProvider.stream)),
    redirect: (context, state) {
      final isLoggedIn = authState.asData?.value != null;
      final user = appUser.asData?.value;
      final isSplash = state.matchedLocation == '/splash';
      if (authState.isLoading || appUser.isLoading) {
        return '/splash';
      }
      if (!isLoggedIn && !isSplash) {
        return '/welcome';
      }
      if (isLoggedIn) {
        final isUtenteRoute = state.matchedLocation.startsWith('/utente');
        final isUnidadeRoute = state.matchedLocation.startsWith('/unidade');
        if (user?.role == UserRole.unidade && isUtenteRoute) {
          return '/unidade/home';
        }
        if (user?.role == UserRole.utente && isUnidadeRoute) {
          return '/utente/home';
        }
      }
      if (isLoggedIn && (state.matchedLocation == '/welcome' || isSplash)) {
        if (user?.role == UserRole.unidade) {
          return '/unidade/home';
        }
        return '/utente/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyScreen(),
      ),
      GoRoute(
        path: '/terms',
        builder: (context, state) => const TermsScreen(),
      ),
      GoRoute(
        path: '/language',
        builder: (context, state) => const LanguageScreen(),
      ),
      GoRoute(
        path: '/change-password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: '/utente/home',
        builder: (context, state) => const UtenteHomeScreen(),
      ),
      GoRoute(
        path: '/unidade/home',
        builder: (context, state) => const UnidadeHomeScreen(),
      ),
      GoRoute(
        path: '/utente/notifications',
        builder: (context, state) => const UtenteNotificationsScreen(),
      ),
      GoRoute(
        path: '/unidade/notifications',
        builder: (context, state) => const UnidadeNotificationsScreen(),
      ),
      GoRoute(
        path: '/utente/reports',
        builder: (context, state) => const UtenteReportsScreen(),
      ),
      GoRoute(
        path: '/unidade/reports',
        builder: (context, state) => const UnidadeReportsScreen(),
      ),
      GoRoute(
        path: '/utente/report/:id',
        builder: (context, state) => ReportDetailScreen(
          reportId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/unidade/report/:id',
        builder: (context, state) => ReportDetailUnidadeScreen(
          reportId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/utente/profile',
        builder: (context, state) => const UtenteProfileScreen(),
      ),
      GoRoute(
        path: '/unidade/profile',
        builder: (context, state) => const UnidadeProfileScreen(),
      ),
      GoRoute(
        path: '/utente/profile/edit',
        builder: (context, state) => const UtenteEditProfileScreen(),
      ),
      GoRoute(
        path: '/unidade/profile/edit',
        builder: (context, state) => const UnidadeEditProfileScreen(),
      ),
      GoRoute(
        path: '/utente/new-test',
        builder: (context, state) => const NewTestScreen(),
      ),
      GoRoute(
        path: '/unidade/new-test',
        builder: (context, state) => const NewTestUnidadeScreen(),
      ),
      GoRoute(
        path: '/utente/test-done',
        builder: (context, state) => const TestDoneScreen(),
      ),
      GoRoute(
        path: '/unidade/test-done',
        builder: (context, state) => const TestDoneUnidadeScreen(),
      ),
      GoRoute(
        path: '/tutorial',
        builder: (context, state) => const TutorialScreen(),
      ),
      GoRoute(
        path: '/sos',
        builder: (context, state) => const SosScreen(),
      ),
      GoRoute(
        path: '/unidade/pacientes',
        builder: (context, state) => const PacientesScreen(),
      ),
    ],
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
