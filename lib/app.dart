import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/theme.dart';

class App extends ConsumerWidget {
  final bool isOnboardingCompleted;
  final GoRouter router;

  const App({
    super.key,
    required this.isOnboardingCompleted,
    required this.router,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'AfriMap Explorer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
