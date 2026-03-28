import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/models.dart';

class LocalDataSource {
  static const String _onboardingKey = 'onboarding_completed';
  static const String _exploredCountriesKey = 'explored_countries';
  static const String _quizResultsKey = 'quiz_results';
  static const String _cachedCountriesKey = 'cached_countries';
  static const String _cachedRegionsKey = 'cached_regions';
  static const String _cachedLanguagesKey = 'cached_languages';
  static const String _cachedIslandsKey = 'cached_islands';
  static const String _cachedRegionLanguagesKey = 'cached_region_languages';

  final SharedPreferences _prefs;

  LocalDataSource(this._prefs);

  // Onboarding
  bool get isOnboardingCompleted => _prefs.getBool(_onboardingKey) ?? false;
  Future<void> setOnboardingCompleted() => _prefs.setBool(_onboardingKey, true);

  // Explored countries
  Set<String> get exploredCountries {
    final list = _prefs.getStringList(_exploredCountriesKey) ?? [];
    return list.toSet();
  }

  Future<void> addExploredCountry(String countryId) async {
    final countries = exploredCountries;
    countries.add(countryId);
    await _prefs.setStringList(_exploredCountriesKey, countries.toList());
  }

  // Quiz results
  List<QuizResult> get quizResults {
    final jsonStr = _prefs.getString(_quizResultsKey);
    if (jsonStr == null) return [];
    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList.map((e) => QuizResult.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<void> addQuizResult(QuizResult result) async {
    final results = quizResults;
    results.add(result);
    final jsonStr = json.encode(results.map((e) => e.toMap()).toList());
    await _prefs.setString(_quizResultsKey, jsonStr);
  }

  int get totalQuizzesCompleted => quizResults.length;

  int get bestScore {
    final results = quizResults;
    if (results.isEmpty) return 0;
    return results.map((r) => r.score).reduce((a, b) => a > b ? a : b);
  }

  // Cache data
  Future<void> cacheCountries(List<Country> countries) async {
    final jsonStr = json.encode(countries.map((c) => c.toMap()).toList());
    await _prefs.setString(_cachedCountriesKey, jsonStr);
  }

  List<Country> getCachedCountries() {
    final jsonStr = _prefs.getString(_cachedCountriesKey);
    if (jsonStr == null) return [];
    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList.map((e) => Country.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<void> cacheRegions(List<Region> regions) async {
    final jsonStr = json.encode(regions.map((r) => r.toMap()).toList());
    await _prefs.setString(_cachedRegionsKey, jsonStr);
  }

  List<Region> getCachedRegions() {
    final jsonStr = _prefs.getString(_cachedRegionsKey);
    if (jsonStr == null) return [];
    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList.map((e) => Region.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<void> cacheLanguages(List<Language> languages) async {
    final jsonStr = json.encode(languages.map((l) => l.toMap()).toList());
    await _prefs.setString(_cachedLanguagesKey, jsonStr);
  }

  List<Language> getCachedLanguages() {
    final jsonStr = _prefs.getString(_cachedLanguagesKey);
    if (jsonStr == null) return [];
    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList.map((e) => Language.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<void> cacheIslands(List<Island> islands) async {
    final jsonStr = json.encode(islands.map((i) => i.toMap()).toList());
    await _prefs.setString(_cachedIslandsKey, jsonStr);
  }

  List<Island> getCachedIslands() {
    final jsonStr = _prefs.getString(_cachedIslandsKey);
    if (jsonStr == null) return [];
    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList.map((e) => Island.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<void> cacheRegionLanguages(List<RegionLanguage> regionLanguages) async {
    final jsonStr = json.encode(regionLanguages.map((rl) => rl.toMap()).toList());
    await _prefs.setString(_cachedRegionLanguagesKey, jsonStr);
  }

  List<RegionLanguage> getCachedRegionLanguages() {
    final jsonStr = _prefs.getString(_cachedRegionLanguagesKey);
    if (jsonStr == null) return [];
    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList.map((e) => RegionLanguage.fromMap(e as Map<String, dynamic>)).toList();
  }

  // Badges
  static const String _unlockedBadgesKey = 'unlocked_badges';

  Set<String> getUnlockedBadged() {
    return (_prefs.getStringList(_unlockedBadgesKey) ?? []).toSet();
  }

  // Alias for providers
  Set<String> getUnlockedBadges() => getUnlockedBadged();

  Future<void> unlockBadge(String badgeId) async {
    final badges = getUnlockedBadged();
    badges.add(badgeId);
    await _prefs.setStringList(_unlockedBadgesKey, badges.toList());
  }
}
