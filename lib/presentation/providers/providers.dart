import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/supabase_config.dart';
import '../../data/datasources/local/local_datasource.dart';
import '../../data/datasources/remote/remote_datasource.dart';
import '../../data/models/models.dart';
import '../../data/repositories/country_repository.dart';
import '../../data/repositories/quiz_repository.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden');
});

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalDataSource(prefs);
});

final remoteDataSourceProvider = Provider<RemoteDataSource?>((ref) {
  if (!SupabaseConfig.isConfigured) return null;
  try {
    return RemoteDataSource(Supabase.instance.client);
  } catch (_) {
    return null;
  }
});

final countryRepositoryProvider = Provider<CountryRepository>((ref) {
  final local = ref.watch(localDataSourceProvider);
  final remote = ref.watch(remoteDataSourceProvider);
  return CountryRepository(local, remote);
});

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  ref.watch(dataInitializerProvider); // attend l'init des données
  final countryRepo = ref.watch(countryRepositoryProvider);
  return QuizRepository(countryRepo);
});

// Initialisation des données au démarrage
final dataInitializerProvider = FutureProvider<void>((ref) async {
  final repo = ref.watch(countryRepositoryProvider);
  await repo.initialize();
});

// Pays disponibles (dépend de l'initialisation)
final countriesProvider = Provider<List<Country>>((ref) {
  ref.watch(dataInitializerProvider);
  return ref.watch(countryRepositoryProvider).countries;
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredCountriesProvider = Provider<List<Country>>((ref) {
  final query = ref.watch(searchQueryProvider);
  ref.watch(dataInitializerProvider); // attend l'init
  return ref.watch(countryRepositoryProvider).searchCountries(query);
});

final regionsByCountryProvider =
    Provider.family<List<Region>, String>((ref, countryId) {
  ref.watch(dataInitializerProvider);
  return ref.watch(countryRepositoryProvider).getRegionsByCountry(countryId);
});

final languagesByCountryProvider =
    Provider.family<List<Language>, String>((ref, countryId) {
  ref.watch(dataInitializerProvider);
  return ref.watch(countryRepositoryProvider).getLanguagesByCountry(countryId);
});

final languagesByRegionProvider =
    Provider.family<List<Language>, String>((ref, regionId) {
  ref.watch(dataInitializerProvider);
  return ref.watch(countryRepositoryProvider).getLanguagesByRegion(regionId);
});

final islandsByCountryProvider =
    Provider.family<List<Island>, String>((ref, countryId) {
  ref.watch(dataInitializerProvider);
  return ref.watch(countryRepositoryProvider).getIslandsByCountry(countryId);
});

// ============ Progress providers ============

final exploredCountriesProvider =
    StateNotifierProvider<ExploredCountriesNotifier, Set<String>>((ref) {
  final local = ref.watch(localDataSourceProvider);
  return ExploredCountriesNotifier(local);
});

class ExploredCountriesNotifier extends StateNotifier<Set<String>> {
  final LocalDataSource _local;

  ExploredCountriesNotifier(this._local) : super(_local.exploredCountries);

  void addCountry(String countryId) {
    _local.addExploredCountry(countryId);
    state = {...state, countryId};
  }
}

final quizResultsProvider =
    StateNotifierProvider<QuizResultsNotifier, List<QuizResult>>((ref) {
  final local = ref.watch(localDataSourceProvider);
  final repo = ref.watch(countryRepositoryProvider);
  return QuizResultsNotifier(local, repo);
});

class QuizResultsNotifier extends StateNotifier<List<QuizResult>> {
  final LocalDataSource _local;
  final CountryRepository _repo;

  QuizResultsNotifier(this._local, this._repo) : super(_local.quizResults);

  void addResult(QuizResult result) {
    _local.addQuizResult(result);
    state = [...state, result];
    _repo.saveQuizResult(result);
  }

  int get totalQuizzes => state.length;
  int get bestScore =>
      state.isEmpty ? 0 : state.map((r) => r.score).reduce((a, b) => a > b ? a : b);

  Set<QuizType> get playedTypes => state.map((r) => r.type).toSet();
}

// ============ Quiz state provider ============

final quizStateProvider =
    StateNotifierProvider<QuizNotifier, QuizState>((ref) {
  final quizRepo = ref.watch(quizRepositoryProvider);
  final resultsNotifier = ref.read(quizResultsProvider.notifier);
  return QuizNotifier(quizRepo, resultsNotifier);
});

class QuizNotifier extends StateNotifier<QuizState> {
  final QuizRepository _quizRepo;
  final QuizResultsNotifier _resultsNotifier;

  QuizNotifier(this._quizRepo, this._resultsNotifier)
      : super(const QuizState(quizType: QuizType.countryCapital));

  void startQuiz(QuizType type, {QuizDifficulty difficulty = QuizDifficulty.easy}) {
    var questions = _quizRepo.generateQuiz(type, count: difficulty.questionCount);

    // Fallback: si pas assez de questions, réduire le nombre
    if (questions.isEmpty) {
      questions = _quizRepo.generateQuiz(type, count: 5);
    }
    // Encore vide ? essayer le quiz pays-capitale (toujours disponible)
    if (questions.isEmpty) {
      questions = _quizRepo.generateCountryCapitalQuiz(count: 5);
    }

    state = QuizState(
      questions: questions,
      quizType: type,
      difficulty: difficulty,
      timeRemaining: difficulty.timeLimit,
      isTimerActive: true,
      userAnswers: List.filled(questions.length, null),
    );
  }

  void answerQuestion(String answer, {int timeSpent = 0}) {
    final current = state.currentQuestion;
    if (current == null) return;

    final isCorrect = answer == current.correctAnswer;
    final newAnswers = List<String?>.from(state.userAnswers);
    newAnswers[state.currentIndex] = answer;

    final detail = QuizAnswerDetail(
      questionId: current.id,
      question: current.question,
      correctAnswer: current.correctAnswer,
      userAnswer: answer,
      isCorrect: isCorrect,
      timeSpent: timeSpent,
    );

    final newDetails = List<QuizAnswerDetail>.from(state.answerDetails)..add(detail);

    state = state.copyWith(
      userAnswers: newAnswers,
      answerDetails: newDetails,
      correctAnswers: isCorrect ? state.correctAnswers + 1 : state.correctAnswers,
      wrongAnswers: !isCorrect ? state.wrongAnswers + 1 : state.wrongAnswers,
      isTimerActive: false,
    );
  }

  void handleTimeout() {
    final current = state.currentQuestion;
    if (current == null) return;

    final detail = QuizAnswerDetail(
      questionId: current.id,
      question: current.question,
      correctAnswer: current.correctAnswer,
      userAnswer: null,
      isCorrect: false,
      isTimeout: true,
      timeSpent: state.difficulty.timeLimit,
    );

    final newDetails = List<QuizAnswerDetail>.from(state.answerDetails)..add(detail);
    final newAnswers = List<String?>.from(state.userAnswers);
    newAnswers[state.currentIndex] = null;

    state = state.copyWith(
      userAnswers: newAnswers,
      answerDetails: newDetails,
      timeouts: state.timeouts + 1,
      wrongAnswers: state.wrongAnswers + 1,
      isTimerActive: false,
    );
  }

  void updateTimer(int remaining) {
    state = state.copyWith(timeRemaining: remaining);
    if (remaining <= 0) {
      handleTimeout();
    }
  }

  void nextQuestion() {
    if (state.currentIndex < state.questions.length - 1) {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
        timeRemaining: state.difficulty.timeLimit,
        isTimerActive: true,
      );
    } else {
      final maxScore = state.questions.length * state.difficulty.pointsPerQuestion;
      final result = QuizResult(
        id: const Uuid().v4(),
        type: state.quizType,
        difficulty: state.difficulty,
        totalQuestions: state.questions.length,
        correctAnswers: state.correctAnswers,
        wrongAnswers: state.wrongAnswers,
        timeouts: state.timeouts,
        completedAt: DateTime.now(),
        score: state.correctAnswers * state.difficulty.pointsPerQuestion,
        maxScore: maxScore,
        answerDetails: state.answerDetails,
      );
      _resultsNotifier.addResult(result);
      state = state.copyWith(isCompleted: true, isTimerActive: false);
    }
  }

  void reset() {
    state = QuizState(quizType: state.quizType);
  }
}

// ============ Badges provider ============

final badgesProvider =
    StateNotifierProvider<BadgesNotifier, List<Badge>>((ref) {
  final local = ref.watch(localDataSourceProvider);
  final results = ref.watch(quizResultsProvider);
  final explored = ref.watch(exploredCountriesProvider);
  final countries = ref.watch(countriesProvider);
  return BadgesNotifier(local, results, explored, countries.length);
});

class BadgesNotifier extends StateNotifier<List<Badge>> {
  final LocalDataSource _local;
  final List<QuizResult> _results;
  final Set<String> _explored;
  final int _totalCountries;

  BadgesNotifier(this._local, this._results, this._explored, this._totalCountries)
      : super(BadgeDefinitions.all) {
    _checkBadges();
  }

  void _checkBadges() {
    final unlocked = _local.getUnlockedBadges();
    final updated = <Badge>[];
    for (final badge in state) {
      if (unlocked.contains(badge.id)) {
        updated.add(Badge(
          id: badge.id, name: badge.name, description: badge.description,
          icon: badge.icon, isUnlocked: true,
        ));
      } else if (_shouldUnlock(badge)) {
        final date = DateTime.now();
        _local.unlockBadge(badge.id);
        updated.add(badge.unlock(date));
      } else {
        updated.add(badge);
      }
    }
    state = updated;
  }

  bool _shouldUnlock(Badge badge) {
    switch (badge.id) {
      case 'first_quiz': return _results.isNotEmpty;
      case 'perfect_score': return _results.any((r) => r.percentage == 100);
      case 'five_quizzes': return _results.length >= 5;
      case 'ten_quizzes': return _results.length >= 10;
      case 'explorer_10': return _explored.length >= 10;
      case 'explorer_all': return _totalCountries > 0 && _explored.length >= _totalCountries;
      case 'all_types': return _results.map((r) => r.type).toSet().length >= 6;
      case 'streak_5': return _results.isNotEmpty && _results.last.correctAnswers >= 5;
      case 'hard_quiz': return _results.any((r) => r.difficulty == QuizDifficulty.hard);
      case 'speed_demon': return _results.expand((r) => r.answerDetails).any((d) => d.timeSpent < 3 && d.isCorrect);
      default: return false;
    }
  }

  int get unlockedCount => state.where((b) => b.isUnlocked).length;
  int get totalCount => state.length;
}
