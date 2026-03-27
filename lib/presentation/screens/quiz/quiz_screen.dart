import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/models.dart';
import '../../providers/providers.dart';

class QuizScreen extends ConsumerWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.quizTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Icon(
              Icons.quiz,
              size: 72,
              color: AppColors.primary,
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 16),
            Text(
              AppStrings.quizSelect,
              textAlign: TextAlign.center,
              style: AppTextStyles.headline2,
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 32),
            _buildQuizTypeCard(
              context,
              ref,
              icon: Icons.location_city,
              title: AppStrings.quizCountryCapital,
              description: 'Associe chaque pays à sa capitale',
              color: AppColors.primary,
              type: QuizType.countryCapital,
              delay: 300,
            ),
            const SizedBox(height: 12),
            _buildQuizTypeCard(
              context,
              ref,
              icon: Icons.language,
              title: AppStrings.quizCountryLanguage,
              description: 'Découvre les langues de chaque pays',
              color: AppColors.accent,
              type: QuizType.countryLanguage,
              delay: 400,
            ),
            const SizedBox(height: 12),
            _buildQuizTypeCard(
              context,
              ref,
              icon: Icons.map,
              title: AppStrings.quizRegionLanguage,
              description: 'Teste tes connaissances des régions',
              color: AppColors.success,
              type: QuizType.regionLanguage,
              delay: 500,
            ),
            const SizedBox(height: 12),
            _buildQuizTypeCard(
              context,
              ref,
              icon: Icons.shuffle,
              title: AppStrings.quizMultipleChoice,
              description: 'Un mélange de tous les types de questions',
              color: Colors.deepPurple,
              type: QuizType.multipleChoice,
              delay: 600,
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildQuizTypeCard(
    BuildContext context,
    WidgetRef ref, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required QuizType type,
    required int delay,
  }) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          ref.read(quizStateProvider.notifier).startQuiz(type);
          context.push('/quiz/play');
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: delay.ms).slideX(begin: 0.1);
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
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

class QuizPlayScreen extends ConsumerStatefulWidget {
  const QuizPlayScreen({super.key});

  @override
  ConsumerState<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends ConsumerState<QuizPlayScreen> {
  String? _selectedAnswer;
  bool _showFeedback = false;

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizStateProvider);

    if (quizState.isCompleted) {
      return _buildResultsScreen(quizState);
    }

    final question = quizState.currentQuestion;
    if (question == null) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppStrings.quizTitle)),
        body: const Center(child: Text('Aucune question disponible')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${AppStrings.question} ${quizState.currentIndex + 1}/${quizState.questions.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: quizState.progress,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 32),
            Text(
              question.question,
              textAlign: TextAlign.center,
              style: AppTextStyles.quizQuestion,
            ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.95, 0.95)),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.separated(
                itemCount: question.options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final option = question.options[index];
                  return _buildOptionButton(option, question.correctAnswer);
                },
              ),
            ),
            if (_showFeedback) ...[
              const SizedBox(height: 16),
              _buildFeedback(question.correctAnswer),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedAnswer = null;
                      _showFeedback = false;
                    });
                    ref.read(quizStateProvider.notifier).nextQuestion();
                  },
                  child: Text(
                    quizState.currentIndex < quizState.questions.length - 1
                        ? AppStrings.nextQuestion
                        : AppStrings.seeResults,
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String option, String correctAnswer) {
    final isSelected = _selectedAnswer == option;
    final isCorrect = option == correctAnswer;

    Color backgroundColor;
    Color borderColor;
    Color textColor;

    if (_showFeedback) {
      if (isCorrect) {
        backgroundColor = AppColors.correct.withOpacity(0.15);
        borderColor = AppColors.correct;
        textColor = AppColors.correct;
      } else if (isSelected && !isCorrect) {
        backgroundColor = AppColors.incorrect.withOpacity(0.15);
        borderColor = AppColors.incorrect;
        textColor = AppColors.incorrect;
      } else {
        backgroundColor = Colors.white;
        borderColor = Colors.grey[300]!;
        textColor = AppColors.onSurface;
      }
    } else {
      backgroundColor = isSelected
          ? AppColors.primary.withOpacity(0.1)
          : Colors.white;
      borderColor = isSelected ? AppColors.primary : Colors.grey[300]!;
      textColor = isSelected ? AppColors.primary : AppColors.onSurface;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: OutlinedButton(
        onPressed: _showFeedback
            ? null
            : () {
                setState(() {
                  _selectedAnswer = option;
                  _showFeedback = true;
                });
                ref.read(quizStateProvider.notifier).answerQuestion(option);
              },
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(color: borderColor, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          children: [
            if (_showFeedback && isCorrect)
              const Icon(Icons.check_circle, color: AppColors.correct)
            else if (_showFeedback && isSelected && !isCorrect)
              const Icon(Icons.cancel, color: AppColors.incorrect),
            if (_showFeedback && (isCorrect || (isSelected && !isCorrect)))
              const SizedBox(width: 8),
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (100 * _getDelayIndex(option)).ms).slideX(begin: 0.05);
  }

  int _getDelayIndex(String option) {
    final question = ref.read(quizStateProvider).currentQuestion;
    if (question == null) return 0;
    return question.options.indexOf(option);
  }

  Widget _buildFeedback(String correctAnswer) {
    final isCorrect = _selectedAnswer == correctAnswer;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppColors.correct.withOpacity(0.1)
            : AppColors.incorrect.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCorrect ? AppColors.correct : AppColors.incorrect,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect ? Icons.celebration : Icons.info,
            color: isCorrect ? AppColors.correct : AppColors.incorrect,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCorrect ? AppStrings.correctAnswer : AppStrings.wrongAnswer,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? AppColors.correct : AppColors.incorrect,
                  ),
                ),
                if (!isCorrect) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Réponse: $correctAnswer',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildResultsScreen(QuizState quizState) {
    final percentage = (quizState.correctAnswers / quizState.questions.length * 100).round();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                percentage >= 70 ? Icons.emoji_events : Icons.thumb_up,
                size: 80,
                color: percentage >= 70 ? AppColors.warning : AppColors.primary,
              ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
              const SizedBox(height: 24),
              Text(
                AppStrings.congratulations,
                style: AppTextStyles.headline1,
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 16),
              Text(
                '${quizState.correctAnswers} ${AppStrings.outOf} ${quizState.questions.length} ${AppStrings.points}',
                style: AppTextStyles.bodyLarge,
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 8),
              Text(
                '$percentage%',
                style: AppTextStyles.score,
              ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.5, 0.5)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(quizStateProvider.notifier).startQuiz(quizState.quizType);
                    setState(() {
                      _selectedAnswer = null;
                      _showFeedback = false;
                    });
                  },
                  child: const Text(AppStrings.tryAgain),
                ),
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => context.go('/quiz'),
                  child: const Text(AppStrings.backToHome),
                ),
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
            ],
          ),
        ),
      ),
    );
  }
}
