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
    questions.addAll(_createSynonyms(level));
    questions.addAll(_createAntonyms(level));
    
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
      ('Apple is to fruit as carrot is to:', ['vegetable', 'orange', 'food', 'plant'], 0),
      ('Ear is to hear as eye is to:', ['see', 'blink', 'cry', 'close'], 0),
      ('Pen is to write as brush is to:', ['paint', 'clean', 'sweep', 'draw'], 0),
    ] : level == CCATLevel.level11 ? [
      ('Author is to book as composer is to:', ['song', 'instrument', 'concert', 'band'], 0),
      ('Library is to books as museum is to:', ['artifacts', 'tickets', 'guides', 'visitors'], 0),
      ('Chef is to kitchen as pilot is to:', ['cockpit', 'plane', 'airport', 'sky'], 0),
      ('Brush is to paint as pen is to:', ['ink', 'paper', 'write', 'letter'], 0),
      ('Doctor is to patient as teacher is to:', ['student', 'school', 'book', 'class'], 0),
      ('Thermometer is to temperature as scale is to:', ['weight', 'height', 'length', 'time'], 0),
      ('Seed is to plant as egg is to:', ['bird', 'chicken', 'nest', 'shell'], 0),
      ('Clock is to time as compass is to:', ['direction', 'north', 'map', 'travel'], 0),
    ] : [
      ('Ephemeral is to permanent as volatile is to:', ['stable', 'explosive', 'liquid', 'gas'], 0),
      ('Meticulous is to careless as frugal is to:', ['wasteful', 'careful', 'poor', 'rich'], 0),
      ('Archipelago is to islands as constellation is to:', ['stars', 'planets', 'galaxies', 'moons'], 0),
      ('Taciturn is to talkative as somber is to:', ['cheerful', 'dark', 'serious', 'quiet'], 0),
      ('Chronometer is to time as barometer is to:', ['pressure', 'temperature', 'distance', 'speed'], 0),
      ('Plaintiff is to defendant as prosecutor is to:', ['accused', 'judge', 'lawyer', 'jury'], 0),
      ('Prologue is to epilogue as dawn is to:', ['dusk', 'morning', 'night', 'noon'], 0),
      ('Catalyst is to reaction as stimulus is to:', ['response', 'chemical', 'change', 'speed'], 0),
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

  List<Question> _createSynonyms(CCATLevel level) {
    final difficulty = _getDifficultyForLevel(level);
    List<Question> questions = [];
    
    final synonyms = level == CCATLevel.level10 ? [
      ('Which word means the same as HAPPY?', ['joyful', 'angry', 'tired', 'scared'], 0),
      ('Which word means the same as BIG?', ['large', 'small', 'tiny', 'thin'], 0),
      ('Which word means the same as FAST?', ['quick', 'slow', 'lazy', 'late'], 0),
      ('Which word means the same as COLD?', ['chilly', 'hot', 'warm', 'bright'], 0),
      ('Which word means the same as NICE?', ['kind', 'mean', 'ugly', 'loud'], 0),
      ('Which word means the same as SMART?', ['clever', 'dumb', 'slow', 'weak'], 0),
      ('Which word means the same as QUIET?', ['silent', 'loud', 'noisy', 'busy'], 0),
      ('Which word means the same as LITTLE?', ['small', 'huge', 'giant', 'tall'], 0),
    ] : level == CCATLevel.level11 ? [
      ('Which word means the same as ABUNDANT?', ['plentiful', 'scarce', 'empty', 'rare'], 0),
      ('Which word means the same as BRAVE?', ['courageous', 'fearful', 'timid', 'weak'], 0),
      ('Which word means the same as ASSIST?', ['help', 'hinder', 'stop', 'leave'], 0),
      ('Which word means the same as ANCIENT?', ['old', 'new', 'modern', 'recent'], 0),
      ('Which word means the same as CONCEAL?', ['hide', 'reveal', 'show', 'expose'], 0),
      ('Which word means the same as DEPART?', ['leave', 'arrive', 'stay', 'remain'], 0),
      ('Which word means the same as EXHAUSTED?', ['tired', 'energetic', 'lively', 'rested'], 0),
      ('Which word means the same as FORTUNATE?', ['lucky', 'unlucky', 'poor', 'sad'], 0),
    ] : [
      ('Which word means the same as UBIQUITOUS?', ['omnipresent', 'rare', 'scarce', 'limited'], 0),
      ('Which word means the same as EPHEMERAL?', ['transient', 'permanent', 'lasting', 'enduring'], 0),
      ('Which word means the same as BENEVOLENT?', ['kind', 'malicious', 'cruel', 'harsh'], 0),
      ('Which word means the same as CACOPHONY?', ['discord', 'harmony', 'melody', 'rhythm'], 0),
      ('Which word means the same as ARDUOUS?', ['difficult', 'easy', 'simple', 'effortless'], 0),
      ('Which word means the same as AMELIORATE?', ['improve', 'worsen', 'destroy', 'neglect'], 0),
      ('Which word means the same as COGENT?', ['convincing', 'weak', 'unclear', 'confusing'], 0),
      ('Which word means the same as DILATORY?', ['slow', 'prompt', 'quick', 'hasty'], 0),
    ];

    for (var i = 0; i < synonyms.length; i++) {
      final (stem, options, correct) = synonyms[i];
      questions.add(Question(
        id: '${level.value}_verbal_synonyms_$i',
        type: QuestionType.verbal,
        subType: VerbalSubType.synonyms.value,
        stem: stem,
        stemFrench: '$stem (FR)',
        options: options,
        optionsFrench: options,
        correctAnswer: correct,
        explanation: 'The correct answer is ${options[correct]}, which means the same as the given word.',
        explanationFrench: 'La bonne réponse est ${options[correct]}.',
        difficulty: difficulty,
        level: level,
      ));
    }
    return questions;
  }

  List<Question> _createAntonyms(CCATLevel level) {
    final difficulty = _getDifficultyForLevel(level);
    List<Question> questions = [];
    
    final antonyms = level == CCATLevel.level10 ? [
      ('Which word means the OPPOSITE of HAPPY?', ['sad', 'glad', 'joyful', 'excited'], 0),
      ('Which word means the OPPOSITE of BIG?', ['small', 'large', 'huge', 'giant'], 0),
      ('Which word means the OPPOSITE of HOT?', ['cold', 'warm', 'burning', 'heated'], 0),
      ('Which word means the OPPOSITE of FAST?', ['slow', 'quick', 'rapid', 'speedy'], 0),
      ('Which word means the OPPOSITE of UP?', ['down', 'high', 'above', 'over'], 0),
      ('Which word means the OPPOSITE of OPEN?', ['closed', 'wide', 'ajar', 'unlocked'], 0),
      ('Which word means the OPPOSITE of LIGHT?', ['dark', 'bright', 'sunny', 'clear'], 0),
      ('Which word means the OPPOSITE of LOUD?', ['quiet', 'noisy', 'booming', 'blaring'], 0),
    ] : level == CCATLevel.level11 ? [
      ('Which word means the OPPOSITE of ANCIENT?', ['modern', 'old', 'antique', 'aged'], 0),
      ('Which word means the OPPOSITE of EXPAND?', ['contract', 'grow', 'enlarge', 'spread'], 0),
      ('Which word means the OPPOSITE of VICTORY?', ['defeat', 'triumph', 'success', 'win'], 0),
      ('Which word means the OPPOSITE of GENEROUS?', ['stingy', 'giving', 'kind', 'liberal'], 0),
      ('Which word means the OPPOSITE of BRAVE?', ['cowardly', 'heroic', 'bold', 'daring'], 0),
      ('Which word means the OPPOSITE of ACCEPT?', ['reject', 'receive', 'take', 'welcome'], 0),
      ('Which word means the OPPOSITE of ARTIFICIAL?', ['natural', 'fake', 'synthetic', 'man-made'], 0),
      ('Which word means the OPPOSITE of SHALLOW?', ['deep', 'surface', 'light', 'thin'], 0),
    ] : [
      ('Which word means the OPPOSITE of BENEVOLENT?', ['malevolent', 'kind', 'generous', 'charitable'], 0),
      ('Which word means the OPPOSITE of EPHEMERAL?', ['permanent', 'brief', 'fleeting', 'temporary'], 0),
      ('Which word means the OPPOSITE of VERBOSE?', ['concise', 'wordy', 'lengthy', 'prolonged'], 0),
      ('Which word means the OPPOSITE of PRUDENT?', ['reckless', 'wise', 'careful', 'cautious'], 0),
      ('Which word means the OPPOSITE of ENIGMATIC?', ['obvious', 'mysterious', 'puzzling', 'cryptic'], 0),
      ('Which word means the OPPOSITE of LOQUACIOUS?', ['taciturn', 'talkative', 'chatty', 'garrulous'], 0),
      ('Which word means the OPPOSITE of METICULOUS?', ['careless', 'precise', 'thorough', 'detailed'], 0),
      ('Which word means the OPPOSITE of AFFLUENT?', ['impoverished', 'wealthy', 'rich', 'prosperous'], 0),
    ];

    for (var i = 0; i < antonyms.length; i++) {
      final (stem, options, correct) = antonyms[i];
      questions.add(Question(
        id: '${level.value}_verbal_antonyms_$i',
        type: QuestionType.verbal,
        subType: VerbalSubType.antonyms.value,
        stem: stem,
        stemFrench: '$stem (FR)',
        options: options,
        optionsFrench: options,
        correctAnswer: correct,
        explanation: 'The correct answer is ${options[correct]}, which means the opposite of the given word.',
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
      ('4 : 8 :: 6 : ?', ['10', '12', '14', '16'], 1),
      ('5 : 10 :: 7 : ?', ['12', '13', '14', '15'], 2),
      ('2 : 6 :: 4 : ?', ['10', '12', '14', '8'], 1),
      ('1 : 3 :: 2 : ?', ['4', '5', '6', '7'], 2),
      ('3 : 6 :: 5 : ?', ['8', '9', '10', '11'], 2),
    ] : level == CCATLevel.level11 ? [
      ('5 : 25 :: 6 : ?', ['30', '36', '42', '48'], 1),
      ('8 : 64 :: 9 : ?', ['72', '81', '90', '99'], 1),
      ('2 : 8 :: 3 : ?', ['18', '24', '27', '30'], 2),
      ('4 : 16 :: 5 : ?', ['20', '25', '30', '35'], 1),
      ('3 : 12 :: 4 : ?', ['14', '16', '18', '20'], 1),
      ('6 : 36 :: 7 : ?', ['42', '49', '56', '63'], 1),
      ('7 : 49 :: 8 : ?', ['56', '64', '72', '80'], 1),
      ('10 : 100 :: 11 : ?', ['110', '111', '121', '132'], 2),
    ] : [
      ('3 : 27 :: 4 : ?', ['64', '48', '36', '16'], 0),
      ('2 : 16 :: 3 : ?', ['81', '72', '64', '54'], 0),
      ('5 : 125 :: 4 : ?', ['64', '80', '100', '120'], 0),
      ('2 : 32 :: 3 : ?', ['243', '81', '27', '9'], 0),
      ('4 : 256 :: 3 : ?', ['81', '64', '27', '9'], 0),
      ('6 : 216 :: 5 : ?', ['125', '100', '75', '50'], 0),
      ('7 : 343 :: 4 : ?', ['64', '48', '32', '16'], 0),
      ('2 : 64 :: 3 : ?', ['729', '243', '81', '27'], 0),
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
      ('Which is greater? A: 5 + 3, B: 4 + 2', ['A', 'B', 'Equal', 'Cannot tell'], 0),
      ('Which is less? A: 10 - 2, B: 5 + 4', ['A', 'B', 'Equal', 'Cannot tell'], 0),
      ('Compare: A: 2 x 3, B: 3 + 3', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 2),
      ('Which is greater? A: 4 x 2, B: 3 x 3', ['A', 'B', 'Equal', 'Cannot tell'], 1),
      ('Compare: A: 15 - 5, B: 2 x 5', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 2),
      ('Which is less? A: 6 + 6, B: 4 x 4', ['A', 'B', 'Equal', 'Cannot tell'], 0),
      ('Compare: A: 20 ÷ 4, B: 10 ÷ 2', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 2),
      ('Which is greater? A: 7 + 8, B: 5 x 3', ['A', 'B', 'Equal', 'Cannot tell'], 2),
    ] : level == CCATLevel.level11 ? [
      ('Which is greater? A: 1/2 of 10, B: 1/3 of 12', ['A', 'B', 'Equal', 'Cannot tell'], 0),
      ('Which is less? A: 0.5, B: 0.05', ['A', 'B', 'Equal', 'Cannot tell'], 1),
      ('Compare: A: 3 squared, B: 2 cubed', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 0),
      ('Which is greater? A: 2/3 of 9, B: 3/4 of 8', ['A', 'B', 'Equal', 'Cannot tell'], 2),
      ('Compare: A: 0.25, B: 1/4', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 2),
      ('Which is less? A: 4 squared, B: 3 cubed', ['A', 'B', 'Equal', 'Cannot tell'], 0),
      ('Compare: A: 15%, B: 0.15', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 2),
      ('Which is greater? A: 5/8, B: 7/12', ['A', 'B', 'Equal', 'Cannot tell'], 0),
    ] : [
      ('Compare: A: sqrt(144), B: 12', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 2),
      ('Which is less? A: -5, B: -10', ['A', 'B', 'Equal', 'Cannot tell'], 1),
      ('Compare: A: 2^4, B: 4^2', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 2),
      ('Which is greater? A: π, B: 3.14', ['A', 'B', 'Equal', 'Cannot tell'], 0),
      ('Compare: A: sqrt(2), B: 1.5', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 1),
      ('Which is less? A: 3^3, B: 2^5', ['A', 'B', 'Equal', 'Cannot tell'], 0),
      ('Compare: A: log₁₀(100), B: 2', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 2),
      ('Which is greater? A: |-7|, B: |5|', ['A', 'B', 'Equal', 'Cannot tell'], 0),
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
      ('3, 6, 9, 12, ?', ['13', '14', '15', '16'], 2),
      ('1, 3, 5, 7, ?', ['8', '9', '10', '11'], 1),
      ('20, 18, 16, 14, ?', ['10', '11', '12', '13'], 2),
      ('4, 8, 12, 16, ?', ['18', '19', '20', '22'], 2),
      ('100, 90, 80, 70, ?', ['50', '55', '60', '65'], 2),
    ] : level == CCATLevel.level11 ? [
      ('1, 4, 9, 16, ?', ['20', '24', '25', '30'], 2),
      ('2, 6, 12, 20, ?', ['28', '30', '32', '36'], 1),
      ('1, 1, 2, 3, 5, ?', ['7', '8', '9', '10'], 1),
      ('2, 4, 8, 16, ?', ['24', '28', '32', '36'], 2),
      ('1, 2, 4, 7, 11, ?', ['14', '15', '16', '17'], 2),
      ('3, 5, 8, 12, 17, ?', ['21', '22', '23', '24'], 2),
      ('1, 3, 6, 10, 15, ?', ['19', '20', '21', '22'], 2),
      ('2, 3, 5, 8, 12, ?', ['15', '16', '17', '18'], 2),
    ] : [
      ('2, 3, 5, 7, 11, ?', ['12', '13', '14', '15'], 1),
      ('1, 8, 27, 64, ?', ['100', '125', '150', '200'], 1),
      ('3, 6, 12, 24, ?', ['36', '40', '48', '50'], 2),
      ('1, 4, 27, 256, ?', ['625', '1024', '2048', '3125'], 3),
      ('2, 6, 18, 54, ?', ['108', '126', '162', '180'], 2),
      ('1, 2, 6, 24, 120, ?', ['240', '480', '600', '720'], 3),
      ('1, 1, 2, 3, 5, 8, 13, ?', ['18', '20', '21', '24'], 2),
      ('1, 2, 4, 8, 16, 32, ?', ['48', '56', '64', '72'], 2),
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

  // MARK: - Non-Verbal Questions Generation (Text-based representations)

  List<Question> _createFigureMatrices(CCATLevel level) {
    final difficulty = _getDifficultyForLevel(level);
    List<Question> questions = [];
    
    final matrices = [
      ('Shape Pattern: Circle -> Sphere. Square -> ?', ['Cube', 'Triangle', 'Line', 'Point'], 0),
      ('Color Pattern: Red -> Pink. Blue -> ?', ['Sky Blue', 'Green', 'Purple', 'Orange'], 0),
      ('Size Pattern: Big -> Small. Tall -> ?', ['Short', 'Wide', 'Fat', 'Long'], 0),
      ('Direction: Up -> Down. Left -> ?', ['Right', 'Center', 'North', 'South'], 0),
      ('Texture: Rough -> Smooth. Hard -> ?', ['Soft', 'Solid', 'Rock', 'Stone'], 0),
    ];

    for (var i = 0; i < matrices.length; i++) {
      final (stem, options, correct) = matrices[i];
      questions.add(Question(
        id: '${level.value}_nonverbal_matrices_$i',
        type: QuestionType.nonVerbal,
        subType: NonVerbalSubType.figureMatrices.value,
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

  List<Question> _createFigureClassification(CCATLevel level) {
    final difficulty = _getDifficultyForLevel(level);
    List<Question> questions = [];
    
    final items = [
      ('Which shape is different?', ['Circle', 'Square', 'Triangle', 'Rectangle'], 0), // Circle has no corners
      ('Which object is different?', ['Ball', 'Box', 'Dice', 'Brick'], 0), // Ball is round
      ('Which direction is different?', ['North', 'South', 'East', 'Up'], 3), // Up is vertical
      ('Which line is different?', ['Straight', 'Curved', 'Zigzag', 'Dotted'], 3), // Dotted is not continuous
      ('Which symmetry is different?', ['H', 'A', 'M', 'P'], 3), // P has no vertical symmetry
    ];

    for (var i = 0; i < items.length; i++) {
      final (stem, options, correct) = items[i];
      questions.add(Question(
        id: '${level.value}_nonverbal_class_$i',
        type: QuestionType.nonVerbal,
        subType: NonVerbalSubType.figureClassification.value,
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

  List<Question> _createFigureSeries(CCATLevel level) {
    final difficulty = _getDifficultyForLevel(level);
    List<Question> questions = [];
    
    final series = [
      ('Sequence: | , || , ||| , ?', ['||||', '||', '|', 'V'], 0),
      ('Sequence: O , OO , OOO , ?', ['OOOO', 'O', '0', '8'], 0),
      ('Sequence: A , C , E , ?', ['G', 'F', 'H', 'I'], 0),
      ('Sequence: 12:00 , 12:15 , 12:30 , ?', ['12:45', '12:40', '1:00', '12:35'], 0),
      ('Sequence: North , East , South , ?', ['West', 'North', 'Up', 'Down'], 0),
    ];

    for (var i = 0; i < series.length; i++) {
      final (stem, options, correct) = series[i];
      questions.add(Question(
        id: '${level.value}_nonverbal_series_$i',
        type: QuestionType.nonVerbal,
        subType: NonVerbalSubType.figureSeries.value,
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
