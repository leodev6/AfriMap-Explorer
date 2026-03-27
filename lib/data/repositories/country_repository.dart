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

  CountryRepository(this._local, [this._remote]);

  Future<void> initialize() async {
    // Try loading from cache first
    _countries = _local.getCachedCountries();
    _regions = _local.getCachedRegions();
    _languages = _local.getCachedLanguages();
    _islands = _local.getCachedIslands();
    _regionLanguages = _local.getCachedRegionLanguages();

    // If no cached data, load seed data
    if (_countries.isEmpty) {
      _countries = SeedData.countries;
      _regions = SeedData.regions;
      _languages = SeedData.languages;
      _islands = SeedData.islands;
      _regionLanguages = SeedData.regionLanguages;

      // Cache the seed data
      await _local.cacheCountries(_countries);
      await _local.cacheRegions(_regions);
      await _local.cacheLanguages(_languages);
      await _local.cacheIslands(_islands);
      await _local.cacheRegionLanguages(_regionLanguages);
    }

    // Try syncing with remote if available
    if (_remote != null) {
      try {
        final remoteCountries = await _remote.fetchCountries();
        if (remoteCountries.isNotEmpty) {
          _countries = remoteCountries;
          await _local.cacheCountries(_countries);
        }

        final remoteRegions = await _remote.fetchRegions();
        if (remoteRegions.isNotEmpty) {
          _regions = remoteRegions;
          await _local.cacheRegions(_regions);
        }

        final remoteLanguages = await _remote.fetchLanguages();
        if (remoteLanguages.isNotEmpty) {
          _languages = remoteLanguages;
          await _local.cacheLanguages(_languages);
        }

        final remoteIslands = await _remote.fetchIslands();
        if (remoteIslands.isNotEmpty) {
          _islands = remoteIslands;
          await _local.cacheIslands(_islands);
        }

        final remoteRegionLangs = await _remote.fetchRegionLanguages();
        if (remoteRegionLangs.isNotEmpty) {
          _regionLanguages = remoteRegionLangs;
          await _local.cacheRegionLanguages(_regionLanguages);
        }
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
