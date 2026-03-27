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

final countryRepositoryProvider = Provider<CountryRepository>((ref) {
  final local = ref.watch(localDataSourceProvider);
  RemoteDataSource? remote;
  if (SupabaseConfig.isConfigured) {
    try {
      remote = RemoteDataSource(Supabase.instance.client);
    } catch (_) {}
  }
  return CountryRepository(local, remote);
});

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  final countryRepo = ref.watch(countryRepositoryProvider);
  return QuizRepository(countryRepo);
});

final dataInitializerProvider = FutureProvider<void>((ref) async {
  final repo = ref.watch(countryRepositoryProvider);
  await repo.initialize();
});

final countriesProvider = Provider<List<Country>>((ref) {
  ref.watch(dataInitializerProvider);
  return ref.watch(countryRepositoryProvider).countries;
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredCountriesProvider = Provider<List<Country>>((ref) {
  final query = ref.watch(searchQueryProvider);
  return ref.watch(countryRepositoryProvider).searchCountries(query);
});

final regionsByCountryProvider =
    Provider.family<List<Region>, String>((ref, countryId) {
  return ref.watch(countryRepositoryProvider).getRegionsByCountry(countryId);
});

final languagesByCountryProvider =
    Provider.family<List<Language>, String>((ref, countryId) {
  return ref.watch(countryRepositoryProvider).getLanguagesByCountry(countryId);
});

final languagesByRegionProvider =
    Provider.family<List<Language>, String>((ref, regionId) {
  return ref.watch(countryRepositoryProvider).getLanguagesByRegion(regionId);
});

final islandsByCountryProvider =
    Provider.family<List<Island>, String>((ref, countryId) {
  return ref.watch(countryRepositoryProvider).getIslandsByCountry(countryId);
});

// Progress providers
final exploredCountriesProvider = StateNotifierProvider<ExploredCountriesNotifier, Set<String>>((ref) {
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

final quizResultsProvider = StateNotifierProvider<QuizResultsNotifier, List<QuizResult>>((ref) {
  final local = ref.watch(localDataSourceProvider);
  return QuizResultsNotifier(local);
});

class QuizResultsNotifier extends StateNotifier<List<QuizResult>> {
  final LocalDataSource _local;

  QuizResultsNotifier(this._local) : super(_local.quizResults);

  void addResult(QuizResult result) {
    _local.addQuizResult(result);
    state = [...state, result];
  }

  int get totalQuizzes => state.length;
  int get bestScore => state.isEmpty ? 0 : state.map((r) => r.score).reduce((a, b) => a > b ? a : b);
}

// Quiz state provider
final quizStateProvider = StateNotifierProvider.autoDispose<QuizNotifier, QuizState>((ref) {
  final quizRepo = ref.watch(quizRepositoryProvider);
  final resultsNotifier = ref.read(quizResultsProvider.notifier);
  return QuizNotifier(quizRepo, resultsNotifier);
});

class QuizNotifier extends StateNotifier<QuizState> {
  final QuizRepository _quizRepo;
  final QuizResultsNotifier _resultsNotifier;

  QuizNotifier(this._quizRepo, this._resultsNotifier)
      : super(const QuizState(quizType: QuizType.countryCapital));

  void startQuiz(QuizType type, {int count = 10}) {
    final questions = _quizRepo.generateQuiz(type, count: count);
    state = QuizState(
      questions: questions,
      quizType: type,
      userAnswers: List.filled(questions.length, null),
    );
  }

  void answerQuestion(String answer) {
    final current = state.currentQuestion;
    if (current == null) return;

    final isCorrect = answer == current.correctAnswer;
    final newAnswers = List<String?>.from(state.userAnswers);
    newAnswers[state.currentIndex] = answer;

    state = state.copyWith(
      userAnswers: newAnswers,
      correctAnswers: isCorrect
          ? state.correctAnswers + 1
          : state.correctAnswers,
    );
  }

  void nextQuestion() {
    if (state.currentIndex < state.questions.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    } else {
      final result = QuizResult(
        id: const Uuid().v4(),
        type: state.quizType,
        totalQuestions: state.questions.length,
        correctAnswers: state.correctAnswers,
        completedAt: DateTime.now(),
        score: state.correctAnswers * 10,
      );
      _resultsNotifier.addResult(result);
      state = state.copyWith(isCompleted: true);
    }
  }

  void reset() {
    state = QuizState(quizType: state.quizType);
  }
}
