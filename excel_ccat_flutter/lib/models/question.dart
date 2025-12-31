// Question models for Excel CCAT Flutter App
// Based on CCAT 7 test structure

/// Question types matching CCAT 7 test batteries
enum QuestionType {
  verbal('verbal', 'Verbal'),
  quantitative('quantitative', 'Quantitative'),
  nonVerbal('non_verbal', 'Non-Verbal');

  final String value;
  final String displayName;
  const QuestionType(this.value, this.displayName);
}

/// Verbal subtypes for CCAT
enum VerbalSubType {
  analogies('analogies', 'Verbal Analogies'),
  sentenceCompletion('sentence_completion', 'Sentence Completion'),
  classification('classification', 'Verbal Classification'),
  synonyms('synonyms', 'Synonyms'),
  antonyms('antonyms', 'Antonyms');

  final String value;
  final String displayName;
  const VerbalSubType(this.value, this.displayName);
}

/// Quantitative subtypes for CCAT
enum QuantitativeSubType {
  numberAnalogies('number_analogies', 'Number Analogies'),
  quantitativeRelations('quantitative_relations', 'Quantitative Relations'),
  numberSeries('number_series', 'Number Series'),
  equationBuilding('equation_building', 'Equation Building');

  final String value;
  final String displayName;
  const QuantitativeSubType(this.value, this.displayName);
}

/// Non-Verbal subtypes for CCAT
enum NonVerbalSubType {
  figureMatrices('figure_matrices', 'Figure Matrices'),
  figureClassification('figure_classification', 'Figure Classification'),
  figureSeries('figure_series', 'Figure Series'),
  figureAnalysis('figure_analysis', 'Figure Analysis/Paper Folding');

  final String value;
  final String displayName;
  const NonVerbalSubType(this.value, this.displayName);
}

/// CCAT Grade Levels as defined by official test
enum CCATLevel {
  levelK('level_k', 'Kindergarten', 'K'),
  level10('level_10', 'Level 10 (Grades 2-3)', '2-3'),
  level11('level_11', 'Level 11 (Grades 4-5)', '4-5'),
  level12('level_12', 'Level 12 (Grades 6+)', '6+');

  final String value;
  final String displayName;
  final String gradeRange;
  const CCATLevel(this.value, this.displayName, this.gradeRange);
}

/// Question difficulty levels
enum Difficulty {
  easy('easy', 'Easy'),
  medium('medium', 'Medium'),
  hard('hard', 'Hard');

  final String value;
  final String displayName;
  const Difficulty(this.value, this.displayName);
}

/// Supported languages
enum Language {
  english('en', 'English', '🇨🇦'),
  french('fr', 'Français', '🇨🇦');

  final String code;
  final String displayName;
  final String flag;
  const Language(this.code, this.displayName, this.flag);
}

/// Test types based on TDSB requirements
enum TestType {
  quickAssessment('quick_assessment', 'Quick Assessment', 20, 10),
  standardPractice('standard_practice', 'Standard Practice', 50, 30),
  fullMock('full_mock', 'Full Mock Test', 176, 90),
  customTest('custom_test', 'Custom Test', 30, 20);

  final String value;
  final String displayName;
  final int defaultQuestionCount;
  final int defaultTimeMinutes;
  const TestType(this.value, this.displayName, this.defaultQuestionCount, this.defaultTimeMinutes);
}

/// Main Question model
class Question {
  final String id;
  final QuestionType type;
  final String subType;
  final String stem;
  final String stemFrench;
  final List<String> options;
  final List<String> optionsFrench;
  final int correctAnswer;
  final String explanation;
  final String explanationFrench;
  final Difficulty difficulty;
  final CCATLevel level;
  final String? imageAsset; // For non-verbal questions with figures
  final Map<String, dynamic>? visualData; // For programmatic visual questions

  Question({
    required this.id,
    required this.type,
    required this.subType,
    required this.stem,
    required this.stemFrench,
    required this.options,
    required this.optionsFrench,
    required this.correctAnswer,
    required this.explanation,
    required this.explanationFrench,
    required this.difficulty,
    required this.level,
    this.imageAsset,
    this.visualData,
  });

  String getStem(Language language) =>
      language == Language.french ? stemFrench : stem;

  List<String> getOptions(Language language) =>
      language == Language.french ? optionsFrench : options;

  String getExplanation(Language language) =>
      language == Language.french ? explanationFrench : explanation;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.value,
        'subType': subType,
        'stem': stem,
        'stemFrench': stemFrench,
        'options': options,
        'optionsFrench': optionsFrench,
        'correctAnswer': correctAnswer,
        'explanation': explanation,
        'explanationFrench': explanationFrench,
        'difficulty': difficulty.value,
        'level': level.value,
        'imageAsset': imageAsset,
        'visualData': visualData,
      };

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? '',
      type: QuestionType.values.firstWhere(
        (t) => t.value == json['type'],
        orElse: () => QuestionType.verbal,
      ),
      subType: json['subType'] ?? '',
      stem: json['stem'] ?? '',
      stemFrench: json['stemFrench'] ?? json['stem'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      optionsFrench: List<String>.from(json['optionsFrench'] ?? json['options'] ?? []),
      correctAnswer: json['correctAnswer'] ?? 0,
      explanation: json['explanation'] ?? '',
      explanationFrench: json['explanationFrench'] ?? json['explanation'] ?? '',
      difficulty: Difficulty.values.firstWhere(
        (d) => d.value == json['difficulty'],
        orElse: () => Difficulty.medium,
      ),
      level: CCATLevel.values.firstWhere(
        (l) => l.value == json['level'],
        orElse: () => CCATLevel.level12,
      ),
      visualData: json['visualData'],
      imageAsset: json['imageAsset'],
    );
  }
}

/// Test configuration
class TestConfiguration {
  final TestType testType;
  final CCATLevel level;
  final int questionCount;
  final int timeInMinutes;
  final List<QuestionType>? selectedTypes;
  final List<String>? selectedSubTypes;
  final bool shuffleQuestions;

  TestConfiguration({
    required this.testType,
    required this.level,
    int? questionCount,
    int? timeInMinutes,
    this.selectedTypes,
    this.selectedSubTypes,
    this.shuffleQuestions = true,
  })  : questionCount = questionCount ?? testType.defaultQuestionCount,
        timeInMinutes = timeInMinutes ?? testType.defaultTimeMinutes;

  TestConfiguration copyWith({
    TestType? testType,
    CCATLevel? level,
    int? questionCount,
    int? timeInMinutes,
    List<QuestionType>? selectedTypes,
    List<String>? selectedSubTypes,
    bool? shuffleQuestions,
  }) {
    return TestConfiguration(
      testType: testType ?? this.testType,
      level: level ?? this.level,
      questionCount: questionCount ?? this.questionCount,
      timeInMinutes: timeInMinutes ?? this.timeInMinutes,
      selectedTypes: selectedTypes ?? this.selectedTypes,
      selectedSubTypes: selectedSubTypes ?? this.selectedSubTypes,
      shuffleQuestions: shuffleQuestions ?? this.shuffleQuestions,
    );
  }
}

/// User answer for a question
class UserAnswer {
  final String questionId;
  final int selectedOption;
  final bool isCorrect;
  final Duration timeTaken;

  UserAnswer({
    required this.questionId,
    required this.selectedOption,
    required this.isCorrect,
    required this.timeTaken,
  });

  Map<String, dynamic> toJson() => {
        'questionId': questionId,
        'selectedOption': selectedOption,
        'isCorrect': isCorrect,
        'timeTaken': timeTaken.inMilliseconds,
      };

  factory UserAnswer.fromJson(Map<String, dynamic> json) {
    return UserAnswer(
      questionId: json['questionId'] ?? '',
      selectedOption: json['selectedOption'] ?? -1,
      isCorrect: json['isCorrect'] ?? false,
      timeTaken: Duration(milliseconds: json['timeTaken'] ?? 0),
    );
  }
}

/// Test session result
class TestResult {
  final String id;
  final DateTime completedAt;
  final TestConfiguration configuration;
  final List<UserAnswer> answers;
  final int totalQuestions;
  final int correctAnswers;
  final Duration totalTime;
  final Map<QuestionType, int> scoreByType;
  final Map<String, int> scoreBySubType;

  TestResult({
    required this.id,
    required this.completedAt,
    required this.configuration,
    required this.answers,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.totalTime,
    required this.scoreByType,
    required this.scoreBySubType,
  });

  double get percentage =>
      totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0;

  int get percentile {
    // Approximate percentile based on score
    if (percentage >= 99) return 99;
    if (percentage >= 95) return 95;
    if (percentage >= 90) return 90;
    if (percentage >= 85) return 85;
    if (percentage >= 80) return 75;
    if (percentage >= 70) return 60;
    if (percentage >= 60) return 45;
    if (percentage >= 50) return 30;
    return 15;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'completedAt': completedAt.toIso8601String(),
        'totalQuestions': totalQuestions,
        'correctAnswers': correctAnswers,
        'totalTime': totalTime.inMilliseconds,
        'answers': answers.map((a) => a.toJson()).toList(),
        'scoreByType': scoreByType.map((k, v) => MapEntry(k.value, v)),
        'scoreBySubType': scoreBySubType,
      };
}

/// User progress tracking
class UserProgress {
  final int totalQuestionsAttempted;
  final int totalCorrect;
  final Map<CCATLevel, int> questionsPerLevel;
  final Map<QuestionType, int> correctPerType;
  final List<TestResult> recentTests;
  final DateTime lastPracticeDate;
  final int currentStreak;
  final int longestStreak;

  UserProgress({
    this.totalQuestionsAttempted = 0,
    this.totalCorrect = 0,
    this.questionsPerLevel = const {},
    this.correctPerType = const {},
    this.recentTests = const [],
    DateTime? lastPracticeDate,
    this.currentStreak = 0,
    this.longestStreak = 0,
  }) : lastPracticeDate = lastPracticeDate ?? DateTime.now();

  double get accuracy =>
      totalQuestionsAttempted > 0
          ? (totalCorrect / totalQuestionsAttempted) * 100
          : 0;

  Map<String, dynamic> toJson() => {
        'totalQuestionsAttempted': totalQuestionsAttempted,
        'totalCorrect': totalCorrect,
        'questionsPerLevel':
            questionsPerLevel.map((k, v) => MapEntry(k.value, v)),
        'correctPerType': correctPerType.map((k, v) => MapEntry(k.value, v)),
        'lastPracticeDate': lastPracticeDate.toIso8601String(),
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
      };
}
