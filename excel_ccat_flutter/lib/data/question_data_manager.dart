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
      ('Cow is to calf as horse is to:', ['foal', 'pony', 'mare', 'stallion'], 0),
      ('Book is to read as song is to:', ['listen', 'write', 'dance', 'play'], 0),
      ('Hot is to cold as day is to:', ['night', 'sun', 'warm', 'light'], 0),
      ('Teacher is to school as doctor is to:', ['hospital', 'medicine', 'patient', 'nurse'], 0),
      ('Knife is to cut as hammer is to:', ['nail', 'build', 'hit', 'wood'], 0),
      ('Snow is to winter as rain is to:', ['spring', 'cloud', 'umbrella', 'wet'], 0),
      ('Bee is to honey as cow is to:', ['milk', 'grass', 'farm', 'beef'], 0),
      ('Piano is to keys as guitar is to:', ['strings', 'music', 'wood', 'pick'], 0),
    ] : level == CCATLevel.level11 ? [
      ('Author is to book as composer is to:', ['song', 'instrument', 'concert', 'band'], 0),
      ('Library is to books as museum is to:', ['artifacts', 'tickets', 'guides', 'visitors'], 0),
      ('Chef is to kitchen as pilot is to:', ['cockpit', 'plane', 'airport', 'sky'], 0),
      ('Brush is to paint as pen is to:', ['ink', 'paper', 'write', 'letter'], 0),
      ('Doctor is to patient as teacher is to:', ['student', 'school', 'book', 'class'], 0),
      ('Thermometer is to temperature as scale is to:', ['weight', 'height', 'length', 'time'], 0),
      ('Seed is to plant as egg is to:', ['bird', 'chicken', 'nest', 'shell'], 0),
      ('Clock is to time as compass is to:', ['direction', 'north', 'map', 'travel'], 0),
      ('Captain is to ship as conductor is to:', ['orchestra', 'train', 'music', 'baton'], 0),
      ('Astronomer is to stars as geologist is to:', ['rocks', 'maps', 'weather', 'animals'], 0),
      ('Brake is to stop as accelerator is to:', ['speed', 'slow', 'car', 'drive'], 0),
      ('Prologue is to book as overture is to:', ['opera', 'end', 'music', 'play'], 0),
      ('Flock is to sheep as pack is to:', ['wolves', 'birds', 'fish', 'bees'], 0),
      ('Telescope is to stars as microscope is to:', ['cells', 'planets', 'eyes', 'light'], 0),
      ('Carpenter is to wood as blacksmith is to:', ['metal', 'fire', 'horse', 'tools'], 0),
      ('Chapter is to book as act is to:', ['play', 'movie', 'scene', 'story'], 0),
    ] : [
      ('Ephemeral is to permanent as volatile is to:', ['stable', 'explosive', 'liquid', 'gas'], 0),
      ('Meticulous is to careless as frugal is to:', ['wasteful', 'careful', 'poor', 'rich'], 0),
      ('Archipelago is to islands as constellation is to:', ['stars', 'planets', 'galaxies', 'moons'], 0),
      ('Taciturn is to talkative as somber is to:', ['cheerful', 'dark', 'serious', 'quiet'], 0),
      ('Chronometer is to time as barometer is to:', ['pressure', 'temperature', 'distance', 'speed'], 0),
      ('Plaintiff is to defendant as prosecutor is to:', ['accused', 'judge', 'lawyer', 'jury'], 0),
      ('Prologue is to epilogue as dawn is to:', ['dusk', 'morning', 'night', 'noon'], 0),
      ('Catalyst is to reaction as stimulus is to:', ['response', 'chemical', 'change', 'speed'], 0),
      ('Lexicon is to words as atlas is to:', ['maps', 'books', 'countries', 'geography'], 0),
      ('Apiary is to bees as aviary is to:', ['birds', 'ants', 'fish', 'plants'], 0),
      ('Numismatist is to coins as philatelist is to:', ['stamps', 'books', 'art', 'antiques'], 0),
      ('Zenith is to nadir as apex is to:', ['base', 'top', 'middle', 'side'], 0),
      ('Maelstrom is to water as tornado is to:', ['air', 'earth', 'fire', 'wind'], 0),
      ('Ameliorate is to worsen as expedite is to:', ['delay', 'hurry', 'improve', 'send'], 0),
      ('Pedagogue is to teaching as demagogue is to:', ['manipulation', 'democracy', 'speaking', 'leading'], 0),
      ('Ornithology is to birds as entomology is to:', ['insects', 'rocks', 'plants', 'fish'], 0),
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
      ('Which word means the same as ANGRY?', ['mad', 'calm', 'happy', 'sad'], 0),
      ('Which word means the same as PRETTY?', ['beautiful', 'ugly', 'plain', 'dull'], 0),
      ('Which word means the same as FUNNY?', ['amusing', 'boring', 'sad', 'serious'], 0),
      ('Which word means the same as SLEEPY?', ['drowsy', 'awake', 'alert', 'active'], 0),
      ('Which word means the same as RICH?', ['wealthy', 'poor', 'broke', 'needy'], 0),
      ('Which word means the same as EASY?', ['simple', 'hard', 'difficult', 'tough'], 0),
      ('Which word means the same as BRAVE?', ['fearless', 'scared', 'afraid', 'timid'], 0),
      ('Which word means the same as DIRTY?', ['filthy', 'clean', 'neat', 'tidy'], 0),
    ] : level == CCATLevel.level11 ? [
      ('Which word means the same as ABUNDANT?', ['plentiful', 'scarce', 'empty', 'rare'], 0),
      ('Which word means the same as BRAVE?', ['courageous', 'fearful', 'timid', 'weak'], 0),
      ('Which word means the same as ASSIST?', ['help', 'hinder', 'stop', 'leave'], 0),
      ('Which word means the same as ANCIENT?', ['old', 'new', 'modern', 'recent'], 0),
      ('Which word means the same as CONCEAL?', ['hide', 'reveal', 'show', 'expose'], 0),
      ('Which word means the same as DEPART?', ['leave', 'arrive', 'stay', 'remain'], 0),
      ('Which word means the same as EXHAUSTED?', ['tired', 'energetic', 'lively', 'rested'], 0),
      ('Which word means the same as FORTUNATE?', ['lucky', 'unlucky', 'poor', 'sad'], 0),
      ('Which word means the same as GENUINE?', ['authentic', 'fake', 'false', 'phony'], 0),
      ('Which word means the same as HAZARDOUS?', ['dangerous', 'safe', 'secure', 'harmless'], 0),
      ('Which word means the same as IMITATE?', ['copy', 'create', 'invent', 'originate'], 0),
      ('Which word means the same as JEALOUS?', ['envious', 'content', 'satisfied', 'pleased'], 0),
      ('Which word means the same as KEEN?', ['eager', 'reluctant', 'bored', 'lazy'], 0),
      ('Which word means the same as LIBERTY?', ['freedom', 'prison', 'captivity', 'bondage'], 0),
      ('Which word means the same as MAGNIFICENT?', ['splendid', 'ordinary', 'plain', 'simple'], 0),
      ('Which word means the same as NUMEROUS?', ['many', 'few', 'single', 'rare'], 0),
    ] : [
      ('Which word means the same as UBIQUITOUS?', ['omnipresent', 'rare', 'scarce', 'limited'], 0),
      ('Which word means the same as EPHEMERAL?', ['transient', 'permanent', 'lasting', 'enduring'], 0),
      ('Which word means the same as BENEVOLENT?', ['kind', 'malicious', 'cruel', 'harsh'], 0),
      ('Which word means the same as CACOPHONY?', ['discord', 'harmony', 'melody', 'rhythm'], 0),
      ('Which word means the same as ARDUOUS?', ['difficult', 'easy', 'simple', 'effortless'], 0),
      ('Which word means the same as AMELIORATE?', ['improve', 'worsen', 'destroy', 'neglect'], 0),
      ('Which word means the same as COGENT?', ['convincing', 'weak', 'unclear', 'confusing'], 0),
      ('Which word means the same as DILATORY?', ['slow', 'prompt', 'quick', 'hasty'], 0),
      ('Which word means the same as ERUDITE?', ['scholarly', 'ignorant', 'uneducated', 'simple'], 0),
      ('Which word means the same as FASTIDIOUS?', ['meticulous', 'careless', 'sloppy', 'messy'], 0),
      ('Which word means the same as GREGARIOUS?', ['sociable', 'reclusive', 'shy', 'introverted'], 0),
      ('Which word means the same as HACKNEYED?', ['overused', 'original', 'fresh', 'novel'], 0),
      ('Which word means the same as ICONOCLAST?', ['rebel', 'conformist', 'follower', 'traditionalist'], 0),
      ('Which word means the same as JUDICIOUS?', ['wise', 'foolish', 'reckless', 'imprudent'], 0),
      ('Which word means the same as LACONIC?', ['concise', 'verbose', 'wordy', 'lengthy'], 0),
      ('Which word means the same as MAGNANIMOUS?', ['generous', 'petty', 'selfish', 'stingy'], 0),
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
      ('Which word means the OPPOSITE of NEW?', ['old', 'fresh', 'recent', 'modern'], 0),
      ('Which word means the OPPOSITE of CLEAN?', ['dirty', 'neat', 'tidy', 'spotless'], 0),
      ('Which word means the OPPOSITE of EMPTY?', ['full', 'vacant', 'hollow', 'bare'], 0),
      ('Which word means the OPPOSITE of SOFT?', ['hard', 'gentle', 'smooth', 'fluffy'], 0),
      ('Which word means the OPPOSITE of EARLY?', ['late', 'soon', 'before', 'prompt'], 0),
      ('Which word means the OPPOSITE of WET?', ['dry', 'damp', 'moist', 'soaked'], 0),
      ('Which word means the OPPOSITE of RICH?', ['poor', 'wealthy', 'loaded', 'abundant'], 0),
      ('Which word means the OPPOSITE of SAFE?', ['dangerous', 'secure', 'protected', 'guarded'], 0),
    ] : level == CCATLevel.level11 ? [
      ('Which word means the OPPOSITE of ANCIENT?', ['modern', 'old', 'antique', 'aged'], 0),
      ('Which word means the OPPOSITE of EXPAND?', ['contract', 'grow', 'enlarge', 'spread'], 0),
      ('Which word means the OPPOSITE of VICTORY?', ['defeat', 'triumph', 'success', 'win'], 0),
      ('Which word means the OPPOSITE of GENEROUS?', ['stingy', 'giving', 'kind', 'liberal'], 0),
      ('Which word means the OPPOSITE of BRAVE?', ['cowardly', 'heroic', 'bold', 'daring'], 0),
      ('Which word means the OPPOSITE of ACCEPT?', ['reject', 'receive', 'take', 'welcome'], 0),
      ('Which word means the OPPOSITE of ARTIFICIAL?', ['natural', 'fake', 'synthetic', 'man-made'], 0),
      ('Which word means the OPPOSITE of SHALLOW?', ['deep', 'surface', 'light', 'thin'], 0),
      ('Which word means the OPPOSITE of OPTIMISTIC?', ['pessimistic', 'hopeful', 'positive', 'cheerful'], 0),
      ('Which word means the OPPOSITE of TEMPORARY?', ['permanent', 'brief', 'short', 'fleeting'], 0),
      ('Which word means the OPPOSITE of MAXIMUM?', ['minimum', 'highest', 'greatest', 'most'], 0),
      ('Which word means the OPPOSITE of INNOCENT?', ['guilty', 'pure', 'blameless', 'naive'], 0),
      ('Which word means the OPPOSITE of HUMBLE?', ['arrogant', 'modest', 'meek', 'shy'], 0),
      ('Which word means the OPPOSITE of HARMONY?', ['discord', 'peace', 'unity', 'agreement'], 0),
      ('Which word means the OPPOSITE of FLEXIBLE?', ['rigid', 'bendable', 'elastic', 'adaptable'], 0),
      ('Which word means the OPPOSITE of EXTERIOR?', ['interior', 'outside', 'outer', 'external'], 0),
    ] : [
      ('Which word means the OPPOSITE of BENEVOLENT?', ['malevolent', 'kind', 'generous', 'charitable'], 0),
      ('Which word means the OPPOSITE of EPHEMERAL?', ['permanent', 'brief', 'fleeting', 'temporary'], 0),
      ('Which word means the OPPOSITE of VERBOSE?', ['concise', 'wordy', 'lengthy', 'prolonged'], 0),
      ('Which word means the OPPOSITE of PRUDENT?', ['reckless', 'wise', 'careful', 'cautious'], 0),
      ('Which word means the OPPOSITE of ENIGMATIC?', ['obvious', 'mysterious', 'puzzling', 'cryptic'], 0),
      ('Which word means the OPPOSITE of LOQUACIOUS?', ['taciturn', 'talkative', 'chatty', 'garrulous'], 0),
      ('Which word means the OPPOSITE of METICULOUS?', ['careless', 'precise', 'thorough', 'detailed'], 0),
      ('Which word means the OPPOSITE of AFFLUENT?', ['impoverished', 'wealthy', 'rich', 'prosperous'], 0),
      ('Which word means the OPPOSITE of SANGUINE?', ['pessimistic', 'optimistic', 'hopeful', 'confident'], 0),
      ('Which word means the OPPOSITE of RETICENT?', ['forthcoming', 'reserved', 'quiet', 'shy'], 0),
      ('Which word means the OPPOSITE of PARSIMONIOUS?', ['lavish', 'frugal', 'thrifty', 'economical'], 0),
      ('Which word means the OPPOSITE of OBSEQUIOUS?', ['defiant', 'servile', 'fawning', 'submissive'], 0),
      ('Which word means the OPPOSITE of NEFARIOUS?', ['virtuous', 'wicked', 'evil', 'villainous'], 0),
      ('Which word means the OPPOSITE of MUNDANE?', ['extraordinary', 'ordinary', 'common', 'dull'], 0),
      ('Which word means the OPPOSITE of LANGUID?', ['energetic', 'sluggish', 'listless', 'lethargic'], 0),
      ('Which word means the OPPOSITE of INDIGENOUS?', ['foreign', 'native', 'local', 'endemic'], 0),
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
      ('The dog barked _____ at the mailman.', ['loudly', 'quietly', 'softly', 'gently'], 0),
      ('I need an umbrella because it is _____.', ['raining', 'sunny', 'windy', 'cold'], 0),
      ('The ice cream was so _____ on a hot day.', ['refreshing', 'boring', 'loud', 'fast'], 0),
      ('She _____ her homework before going out to play.', ['finished', 'forgot', 'lost', 'broke'], 0),
      ('The birthday cake was _____ with colorful frosting.', ['decorated', 'empty', 'broken', 'lost'], 0),
      ('We plant seeds in _____ to grow flowers.', ['spring', 'winter', 'night', 'space'], 0),
      ('The library is a _____ place to read books.', ['quiet', 'loud', 'fast', 'wet'], 0),
      ('Mom uses a _____ to cook dinner.', ['stove', 'bed', 'chair', 'book'], 0),
      ('Birds build _____ in trees.', ['nests', 'houses', 'cars', 'boats'], 0),
    ] : level == CCATLevel.level11 ? [
      ('The scientist\'s hypothesis was _____ by the results.', ['validated', 'ignored', 'created', 'changed'], 0),
      ('Despite her shy appearance, she was actually quite _____.', ['outgoing', 'quiet', 'nervous', 'boring'], 0),
      ('The ancient ruins were _____ preserved.', ['remarkably', 'poorly', 'quickly', 'loudly'], 0),
      ('The detective found a _____ clue at the crime scene.', ['crucial', 'useless', 'broken', 'loud'], 0),
      ('The medicine helped _____ her headache.', ['relieve', 'increase', 'ignore', 'create'], 0),
      ('The _____ weather forced us to cancel the picnic.', ['inclement', 'beautiful', 'sunny', 'warm'], 0),
      ('His _____ attitude made everyone uncomfortable.', ['hostile', 'friendly', 'helpful', 'kind'], 0),
      ('The _____ student received an award for excellence.', ['outstanding', 'mediocre', 'lazy', 'absent'], 0),
      ('We need to _____ our resources carefully.', ['conserve', 'waste', 'ignore', 'destroy'], 0),
      ('The project requires _____ between team members.', ['collaboration', 'competition', 'isolation', 'conflict'], 0),
      ('Her _____ explanation helped everyone understand.', ['lucid', 'confusing', 'unclear', 'vague'], 0),
      ('The _____ bridge connected the two cities.', ['magnificent', 'tiny', 'broken', 'invisible'], 0),
    ] : [
      ('The politician\'s _____ speech failed to convince the audience.', ['bombastic', 'sincere', 'brief', 'eloquent'], 0),
      ('Her _____ nature made her popular among colleagues.', ['affable', 'hostile', 'indifferent', 'withdrawn'], 0),
      ('The judge\'s _____ ruling satisfied neither party.', ['ambiguous', 'clear', 'fair', 'harsh'], 0),
      ('The professor\'s _____ lecture captivated the students.', ['erudite', 'boring', 'simple', 'short'], 0),
      ('His _____ behavior during the meeting was unprofessional.', ['obstreperous', 'calm', 'polite', 'quiet'], 0),
      ('The _____ evidence proved the defendant\'s innocence.', ['exculpatory', 'damning', 'irrelevant', 'missing'], 0),
      ('Her _____ approach to problem-solving impressed everyone.', ['pragmatic', 'impractical', 'emotional', 'random'], 0),
      ('The CEO\'s _____ decision saved the company millions.', ['perspicacious', 'foolish', 'hasty', 'random'], 0),
      ('The _____ landscape stretched for miles.', ['bucolic', 'urban', 'industrial', 'barren'], 0),
      ('His _____ comments during the debate won him supporters.', ['trenchant', 'vague', 'timid', 'irrelevant'], 0),
      ('The _____ nature of the virus made it difficult to study.', ['protean', 'stable', 'predictable', 'simple'], 0),
      ('Her _____ wit always entertained dinner guests.', ['sardonic', 'dull', 'predictable', 'boring'], 0),
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
      ('Which doesn\'t belong? Chair, Sofa, Bed, Pizza', ['Pizza', 'Chair', 'Sofa', 'Bed'], 0),
      ('Which doesn\'t belong? Car, Bus, Train, Apple', ['Apple', 'Car', 'Bus', 'Train'], 0),
      ('Which doesn\'t belong? Monday, Tuesday, January, Friday', ['January', 'Monday', 'Tuesday', 'Friday'], 0),
      ('Which doesn\'t belong? Milk, Juice, Water, Bread', ['Bread', 'Milk', 'Juice', 'Water'], 0),
      ('Which doesn\'t belong? Soccer, Tennis, Reading, Basketball', ['Reading', 'Soccer', 'Tennis', 'Basketball'], 0),
      ('Which doesn\'t belong? Spring, Summer, Winter, Afternoon', ['Afternoon', 'Spring', 'Summer', 'Winter'], 0),
      ('Which doesn\'t belong? Eye, Ear, Nose, Shoe', ['Shoe', 'Eye', 'Ear', 'Nose'], 0),
      ('Which doesn\'t belong? Lion, Tiger, Bear, Flower', ['Flower', 'Lion', 'Tiger', 'Bear'], 0),
      ('Which doesn\'t belong? Shirt, Pants, Hat, Table', ['Table', 'Shirt', 'Pants', 'Hat'], 0),
    ] : level == CCATLevel.level11 ? [
      ('Which doesn\'t belong? Mercury, Venus, Sun, Mars', ['Sun', 'Mercury', 'Venus', 'Mars'], 0),
      ('Which doesn\'t belong? Piano, Violin, Drum, Painting', ['Painting', 'Piano', 'Violin', 'Drum'], 0),
      ('Which doesn\'t belong? Triangle, Square, Circle, Cube', ['Cube', 'Triangle', 'Square', 'Circle'], 0),
      ('Which doesn\'t belong? Nitrogen, Oxygen, Carbon, Water', ['Water', 'Nitrogen', 'Oxygen', 'Carbon'], 0),
      ('Which doesn\'t belong? Shakespeare, Hemingway, Einstein, Dickens', ['Einstein', 'Shakespeare', 'Hemingway', 'Dickens'], 0),
      ('Which doesn\'t belong? Atlantic, Pacific, Indian, Nile', ['Nile', 'Atlantic', 'Pacific', 'Indian'], 0),
      ('Which doesn\'t belong? Fraction, Decimal, Percentage, Paragraph', ['Paragraph', 'Fraction', 'Decimal', 'Percentage'], 0),
      ('Which doesn\'t belong? Noun, Verb, Adjective, Mathematics', ['Mathematics', 'Noun', 'Verb', 'Adjective'], 0),
      ('Which doesn\'t belong? Heart, Lung, Brain, Pencil', ['Pencil', 'Heart', 'Lung', 'Brain'], 0),
      ('Which doesn\'t belong? Canada, France, Japan, Toronto', ['Toronto', 'Canada', 'France', 'Japan'], 0),
      ('Which doesn\'t belong? Celsius, Fahrenheit, Kelvin, Kilogram', ['Kilogram', 'Celsius', 'Fahrenheit', 'Kelvin'], 0),
      ('Which doesn\'t belong? Democracy, Monarchy, Republic, Photosynthesis', ['Photosynthesis', 'Democracy', 'Monarchy', 'Republic'], 0),
    ] : [
      ('Which doesn\'t belong? Monarchy, Democracy, Republic, Capitalism', ['Capitalism', 'Monarchy', 'Democracy', 'Republic'], 0),
      ('Which doesn\'t belong? Metaphor, Simile, Hyperbole, Paragraph', ['Paragraph', 'Metaphor', 'Simile', 'Hyperbole'], 0),
      ('Which doesn\'t belong? Photosynthesis, Respiration, Digestion, Gravity', ['Gravity', 'Photosynthesis', 'Respiration', 'Digestion'], 0),
      ('Which doesn\'t belong? Baroque, Renaissance, Romanticism, Algebra', ['Algebra', 'Baroque', 'Renaissance', 'Romanticism'], 0),
      ('Which doesn\'t belong? Aristotle, Plato, Socrates, Newton', ['Newton', 'Aristotle', 'Plato', 'Socrates'], 0),
      ('Which doesn\'t belong? Irony, Sarcasm, Satire, Algorithm', ['Algorithm', 'Irony', 'Sarcasm', 'Satire'], 0),
      ('Which doesn\'t belong? Mitochondria, Nucleus, Ribosome, Equation', ['Equation', 'Mitochondria', 'Nucleus', 'Ribosome'], 0),
      ('Which doesn\'t belong? Empiricism, Rationalism, Existentialism, Thermodynamics', ['Thermodynamics', 'Empiricism', 'Rationalism', 'Existentialism'], 0),
      ('Which doesn\'t belong? Sonnet, Haiku, Limerick, Thesis', ['Thesis', 'Sonnet', 'Haiku', 'Limerick'], 0),
      ('Which doesn\'t belong? Impressionism, Cubism, Surrealism, Calculus', ['Calculus', 'Impressionism', 'Cubism', 'Surrealism'], 0),
      ('Which doesn\'t belong? Syntax, Semantics, Pragmatics, Velocity', ['Velocity', 'Syntax', 'Semantics', 'Pragmatics'], 0),
      ('Which doesn\'t belong? Mozart, Beethoven, Bach, Darwin', ['Darwin', 'Mozart', 'Beethoven', 'Bach'], 0),
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
      ('6 : 12 :: 8 : ?', ['14', '16', '18', '20'], 1),
      ('2 : 10 :: 3 : ?', ['12', '15', '18', '21'], 1),
      ('4 : 12 :: 5 : ?', ['13', '14', '15', '16'], 2),
      ('1 : 5 :: 2 : ?', ['8', '9', '10', '11'], 2),
      ('7 : 14 :: 9 : ?', ['16', '17', '18', '19'], 2),
      ('5 : 15 :: 6 : ?', ['16', '17', '18', '19'], 2),
      ('8 : 16 :: 10 : ?', ['18', '19', '20', '21'], 2),
      ('3 : 15 :: 4 : ?', ['18', '19', '20', '21'], 2),
    ] : level == CCATLevel.level11 ? [
      ('5 : 25 :: 6 : ?', ['30', '36', '42', '48'], 1),
      ('8 : 64 :: 9 : ?', ['72', '81', '90', '99'], 1),
      ('2 : 8 :: 3 : ?', ['18', '24', '27', '30'], 2),
      ('4 : 16 :: 5 : ?', ['20', '25', '30', '35'], 1),
      ('3 : 12 :: 4 : ?', ['14', '16', '18', '20'], 1),
      ('6 : 36 :: 7 : ?', ['42', '49', '56', '63'], 1),
      ('7 : 49 :: 8 : ?', ['56', '64', '72', '80'], 1),
      ('10 : 100 :: 11 : ?', ['110', '111', '121', '132'], 2),
      ('3 : 9 :: 7 : ?', ['14', '21', '42', '49'], 3),
      ('9 : 81 :: 10 : ?', ['90', '91', '100', '110'], 2),
      ('11 : 121 :: 12 : ?', ['132', '144', '156', '168'], 1),
      ('4 : 64 :: 5 : ?', ['100', '125', '150', '175'], 1),
      ('2 : 4 :: 12 : ?', ['24', '36', '144', '48'], 2),
      ('15 : 225 :: 13 : ?', ['156', '169', '182', '195'], 1),
      ('20 : 400 :: 15 : ?', ['200', '225', '250', '275'], 1),
      ('8 : 512 :: 5 : ?', ['100', '125', '150', '175'], 1),
    ] : [
      ('3 : 27 :: 4 : ?', ['64', '48', '36', '16'], 0),
      ('2 : 16 :: 3 : ?', ['81', '72', '64', '54'], 0),
      ('5 : 125 :: 4 : ?', ['64', '80', '100', '120'], 0),
      ('2 : 32 :: 3 : ?', ['243', '81', '27', '9'], 0),
      ('4 : 256 :: 3 : ?', ['81', '64', '27', '9'], 0),
      ('6 : 216 :: 5 : ?', ['125', '100', '75', '50'], 0),
      ('7 : 343 :: 4 : ?', ['64', '48', '32', '16'], 0),
      ('2 : 64 :: 3 : ?', ['729', '243', '81', '27'], 0),
      ('10 : 1000 :: 6 : ?', ['216', '180', '120', '60'], 0),
      ('4 : 1024 :: 2 : ?', ['64', '32', '16', '8'], 0),
      ('8 : 4096 :: 5 : ?', ['625', '500', '125', '25'], 0),
      ('11 : 1331 :: 7 : ?', ['343', '294', '245', '196'], 0),
      ('9 : 729 :: 8 : ?', ['512', '448', '384', '320'], 0),
      ('3 : 81 :: 2 : ?', ['16', '8', '4', '2'], 0),
      ('5 : 3125 :: 4 : ?', ['1024', '512', '256', '128'], 0),
      ('6 : 7776 :: 3 : ?', ['243', '162', '81', '27'], 0),
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
      ('Which is less? A: 3 x 4, B: 2 x 7', ['A', 'B', 'Equal', 'Cannot tell'], 0),
      ('Compare: A: 18 ÷ 3, B: 12 ÷ 2', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 2),
      ('Which is greater? A: 9 + 5, B: 7 + 6', ['A', 'B', 'Equal', 'Cannot tell'], 0),
      ('Which is less? A: 5 x 5, B: 4 x 7', ['A', 'B', 'Equal', 'Cannot tell'], 1),
      ('Compare: A: 24 ÷ 6, B: 16 ÷ 4', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 2),
      ('Which is greater? A: 11 - 3, B: 4 + 5', ['A', 'B', 'Equal', 'Cannot tell'], 1),
      ('Which is less? A: 6 x 3, B: 9 x 2', ['A', 'B', 'Equal', 'Cannot tell'], 2),
      ('Compare: A: 30 ÷ 5, B: 18 ÷ 3', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 2),
    ] : level == CCATLevel.level11 ? [
      ('Which is greater? A: 1/2 of 10, B: 1/3 of 12', ['A', 'B', 'Equal', 'Cannot tell'], 0),
      ('Which is less? A: 0.5, B: 0.05', ['A', 'B', 'Equal', 'Cannot tell'], 1),
      ('Compare: A: 3 squared, B: 2 cubed', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 0),
      ('Which is greater? A: 2/3 of 9, B: 3/4 of 8', ['A', 'B', 'Equal', 'Cannot tell'], 2),
      ('Compare: A: 0.25, B: 1/4', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 2),
      ('Which is less? A: 4 squared, B: 3 cubed', ['A', 'B', 'Equal', 'Cannot tell'], 0),
      ('Compare: A: 15%, B: 0.15', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 2),
      ('Which is greater? A: 5/8, B: 7/12', ['A', 'B', 'Equal', 'Cannot tell'], 0),
      ('Which is less? A: 0.75, B: 4/5', ['A', 'B', 'Equal', 'Cannot tell'], 0),
      ('Compare: A: 5 squared, B: 6 x 4', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 0),
      ('Which is greater? A: 1/5 of 100, B: 1/4 of 80', ['A', 'B', 'Equal', 'Cannot tell'], 2),
      ('Which is less? A: 0.6, B: 2/3', ['A', 'B', 'Equal', 'Cannot tell'], 0),
      ('Compare: A: 25%, B: 0.3', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 1),
      ('Which is greater? A: 7/9, B: 8/11', ['A', 'B', 'Equal', 'Cannot tell'], 0),
      ('Which is less? A: 6 cubed, B: 200', ['A', 'B', 'Equal', 'Cannot tell'], 1),
      ('Compare: A: 2.5, B: 5/2', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 2),
    ] : [
      ('Compare: A: sqrt(144), B: 12', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 2),
      ('Which is less? A: -5, B: -10', ['A', 'B', 'Equal', 'Cannot tell'], 1),
      ('Compare: A: 2^4, B: 4^2', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 2),
      ('Which is greater? A: π, B: 3.14', ['A', 'B', 'Equal', 'Cannot tell'], 0),
      ('Compare: A: sqrt(2), B: 1.5', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 1),
      ('Which is less? A: 3^3, B: 2^5', ['A', 'B', 'Equal', 'Cannot tell'], 0),
      ('Compare: A: log₁₀(100), B: 2', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 2),
      ('Which is greater? A: |-7|, B: |5|', ['A', 'B', 'Equal', 'Cannot tell'], 0),
      ('Which is less? A: sqrt(50), B: 7', ['A', 'B', 'Equal', 'Cannot tell'], 0),
      ('Compare: A: 5^3, B: 3^5', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 1),
      ('Which is greater? A: e, B: 2.71', ['A', 'B', 'Equal', 'Cannot tell'], 0),
      ('Compare: A: sqrt(3) + sqrt(5), B: sqrt(8)', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 0),
      ('Which is less? A: log₂(8), B: log₃(27)', ['A', 'B', 'Equal', 'Cannot tell'], 2),
      ('Compare: A: 1/sqrt(2), B: sqrt(2)/2', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 2),
      ('Which is greater? A: (2/3)^2, B: 2/3', ['A', 'B', 'Equal', 'Cannot tell'], 1),
      ('Compare: A: 10^(-2), B: 0.01', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], 2),
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
      ('7, 14, 21, 28, ?', ['30', '32', '35', '38'], 2),
      ('50, 45, 40, 35, ?', ['25', '28', '30', '32'], 2),
      ('1, 2, 3, 4, ?', ['5', '6', '7', '8'], 0),
      ('6, 12, 18, 24, ?', ['28', '30', '32', '36'], 1),
      ('15, 12, 9, 6, ?', ['0', '2', '3', '4'], 2),
      ('8, 16, 24, 32, ?', ['36', '38', '40', '42'], 2),
      ('25, 20, 15, 10, ?', ['5', '6', '7', '8'], 0),
      ('9, 18, 27, 36, ?', ['42', '43', '44', '45'], 3),
    ] : level == CCATLevel.level11 ? [
      ('1, 4, 9, 16, ?', ['20', '24', '25', '30'], 2),
      ('2, 6, 12, 20, ?', ['28', '30', '32', '36'], 1),
      ('1, 1, 2, 3, 5, ?', ['7', '8', '9', '10'], 1),
      ('2, 4, 8, 16, ?', ['24', '28', '32', '36'], 2),
      ('1, 2, 4, 7, 11, ?', ['14', '15', '16', '17'], 2),
      ('3, 5, 8, 12, 17, ?', ['21', '22', '23', '24'], 2),
      ('1, 3, 6, 10, 15, ?', ['19', '20', '21', '22'], 2),
      ('2, 3, 5, 8, 12, ?', ['15', '16', '17', '18'], 2),
      ('1, 8, 27, 64, ?', ['100', '125', '150', '175'], 1),
      ('1, 2, 4, 8, ?', ['10', '12', '14', '16'], 3),
      ('5, 9, 14, 20, 27, ?', ['33', '34', '35', '36'], 2),
      ('3, 6, 11, 18, 27, ?', ['36', '38', '40', '42'], 1),
      ('2, 5, 10, 17, 26, ?', ['35', '37', '39', '41'], 1),
      ('4, 6, 9, 13, 18, ?', ['22', '23', '24', '25'], 2),
      ('1, 4, 10, 20, 35, ?', ['50', '55', '56', '60'], 2),
      ('2, 6, 14, 30, 62, ?', ['124', '126', '128', '130'], 1),
    ] : [
      ('2, 3, 5, 7, 11, ?', ['12', '13', '14', '15'], 1),
      ('1, 8, 27, 64, ?', ['100', '125', '150', '200'], 1),
      ('3, 6, 12, 24, ?', ['36', '40', '48', '50'], 2),
      ('1, 4, 27, 256, ?', ['625', '1024', '2048', '3125'], 3),
      ('2, 6, 18, 54, ?', ['108', '126', '162', '180'], 2),
      ('1, 2, 6, 24, 120, ?', ['240', '480', '600', '720'], 3),
      ('1, 1, 2, 3, 5, 8, 13, ?', ['18', '20', '21', '24'], 2),
      ('1, 2, 4, 8, 16, 32, ?', ['48', '56', '64', '72'], 2),
      ('2, 3, 5, 9, 17, ?', ['31', '33', '35', '37'], 1),
      ('1, 3, 7, 15, 31, ?', ['47', '55', '63', '71'], 2),
      ('4, 9, 25, 49, 121, ?', ['144', '169', '196', '225'], 1),
      ('1, 4, 9, 25, 36, ?', ['49', '64', '81', '100'], 0),
      ('3, 5, 11, 29, 83, ?', ['167', '197', '227', '245'], 3),
      ('2, 9, 28, 65, 126, ?', ['189', '215', '217', '243'], 2),
      ('5, 11, 23, 47, 95, ?', ['143', '175', '191', '215'], 2),
      ('1, 4, 13, 40, 121, ?', ['244', '324', '364', '404'], 2),
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
    
    final matrices = level == CCATLevel.level10 ? [
      ('Shape Pattern: Circle -> Sphere. Square -> ?', ['Cube', 'Triangle', 'Line', 'Point'], 0),
      ('Color Pattern: Red -> Pink. Blue -> ?', ['Sky Blue', 'Green', 'Purple', 'Orange'], 0),
      ('Size Pattern: Big -> Small. Tall -> ?', ['Short', 'Wide', 'Fat', 'Long'], 0),
      ('Direction: Up -> Down. Left -> ?', ['Right', 'Center', 'North', 'South'], 0),
      ('Texture: Rough -> Smooth. Hard -> ?', ['Soft', 'Solid', 'Rock', 'Stone'], 0),
      ('Number: One -> 1. Two -> ?', ['2', '3', '4', 'II'], 0),
      ('Season: Winter -> Cold. Summer -> ?', ['Hot', 'Snow', 'Rain', 'Wind'], 0),
      ('Animal: Dog -> Bark. Cat -> ?', ['Meow', 'Roar', 'Chirp', 'Howl'], 0),
      ('Shape Sides: Triangle -> 3. Pentagon -> ?', ['5', '4', '6', '7'], 0),
      ('Fruit Color: Apple -> Red. Banana -> ?', ['Yellow', 'Green', 'Orange', 'Purple'], 0),
      ('Body Part: Hand -> Fingers. Foot -> ?', ['Toes', 'Arms', 'Legs', 'Knees'], 0),
      ('Transport: Road -> Car. Water -> ?', ['Boat', 'Plane', 'Train', 'Bus'], 0),
      ('Day: Monday -> 1st. Wednesday -> ?', ['3rd', '2nd', '4th', '5th'], 0),
      ('Animal Home: Bird -> Nest. Bee -> ?', ['Hive', 'Den', 'Cage', 'Barn'], 0),
      ('Tool: Cut -> Scissors. Hammer -> ?', ['Nail', 'Screw', 'Saw', 'Drill'], 0),
      ('Weather: Rain -> Umbrella. Sun -> ?', ['Hat', 'Coat', 'Boots', 'Gloves'], 0),
    ] : level == CCATLevel.level11 ? [
      ('Pattern: Circle, Square, Triangle. Square, Triangle, ?', ['Circle', 'Rectangle', 'Pentagon', 'Oval'], 0),
      ('Rotation: N -> Z. C -> ?', ['Reversed C', 'O', 'D', 'G'], 0),
      ('Mirror: b -> d. p -> ?', ['q', 'b', 'd', 'g'], 0),
      ('Sequence: □■□ -> ■□■. ○●○ -> ?', ['●○●', '○○○', '●●●', '○●○'], 0),
      ('Addition: △ + △ = 2△. □ + □ + □ = ?', ['3□', '2□', '4□', '□'], 0),
      ('Subtraction: ●●●● - ● = ?', ['●●●', '●●', '●●●●●', '●'], 0),
      ('Fold: Paper -> Crease. Water -> ?', ['Wave', 'Ice', 'Steam', 'Drop'], 0),
      ('Scale: Map -> Reduce. Microscope -> ?', ['Enlarge', 'Shrink', 'Flatten', 'Twist'], 0),
      ('Grid: 2x2 -> 4 squares. 3x3 -> ?', ['9 squares', '6 squares', '8 squares', '12 squares'], 0),
      ('Fraction: Half -> 1/2. Quarter -> ?', ['1/4', '1/3', '1/5', '2/4'], 0),
      ('Angle: Right -> 90°. Straight -> ?', ['180°', '90°', '45°', '360°'], 0),
      ('3D Shape: Square -> Cube. Circle -> ?', ['Sphere', 'Cylinder', 'Cone', 'Pyramid'], 0),
      ('Symmetry: Line -> Vertical. Turn -> ?', ['Rotational', 'Horizontal', 'Diagonal', 'Point'], 0),
      ('Graph: Points -> Scatter. Bars -> ?', ['Bar chart', 'Line graph', 'Pie chart', 'Table'], 0),
      ('Volume: Length x Width = Area. Area x Height = ?', ['Volume', 'Perimeter', 'Surface', 'Diagonal'], 0),
      ('Perspective: Front -> Top. Side -> ?', ['Bottom', 'Back', 'Front', 'Top'], 1),
    ] : [
      ('Transformation: ABCD -> DCBA. 1234 -> ?', ['4321', '2143', '3412', '1324'], 0),
      ('Matrix Logic: If A+B=C, then C-B=?', ['A', 'B', 'C', 'D'], 0),
      ('Pattern Rule: 2,4,8 follows x2. 3,9,27 follows ?', ['x3', 'x2', '+6', '+9'], 0),
      ('Set Theory: Inside circle only -> A. Outside only -> B. Overlap -> ?', ['A∩B', 'A∪B', 'A-B', 'B-A'], 0),
      ('Coordinate: (0,0) -> Origin. (3,4) -> ?', ['Quadrant I', 'Quadrant II', 'Quadrant III', 'Quadrant IV'], 0),
      ('Vector: East 3 + North 4 = ?', ['5 NE', '7 NE', '12 NE', '1 NE'], 0),
      ('Probability: Certain -> 1. Impossible -> ?', ['0', '0.5', '-1', '2'], 0),
      ('Function: f(x)=2x. f(3)=?', ['6', '5', '9', '8'], 0),
      ('Logic Gate: AND -> Both true. OR -> ?', ['At least one true', 'Both false', 'Neither', 'All false'], 0),
      ('Binary: 2 -> 10. 5 -> ?', ['101', '110', '011', '111'], 0),
      ('Tessellation: Square -> Tiles perfectly. Pentagon -> ?', ['Gaps', 'Perfect', 'Overlap', 'Identical'], 0),
      ('Topology: Donut -> Torus. Ball -> ?', ['Sphere', 'Cube', 'Cylinder', 'Cone'], 0),
      ('Fractal: Zoom in -> Same pattern. Scale -> ?', ['Self-similar', 'Different', 'Random', 'Linear'], 0),
      ('Isometry: Slide -> Translation. Flip -> ?', ['Reflection', 'Rotation', 'Dilation', 'Shear'], 0),
      ('Graph Theory: Points -> Vertices. Lines -> ?', ['Edges', 'Faces', 'Angles', 'Curves'], 0),
      ('Complex Pattern: AB|CD → DC|BA. 12|34 → ?', ['43|21', '21|43', '34|12', '12|34'], 0),
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
    
    final items = level == CCATLevel.level10 ? [
      ('Which shape is different?', ['Circle', 'Square', 'Triangle', 'Rectangle'], 0),
      ('Which object is different?', ['Ball', 'Box', 'Dice', 'Brick'], 0),
      ('Which direction is different?', ['North', 'South', 'East', 'Up'], 3),
      ('Which line is different?', ['Straight', 'Curved', 'Zigzag', 'Dotted'], 3),
      ('Which symmetry is different?', ['H', 'A', 'M', 'P'], 3),
      ('Which number is different?', ['2', '4', '6', '7'], 3),
      ('Which letter is different?', ['A', 'E', 'I', 'B'], 3),
      ('Which color is different?', ['Red', 'Blue', 'Yellow', 'Green'], 3),
      ('Which animal is different?', ['Dog', 'Cat', 'Bird', 'Fish'], 2),
      ('Which fruit is different?', ['Apple', 'Orange', 'Banana', 'Carrot'], 3),
      ('Which vehicle is different?', ['Car', 'Bus', 'Truck', 'Bicycle'], 3),
      ('Which shape has corners?', ['Circle', 'Oval', 'Ellipse', 'Square'], 3),
      ('Which is NOT a primary color?', ['Red', 'Blue', 'Yellow', 'Green'], 3),
      ('Which does NOT fly?', ['Bird', 'Plane', 'Butterfly', 'Fish'], 3),
      ('Which is NOT round?', ['Ball', 'Sun', 'Moon', 'Box'], 3),
      ('Which is NOT a day?', ['Monday', 'Friday', 'June', 'Sunday'], 2),
    ] : level == CCATLevel.level11 ? [
      ('Which has a different number of sides?', ['Triangle', 'Square', 'Pentagon', 'Hexagon'], 0),
      ('Which is NOT a polygon?', ['Triangle', 'Square', 'Circle', 'Pentagon'], 2),
      ('Which angle is different?', ['Acute', 'Right', 'Obtuse', 'Curved'], 3),
      ('Which transformation is different?', ['Slide', 'Flip', 'Turn', 'Stretch'], 3),
      ('Which is NOT a solid?', ['Cube', 'Sphere', 'Cone', 'Circle'], 3),
      ('Which pattern is different?', ['ABAB', 'CDCD', 'EFEF', 'GHIJ'], 3),
      ('Which has rotational symmetry?', ['N', 'S', 'T', 'L'], 1),
      ('Which fraction is different?', ['1/2', '2/4', '3/6', '2/3'], 3),
      ('Which is NOT parallel?', ['=', '||', '///', 'X'], 3),
      ('Which shape tessellates?', ['Circle', 'Pentagon', 'Square', 'Oval'], 2),
      ('Which has line symmetry?', ['A', 'B', 'C', 'F'], 0),
      ('Which is a right angle?', ['45°', '90°', '120°', '180°'], 1),
      ('Which is NOT perpendicular?', ['L', 'T', '+', 'V'], 3),
      ('Which has 4 faces?', ['Tetrahedron', 'Cube', 'Octahedron', 'Sphere'], 0),
      ('Which is a prime number?', ['4', '6', '7', '9'], 2),
      ('Which sequence is different?', ['1,2,3', '2,4,6', '3,6,9', '1,3,5'], 3),
    ] : [
      ('Which is NOT a Platonic solid?', ['Tetrahedron', 'Cube', 'Sphere', 'Dodecahedron'], 2),
      ('Which has infinite symmetry?', ['Square', 'Circle', 'Triangle', 'Pentagon'], 1),
      ('Which is transcendental?', ['√2', 'π', '3/4', '√3'], 1),
      ('Which is NOT a conic section?', ['Circle', 'Parabola', 'Hyperbola', 'Helix'], 3),
      ('Which is a topological property?', ['Size', 'Connectedness', 'Angle', 'Length'], 1),
      ('Which has Euler characteristic 2?', ['Torus', 'Sphere', 'Möbius strip', 'Klein bottle'], 1),
      ('Which transformation preserves area?', ['Dilation', 'Rotation', 'Scaling', 'Stretching'], 1),
      ('Which is NOT a fractal dimension?', ['1.26', '2', '1.5', 'i'], 3),
      ('Which is an irrational number?', ['3/4', '0.5', '√2', '1.5'], 2),
      ('Which group has 4 elements?', ['Z₂', 'Z₃', 'Z₄', 'Z₅'], 2),
      ('Which is a golden ratio?', ['1.414', '1.618', '2.718', '3.14'], 1),
      ('Which is NOT symmetric?', ['○', '□', '△', 'F'], 3),
      ('Which angle is in radians?', ['90°', '180°', 'π', '45°'], 2),
      ('Which is a perfect square?', ['15', '16', '17', '18'], 1),
      ('Which has bilateral symmetry?', ['Starfish', 'Human', 'Jellyfish', 'Sea urchin'], 1),
      ('Which is a complex number?', ['π', 'e', '3+4i', '√2'], 2),
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
    
    final series = level == CCATLevel.level10 ? [
      ('Sequence: | , || , ||| , ?', ['||||', '||', '|', 'V'], 0),
      ('Sequence: O , OO , OOO , ?', ['OOOO', 'O', '0', '8'], 0),
      ('Sequence: A , C , E , ?', ['G', 'F', 'H', 'I'], 0),
      ('Sequence: 12:00 , 12:15 , 12:30 , ?', ['12:45', '12:40', '1:00', '12:35'], 0),
      ('Sequence: North , East , South , ?', ['West', 'North', 'Up', 'Down'], 0),
      ('Sequence: ● , ●● , ●●● , ?', ['●●●●', '●●', '●', '●●●●●'], 0),
      ('Sequence: △ , □ , ⬠ , ?', ['⬡', '○', '△', '□'], 0),
      ('Sequence: 1st , 2nd , 3rd , ?', ['4th', '5th', '3rd', '2nd'], 0),
      ('Sequence: Small , Medium , Large , ?', ['Extra Large', 'Small', 'Tiny', 'Medium'], 0),
      ('Sequence: Morning , Afternoon , Evening , ?', ['Night', 'Morning', 'Noon', 'Dawn'], 0),
      ('Sequence: Monday , Wednesday , Friday , ?', ['Sunday', 'Saturday', 'Thursday', 'Tuesday'], 0),
      ('Sequence: January , April , July , ?', ['October', 'August', 'September', 'November'], 0),
      ('Sequence: + , - , × , ?', ['÷', '+', '=', '%'], 0),
      ('Sequence: ♠ , ♥ , ♦ , ?', ['♣', '♠', '♥', '★'], 0),
      ('Sequence: Red , Orange , Yellow , ?', ['Green', 'Blue', 'Red', 'Purple'], 0),
      ('Sequence: Baby , Child , Teen , ?', ['Adult', 'Baby', 'Child', 'Elder'], 0),
    ] : level == CCATLevel.level11 ? [
      ('Sequence: 1 , 4 , 9 , 16 , ?', ['25', '20', '24', '36'], 0),
      ('Sequence: 2 , 4 , 8 , 16 , ?', ['32', '24', '20', '18'], 0),
      ('Sequence: A1 , B2 , C3 , ?', ['D4', 'E5', 'D3', 'C4'], 0),
      ('Sequence: □ , □□ , □□□ , □□□□ , ?', ['□□□□□', '□□□', '□□', '□'], 0),
      ('Sequence: ↑ , → , ↓ , ?', ['←', '↑', '↗', '↘'], 0),
      ('Sequence: 90° , 180° , 270° , ?', ['360°', '45°', '90°', '270°'], 0),
      ('Sequence: AB , CD , EF , ?', ['GH', 'HI', 'FG', 'EF'], 0),
      ('Sequence: 1/2 , 1/4 , 1/8 , ?', ['1/16', '1/6', '1/10', '1/12'], 0),
      ('Sequence: ○● , ●○○ , ○○○● , ?', ['●○○○○', '○●', '●●●●', '○○●●'], 0),
      ('Sequence: 3 , 6 , 12 , 24 , ?', ['48', '36', '30', '42'], 0),
      ('Sequence: Z , Y , X , W , ?', ['V', 'U', 'X', 'A'], 0),
      ('Sequence: □○ , □□○○ , □□□○○○ , ?', ['□□□□○○○○', '□○□○', '○□○□', '□□○○'], 0),
      ('Sequence: 100 , 81 , 64 , 49 , ?', ['36', '25', '16', '9'], 0),
      ('Sequence: Sun , Mon , Tue , Wed , ?', ['Thu', 'Fri', 'Sat', 'Sun'], 0),
      ('Sequence: NE , SE , SW , ?', ['NW', 'NE', 'N', 'S'], 0),
      ('Sequence: 5 , 10 , 20 , 35 , ?', ['55', '50', '45', '60'], 0),
    ] : [
      ('Sequence: 1 , 1 , 2 , 3 , 5 , 8 , ?', ['13', '11', '10', '12'], 0),
      ('Sequence: 2 , 3 , 5 , 7 , 11 , ?', ['13', '12', '14', '15'], 0),
      ('Sequence: 1 , 8 , 27 , 64 , ?', ['125', '100', '81', '216'], 0),
      ('Sequence: a² , b² , c² , ?', ['d²', 'a³', 'b³', 'ab'], 0),
      ('Sequence: 2^1 , 2^2 , 2^3 , 2^4 , ?', ['2^5', '2^6', '3^5', '4^5'], 0),
      ('Sequence: log₁₀(10) , log₁₀(100) , log₁₀(1000) , ?', ['log₁₀(10000)', 'log₁₀(500)', 'log₁₀(2000)', 'log₁₀(5000)'], 0),
      ('Sequence: π/6 , π/4 , π/3 , ?', ['π/2', 'π', '2π', 'π/5'], 0),
      ('Sequence: sin(0°) , sin(30°) , sin(60°) , ?', ['sin(90°)', 'sin(45°)', 'sin(120°)', 'sin(180°)'], 0),
      ('Sequence: n! for n=1,2,3,4 is 1,2,6,24, ?', ['120', '100', '96', '48'], 0),
      ('Sequence: √1 , √4 , √9 , √16 , ?', ['√25', '√20', '√18', '√36'], 0),
      ('Sequence: 1/1 , 1/2 , 2/3 , 3/5 , ?', ['5/8', '4/7', '3/4', '4/6'], 0),
      ('Sequence: e⁰ , e¹ , e² , ?', ['e³', 'e⁴', '3e', '2e'], 0),
      ('Sequence: i⁰ , i¹ , i² , i³ , ?', ['i⁴', '1', '-1', '-i'], 1),
      ('Sequence: ∑n (n=1 to 1,2,3,4) = 1,3,6,10, ?', ['15', '14', '12', '16'], 0),
      ('Sequence: Δ¹ , Δ² , Δ³ , ?', ['Δ⁴', 'Δ⁵', '4Δ', 'Δ+4'], 0),
      ('Sequence: (1,1) , (2,4) , (3,9) , ?', ['(4,16)', '(4,12)', '(5,25)', '(3,6)'], 0),
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
