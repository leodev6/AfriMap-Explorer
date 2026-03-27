import '../models/models.dart';
import '../datasources/local/local_datasource.dart';
import '../datasources/remote/remote_datasource.dart';
import '../seed/seed_data.dart';

class CountryRepository {
  final LocalDataSource _local;
  final RemoteDataSource? _remote;

  List<Country> _countries = [];
  List<Region> _regions = [];
  List<Language> _languages = [];
  List<Island> _islands = [];
  List<RegionLanguage> _regionLanguages = [];

  bool _initialized = false;
  bool get isInitialized => _initialized;

  CountryRepository(this._local, [this._remote]);

  Future<void> initialize() async {
    if (_initialized) return;

    // 1. Charger depuis le cache local immédiatement
    _loadFromLocalCache();

    // 2. Si pas de cache local, charger les données seed
    if (_countries.isEmpty) {
      _loadFromSeed();
      await _saveToLocalCache();
    }

    _initialized = true;

    // 3. En arrière-plan : synchroniser avec Supabase si disponible
    if (_remote != null) {
      _syncWithRemote();
    }
  }

  void _loadFromLocalCache() {
    _countries = _local.getCachedCountries();
    _regions = _local.getCachedRegions();
    _languages = _local.getCachedLanguages();
    _islands = _local.getCachedIslands();
    _regionLanguages = _local.getCachedRegionLanguages();
  }

  void _loadFromSeed() {
    _countries = SeedData.countries;
    _regions = SeedData.regions;
    _languages = SeedData.languages;
    _islands = SeedData.islands;
    _regionLanguages = SeedData.regionLanguages;
  }

  Future<void> _saveToLocalCache() async {
    await _local.cacheCountries(_countries);
    await _local.cacheRegions(_regions);
    await _local.cacheLanguages(_languages);
    await _local.cacheIslands(_islands);
    await _local.cacheRegionLanguages(_regionLanguages);
  }

  Future<void> _syncWithRemote() async {
    try {
      // Vérifier si Supabase a des données
      final remoteCountries = await _remote!.fetchCountries();

      if (remoteCountries.isNotEmpty) {
        // Supabase a des données → tirer depuis Supabase
        _countries = remoteCountries;
        _regions = await _remote!.fetchRegions();
        _languages = await _remote!.fetchLanguages();
        _islands = await _remote!.fetchIslands();
        _regionLanguages = await _remote!.fetchRegionLanguages();

        // Sauvegarder dans le cache local
        await _saveToLocalCache();
      } else {
        // Supabase est vide → pousser les données locales vers Supabase
        await _pushToRemote();
      }
    } catch (e) {
      // Pas de connexion ou erreur → garder les données locales
    }
  }

  Future<void> _pushToRemote() async {
    if (_remote == null) return;
    try {
      await _remote!.upsertCountries(_countries);
      await _remote!.upsertRegions(_regions);
      await _remote!.upsertLanguages(_languages);
      await _remote!.upsertIslands(_islands);
      await _remote!.upsertRegionLanguages(_regionLanguages);
    } catch (_) {}
  }

  // Forcer une synchronisation complète
  Future<void> forceSyncWithRemote() async {
    if (_remote == null) return;
    await _syncWithRemote();
  }

  // Sauvegarder un résultat de quiz
  Future<void> saveQuizResult(QuizResult result) async {
    if (_remote != null) {
      try {
        await _remote!.saveQuizResult(result);
      } catch (_) {}
    }
  }

  List<Country> get countries => _countries;

  List<Country> searchCountries(String query) {
    if (query.isEmpty) return _countries;
    return _countries
        .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Country? getCountryById(String id) {
    try {
      return _countries.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Region> getRegionsByCountry(String countryId) {
    return _regions.where((r) => r.countryId == countryId).toList();
  }

  List<Language> getLanguagesByRegion(String regionId) {
    final regionLangIds = _regionLanguages
        .where((rl) => rl.regionId == regionId)
        .map((rl) => rl.languageId)
        .toSet();
    return _languages.where((l) => regionLangIds.contains(l.id)).toList();
  }

  List<Language> getLanguagesByCountry(String countryId) {
    final regionIds = _regions
        .where((r) => r.countryId == countryId)
        .map((r) => r.id)
        .toSet();
    final langIds = _regionLanguages
        .where((rl) => regionIds.contains(rl.regionId))
        .map((rl) => rl.languageId)
        .toSet();
    return _languages.where((l) => langIds.contains(l.id)).toList();
  }

  List<Island> getIslandsByCountry(String countryId) {
    return _islands.where((i) => i.countryId == countryId).toList();
  }

  List<Language> get allLanguages => _languages;

  List<Region> get allRegions => _regions;

  Region? getRegionById(String id) {
    try {
      return _regions.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }
}
