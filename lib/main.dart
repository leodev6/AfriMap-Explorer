import 'package:afrimapexplorer/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/router/app_router.dart';
import 'core/constants/supabase_config.dart';
import 'data/datasources/local/local_datasource.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase if configured
  if (SupabaseConfig.isConfigured) {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  }

  final prefs = await SharedPreferences.getInstance();
  final localDataSource = LocalDataSource(prefs);
  final isOnboardingCompleted = localDataSource.isOnboardingCompleted;

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: _AfriMapAppWrapper(
        isOnboardingCompleted: isOnboardingCompleted,
        localDataSource: localDataSource,
      ),
    ),
  );
}

class _AfriMapAppWrapper extends StatefulWidget {
  final bool isOnboardingCompleted;
  final LocalDataSource localDataSource;

  const _AfriMapAppWrapper({
    required this.isOnboardingCompleted,
    required this.localDataSource,
  });

  @override
  State<_AfriMapAppWrapper> createState() => _AfriMapAppWrapperState();
}

class _AfriMapAppWrapperState extends State<_AfriMapAppWrapper> {
  late bool _isOnboardingCompleted;

  @override
  void initState() {
    super.initState();
    _isOnboardingCompleted = widget.isOnboardingCompleted;
  }

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.createRouter(
      isOnboardingCompleted: _isOnboardingCompleted,
      onOnboardingComplete: () {
        widget.localDataSource.setOnboardingCompleted();
        setState(() {
          _isOnboardingCompleted = true;
        });
      },
    );

    return App(
      isOnboardingCompleted: _isOnboardingCompleted,
      router: router,
    );
  }
}
