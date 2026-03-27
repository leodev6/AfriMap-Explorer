import 'package:go_router/go_router.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/country_detail/country_detail_screen.dart';
import '../../presentation/screens/region_detail/region_detail_screen.dart';
import '../../presentation/screens/quiz/quiz_screen.dart';
import '../../presentation/screens/progress/progress_screen.dart';

class AppRouter {
  static GoRouter createRouter({required bool isOnboardingCompleted, required void Function() onOnboardingComplete}) {
    return GoRouter(
      initialLocation: isOnboardingCompleted ? '/' : '/onboarding',
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => OnboardingScreen(
            onComplete: onOnboardingComplete,
          ),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/country/:id',
          builder: (context, state) => CountryDetailScreen(
            countryId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: '/country/:countryId/region/:regionId',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return RegionDetailScreen(
              countryId: state.pathParameters['countryId']!,
              regionId: state.pathParameters['regionId']!,
              countryName: extra['countryName'] ?? '',
              regionName: extra['regionName'] ?? '',
            );
          },
        ),
        GoRoute(
          path: '/quiz',
          builder: (context, state) => const QuizScreen(),
        ),
        GoRoute(
          path: '/quiz/play',
          builder: (context, state) => const QuizPlayScreen(),
        ),
        GoRoute(
          path: '/progress',
          builder: (context, state) => const ProgressScreen(),
        ),
      ],
    );
  }
}
