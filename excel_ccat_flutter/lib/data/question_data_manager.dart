import 'dart:math';
import '../models/question.dart';

/// Manages question data generation and retrieval
class QuestionDataManager {
  static final QuestionDataManager _instance = QuestionDataManager._internal();
  factory QuestionDataManager() => _instance;
  QuestionDataManager._internal();

  List<Question> _allQuestions = [];

  /// Initialize and load questions
  Future<void> initialize() async {
    _allQuestions = [];
    for (var level in CCATLevel.values) {
      _allQuestions.addAll(_generateQuestionsForLevel(level));
    }
  }

  /// Get questions based on configuration
  List<Question> getConfiguredQuestions(
    TestConfiguration config,
    Language language,
  ) {
    var questions = _allQuestions.where((q) => q.level == config.level).toList();

    if (config.selectedTypes != null && config.selectedTypes!.isNotEmpty) {
      questions = questions
          .where((q) => config.selectedTypes!.contains(q.type))
          .toList();
    }

    if (config.selectedSubTypes != null && config.selectedSubTypes!.isNotEmpty) {
      questions = questions
          .where((q) => config.selectedSubTypes!.contains(q.subType))
          .toList();
    }

    // Fallback if not enough questions
    if (questions.isEmpty) {
      questions = _generateQuestions(
        count: config.questionCount,
        level: config.level,
      );
    }

    if (config.shuffleQuestions) {
      questions.shuffle();
    }

    // Ensure we have enough questions by duplicating if necessary
    while (questions.count < config.questionCount) {
      questions.addAll(List.from(questions));
    }

    return questions.take(config.questionCount).toList();
  }

  /// Generate questions for a specific level
  List<Question> _generateQuestionsForLevel(CCATLevel level) {
    List<Question> questions = [];
    
    // Verbal
    questions.addAll(_createVerbalAnalogies(level));
    questions.addAll(_createSentenceCompletion(level));
    questions.addAll(_createVerbalClassification(level));
    
    // Quantitative
    questions.addAll(_createNumberAnalogies(level));
    questions.addAll(_createQuantitativeRelations(level));
    questions.addAll(_createNumberSeries(level));
    
    // Non-Verbal
    questions.addAll(_createFigureMatrices(level));
    questions.addAll(_createFigureClassification(level));
    questions.addAll(_createFigureSeries(level));
    
    return questions;
  }

  List<Question> _generateQuestions({
    required int count,
    required CCATLevel level,
    QuestionType? type,
  }) {
    return List.generate(count, (index) {
      final qType = type ?? QuestionType.values[index % 3];
      return _createGenericQuestion(qType, index, level);
    });
  }

  Question _createGenericQuestion(
    QuestionType type,
    int index,
    CCATLevel level,
  ) {
    return Question(
      id: '${level.value}_${type.value}_$index',
      type: type,
      subType: 'generic',
      stem: 'Question $index: Select the best answer.',
      stemFrench: 'Question $index: Sélectionnez la meilleure réponse.',
      options: ['Option A', 'Option B', 'Option C', 'Option D'],
      optionsFrench: ['Option A', 'Option B', 'Option C', 'Option D'],
      correctAnswer: index % 4,
      explanation: 'The correct answer is Option ${['A', 'B', 'C', 'D'][index % 4]}.',
      explanationFrench: 'La bonne réponse est Option ${['A', 'B', 'C', 'D'][index % 4]}.',
      difficulty: Difficulty.medium,
      level: level,
    );
  }

  // MARK: - Verbal Questions Generation

  List<Question> _createVerbalAnalogies(CCATLevel level) {
    final difficulty = _getDifficultyForLevel(level);
    List<Question> questions = [];
    
    final analogies = level == CCATLevel.level10 ? [
      ('Dog is to puppy as cat is to:', ['kitten', 'mouse', 'bird', 'fish'], 0),
      ('Big is to small as tall is to:', ['short', 'wide', 'long', 'thin'], 0),
      ('Sun is to day as moon is to:', ['night', 'star', 'sky', 'cloud'], 0),
      ('Hand is to glove as foot is to:', ['sock', 'shoe', 'leg', 'toe'], 1),
      ('Bird is to fly as fish is to:', ['swim', 'walk', 'run', 'jump'], 0),
    ] : level == CCATLevel.level11 ? [
      ('Author is to book as composer is to:', ['song', 'instrument', 'concert', 'band'], 0),
      ('Library is to books as museum is to:', ['artifacts', 'tickets', 'guides', 'visitors'], 0),
      ('Chef is to kitchen as pilot is to:', ['cockpit', 'plane', 'airport', 'sky'], 0),
      ('Brush is to paint as pen is to:', ['ink', 'paper', 'write', 'letter'], 0),
      ('Doctor is to patient as teacher is to:', ['student', 'school', 'book', 'class'], 0),
    ] : [
      ('Ephemeral is to permanent as volatile is to:', ['stable', 'explosive', 'liquid', 'gas'], 0),
      ('Meticulous is to careless as frugal is to:', ['wasteful', 'careful', 'poor', 'rich'], 0),
      ('Archipelago is to islands as constellation is to:', ['stars', 'planets', 'galaxies', 'moons'], 0),
      ('Taciturn is to talkative as somber is to:', ['cheerful', 'dark', 'serious', 'quiet'], 0),
      ('Chronometer is to time as barometer is to:', ['pressure', 'temperature', 'distance', 'speed'], 0),
    ];

    for (var i = 0; i < analogies.length; i++) {
      final (stem, options, correct) = analogies[i];
      questions.add(Question(
        id: '${level.value}_verbal_analogies_$i',
        type: QuestionType.verbal,
        subType: VerbalSubType.analogies.value,
        stem: stem,
        stemFrench: '$stem (FR)',
        options: options,
        optionsFrench: options,
        correctAnswer: correct,
        explanation: 'The correct answer is ${options[correct]}.',
        explanationFrench: 'La bonne réponse est ${options[correct]}.',
        difficulty: difficulty,
        level: level,
      ));
    }
    return questions;
  }

  List<Question> _createSentenceCompletion(CCATLevel level) {
    final difficulty = _getDifficultyForLevel(level);
    List<Question> questions = [];
    
    final sentences = level == CCATLevel.level10 ? [
      ('The cat was very _____ and purred loudly.', ['happy', 'angry', 'scared', 'tired'], 0),
      ('After running, I felt very _____.', ['tired', 'excited', 'hungry', 'cold'], 0),
      ('The sun was bright, so I wore my _____.', ['sunglasses', 'boots', 'jacket', 'hat'], 0),
    ] : level == CCATLevel.level11 ? [
      ('The scientist\'s hypothesis was _____ by the results.', ['validated', 'ignored', 'created', 'changed'], 0),
      ('Despite her shy appearance, she was actually quite _____.', ['outgoing', 'quiet', 'nervous', 'boring'], 0),
      ('The ancient ruins were _____ preserved.', ['remarkably', 'poorly', 'quickly', 'loudly'], 0),
    ] : [
      ('The politician\'s _____ speech failed to convince the audience.', ['bombastic', 'sincere', 'brief', 'eloquent'], 0),
      ('Her _____ nature made her popular among colleagues.', ['affable', 'hostile', 'indifferent', 'withdrawn'], 0),
      ('The judge\'s _____ ruling satisfied neither party.', ['ambiguous', 'clear', 'fair', 'harsh'], 0),
    ];

    for (var i = 0; i < sentences.length; i++) {
      final (stem, options, correct) = sentences[i];
      questions.add(Question(
        id: '${level.value}_verbal_sentence_$i',
        type: QuestionType.verbal,
        subType: VerbalSubType.sentenceCompletion.value,
        stem: stem,
        stemFrench: '$stem (FR)',
        options: options,
        optionsFrench: options,
        correctAnswer: correct,
        explanation: 'The correct answer is ${options[correct]}.',
        explanationFrench: 'La bonne réponse est ${options[correct]}.',
        difficulty: difficulty,
        level: level,
      ));
    }
    return questions;
  }

  List<Question> _createVerbalClassification(CCATLevel level) {
    final difficulty = _getDifficultyForLevel(level);
    List<Question> questions = [];
    
    final items = level == CCATLevel.level10 ? [
      ('Which doesn\'t belong? Apple, Banana, Carrot, Orange', ['Carrot', 'Apple', 'Banana', 'Orange'], 0),
      ('Which doesn\'t belong? Dog, Cat, Bird, Table', ['Table', 'Dog', 'Cat', 'Bird'], 0),
      ('Which doesn\'t belong? Red, Blue, Green, Happy', ['Happy', 'Red', 'Blue', 'Green'], 0),
    ] : level == CCATLevel.level11 ? [
      ('Which doesn\'t belong? Mercury, Venus, Sun, Mars', ['Sun', 'Mercury', 'Venus', 'Mars'], 0),
      ('Which doesn\'t belong? Piano, Violin, Drum, Painting', ['Painting', 'Piano', 'Violin', 'Drum'], 0),
      ('Which doesn\'t belong? Triangle, Square, Circle, Cube', ['Cube', 'Triangle', 'Square', 'Circle'], 0),
    ] : [
      ('Which doesn\'t belong? Monarchy, Democracy, Republic, Capitalism', ['Capitalism', 'Monarchy', 'Democracy', 'Republic'], 0),
      ('Which doesn\'t belong? Metaphor, Simile, Hyperbole, Paragraph', ['Paragraph', 'Metaphor', 'Simile', 'Hyperbole'], 0),
      ('Which doesn\'t belong? Photosynthesis, Respiration, Digestion, Gravity', ['Gravity', 'Photosynthesis', 'Respiration', 'Digestion'], 0),
    ];

    for (var i = 0; i < items.length; i++) {
      final (stem, options, correct) = items[i];
      questions.add(Question(
        id: '${level.value}_verbal_classification_$i',
        type: QuestionType.verbal,
        subType: VerbalSubType.classification.value,
        stem: stem,
        stemFrench: '$stem (FR)',
        options: options,
        optionsFrench: options,
        correctAnswer: correct,
        explanation: 'The correct answer is ${options[correct]}.',
        explanationFrench: 'La bonne réponse est ${options[correct]}.',
        difficulty: difficulty,
        level: level,
      ));
    }
    return questions;
  }

  // MARK: - Quantitative Questions Generation

  List<Question> _createNumberAnalogies(CCATLevel level) {
    final difficulty = _getDifficultyForLevel(level);
    List<Question> questions = [];
    
    final analogies = level == CCATLevel.level10 ? [
      ('2 : 4 :: 3 : ?', ['5', '6', '7', '8'], 1),
      ('1 : 2 :: 5 : ?', ['8', '9', '10', '11'], 2),
      ('3 : 9 :: 4 : ?', ['12', '14', '16', '18'], 2),
    ] : level == CCATLevel.level11 ? [
      ('5 : 25 :: 6 : ?', ['30', '36', '42', '48'], 1),
      ('8 : 64 :: 9 : ?', ['72', '81', '90', '99'], 1),
      ('2 : 8 :: 3 : ?', ['18', '24', '27', '30'], 2),
    ] : [
      ('3 : 27 :: 4 : ?', ['64', '48', '36', '16'], 0),
      ('2 : 16 :: 3 : ?', ['81', '72', '64', '54'], 0),
      ('5 : 125 :: 4 : ?', ['64', '80', '100', '120'], 0),
    ];

    for (var i = 0; i < analogies.length; i++) {
      final (stem, options, correct) = analogies[i];
      questions.add(Question(
        id: '${level.value}_quant_analogies_$i',
        type: QuestionType.quantitative,
        subType: QuantitativeSubType.numberAnalogies.value,
        stem: stem,
        stemFrench: stem,
        options: options,
        optionsFrench: options,
        correctAnswer: correct,
        explanation: 'The correct answer is ${options[correct]}.',
        explanationFrench: 'La bonne réponse est ${options[correct]}.',
        difficulty: difficulty,
        level: level,
      ));
    }
    return questions;
  }

  List<Question> _createQuantitativeRelations(CCATLevel level) {
    final difficulty = _getDifficultyForLevel(level);
    List<Question> questions = [];
    
    final relations = level == CCATLevel.level10 ? [
      ('Which is greater?', ['5 + 3', '4 + 2', 'Equal', 'Cannot tell'], 0),
      ('Which is less?', ['10 - 2', '5 + 4', 'Equal', 'Cannot tell'], 0),
      ('Which is greater?', ['2 x 3', '3 + 3', 'Equal', 'Cannot tell'], 2),
    ] : level == CCATLevel.level11 ? [
      ('Which is greater?', ['1/2 of 10', '1/3 of 12', 'Equal', 'Cannot tell'], 0),
      ('Which is less?', ['0.5', '0.05', 'Equal', 'Cannot tell'], 1),
      ('Which is greater?', ['3 squared', '2 cubed', 'Equal', 'Cannot tell'], 0),
    ] : [
      ('Which is greater?', ['sqrt(144)', '12', 'Equal', 'Cannot tell'], 2),
      ('Which is less?', ['-5', '-10', 'Equal', 'Cannot tell'], 1),
      ('Which is greater?', ['2^4', '4^2', 'Equal', 'Cannot tell'], 2),
    ];

    for (var i = 0; i < relations.length; i++) {
      final (stem, options, correct) = relations[i];
      questions.add(Question(
        id: '${level.value}_quant_relations_$i',
        type: QuestionType.quantitative,
        subType: QuantitativeSubType.quantitativeRelations.value,
        stem: stem,
        stemFrench: stem == 'Which is greater?' ? 'Lequel est plus grand?' : 'Lequel est plus petit?',
        options: options,
        optionsFrench: options,
        correctAnswer: correct,
        explanation: 'The correct answer is ${options[correct]}.',
        explanationFrench: 'La bonne réponse est ${options[correct]}.',
        difficulty: difficulty,
        level: level,
      ));
    }
    return questions;
  }

  List<Question> _createNumberSeries(CCATLevel level) {
    final difficulty = _getDifficultyForLevel(level);
    List<Question> questions = [];
    
    final series = level == CCATLevel.level10 ? [
      ('2, 4, 6, 8, ?', ['9', '10', '11', '12'], 1),
      ('10, 9, 8, 7, ?', ['6', '5', '4', '3'], 0),
      ('5, 10, 15, 20, ?', ['22', '24', '25', '30'], 2),
    ] : level == CCATLevel.level11 ? [
      ('1, 4, 9, 16, ?', ['20', '24', '25', '30'], 2),
      ('2, 6, 12, 20, ?', ['28', '30', '32', '36'], 1),
      ('1, 1, 2, 3, 5, ?', ['7', '8', '9', '10'], 1),
    ] : [
      ('2, 3, 5, 7, 11, ?', ['12', '13', '14', '15'], 1),
      ('1, 8, 27, 64, ?', ['100', '125', '150', '200'], 1),
      ('3, 6, 12, 24, ?', ['36', '40', '48', '50'], 2),
    ];

    for (var i = 0; i < series.length; i++) {
      final (stem, options, correct) = series[i];
      questions.add(Question(
        id: '${level.value}_quant_series_$i',
        type: QuestionType.quantitative,
        subType: QuantitativeSubType.numberSeries.value,
        stem: stem,
        stemFrench: stem,
        options: options,
        optionsFrench: options,
        correctAnswer: correct,
        explanation: 'The correct answer is ${options[correct]}.',
        explanationFrench: 'La bonne réponse est ${options[correct]}.',
        difficulty: difficulty,
        level: level,
      ));
    }
    return questions;
  }

  // MARK: - Non-Verbal Questions Generation (Placeholders)

  List<Question> _createFigureMatrices(CCATLevel level) {
    return List.generate(5, (i) => _createGenericQuestion(QuestionType.nonVerbal, i, level));
  }

  List<Question> _createFigureClassification(CCATLevel level) {
    return List.generate(5, (i) => _createGenericQuestion(QuestionType.nonVerbal, i + 5, level));
  }

  List<Question> _createFigureSeries(CCATLevel level) {
    return List.generate(5, (i) => _createGenericQuestion(QuestionType.nonVerbal, i + 10, level));
  }

  Difficulty _getDifficultyForLevel(CCATLevel level) {
    switch (level) {
      case CCATLevel.levelK:
      case CCATLevel.level10:
        return Difficulty.easy;
      case CCATLevel.level11:
        return Difficulty.medium;
      case CCATLevel.level12:
        return Difficulty.hard;
    }
  }
}

extension ListExtension<T> on List<T> {
  int get count => length;
}
