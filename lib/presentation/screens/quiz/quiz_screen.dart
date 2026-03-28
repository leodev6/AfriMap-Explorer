import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/models.dart' hide Badge;
import '../../providers/providers.dart';

// ============ HELPERS ============

final _typeColors = {
  QuizType.countryCapital: AppColors.primary,
  QuizType.capitalCountry: Colors.teal,
  QuizType.countryLanguage: AppColors.accent,
  QuizType.languageCountry: Colors.purple,
  QuizType.regionLanguage: AppColors.success,
  QuizType.flagCountry: Colors.red,
  QuizType.islandCountry: Colors.indigo,
  QuizType.multipleChoice: Colors.deepPurple,
};

// ============ SÉLECTION DU TYPE DE QUIZ ============

class QuizScreen extends ConsumerWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badges = ref.watch(badgesProvider);
    final unlockedCount = badges.where((b) => b.isUnlocked).length;
    final results = ref.watch(quizResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        actions: [
          Badge(
            label: Text('$unlockedCount/${badges.length}'),
            backgroundColor: AppColors.accent,
            child: IconButton(
              icon: const Icon(Icons.emoji_events),
              onPressed: () => _showBadgesDialog(context, ref),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Quick quiz button
            _QuickQuizSection(results: results),
            const SizedBox(height: 20),

            // Stats summary
            if (results.isNotEmpty) ...[
              _QuizStatsSummary(results: results),
              const SizedBox(height: 20),
            ],

            // Section title
            Row(
              children: [
                const Icon(Icons.category, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                const Text('Choisis un type de quiz',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 12),

            // Quiz type cards
            ...QuizType.values.map((type) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _QuizTypeCard(type: type, results: results),
            )),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  void _showBadgesDialog(BuildContext context, WidgetRef ref) {
    final badges = ref.watch(badgesProvider);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.emoji_events, color: AppColors.warning),
            SizedBox(width: 8),
            Text('Mes Badges'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 0.75,
            ),
            itemCount: badges.length,
              itemBuilder: (ctx, i) {
              final badge = badges[i];
              return Opacity(
                opacity: badge.isUnlocked ? 1.0 : 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 56, height: 56,
                      decoration: BoxDecoration(
                        color: badge.isUnlocked
                            ? AppColors.warning.withOpacity(0.15)
                            : Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: Icon(badge.icon, size: 28,
                          color: badge.isUnlocked ? AppColors.warning : Colors.grey)),
                    ),
                    const SizedBox(height: 6),
                    Text(badge.name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                    Text(badge.description,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 9, color: Colors.grey)),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Fermer')),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
      onTap: (i) {
        switch (i) {
          case 0: context.go('/');
          case 1: context.go('/quiz');
          case 2: context.go('/progress');
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explorer'),
        BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quiz'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Progression'),
      ],
    );
  }
}

// ============ QUICK QUIZ ============

class _QuickQuizSection extends StatelessWidget {
  final List<QuizResult> results;
  const _QuickQuizSection({required this.results});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showQuickQuizDialog(context),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.bolt, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quiz Rapide',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text('Un quiz aléatoire pour tester tes connaissances',
                        style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.play_arrow, color: Colors.white, size: 32),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 100.ms).scale(begin: const Offset(0.95, 0.95));
  }

  void _showQuickQuizDialog(BuildContext context) {
    final types = QuizType.values.where((t) => t != QuizType.multipleChoice).toList();
    types.shuffle();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.bolt, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Quiz Rapide'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choisis un niveau de difficulté :'),
            const SizedBox(height: 16),
            ...QuizDifficulty.values.map((diff) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: Icon(
                    diff == QuizDifficulty.easy ? Icons.sentiment_satisfied
                        : diff == QuizDifficulty.medium ? Icons.sentiment_neutral
                        : Icons.whatshot,
                    color: AppColors.primary,
                  ),
                  label: Text('${diff.label} — ${diff.questionCount} questions'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    final container = ProviderScope.containerOf(context);
                    container.read(quizStateProvider.notifier)
                        .startQuiz(types.first, difficulty: diff);
                    context.push('/quiz/play');
                  },
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

// ============ STATS SUMMARY ============

class _QuizStatsSummary extends StatelessWidget {
  final List<QuizResult> results;
  const _QuizStatsSummary({required this.results});

  @override
  Widget build(BuildContext context) {
    final total = results.length;
    final totalCorrect = results.fold<int>(0, (s, r) => s + r.correctAnswers);
    final totalQuestions = results.fold<int>(0, (s, r) => s + r.totalQuestions);
    final avgPct = totalQuestions > 0 ? (totalCorrect / totalQuestions * 100).round() : 0;
    final bestScore = results.isEmpty ? 0 : results.map((r) => r.score).reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _MiniStat(label: 'Quiz', value: '$total', icon: Icons.quiz, color: AppColors.primary),
            _MiniStat(label: 'Moyenne', value: '$avgPct%', icon: Icons.trending_up, color: AppColors.success),
            _MiniStat(label: 'Meilleur', value: '$bestScore', icon: Icons.star, color: AppColors.warning),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 150.ms);
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _MiniStat({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}

// ============ QUIZ TYPE CARD ============

class _QuizTypeCard extends StatelessWidget {
  final QuizType type;
  final List<QuizResult> results;
  const _QuizTypeCard({required this.type, required this.results});

  @override
  Widget build(BuildContext context) {
    final color = _typeColors[type] ?? AppColors.primary;
    final typeResults = results.where((r) => r.type == type).toList();
    final played = typeResults.length;
    final bestScore = typeResults.isEmpty
        ? 0
        : typeResults.map((r) => r.score).reduce((a, b) => a > b ? a : b);
    final avgPct = typeResults.isEmpty
        ? 0
        : (typeResults.fold<int>(0, (s, r) => s + r.correctAnswers) /
                typeResults.fold<int>(0, (s, r) => s + r.totalQuestions) *
                100)
            .round();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showDifficultyDialog(context, type, color),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Icon
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(child: Icon(type.icon, size: 26, color: color)),
              ),
              const SizedBox(width: 14),
              // Texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(type.label,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(type.description,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    const SizedBox(height: 6),
                    // Stats row
                    Row(
                      children: [
                        _StatBadge(
                          icon: Icons.play_circle_outline,
                          text: '$played',
                          label: 'joués',
                          color: color,
                        ),
                        if (played > 0) ...[
                          const SizedBox(width: 10),
                          _StatBadge(
                            icon: Icons.star_outline,
                            text: '$bestScore',
                            label: 'meilleur',
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 10),
                          _StatBadge(
                            icon: Icons.percent,
                            text: '$avgPct%',
                            label: 'moy.',
                            color: avgPct >= 70 ? AppColors.success : AppColors.error,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Play button
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.play_arrow, color: Colors.white, size: 24),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (80 * type.index).ms).slideX(begin: 0.05);
  }

  void _showDifficultyDialog(BuildContext context, QuizType type, Color color) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(type.icon, size: 24, color: color),
            const SizedBox(width: 8),
            Expanded(child: Text(type.label, style: const TextStyle(fontSize: 16))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(type.description, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            const SizedBox(height: 16),
            const Text('Choisis la difficulté :', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ...QuizDifficulty.values.map((diff) {
              final diffIcon = diff == QuizDifficulty.easy
                  ? Icons.sentiment_satisfied
                  : diff == QuizDifficulty.medium
                      ? Icons.sentiment_neutral
                      : Icons.whatshot;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      side: BorderSide(color: color),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      final container = ProviderScope.containerOf(context);
                      container.read(quizStateProvider.notifier)
                          .startQuiz(type, difficulty: diff);
                      context.push('/quiz/play');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(diffIcon, size: 20, color: color),
                            const SizedBox(width: 8),
                            Text(diff.label,
                                style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 15)),
                          ],
                        ),
                        Text('${diff.questionCount} Q · ${diff.timeLimit}s · ${diff.pointsPerQuestion}pts/Q',
                            style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String text;
  final String label;
  final Color color;
  const _StatBadge({required this.icon, required this.text, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 2),
        Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}

// ============ ÉCRAN DE JEU ============

class QuizPlayScreen extends ConsumerStatefulWidget {
  const QuizPlayScreen({super.key});

  @override
  ConsumerState<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends ConsumerState<QuizPlayScreen> {
  String? _selectedAnswer;
  bool _showFeedback = false;
  Timer? _timer;
  int _timeRemaining = 0;
  int _questionStartTime = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startTimer());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    final quizState = ref.read(quizStateProvider);
    _timeRemaining = quizState.difficulty.timeLimit;
    _questionStartTime = DateTime.now().millisecondsSinceEpoch;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) { timer.cancel(); return; }
      setState(() => _timeRemaining--);
      ref.read(quizStateProvider.notifier).updateTimer(_timeRemaining);
      if (_timeRemaining <= 0) {
        timer.cancel();
        setState(() { _showFeedback = true; _selectedAnswer = null; });
      }
    });
  }

  void _handleAnswer(String answer) {
    if (_showFeedback) return;
    _timer?.cancel();
    final elapsed = (DateTime.now().millisecondsSinceEpoch - _questionStartTime) ~/ 1000;
    setState(() {
      _selectedAnswer = answer;
      _showFeedback = true;
    });
    ref.read(quizStateProvider.notifier).answerQuestion(answer, timeSpent: elapsed);
  }

  void _nextQuestion() {
    _timer?.cancel();
    ref.read(quizStateProvider.notifier).nextQuestion();
    setState(() {
      _selectedAnswer = null;
      _showFeedback = false;
    });
    final quizState = ref.read(quizStateProvider);
    if (!quizState.isCompleted) {
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizStateProvider);

    if (quizState.isCompleted) return _ResultsScreen(
      onRestart: () {
        ref.read(quizStateProvider.notifier)
            .startQuiz(quizState.quizType, difficulty: quizState.difficulty);
        setState(() { _selectedAnswer = null; _showFeedback = false; });
        _startTimer();
      },
    );

    final question = quizState.currentQuestion;
    if (question == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.quiz_outlined, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Aucune question disponible',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text('Type: ${quizState.quizType.label}',
                  style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(quizStateProvider.notifier)
                      .startQuiz(QuizType.countryCapital, difficulty: quizState.difficulty);
                  setState(() {});
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Essayer un autre quiz'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go('/quiz'),
                child: const Text('Retour'),
              ),
            ],
          ),
        ),
      );
    }

    final timerColor = _timeRemaining > 10
        ? AppColors.success
        : _timeRemaining > 5
            ? AppColors.warning
            : AppColors.error;
    final color = _typeColors[quizState.quizType] ?? AppColors.primary;

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: color,
          title: Text('Question ${quizState.currentIndex + 1}/${quizState.questions.length}'),
          actions: [
            // Timer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer, size: 16, color: Colors.white),
                  const SizedBox(width: 4),
                  Text('${_timeRemaining}s',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => _showQuitDialog(context),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Progress bar
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: quizState.progress,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation(color),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('${quizState.correctAnswers}/${quizState.answeredCount} ✓',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success, fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Timer bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _timeRemaining / quizState.difficulty.timeLimit,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(timerColor),
                  minHeight: 5,
                ),
              ),
              const SizedBox(height: 16),

              // Flag if available
              if (question.flagUrl != null) ...[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: CachedNetworkImage(
                      imageUrl: question.flagUrl!,
                      height: 130,
                      width: 200,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        height: 130, width: 200,
                        color: Colors.grey[200],
                        child: const Icon(Icons.flag, size: 48, color: Colors.grey),
                      ),
                    ),
                  ),
                ).animate().scale(duration: 300.ms),
                const SizedBox(height: 16),
              ],

              // Question
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  question.question,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, height: 1.3),
                ),
              ).animate().fadeIn(duration: 250.ms),
              const SizedBox(height: 16),

              // Options
              Expanded(
                child: ListView.separated(
                  itemCount: question.options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (ctx, i) => _OptionButton(
                    option: question.options[i],
                    correctAnswer: question.correctAnswer,
                    selectedAnswer: _selectedAnswer,
                    showFeedback: _showFeedback,
                    onTap: () => _handleAnswer(question.options[i]),
                    delayIndex: i,
                    accentColor: color,
                  ),
                ),
              ),

              // Feedback
              if (_showFeedback) ...[
                _FeedbackCard(
                  isCorrect: _selectedAnswer == question.correctAnswer,
                  isTimeout: _selectedAnswer == null,
                  correctAnswer: question.correctAnswer,
                  explanation: question.explanation,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity, height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: color),
                    onPressed: _nextQuestion,
                    child: Text(
                      quizState.currentIndex < quizState.questions.length - 1
                          ? 'Question suivante →'
                          : 'Voir les résultats',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showQuitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quitter le quiz ?'),
        content: const Text('Ta progression sera perdue.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Continuer')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              _timer?.cancel();
              Navigator.pop(ctx);
              context.go('/quiz');
            },
            child: const Text('Quitter', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String option;
  final String correctAnswer;
  final String? selectedAnswer;
  final bool showFeedback;
  final VoidCallback onTap;
  final int delayIndex;
  final Color accentColor;

  const _OptionButton({
    required this.option,
    required this.correctAnswer,
    required this.selectedAnswer,
    required this.showFeedback,
    required this.onTap,
    required this.delayIndex,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedAnswer == option;
    final isCorrect = option == correctAnswer;

    Color bgColor, borderColor, textColor;
    IconData? icon;

    if (showFeedback) {
      if (isCorrect) {
        bgColor = AppColors.correct.withOpacity(0.12);
        borderColor = AppColors.correct;
        textColor = AppColors.correct;
        icon = Icons.check_circle;
      } else if (isSelected) {
        bgColor = AppColors.incorrect.withOpacity(0.12);
        borderColor = AppColors.incorrect;
        textColor = AppColors.incorrect;
        icon = Icons.cancel;
      } else {
        bgColor = Colors.grey[50]!;
        borderColor = Colors.grey[300]!;
        textColor = Colors.grey[400]!;
      }
    } else {
      bgColor = isSelected ? accentColor.withOpacity(0.08) : Colors.white;
      borderColor = isSelected ? accentColor : Colors.grey[300]!;
      textColor = isSelected ? accentColor : AppColors.onSurface;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: showFeedback ? null : onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: isSelected || (showFeedback && isCorrect) ? 2.5 : 1.5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: textColor, size: 22),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: (isSelected || (showFeedback && isCorrect)) ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                if (!showFeedback && isSelected)
                  Icon(Icons.radio_button_checked, color: accentColor, size: 20),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (70 * delayIndex).ms).slideX(begin: 0.03);
  }
}

class _FeedbackCard extends StatelessWidget {
  final bool isCorrect;
  final bool isTimeout;
  final String correctAnswer;
  final String? explanation;

  const _FeedbackCard({
    required this.isCorrect,
    required this.isTimeout,
    required this.correctAnswer,
    this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? AppColors.correct : AppColors.incorrect;
    final icon = isTimeout ? Icons.hourglass_empty : isCorrect ? Icons.celebration : Icons.info;
    final title = isTimeout ? 'Temps écoulé !' : isCorrect ? 'Bonne réponse !' : 'Mauvaise réponse';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)),
            ],
          ),
          if (!isCorrect) ...[
            const SizedBox(height: 6),
            Text('Réponse : $correctAnswer',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          ],
          if (explanation != null) ...[
            const SizedBox(height: 4),
            Text(explanation!, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 250.ms).scale(begin: const Offset(0.92, 0.92));
  }
}

// ============ ÉCRAN DE RÉSULTATS ============

class _ResultsScreen extends ConsumerWidget {
  final VoidCallback onRestart;
  const _ResultsScreen({required this.onRestart});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizStateProvider);
    final total = quizState.questions.length;
    final pct = total > 0 ? (quizState.correctAnswers / total * 100).round() : 0;
    final score = quizState.correctAnswers * quizState.difficulty.pointsPerQuestion;
    final maxScore = total * quizState.difficulty.pointsPerQuestion;
    final color = _typeColors[quizState.quizType] ?? AppColors.primary;

    IconData resultIcon;
    String message;
    if (pct >= 90) { resultIcon = Icons.emoji_events; message = 'Excellent ! Tu es un expert !'; }
    else if (pct >= 70) { resultIcon = Icons.star; message = 'Très bien ! Continue comme ça !'; }
    else if (pct >= 50) { resultIcon = Icons.thumb_up; message = 'Pas mal ! Encore un effort !'; }
    else { resultIcon = Icons.fitness_center; message = 'Courage ! Recommence !'; }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Icon(resultIcon, size: 80, color: color)
                  .animate().scale(duration: 600.ms, curve: Curves.elasticOut),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600))
                  .animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 20),

              // Score card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Icon(quizState.quizType.icon, size: 28, color: color),
                    const SizedBox(height: 8),
                    Text(quizState.quizType.label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    const SizedBox(height: 12),
                    Text('$score / $maxScore',
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: color)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('$pct %',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 300.ms).scale(begin: const Offset(0.85, 0.85)),
              const SizedBox(height: 20),

              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ResultStat(label: 'Correctes', value: '${quizState.correctAnswers}', icon: Icons.check_circle, color: AppColors.correct),
                  _ResultStat(label: 'Erreurs', value: '${quizState.wrongAnswers - quizState.timeouts}', icon: Icons.cancel, color: AppColors.incorrect),
                  _ResultStat(label: 'Temps écoulé', value: '${quizState.timeouts}', icon: Icons.timer_off, color: AppColors.warning),
                ],
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 20),

              // Review
              if (quizState.answerDetails.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(Icons.rate_review, size: 18, color: AppColors.primary),
                    const SizedBox(width: 6),
                    const Text('Révision des réponses',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                ...quizState.answerDetails.asMap().entries.map((entry) {
                  final d = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: d.isCorrect ? AppColors.correct.withOpacity(0.06) : AppColors.incorrect.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: d.isCorrect ? AppColors.correct.withOpacity(0.3) : AppColors.incorrect.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          d.isCorrect ? Icons.check_circle : d.isTimeout ? Icons.timer_off : Icons.cancel,
                          size: 20,
                          color: d.isCorrect ? AppColors.correct : AppColors.incorrect,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(d.question,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              Text(
                                d.isTimeout
                                    ? 'Réponse : ${d.correctAnswer}'
                                    : d.isCorrect
                                        ? d.correctAnswer
                                        : '${d.userAnswer} → ${d.correctAnswer}',
                                style: TextStyle(fontSize: 11,
                                    color: d.isCorrect ? AppColors.correct : AppColors.incorrect),
                              ),
                            ],
                          ),
                        ),
                        if (!d.isTimeout && d.timeSpent > 0)
                          Text('${d.timeSpent}s', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                      ],
                    ),
                  );
                }),
              ],
              const SizedBox(height: 20),

              // Buttons
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: color),
                  onPressed: onRestart,
                  child: const Text('Réessayer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity, height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(side: BorderSide(color: color)),
                  onPressed: () => context.go('/quiz'),
                  child: Text('Autres quiz', style: TextStyle(color: color, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _ResultStat({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: color),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
