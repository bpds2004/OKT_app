import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/controllers/auth_controller.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/welcome_screen.dart';
import '../features/utente/screens/utente_home_screen.dart';
import '../features/utente/screens/utente_new_test_screen.dart';
import '../features/utente/screens/utente_reports_screen.dart';
import '../features/utente/screens/utente_report_detail_screen.dart';
import '../features/utente/screens/utente_notifications_screen.dart';
import '../features/utente/screens/utente_profile_screen.dart';
import '../features/unidade/screens/unidade_home_screen.dart';
import '../features/unidade/screens/unidade_tests_screen.dart';
import '../features/unidade/screens/unidade_test_detail_screen.dart';
import '../features/unidade/screens/unidade_create_result_screen.dart';
import '../features/unidade/screens/unidade_notifications_screen.dart';
import '../features/unidade/screens/unidade_profile_screen.dart';
import '../features/articles/screens/articles_list_screen.dart';
import '../features/articles/screens/article_detail_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authStream = ref.watch(authStateProvider.stream);
  final roleFuture = ref.watch(profileRoleProvider);

  return GoRouter(
    initialLocation: '/welcome',
    refreshListenable: GoRouterRefreshStream(authStream),
    redirect: (context, state) {
      final loggedIn = ref.read(authRepoProvider).currentUser != null;
      final location = state.uri.toString();

      if (!loggedIn) {
        if (location == '/welcome' || location == '/login' || location == '/register') {
          return null;
        }
        return '/welcome';
      }

      final role = roleFuture.valueOrNull;
      if (role == null) {
        return null;
      }

      if (location == '/welcome' || location == '/login' || location == '/register' || location == '/') {
        if (role == 'UTENTE') return '/utente/home';
        if (role == 'UNIDADE_SAUDE') return '/unidade/home';
      }

      if (location.startsWith('/utente') && role != 'UTENTE') {
        return '/unidade/home';
      }
      if (location.startsWith('/unidade') && role != 'UNIDADE_SAUDE') {
        return '/utente/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SizedBox.shrink(),
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
        path: '/utente/home',
        builder: (context, state) => const UtenteHomeScreen(),
      ),
      GoRoute(
        path: '/utente/novo-teste',
        builder: (context, state) => const UtenteNewTestScreen(),
      ),
      GoRoute(
        path: '/utente/relatorios',
        builder: (context, state) => const UtenteReportsScreen(),
      ),
      GoRoute(
        path: '/utente/relatorios/:testId',
        builder: (context, state) => UtenteReportDetailScreen(
          testId: state.pathParameters['testId']!,
        ),
      ),
      GoRoute(
        path: '/utente/notificacoes',
        builder: (context, state) => const UtenteNotificationsScreen(),
      ),
      GoRoute(
        path: '/utente/perfil',
        builder: (context, state) => const UtenteProfileScreen(),
      ),
      GoRoute(
        path: '/unidade/home',
        builder: (context, state) => const UnidadeHomeScreen(),
      ),
      GoRoute(
        path: '/unidade/testes',
        builder: (context, state) => const UnidadeTestsScreen(),
      ),
      GoRoute(
        path: '/unidade/testes/:testId',
        builder: (context, state) => UnidadeTestDetailScreen(
          testId: state.pathParameters['testId']!,
        ),
      ),
      GoRoute(
        path: '/unidade/testes/:testId/criar-resultado',
        builder: (context, state) => UnidadeCreateResultScreen(
          testId: state.pathParameters['testId']!,
        ),
      ),
      GoRoute(
        path: '/unidade/notificacoes',
        builder: (context, state) => const UnidadeNotificationsScreen(),
      ),
      GoRoute(
        path: '/unidade/perfil',
        builder: (context, state) => const UnidadeProfileScreen(),
      ),
      GoRoute(
        path: '/artigos',
        builder: (context, state) => const ArticlesListScreen(),
      ),
      GoRoute(
        path: '/artigos/:slug',
        builder: (context, state) => ArticleDetailScreen(
          slug: state.pathParameters['slug']!,
        ),
      ),
    ],
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
