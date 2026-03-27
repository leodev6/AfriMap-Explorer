import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/providers.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final explored = ref.watch(exploredCountriesProvider);
    final quizResults = ref.watch(quizResultsProvider);
    final countries = ref.watch(countriesProvider);

    final totalCountries = countries.length;
    final exploredCount = explored.length;
    final quizzesCompleted = quizResults.length;
    final bestScore = quizResults.isEmpty
        ? 0
        : quizResults.map((r) => r.score).reduce((a, b) => a > b ? a : b);
    final averageScore = quizResults.isEmpty
        ? 0.0
        : quizResults.map((r) => r.percentage).reduce((a, b) => a + b) /
            quizResults.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.progressTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildOverviewCard(exploredCount, totalCountries),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.explore,
                    title: AppStrings.countriesExplored,
                    value: '$exploredCount',
                    color: AppColors.primary,
                    delay: 200,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.quiz,
                    title: AppStrings.quizzesCompleted,
                    value: '$quizzesCompleted',
                    color: AppColors.accent,
                    delay: 300,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.star,
                    title: AppStrings.bestScore,
                    value: '$bestScore',
                    color: AppColors.warning,
                    delay: 400,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.trending_up,
                    title: 'Moyenne',
                    value: '${averageScore.round()}%',
                    color: AppColors.success,
                    delay: 500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (quizResults.isNotEmpty) ...[
              Text(
                'Historique des quiz',
                style: AppTextStyles.headline3,
              ),
              const SizedBox(height: 12),
              ...quizResults.reversed.take(10).toList().asMap().entries.map((entry) {
                final result = entry.value;
                final typeLabel = _getQuizTypeLabel(result.type);
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: result.percentage >= 70
                          ? AppColors.success.withOpacity(0.15)
                          : result.percentage >= 40
                              ? AppColors.warning.withOpacity(0.15)
                              : AppColors.error.withOpacity(0.15),
                      child: Icon(
                        result.percentage >= 70
                            ? Icons.emoji_events
                            : result.percentage >= 40
                                ? Icons.thumb_up
                                : Icons.refresh,
                        color: result.percentage >= 70
                            ? AppColors.success
                            : result.percentage >= 40
                                ? AppColors.warning
                                : AppColors.error,
                        size: 20,
                      ),
                    ),
                    title: Text(typeLabel),
                    subtitle: Text(
                      '${result.correctAnswers}/${result.totalQuestions} - ${result.percentage.round()}%',
                    ),
                    trailing: Text(
                      '${result.score} pts',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: (100 * entry.key).ms).slideX(begin: 0.05);
              }),
            ] else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(Icons.quiz_outlined, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        'Aucun quiz complété',
                        style: TextStyle(color: Colors.grey[500], fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Joue à un quiz pour voir ta progression ici !',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms),
            ],
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildOverviewCard(int explored, int total) {
    final progress = total > 0 ? explored / total : 0.0;
    return Card(
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.public, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Text(
                  'Exploration',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '$explored / $total pays',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation(Colors.white),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).round()}% exploré',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required int delay,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: delay.ms).scale(begin: const Offset(0.9, 0.9));
  }

  String _getQuizTypeLabel(dynamic type) {
    if (type is int) {
      switch (type) {
        case 0:
          return AppStrings.quizCountryCapital;
        case 1:
          return AppStrings.quizCountryLanguage;
        case 2:
          return AppStrings.quizRegionLanguage;
        case 3:
          return AppStrings.quizMultipleChoice;
        default:
          return 'Quiz';
      }
    }
    return type.toString();
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 2,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/');
          case 1:
            context.go('/quiz');
          case 2:
            context.go('/progress');
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: AppStrings.exploreButton,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.quiz),
          label: AppStrings.quizButton,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Progression',
        ),
      ],
    );
  }
}
