import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/models.dart';

class RemoteDataSource {
  final SupabaseClient _client;

  RemoteDataSource(this._client);

  // ============ FETCH ============

  Future<List<Country>> fetchCountries() async {
    final response = await _client.from('countries').select();
    return (response as List)
        .map((e) => Country.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Region>> fetchRegions() async {
    final response = await _client.from('regions').select();
    return (response as List)
        .map((e) => Region.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Language>> fetchLanguages() async {
    final response = await _client.from('languages').select();
    return (response as List)
        .map((e) => Language.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Island>> fetchIslands() async {
    final response = await _client.from('islands').select();
    return (response as List)
        .map((e) => Island.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<RegionLanguage>> fetchRegionLanguages() async {
    final response = await _client.from('region_languages').select();
    return (response as List)
        .map((e) => RegionLanguage.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  // ============ UPSERT (push local → Supabase) ============

  Future<void> upsertCountries(List<Country> countries) async {
    if (countries.isEmpty) return;
    final data = countries.map((c) => c.toMap()).toList();
    await _client.from('countries').upsert(data);
  }

  Future<void> upsertRegions(List<Region> regions) async {
    if (regions.isEmpty) return;
    final data = regions.map((r) => r.toMap()).toList();
    await _client.from('regions').upsert(data);
  }

  Future<void> upsertLanguages(List<Language> languages) async {
    if (languages.isEmpty) return;
    final data = languages.map((l) => l.toMap()).toList();
    await _client.from('languages').upsert(data);
  }

  Future<void> upsertIslands(List<Island> islands) async {
    if (islands.isEmpty) return;
    final data = islands.map((i) => i.toMap()).toList();
    await _client.from('islands').upsert(data);
  }

  Future<void> upsertRegionLanguages(List<RegionLanguage> regionLanguages) async {
    if (regionLanguages.isEmpty) return;
    final data = regionLanguages.map((rl) => rl.toMap()).toList();
    await _client.from('region_languages').upsert(data);
  }

  // ============ QUIZ RESULTS ============

  Future<void> saveQuizResult(QuizResult result) async {
    await _client.from('quiz_results').insert(result.toMap());
  }

  Future<List<QuizResult>> fetchQuizResults(String? deviceId) async {
    if (deviceId == null) return [];
    final response = await _client
        .from('quiz_results')
        .select()
        .eq('device_id', deviceId)
        .order('completed_at', ascending: false);
    return (response as List)
        .map((e) => QuizResult.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
