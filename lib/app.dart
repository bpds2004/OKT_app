import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/okt_theme.dart';
import 'router/app_router.dart';

class OktApp extends ConsumerWidget {
  const OktApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'OKT',
      theme: OktTheme.light,
      routerConfig: router,
    );
  }
}
