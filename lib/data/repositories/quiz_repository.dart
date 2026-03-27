import 'dart:math';
import '../models/models.dart';
import '../repositories/country_repository.dart';
import '../../core/constants/app_strings.dart';

class QuizRepository {
  final CountryRepository _countryRepo;
  final Random _random = Random();

  QuizRepository(this._countryRepo);

  List<QuizQuestion> generateCountryCapitalQuiz({int count = AppConstants.quizQuestionsCount}) {
    final countries = List<Country>.from(_countryRepo.countries)..shuffle(_random);
    final questions = <QuizQuestion>[];

    for (int i = 0; i < count && i < countries.length; i++) {
      final country = countries[i];
      final wrongAnswers = _getRandomWrongCapitals(country, 3);
      final options = [...wrongAnswers, country.capital]..shuffle(_random);

      questions.add(QuizQuestion(
        id: 'cc_${country.id}',
        type: QuizType.countryCapital,
        question: 'Quelle est la capitale de ${country.name} ?',
        correctAnswer: country.capital,
        options: options,
        relatedCountryId: country.id,
      ));
    }
    return questions;
  }

  List<String> _getRandomWrongCapitals(Country correctCountry, int count) {
    final otherCountries = _countryRepo.countries
        .where((c) => c.id != correctCountry.id && c.capital.isNotEmpty)
        .toList()
      ..shuffle(_random);
    return otherCountries.take(count).map((c) => c.capital).toList();
  }

  List<QuizQuestion> generateCountryLanguageQuiz({int count = AppConstants.quizQuestionsCount}) {
    final countries = _countryRepo.countries
        .where((c) => _countryRepo.getLanguagesByCountry(c.id).isNotEmpty)
        .toList()
      ..shuffle(_random);
    final questions = <QuizQuestion>[];

    for (int i = 0; i < count && i < countries.length; i++) {
      final country = countries[i];
      final countryLangs = _countryRepo.getLanguagesByCountry(country.id);
      if (countryLangs.isEmpty) continue;

      final officialLangs = countryLangs.where((l) => l.isOfficial).toList();
      final displayLangs = officialLangs.isNotEmpty ? officialLangs : countryLangs;
      final correctAnswer = displayLangs.map((l) => l.name).join(', ');

      final allLangs = _countryRepo.allLanguages;
      final wrongOptions = <String>[];
      final usedLangIds = displayLangs.map((l) => l.id).toSet();

      for (int j = 0; j < 3 && wrongOptions.length < 3; j++) {
        final otherCountry = countries[_random.nextInt(countries.length)];
        if (otherCountry.id == country.id) continue;
        final otherLangs = _countryRepo.getLanguagesByCountry(otherCountry.id);
        if (otherLangs.isNotEmpty) {
          final wrongLang = otherLangs[_random.nextInt(otherLangs.length)];
          if (!usedLangIds.contains(wrongLang.id)) {
            wrongOptions.add(wrongLang.name);
          }
        }
      }

      while (wrongOptions.length < 3) {
        final randLang = allLangs[_random.nextInt(allLangs.length)];
        if (!usedLangIds.contains(randLang.id) && !wrongOptions.contains(randLang.name)) {
          wrongOptions.add(randLang.name);
        }
      }

      final options = [...wrongOptions, correctAnswer]..shuffle(_random);

      questions.add(QuizQuestion(
        id: 'cl_${country.id}',
        type: QuizType.countryLanguage,
        question: 'Quelle langue est parlée en ${country.name} ?',
        correctAnswer: correctAnswer,
        options: options,
        relatedCountryId: country.id,
      ));
    }
    return questions;
  }

  List<QuizQuestion> generateRegionLanguageQuiz({int count = AppConstants.quizQuestionsCount}) {
    final regionsWithLangs = _countryRepo.allRegions
        .where((r) => _countryRepo.getLanguagesByRegion(r.id).isNotEmpty)
        .toList()
      ..shuffle(_random);
    final questions = <QuizQuestion>[];

    for (int i = 0; i < count && i < regionsWithLangs.length; i++) {
      final region = regionsWithLangs[i];
      final regionLangs = _countryRepo.getLanguagesByRegion(region.id);
      if (regionLangs.isEmpty) continue;

      final correctAnswer = regionLangs.map((l) => l.name).join(', ');
      final country = _countryRepo.getCountryById(region.countryId);

      final wrongOptions = <String>[];
      final usedLangNames = regionLangs.map((l) => l.name).toSet();
      final allLangs = _countryRepo.allLanguages;

      for (int j = 0; j < 3; j++) {
        final randLang = allLangs[_random.nextInt(allLangs.length)];
        if (!usedLangNames.contains(randLang.name) && !wrongOptions.contains(randLang.name)) {
          wrongOptions.add(randLang.name);
        }
      }

      while (wrongOptions.length < 3) {
        final randLang = allLangs[_random.nextInt(allLangs.length)];
        if (!usedLangNames.contains(randLang.name) && !wrongOptions.contains(randLang.name)) {
          wrongOptions.add(randLang.name);
        }
      }

      final options = [...wrongOptions, correctAnswer]..shuffle(_random);
      final countryName = country?.name ?? '';

      questions.add(QuizQuestion(
        id: 'rl_${region.id}',
        type: QuizType.regionLanguage,
        question: 'Quelles langues sont parlées dans la région ${region.name} ($countryName) ?',
        correctAnswer: correctAnswer,
        options: options,
        relatedRegionId: region.id,
      ));
    }
    return questions;
  }

  List<QuizQuestion> generateMultipleChoiceQuiz({int count = AppConstants.quizQuestionsCount}) {
    final allQuestions = <QuizQuestion>[];
    allQuestions.addAll(generateCountryCapitalQuiz(count: count ~/ 3 + 1));
    allQuestions.addAll(generateCountryLanguageQuiz(count: count ~/ 3 + 1));
    allQuestions.addAll(generateRegionLanguageQuiz(count: count ~/ 3 + 1));
    allQuestions.shuffle(_random);
    return allQuestions.take(count).toList();
  }

  List<QuizQuestion> generateQuiz(QuizType type, {int count = AppConstants.quizQuestionsCount}) {
    switch (type) {
      case QuizType.countryCapital:
        return generateCountryCapitalQuiz(count: count);
      case QuizType.countryLanguage:
        return generateCountryLanguageQuiz(count: count);
      case QuizType.regionLanguage:
        return generateRegionLanguageQuiz(count: count);
      case QuizType.multipleChoice:
        return generateMultipleChoiceQuiz(count: count);
    }
  }
}
