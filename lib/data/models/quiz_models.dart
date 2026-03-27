import 'package:equatable/equatable.dart';

enum QuizType {
  countryCapital,
  countryLanguage,
  regionLanguage,
  multipleChoice,
}

class QuizQuestion extends Equatable {
  final String id;
  final QuizType type;
  final String question;
  final String correctAnswer;
  final List<String> options;
  final String? relatedCountryId;
  final String? relatedRegionId;

  const QuizQuestion({
    required this.id,
    required this.type,
    required this.question,
    required this.correctAnswer,
    required this.options,
    this.relatedCountryId,
    this.relatedRegionId,
  });

  @override
  List<Object?> get props => [id, type, question, correctAnswer, options];
}

class QuizResult extends Equatable {
  final String id;
  final QuizType type;
  final int totalQuestions;
  final int correctAnswers;
  final DateTime completedAt;
  final int score;

  const QuizResult({
    required this.id,
    required this.type,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.completedAt,
    required this.score,
  });

  double get percentage => totalQuestions > 0
      ? (correctAnswers / totalQuestions * 100)
      : 0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.index,
      'total_questions': totalQuestions,
      'correct_answers': correctAnswers,
      'completed_at': completedAt.toIso8601String(),
      'score': score,
    };
  }

  factory QuizResult.fromMap(Map<String, dynamic> map) {
    return QuizResult(
      id: map['id'] as String,
      type: QuizType.values[map['type'] as int],
      totalQuestions: map['total_questions'] as int,
      correctAnswers: map['correct_answers'] as int,
      completedAt: DateTime.parse(map['completed_at'] as String),
      score: map['score'] as int,
    );
  }

  @override
  List<Object?> get props => [id, type, totalQuestions, correctAnswers, score];
}

class QuizState extends Equatable {
  final List<QuizQuestion> questions;
  final int currentIndex;
  final int correctAnswers;
  final List<String?> userAnswers;
  final bool isCompleted;
  final QuizType quizType;

  const QuizState({
    this.questions = const [],
    this.currentIndex = 0,
    this.correctAnswers = 0,
    this.userAnswers = const [],
    this.isCompleted = false,
    required this.quizType,
  });

  QuizState copyWith({
    List<QuizQuestion>? questions,
    int? currentIndex,
    int? correctAnswers,
    List<String?>? userAnswers,
    bool? isCompleted,
    QuizType? quizType,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      userAnswers: userAnswers ?? this.userAnswers,
      isCompleted: isCompleted ?? this.isCompleted,
      quizType: quizType ?? this.quizType,
    );
  }

  QuizQuestion? get currentQuestion =>
      currentIndex < questions.length ? questions[currentIndex] : null;

  double get progress => questions.isNotEmpty
      ? (currentIndex + 1) / questions.length
      : 0;

  @override
  List<Object?> get props =>
      [questions, currentIndex, correctAnswers, userAnswers, isCompleted, quizType];
}
