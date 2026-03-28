import 'dart:math';
import '../models/models.dart';
import '../repositories/country_repository.dart';

class QuizRepository {
  final CountryRepository _countryRepo;
  final Random _random = Random();

  QuizRepository(this._countryRepo);

  // ============ Pays → Capitale ============
  List<QuizQuestion> generateCountryCapitalQuiz({required int count}) {
    final countries = _countryRepo.countries
        .where((c) => c.capital.isNotEmpty)
        .toList()
      ..shuffle(_random);
    final questions = <QuizQuestion>[];
    int idCounter = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < count && i < countries.length; i++) {
      final country = countries[i];
      final wrongAnswers = _getRandomWrongCapitals(country, 3);
      if (wrongAnswers.length < 3) continue;
      final options = [...wrongAnswers, country.capital]..shuffle(_random);
      idCounter++;

      questions.add(QuizQuestion(
        id: 'cc_$idCounter',
        type: QuizType.countryCapital,
        question: 'Quelle est la capitale de ${country.name} ?',
        correctAnswer: country.capital,
        options: options,
        relatedCountryId: country.id,
        explanation: 'La capitale de ${country.name} est ${country.capital}.',
      ));
    }
    return questions;
  }

  List<String> _getRandomWrongCapitals(Country correctCountry, int count) {
    final others = _countryRepo.countries
        .where((c) => c.id != correctCountry.id && c.capital.isNotEmpty)
        .toList()
      ..shuffle(_random);
    return others.take(count).map((c) => c.capital).toList();
  }

  // ============ Capitale → Pays ============
  List<QuizQuestion> generateCapitalCountryQuiz({required int count}) {
    final countries = _countryRepo.countries
        .where((c) => c.capital.isNotEmpty)
        .toList()
      ..shuffle(_random);
    final questions = <QuizQuestion>[];
    int idCounter = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < count && i < countries.length; i++) {
      final country = countries[i];
      final wrongAnswers = _getRandomWrongCountries(country, 3);
      if (wrongAnswers.length < 3) continue;
      final options = [...wrongAnswers, country.name]..shuffle(_random);
      idCounter++;

      questions.add(QuizQuestion(
        id: 'ca_$idCounter',
        type: QuizType.capitalCountry,
        question: 'Quel pays a pour capitale « ${country.capital} » ?',
        correctAnswer: country.name,
        options: options,
        relatedCountryId: country.id,
        explanation: '${country.capital} est la capitale de ${country.name}.',
      ));
    }
    return questions;
  }

  // ============ Drapeau → Pays ============
  List<QuizQuestion> generateFlagCountryQuiz({required int count}) {
    final countries = _countryRepo.countries
        .where((c) => c.flagUrl.isNotEmpty)
        .toList()
      ..shuffle(_random);
    final questions = <QuizQuestion>[];
    int idCounter = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < count && i < countries.length; i++) {
      final country = countries[i];
      final wrongAnswers = _getRandomWrongCountries(country, 3);
      if (wrongAnswers.length < 3) continue;
      final options = [...wrongAnswers, country.name]..shuffle(_random);
      idCounter++;

      questions.add(QuizQuestion(
        id: 'fc_$idCounter',
        type: QuizType.flagCountry,
        question: 'À quel pays appartient ce drapeau ?',
        correctAnswer: country.name,
        options: options,
        relatedCountryId: country.id,
        flagUrl: country.flagUrl,
        explanation: 'Ce drapeau appartient à ${country.name}.',
      ));
    }
    return questions;
  }

  // ============ Pays → Langues ============
  List<QuizQuestion> generateCountryLanguageQuiz({required int count}) {
    final countries = _countryRepo.countries
        .where((c) => _countryRepo.getLanguagesByCountry(c.id).isNotEmpty)
        .toList()
      ..shuffle(_random);
    final questions = <QuizQuestion>[];
    int idCounter = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < count && i < countries.length; i++) {
      final country = countries[i];
      final langs = _countryRepo.getLanguagesByCountry(country.id);
      if (langs.isEmpty) continue;

      final officialLangs = langs.where((l) => l.isOfficial).toList();
      final displayLangs = officialLangs.isNotEmpty ? officialLangs : langs;

      // Use single language for easier questions
      final mainLang = displayLangs.first;
      final wrongOptions = _getRandomWrongLanguageNames(mainLang.name, 3);
      if (wrongOptions.length < 3) continue;
      final options = [...wrongOptions, mainLang.name]..shuffle(_random);
      idCounter++;

      questions.add(QuizQuestion(
        id: 'cl_$idCounter',
        type: QuizType.countryLanguage,
        question: 'Quelle langue officielle est parlée en ${country.name} ?',
        correctAnswer: mainLang.name,
        options: options,
        relatedCountryId: country.id,
        explanation: 'En ${country.name}, on parle : ${langs.map((l) => l.name).join(", ")}.',
      ));
    }
    return questions;
  }

  // ============ Langues → Pays ============
  List<QuizQuestion> generateLanguageCountryQuiz({required int count}) {
    final countries = _countryRepo.countries
        .where((c) => _countryRepo.getLanguagesByCountry(c.id).isNotEmpty)
        .toList()
      ..shuffle(_random);
    final questions = <QuizQuestion>[];
    int idCounter = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < count && i < countries.length; i++) {
      final country = countries[i];
      final langs = _countryRepo.getLanguagesByCountry(country.id);
      if (langs.isEmpty) continue;

      final officialLangs = langs.where((l) => l.isOfficial).toList();
      final queryLangs = officialLangs.isNotEmpty ? officialLangs : langs;
      final langName = queryLangs.first.name;

      final wrongAnswers = _getRandomWrongCountries(country, 3);
      if (wrongAnswers.length < 3) continue;
      final options = [...wrongAnswers, country.name]..shuffle(_random);
      idCounter++;

      questions.add(QuizQuestion(
        id: 'lc_$idCounter',
        type: QuizType.languageCountry,
        question: 'Quel pays a pour langue officielle « $langName » ?',
        correctAnswer: country.name,
        options: options,
        relatedCountryId: country.id,
        explanation: '${country.name} parle : ${langs.map((l) => l.name).join(", ")}.',
      ));
    }
    return questions;
  }

  // ============ Région → Langues ============
  List<QuizQuestion> generateRegionLanguageQuiz({required int count}) {
    final regions = _countryRepo.allRegions
        .where((r) => _countryRepo.getLanguagesByRegion(r.id).isNotEmpty)
        .toList()
      ..shuffle(_random);
    final questions = <QuizQuestion>[];
    int idCounter = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < count && i < regions.length; i++) {
      final region = regions[i];
      final langs = _countryRepo.getLanguagesByRegion(region.id);
      if (langs.isEmpty) continue;

      final mainLang = langs.first;
      final country = _countryRepo.getCountryById(region.countryId);
      final countryName = country?.name ?? '';

      final wrongOptions = _getRandomWrongLanguageNames(mainLang.name, 3);
      if (wrongOptions.length < 3) continue;
      final options = [...wrongOptions, mainLang.name]..shuffle(_random);
      idCounter++;

      questions.add(QuizQuestion(
        id: 'rl_$idCounter',
        type: QuizType.regionLanguage,
        question: 'Quelle langue est parlée dans la région ${region.name} ($countryName) ?',
        correctAnswer: mainLang.name,
        options: options,
        relatedRegionId: region.id,
        relatedCountryId: region.countryId,
        explanation: 'Dans ${region.name}, on parle : ${langs.map((l) => l.name).join(", ")}.',
      ));
    }
    return questions;
  }

  // ============ Pays → Îles ============
  List<QuizQuestion> generateIslandCountryQuiz({required int count}) {
    final countriesWithIslands = _countryRepo.countries
        .where((c) => _countryRepo.getIslandsByCountry(c.id).isNotEmpty)
        .toList()
      ..shuffle(_random);
    final questions = <QuizQuestion>[];
    int idCounter = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < count && i < countriesWithIslands.length; i++) {
      final country = countriesWithIslands[i];
      final islands = _countryRepo.getIslandsByCountry(country.id);
      if (islands.isEmpty) continue;

      // Always ask: which country does this island belong to?
      final island = islands[_random.nextInt(islands.length)];
      final wrongCountries = _getRandomWrongCountries(country, 3);
      if (wrongCountries.length < 3) continue;
      final options = [...wrongCountries, country.name]..shuffle(_random);
      idCounter++;

      questions.add(QuizQuestion(
        id: 'ic_$idCounter',
        type: QuizType.islandCountry,
        question: 'À quel pays appartient l\'île de « ${island.name} » ?',
        correctAnswer: country.name,
        options: options,
        relatedCountryId: country.id,
        explanation: '${island.name} appartient à ${country.name} (${islands.map((i) => i.name).join(", ")}).',
      ));
    }
    return questions;
  }

  // ============ Mélange ============
  List<QuizQuestion> generateMixedQuiz({required int count}) {
    final perType = (count / 6).ceil();
    final allQuestions = <QuizQuestion>[];
    allQuestions.addAll(generateCountryCapitalQuiz(count: perType));
    allQuestions.addAll(generateCapitalCountryQuiz(count: perType));
    allQuestions.addAll(generateFlagCountryQuiz(count: perType));
    allQuestions.addAll(generateCountryLanguageQuiz(count: perType));
    allQuestions.addAll(generateLanguageCountryQuiz(count: perType));
    allQuestions.addAll(generateRegionLanguageQuiz(count: perType));
    allQuestions.shuffle(_random);
    return allQuestions.take(count).toList();
  }

  // ============ Générateur principal ============
  List<QuizQuestion> generateQuiz(QuizType type, {required int count}) {
    switch (type) {
      case QuizType.countryCapital:
        return generateCountryCapitalQuiz(count: count);
      case QuizType.capitalCountry:
        return generateCapitalCountryQuiz(count: count);
      case QuizType.countryLanguage:
        return generateCountryLanguageQuiz(count: count);
      case QuizType.languageCountry:
        return generateLanguageCountryQuiz(count: count);
      case QuizType.regionLanguage:
        return generateRegionLanguageQuiz(count: count);
      case QuizType.flagCountry:
        return generateFlagCountryQuiz(count: count);
      case QuizType.islandCountry:
        return generateIslandCountryQuiz(count: count);
      case QuizType.multipleChoice:
        return generateMixedQuiz(count: count);
    }
  }

  // ============ Helpers ============

  List<String> _getRandomWrongCountries(Country correct, int count) {
    final others = _countryRepo.countries
        .where((c) => c.id != correct.id)
        .toList()
      ..shuffle(_random);
    return others.take(count).map((c) => c.name).toList();
  }

  List<String> _getRandomWrongLanguageNames(String correctName, int count) {
    final others = _countryRepo.allLanguages
        .where((l) => l.name != correctName)
        .map((l) => l.name)
        .toSet()
        .toList()
      ..shuffle(_random);
    return others.take(count).toList();
  }
}
