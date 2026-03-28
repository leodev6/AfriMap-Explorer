import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum QuizType {
  countryCapital,       // Quelle est la capitale de X ?
  capitalCountry,       // Quel pays a pour capitale X ?
  countryLanguage,      // Quelle langue est parlée en X ?
  languageCountry,      // Quel pays parle la langue X ?
  regionLanguage,       // Quelles langues dans la région X ?
  flagCountry,          // Quel pays a ce drapeau ?
  islandCountry,        // Quelles îles appartiennent au pays X ?
  multipleChoice,       // Mélange de tous
}

enum QuizDifficulty {
  easy,    // 4 options, 30s, 10 questions
  medium,  // 4 options, 20s, 15 questions
  hard,    // 4 options, 10s, 20 questions
}

extension QuizDifficultyExt on QuizDifficulty {
  String get label {
    switch (this) {
      case QuizDifficulty.easy: return 'Facile';
      case QuizDifficulty.medium: return 'Moyen';
      case QuizDifficulty.hard: return 'Difficile';
    }
  }

  int get timeLimit {
    switch (this) {
      case QuizDifficulty.easy: return 30;
      case QuizDifficulty.medium: return 20;
      case QuizDifficulty.hard: return 10;
    }
  }

  int get questionCount {
    switch (this) {
      case QuizDifficulty.easy: return 10;
      case QuizDifficulty.medium: return 15;
      case QuizDifficulty.hard: return 20;
    }
  }

  int get pointsPerQuestion {
    switch (this) {
      case QuizDifficulty.easy: return 10;
      case QuizDifficulty.medium: return 20;
      case QuizDifficulty.hard: return 30;
    }
  }
}

extension QuizTypeExt on QuizType {
  String get label {
    switch (this) {
      case QuizType.countryCapital: return 'Pays → Capitale';
      case QuizType.capitalCountry: return 'Capitale → Pays';
      case QuizType.countryLanguage: return 'Pays → Langues';
      case QuizType.languageCountry: return 'Langues → Pays';
      case QuizType.regionLanguage: return 'Région → Langues';
      case QuizType.flagCountry: return 'Drapeau → Pays';
      case QuizType.islandCountry: return 'Pays → Îles';
      case QuizType.multipleChoice: return 'Mélange';
    }
  }

  String get description {
    switch (this) {
      case QuizType.countryCapital: return 'Associe chaque pays à sa capitale';
      case QuizType.capitalCountry: return 'Retrouve le pays grâce à sa capitale';
      case QuizType.countryLanguage: return 'Découvre les langues de chaque pays';
      case QuizType.languageCountry: return 'Devine le pays à partir de ses langues';
      case QuizType.regionLanguage: return 'Teste tes connaissances des régions';
      case QuizType.flagCountry: return 'Reconnais les drapeaux africains';
      case QuizType.islandCountry: return 'Associe les îles à leur pays';
      case QuizType.multipleChoice: return 'Un mélange de tous les types';
    }
  }

  IconData get icon {
    switch (this) {
      case QuizType.countryCapital: return Icons.location_city;
      case QuizType.capitalCountry: return Icons.public;
      case QuizType.countryLanguage: return Icons.record_voice_over;
      case QuizType.languageCountry: return Icons.translate;
      case QuizType.regionLanguage: return Icons.map;
      case QuizType.flagCountry: return Icons.flag;
      case QuizType.islandCountry: return Icons.beach_access;
      case QuizType.multipleChoice: return Icons.shuffle;
    }
  }
}

class QuizQuestion extends Equatable {
  final String id;
  final QuizType type;
  final String question;
  final String correctAnswer;
  final List<String> options;
  final String? relatedCountryId;
  final String? relatedRegionId;
  final String? flagUrl;
  final String? explanation;

  const QuizQuestion({
    required this.id,
    required this.type,
    required this.question,
    required this.correctAnswer,
    required this.options,
    this.relatedCountryId,
    this.relatedRegionId,
    this.flagUrl,
    this.explanation,
  });

  @override
  List<Object?> get props => [id, type, question, correctAnswer, options];
}

class QuizResult extends Equatable {
  final String id;
  final QuizType type;
  final QuizDifficulty difficulty;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int timeouts;
  final DateTime completedAt;
  final int score;
  final int maxScore;
  final String? deviceId;
  final List<QuizAnswerDetail> answerDetails;

  const QuizResult({
    required this.id,
    required this.type,
    required this.difficulty,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.timeouts,
    required this.completedAt,
    required this.score,
    required this.maxScore,
    this.deviceId,
    this.answerDetails = const [],
  });

  double get percentage => totalQuestions > 0
      ? (correctAnswers / totalQuestions * 100)
      : 0;

  String get grade {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B';
    if (percentage >= 60) return 'C';
    if (percentage >= 50) return 'D';
    return 'E';
  }

  String get message {
    if (percentage >= 90) return 'Excellent ! Tu es un expert de l\'Afrique !';
    if (percentage >= 70) return 'Très bien ! Continue comme ça !';
    if (percentage >= 50) return 'Pas mal ! Encore un effort !';
    return 'Courage ! Recommence pour t\'améliorer !';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.index,
      'difficulty': difficulty.index,
      'total_questions': totalQuestions,
      'correct_answers': correctAnswers,
      'wrong_answers': wrongAnswers,
      'timeouts': timeouts,
      'completed_at': completedAt.toIso8601String(),
      'score': score,
      'max_score': maxScore,
      if (deviceId != null) 'device_id': deviceId,
    };
  }

  factory QuizResult.fromMap(Map<String, dynamic> map) {
    return QuizResult(
      id: map['id'] as String,
      type: QuizType.values[map['type'] as int],
      difficulty: QuizDifficulty.values[map['difficulty'] as int? ?? 0],
      totalQuestions: map['total_questions'] as int,
      correctAnswers: map['correct_answers'] as int,
      wrongAnswers: map['wrong_answers'] as int? ?? 0,
      timeouts: map['timeouts'] as int? ?? 0,
      completedAt: DateTime.parse(map['completed_at'] as String),
      score: map['score'] as int,
      maxScore: map['max_score'] as int? ?? 0,
      deviceId: map['device_id'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, type, totalQuestions, correctAnswers, score];
}

class QuizAnswerDetail extends Equatable {
  final String questionId;
  final String question;
  final String correctAnswer;
  final String? userAnswer;
  final bool isCorrect;
  final bool isTimeout;
  final int timeSpent;

  const QuizAnswerDetail({
    required this.questionId,
    required this.question,
    required this.correctAnswer,
    this.userAnswer,
    required this.isCorrect,
    this.isTimeout = false,
    this.timeSpent = 0,
  });

  @override
  List<Object?> get props => [questionId, isCorrect, userAnswer];
}

class QuizState extends Equatable {
  final List<QuizQuestion> questions;
  final int currentIndex;
  final int correctAnswers;
  final int wrongAnswers;
  final int timeouts;
  final List<String?> userAnswers;
  final List<QuizAnswerDetail> answerDetails;
  final bool isCompleted;
  final QuizType quizType;
  final QuizDifficulty difficulty;
  final int timeRemaining;
  final bool isTimerActive;

  const QuizState({
    this.questions = const [],
    this.currentIndex = 0,
    this.correctAnswers = 0,
    this.wrongAnswers = 0,
    this.timeouts = 0,
    this.userAnswers = const [],
    this.answerDetails = const [],
    this.isCompleted = false,
    required this.quizType,
    this.difficulty = QuizDifficulty.easy,
    this.timeRemaining = 30,
    this.isTimerActive = false,
  });

  QuizState copyWith({
    List<QuizQuestion>? questions,
    int? currentIndex,
    int? correctAnswers,
    int? wrongAnswers,
    int? timeouts,
    List<String?>? userAnswers,
    List<QuizAnswerDetail>? answerDetails,
    bool? isCompleted,
    QuizType? quizType,
    QuizDifficulty? difficulty,
    int? timeRemaining,
    bool? isTimerActive,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      timeouts: timeouts ?? this.timeouts,
      userAnswers: userAnswers ?? this.userAnswers,
      answerDetails: answerDetails ?? this.answerDetails,
      isCompleted: isCompleted ?? this.isCompleted,
      quizType: quizType ?? this.quizType,
      difficulty: difficulty ?? this.difficulty,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      isTimerActive: isTimerActive ?? this.isTimerActive,
    );
  }

  QuizQuestion? get currentQuestion =>
      currentIndex < questions.length ? questions[currentIndex] : null;

  double get progress => questions.isNotEmpty
      ? (currentIndex + 1) / questions.length
      : 0;

  int get answeredCount => correctAnswers + wrongAnswers + timeouts;

  @override
  List<Object?> get props => [
    questions, currentIndex, correctAnswers, wrongAnswers,
    timeouts, userAnswers, isCompleted, quizType, difficulty,
    timeRemaining, isTimerActive,
  ];
}

// ============ BADGES ============

class Badge {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Badge unlock(DateTime date) => Badge(
    id: id, name: name, description: description, icon: icon,
    isUnlocked: true, unlockedAt: date,
  );

  Map<String, dynamic> toMap() => {
    'id': id, 'name': name, 'description': description,
    'is_unlocked': isUnlocked,
    if (unlockedAt != null) 'unlocked_at': unlockedAt!.toIso8601String(),
  };
}

class BadgeDefinitions {
  static const List<Badge> all = [
    Badge(id: 'first_quiz', name: 'Premier Quiz', description: 'Complète ton premier quiz', icon: Icons.gps_fixed),
    Badge(id: 'perfect_score', name: 'Score Parfait', description: 'Obtens 100% à un quiz', icon: Icons.looks_one),
    Badge(id: 'five_quizzes', name: 'Joueur Assidu', description: 'Complète 5 quiz', icon: Icons.star),
    Badge(id: 'ten_quizzes', name: 'Expert Quiz', description: 'Complète 10 quiz', icon: Icons.emoji_events),
    Badge(id: 'explorer_10', name: 'Explorateur', description: 'Explore 10 pays', icon: Icons.explore),
    Badge(id: 'explorer_all', name: 'Globe-trotter', description: 'Explore tous les pays', icon: Icons.public),
    Badge(id: 'all_types', name: 'Touche-à-tout', description: 'Joue tous les types de quiz', icon: Icons.palette),
    Badge(id: 'streak_5', name: 'En Forme', description: '5 bonnes réponses d\'affilée', icon: Icons.local_fire_department),
    Badge(id: 'hard_quiz', name: 'Sans Peur', description: 'Complète un quiz difficile', icon: Icons.fitness_center),
    Badge(id: 'speed_demon', name: 'Éclair', description: 'Réponds en moins de 3 secondes', icon: Icons.bolt),
  ];
}
