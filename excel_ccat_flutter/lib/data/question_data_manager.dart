import 'dart:math';
import 'package:flutter/material.dart';
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
    
    if (level == CCATLevel.levelK) {
      return _createKindergartenQuestions();
    }

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
      ('Dog is to puppy as cat is to:', 'Chien est à chiot ce que chat est à:', ['kitten', 'mouse', 'bird', 'fish'], ['chaton', 'souris', 'oiseau', 'poisson'], 0),
      ('Big is to small as tall is to:', 'Grand est à petit ce que haut est à:', ['short', 'wide', 'long', 'thin'], ['court', 'large', 'long', 'mince'], 0),
      ('Sun is to day as moon is to:', 'Soleil est à jour ce que lune est à:', ['night', 'star', 'sky', 'cloud'], ['nuit', 'étoile', 'ciel', 'nuage'], 0),
      ('Hand is to glove as foot is to:', 'Main est à gant ce que pied est à:', ['sock', 'shoe', 'leg', 'toe'], ['chaussette', 'chaussure', 'jambe', 'orteil'], 1),
      ('Bird is to fly as fish is to:', 'Oiseau est à voler ce que poisson est à:', ['swim', 'walk', 'run', 'jump'], ['nager', 'marcher', 'courir', 'sauter'], 0),
      ('Apple is to fruit as carrot is to:', 'Pomme est à fruit ce que carotte est à:', ['vegetable', 'orange', 'food', 'plant'], ['légume', 'orange', 'nourriture', 'plante'], 0),
      ('Ear is to hear as eye is to:', 'Oreille est à entendre ce que œil est à:', ['see', 'blink', 'cry', 'close'], ['voir', 'cligner', 'pleurer', 'fermer'], 0),
      ('Pen is to write as brush is to:', 'Stylo est à écrire ce que pinceau est à:', ['paint', 'clean', 'sweep', 'draw'], ['peindre', 'nettoyer', 'balayer', 'dessiner'], 0),
      ('Cow is to calf as horse is to:', 'Vache est à veau ce que cheval est à:', ['foal', 'pony', 'mare', 'stallion'], ['poulain', 'poney', 'jument', 'étalon'], 0),
      ('Book is to read as song is to:', 'Livre est à lire ce que chanson est à:', ['listen', 'write', 'dance', 'play'], ['écouter', 'écrire', 'danser', 'jouer'], 0),
      ('Hot is to cold as day is to:', 'Chaud est à froid ce que jour est à:', ['night', 'sun', 'warm', 'light'], ['nuit', 'soleil', 'chaud', 'lumière'], 0),
      ('Teacher is to school as doctor is to:', 'Enseignant est à école ce que médecin est à:', ['hospital', 'medicine', 'patient', 'nurse'], ['hôpital', 'médicament', 'patient', 'infirmière'], 0),
      ('Knife is to cut as hammer is to:', 'Couteau est à couper ce que marteau est à:', ['nail', 'build', 'hit', 'wood'], ['clouer', 'construire', 'frapper', 'bois'], 0),
      ('Snow is to winter as rain is to:', 'Neige est à hiver ce que pluie est à:', ['spring', 'cloud', 'umbrella', 'wet'], ['printemps', 'nuage', 'parapluie', 'mouillé'], 0),
      ('Bee is to honey as cow is to:', 'Abeille est à miel ce que vache est à:', ['milk', 'grass', 'farm', 'beef'], ['lait', 'herbe', 'ferme', 'bœuf'], 0),
      ('Piano is to keys as guitar is to:', 'Piano est à touches ce que guitare est à:', ['strings', 'music', 'wood', 'pick'], ['cordes', 'musique', 'bois', 'médiator'], 0),
    ] : level == CCATLevel.level11 ? [
      ('Author is to book as composer is to:', 'Auteur est à livre ce que compositeur est à:', ['song', 'instrument', 'concert', 'band'], ['chanson', 'instrument', 'concert', 'groupe'], 0),
      ('Library is to books as museum is to:', 'Bibliothèque est à livres ce que musée est à:', ['artifacts', 'tickets', 'guides', 'visitors'], ['artefacts', 'billets', 'guides', 'visiteurs'], 0),
      ('Chef is to kitchen as pilot is to:', 'Chef est à cuisine ce que pilote est à:', ['cockpit', 'plane', 'airport', 'sky'], ['cockpit', 'avion', 'aéroport', 'ciel'], 0),
      ('Brush is to paint as pen is to:', 'Pinceau est à peindre ce que stylo est à:', ['ink', 'paper', 'write', 'letter'], ['encre', 'papier', 'écrire', 'lettre'], 0),
      ('Doctor is to patient as teacher is to:', 'Médecin est à patient ce que enseignant est à:', ['student', 'school', 'book', 'class'], ['élève', 'école', 'livre', 'classe'], 0),
      ('Thermometer is to temperature as scale is to:', 'Thermomètre est à température ce que balance est à:', ['weight', 'height', 'length', 'time'], ['poids', 'taille', 'longueur', 'temps'], 0),
      ('Seed is to plant as egg is to:', 'Graine est à plante ce que œuf est à:', ['bird', 'chicken', 'nest', 'shell'], ['oiseau', 'poulet', 'nid', 'coquille'], 0),
      ('Clock is to time as compass is to:', 'Horloge est à temps ce que boussole est à:', ['direction', 'north', 'map', 'travel'], ['direction', 'nord', 'carte', 'voyage'], 0),
      ('Captain is to ship as conductor is to:', 'Capitaine est à navire ce que chef d\'orchestre est à:', ['orchestra', 'train', 'music', 'baton'], ['orchestre', 'train', 'musique', 'bâton'], 0),
      ('Astronomer is to stars as geologist is to:', 'Astronome est à étoiles ce que géologue est à:', ['rocks', 'maps', 'weather', 'animals'], ['roches', 'cartes', 'météo', 'animaux'], 0),
      ('Brake is to stop as accelerator is to:', 'Frein est à arrêter ce que accélérateur est à:', ['speed', 'slow', 'car', 'drive'], ['vitesse', 'ralentir', 'voiture', 'conduire'], 0),
      ('Prologue is to book as overture is to:', 'Prologue est à livre ce que ouverture est à:', ['opera', 'end', 'music', 'play'], ['opéra', 'fin', 'musique', 'pièce'], 0),
      ('Flock is to sheep as pack is to:', 'Troupeau est à moutons ce que meute est à:', ['wolves', 'birds', 'fish', 'bees'], ['loups', 'oiseaux', 'poissons', 'abeilles'], 0),
      ('Telescope is to stars as microscope is to:', 'Télescope est à étoiles ce que microscope est à:', ['cells', 'planets', 'eyes', 'light'], ['cellules', 'planètes', 'yeux', 'lumière'], 0),
      ('Carpenter is to wood as blacksmith is to:', 'Charpentier est à bois ce que forgeron est à:', ['metal', 'fire', 'horse', 'tools'], ['métal', 'feu', 'cheval', 'outils'], 0),
      ('Chapter is to book as act is to:', 'Chapitre est à livre ce que acte est à:', ['play', 'movie', 'scene', 'story'], ['pièce', 'film', 'scène', 'histoire'], 0),
    ] : [
      ('Ephemeral is to permanent as volatile is to:', 'Éphémère est à permanent ce que volatil est à:', ['stable', 'explosive', 'liquid', 'gas'], ['stable', 'explosif', 'liquide', 'gaz'], 0),
      ('Meticulous is to careless as frugal is to:', 'Méticuleux est à négligent ce que frugal est à:', ['wasteful', 'careful', 'poor', 'rich'], ['gaspilleur', 'prudent', 'pauvre', 'riche'], 0),
      ('Archipelago is to islands as constellation is to:', 'Archipel est à îles ce que constellation est à:', ['stars', 'planets', 'galaxies', 'moons'], ['étoiles', 'planètes', 'galaxies', 'lunes'], 0),
      ('Taciturn is to talkative as somber is to:', 'Taciturne est à bavard ce que sombre est à:', ['cheerful', 'dark', 'serious', 'quiet'], ['joyeux', 'foncé', 'sérieux', 'calme'], 0),
      ('Chronometer is to time as barometer is to:', 'Chronomètre est à temps ce que baromètre est à:', ['pressure', 'temperature', 'distance', 'speed'], ['pression', 'température', 'distance', 'vitesse'], 0),
      ('Plaintiff is to defendant as prosecutor is to:', 'Plaignant est à défendeur ce que procureur est à:', ['accused', 'judge', 'lawyer', 'jury'], ['accusé', 'juge', 'avocat', 'jury'], 0),
      ('Prologue is to epilogue as dawn is to:', 'Prologue est à épilogue ce que aube est à:', ['dusk', 'morning', 'night', 'noon'], ['crépuscule', 'matin', 'nuit', 'midi'], 0),
      ('Catalyst is to reaction as stimulus is to:', 'Catalyseur est à réaction ce que stimulus est à:', ['response', 'chemical', 'change', 'speed'], ['réponse', 'chimique', 'changement', 'vitesse'], 0),
      ('Lexicon is to words as atlas is to:', 'Lexique est à mots ce que atlas est à:', ['maps', 'books', 'countries', 'geography'], ['cartes', 'livres', 'pays', 'géographie'], 0),
      ('Apiary is to bees as aviary is to:', 'Rucher est à abeilles ce que volière est à:', ['birds', 'ants', 'fish', 'plants'], ['oiseaux', 'fourmis', 'poissons', 'plantes'], 0),
      ('Numismatist is to coins as philatelist is to:', 'Numismate est à pièces ce que philatéliste est à:', ['stamps', 'books', 'art', 'antiques'], ['timbres', 'livres', 'art', 'antiquités'], 0),
      ('Zenith is to nadir as apex is to:', 'Zénith est à nadir ce que sommet est à:', ['base', 'top', 'middle', 'side'], ['base', 'haut', 'milieu', 'côté'], 0),
      ('Maelstrom is to water as tornado is to:', 'Maelström est à eau ce que tornade est à:', ['air', 'earth', 'fire', 'wind'], ['air', 'terre', 'feu', 'vent'], 0),
      ('Ameliorate is to worsen as expedite is to:', 'Améliorer est à empirer ce que expédier est à:', ['delay', 'hurry', 'improve', 'send'], ['retarder', 'se dépêcher', 'améliorer', 'envoyer'], 0),
      ('Pedagogue is to teaching as demagogue is to:', 'Pédagogue est à enseignement ce que démagogue est à:', ['manipulation', 'democracy', 'speaking', 'leading'], ['manipulation', 'démocratie', 'parler', 'diriger'], 0),
      ('Ornithology is to birds as entomology is to:', 'Ornithologie est à oiseaux ce que entomologie est à:', ['insects', 'rocks', 'plants', 'fish'], ['insectes', 'roches', 'plantes', 'poissons'], 0),
    ];

    for (var i = 0; i < analogies.length; i++) {
      final (stem, stemFr, options, optionsFr, correct) = analogies[i];
      questions.add(Question(
        id: '${level.value}_verbal_analogies_$i',
        type: QuestionType.verbal,
        subType: VerbalSubType.analogies.value,
        stem: stem,
        stemFrench: stemFr,
        options: options,
        optionsFrench: optionsFr,
        correctAnswer: correct,
        explanation: 'The correct answer is ${options[correct]}.',
        explanationFrench: 'La bonne réponse est ${optionsFr[correct]}.',
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
      ('Which word means the same as HAPPY?', 'Quel mot signifie la même chose que HEUREUX?', ['joyful', 'angry', 'tired', 'scared'], ['joyeux', 'fâché', 'fatigué', 'effrayé'], 0),
      ('Which word means the same as BIG?', 'Quel mot signifie la même chose que GRAND?', ['large', 'small', 'tiny', 'thin'], ['grand', 'petit', 'minuscule', 'mince'], 0),
      ('Which word means the same as FAST?', 'Quel mot signifie la même chose que RAPIDE?', ['quick', 'slow', 'lazy', 'late'], ['rapide', 'lent', 'paresseux', 'tard'], 0),
      ('Which word means the same as COLD?', 'Quel mot signifie la même chose que FROID?', ['chilly', 'hot', 'warm', 'bright'], ['frais', 'chaud', 'tiède', 'brillant'], 0),
      ('Which word means the same as NICE?', 'Quel mot signifie la même chose que GENTIL?', ['kind', 'mean', 'ugly', 'loud'], ['aimable', 'méchant', 'laid', 'bruyant'], 0),
      ('Which word means the same as SMART?', 'Quel mot signifie la même chose que INTELLIGENT?', ['clever', 'dumb', 'slow', 'weak'], ['malin', 'bête', 'lent', 'faible'], 0),
      ('Which word means the same as QUIET?', 'Quel mot signifie la même chose que CALME?', ['silent', 'loud', 'noisy', 'busy'], ['silencieux', 'bruyant', 'bruyant', 'occupé'], 0),
      ('Which word means the same as LITTLE?', 'Quel mot signifie la même chose que PETIT?', ['small', 'huge', 'giant', 'tall'], ['petit', 'énorme', 'géant', 'grand'], 0),
      ('Which word means the same as ANGRY?', 'Quel mot signifie la même chose que FÂCHÉ?', ['mad', 'calm', 'happy', 'sad'], ['furieux', 'calme', 'heureux', 'triste'], 0),
      ('Which word means the same as PRETTY?', 'Quel mot signifie la même chose que JOLI?', ['beautiful', 'ugly', 'plain', 'dull'], ['beau', 'laid', 'quelconque', 'terne'], 0),
      ('Which word means the same as FUNNY?', 'Quel mot signifie la même chose que DRÔLE?', ['amusing', 'boring', 'sad', 'serious'], ['amusant', 'ennuyeux', 'triste', 'sérieux'], 0),
      ('Which word means the same as SLEEPY?', 'Quel mot signifie la même chose que ENDORMI?', ['drowsy', 'awake', 'alert', 'active'], ['somnolent', 'éveillé', 'alerte', 'actif'], 0),
      ('Which word means the same as RICH?', 'Quel mot signifie la même chose que RICHE?', ['wealthy', 'poor', 'broke', 'needy'], ['fortuné', 'pauvre', 'fauché', 'nécessiteux'], 0),
      ('Which word means the same as EASY?', 'Quel mot signifie la même chose que FACILE?', ['simple', 'hard', 'difficult', 'tough'], ['simple', 'dur', 'difficile', 'coriace'], 0),
      ('Which word means the same as BRAVE?', 'Quel mot signifie la même chose que COURAGEUX?', ['fearless', 'scared', 'afraid', 'timid'], ['intrépide', 'effrayé', 'peureux', 'timide'], 0),
      ('Which word means the same as DIRTY?', 'Quel mot signifie la même chose que SALE?', ['filthy', 'clean', 'neat', 'tidy'], ['crasseux', 'propre', 'soigné', 'rangé'], 0),
    ] : level == CCATLevel.level11 ? [
      ('Which word means the same as ABUNDANT?', 'Quel mot signifie la même chose que ABONDANT?', ['plentiful', 'scarce', 'empty', 'rare'], ['copieux', 'rare', 'vide', 'rare'], 0),
      ('Which word means the same as BRAVE?', 'Quel mot signifie la même chose que COURAGEUX?', ['courageous', 'fearful', 'timid', 'weak'], ['courageux', 'craintif', 'timide', 'faible'], 0),
      ('Which word means the same as ASSIST?', 'Quel mot signifie la même chose que AIDER?', ['help', 'hinder', 'stop', 'leave'], ['aider', 'gêner', 'arrêter', 'partir'], 0),
      ('Which word means the same as ANCIENT?', 'Quel mot signifie la même chose que ANCIEN?', ['old', 'new', 'modern', 'recent'], ['vieux', 'nouveau', 'moderne', 'récent'], 0),
      ('Which word means the same as CONCEAL?', 'Quel mot signifie la même chose que DISSIMULER?', ['hide', 'reveal', 'show', 'expose'], ['cacher', 'révéler', 'montrer', 'exposer'], 0),
      ('Which word means the same as DEPART?', 'Quel mot signifie la même chose que PARTIR?', ['leave', 'arrive', 'stay', 'remain'], ['quitter', 'arriver', 'rester', 'demeurer'], 0),
      ('Which word means the same as EXHAUSTED?', 'Quel mot signifie la même chose que ÉPUISÉ?', ['tired', 'energetic', 'lively', 'rested'], ['fatigué', 'énergique', 'vif', 'reposé'], 0),
      ('Which word means the same as FORTUNATE?', 'Quel mot signifie la même chose que FORTUNÉ?', ['lucky', 'unlucky', 'poor', 'sad'], ['chanceux', 'malchanceux', 'pauvre', 'triste'], 0),
      ('Which word means the same as GENUINE?', 'Quel mot signifie la même chose que AUTHENTIQUE?', ['authentic', 'fake', 'false', 'phony'], ['authentique', 'faux', 'faux', 'bidon'], 0),
      ('Which word means the same as HAZARDOUS?', 'Quel mot signifie la même chose que DANGEREUX?', ['dangerous', 'safe', 'secure', 'harmless'], ['dangereux', 'sûr', 'sécurisé', 'inoffensif'], 0),
      ('Which word means the same as IMITATE?', 'Quel mot signifie la même chose que IMITER?', ['copy', 'create', 'invent', 'originate'], ['copier', 'créer', 'inventer', 'concevoir'], 0),
      ('Which word means the same as JEALOUS?', 'Quel mot signifie la même chose que JALOUX?', ['envious', 'content', 'satisfied', 'pleased'], ['envieux', 'content', 'satisfait', 'ravi'], 0),
      ('Which word means the same as KEEN?', 'Quel mot signifie la même chose que VIF?', ['eager', 'reluctant', 'bored', 'lazy'], ['avide', 'réticent', 'ennuyé', 'paresseux'], 0),
      ('Which word means the same as LIBERTY?', 'Quel mot signifie la même chose que LIBERTÉ?', ['freedom', 'prison', 'captivity', 'bondage'], ['liberté', 'prison', 'captivité', 'servitude'], 0),
      ('Which word means the same as MAGNIFICENT?', 'Quel mot signifie la même chose que MAGNIFIQUE?', ['splendid', 'ordinary', 'plain', 'simple'], ['splendide', 'ordinaire', 'quelconque', 'simple'], 0),
      ('Which word means the same as NUMEROUS?', 'Quel mot signifie la même chose que NOMBREUX?', ['many', 'few', 'single', 'rare'], ['beaucoup', 'peu', 'unique', 'rare'], 0),
    ] : [
      ('Which word means the same as UBIQUITOUS?', 'Quel mot signifie la même chose que OMNIPRÉSENT?', ['omnipresent', 'rare', 'scarce', 'limited'], ['omniprésent', 'rare', 'rare', 'limité'], 0),
      ('Which word means the same as EPHEMERAL?', 'Quel mot signifie la même chose que ÉPHÉMÈRE?', ['transient', 'permanent', 'lasting', 'enduring'], ['transitoire', 'permanent', 'durable', 'persistant'], 0),
      ('Which word means the same as BENEVOLENT?', 'Quel mot signifie la même chose que BIENVEILLANT?', ['kind', 'malicious', 'cruel', 'harsh'], ['gentil', 'malveillant', 'cruel', 'dur'], 0),
      ('Which word means the same as CACOPHONY?', 'Quel mot signifie la même chose que CACOPHONIE?', ['discord', 'harmony', 'melody', 'rhythm'], ['discorde', 'harmonie', 'mélodie', 'rythme'], 0),
      ('Which word means the same as ARDUOUS?', 'Quel mot signifie la même chose que ARDU?', ['difficult', 'easy', 'simple', 'effortless'], ['difficile', 'facile', 'simple', 'sans effort'], 0),
      ('Which word means the same as AMELIORATE?', 'Quel mot signifie la même chose que AMÉLIORER?', ['improve', 'worsen', 'destroy', 'neglect'], ['améliorer', 'empirer', 'détruire', 'négliger'], 0),
      ('Which word means the same as COGENT?', 'Quel mot signifie la même chose que CONVAINCANT?', ['convincing', 'weak', 'unclear', 'confusing'], ['convaincant', 'faible', 'pas clair', 'confus'], 0),
      ('Which word means the same as DILATORY?', 'Quel mot signifie la même chose que DILATOIRE?', ['slow', 'prompt', 'quick', 'hasty'], ['lent', 'prompt', 'rapide', 'hâtif'], 0),
      ('Which word means the same as ERUDITE?', 'Quel mot signifie la même chose que ÉRUDIT?', ['scholarly', 'ignorant', 'uneducated', 'simple'], ['savant', 'ignorant', 'inculte', 'simple'], 0),
      ('Which word means the same as FASTIDIOUS?', 'Quel mot signifie la même chose que FASTIDIEUX?', ['meticulous', 'careless', 'sloppy', 'messy'], ['méticuleux', 'négligent', 'bâclé', 'désordonné'], 0),
      ('Which word means the same as GREGARIOUS?', 'Quel mot signifie la même chose que GRÉGAIRE?', ['sociable', 'reclusive', 'shy', 'introverted'], ['sociable', 'solitaire', 'timide', 'introverti'], 0),
      ('Which word means the same as HACKNEYED?', 'Quel mot signifie la même chose que BANAL?', ['overused', 'original', 'fresh', 'novel'], ['usé', 'original', 'frais', 'nouveau'], 0),
      ('Which word means the same as ICONOCLAST?', 'Quel mot signifie la même chose que ICONOCLASTE?', ['rebel', 'conformist', 'follower', 'traditionalist'], ['rebelle', 'conformiste', 'suiveur', 'traditionaliste'], 0),
      ('Which word means the same as JUDICIOUS?', 'Quel mot signifie la même chose que JUDICIEUX?', ['wise', 'foolish', 'reckless', 'imprudent'], ['sage', 'insensé', 'imprudent', 'imprudent'], 0),
      ('Which word means the same as LACONIC?', 'Quel mot signifie la même chose que LACONIQUE?', ['concise', 'verbose', 'wordy', 'lengthy'], ['concis', 'verbeux', 'bavard', 'long'], 0),
      ('Which word means the same as MAGNANIMOUS?', 'Quel mot signifie la même chose que MAGNANIME?', ['generous', 'petty', 'selfish', 'stingy'], ['généreux', 'mesquin', 'égoïste', 'radin'], 0),
    ];

    for (var i = 0; i < synonyms.length; i++) {
      final (stem, stemFr, options, optionsFr, correct) = synonyms[i];
      questions.add(Question(
        id: '${level.value}_verbal_synonyms_$i',
        type: QuestionType.verbal,
        subType: VerbalSubType.synonyms.value,
        stem: stem,
        stemFrench: stemFr,
        options: options,
        optionsFrench: optionsFr,
        correctAnswer: correct,
        explanation: 'The correct answer is ${options[correct]}, which means the same as the given word.',
        explanationFrench: 'La bonne réponse est ${optionsFr[correct]}.',
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
      ('Which word means the OPPOSITE of HAPPY?', 'Quel mot signifie le CONTRAIRE de HEUREUX?', ['sad', 'glad', 'joyful', 'excited'], ['triste', 'content', 'joyeux', 'excité'], 0),
      ('Which word means the OPPOSITE of BIG?', 'Quel mot signifie le CONTRAIRE de GRAND?', ['small', 'large', 'huge', 'giant'], ['petit', 'grand', 'énorme', 'géant'], 0),
      ('Which word means the OPPOSITE of HOT?', 'Quel mot signifie le CONTRAIRE de CHAUD?', ['cold', 'warm', 'burning', 'heated'], ['froid', 'tiède', 'brûlant', 'chauffé'], 0),
      ('Which word means the OPPOSITE of FAST?', 'Quel mot signifie le CONTRAIRE de RAPIDE?', ['slow', 'quick', 'rapid', 'speedy'], ['lent', 'rapide', 'rapide', 'véloce'], 0),
      ('Which word means the OPPOSITE of UP?', 'Quel mot signifie le CONTRAIRE de HAUT?', ['down', 'high', 'above', 'over'], ['bas', 'haut', 'au-dessus', 'par-dessus'], 0),
      ('Which word means the OPPOSITE of OPEN?', 'Quel mot signifie le CONTRAIRE de OUVERT?', ['closed', 'wide', 'ajar', 'unlocked'], ['fermé', 'large', 'entrouvert', 'déverrouillé'], 0),
      ('Which word means the OPPOSITE of LIGHT?', 'Quel mot signifie le CONTRAIRE de CLAIR?', ['dark', 'bright', 'sunny', 'clear'], ['sombre', 'brillant', 'ensoleillé', 'clair'], 0),
      ('Which word means the OPPOSITE of LOUD?', 'Quel mot signifie le CONTRAIRE de BRUYANT?', ['quiet', 'noisy', 'booming', 'blaring'], ['calme', 'bruyant', 'tonitruant', 'braillant'], 0),
      ('Which word means the OPPOSITE of NEW?', 'Quel mot signifie le CONTRAIRE de NOUVEAU?', ['old', 'fresh', 'recent', 'modern'], ['vieux', 'frais', 'récent', 'moderne'], 0),
      ('Which word means the OPPOSITE of CLEAN?', 'Quel mot signifie le CONTRAIRE de PROPRE?', ['dirty', 'neat', 'tidy', 'spotless'], ['sale', 'soigné', 'rangé', 'impeccable'], 0),
      ('Which word means the OPPOSITE of EMPTY?', 'Quel mot signifie le CONTRAIRE de VIDE?', ['full', 'vacant', 'hollow', 'bare'], ['plein', 'vacant', 'creux', 'nu'], 0),
      ('Which word means the OPPOSITE of SOFT?', 'Quel mot signifie le CONTRAIRE de DOUX?', ['hard', 'gentle', 'smooth', 'fluffy'], ['dur', 'doux', 'lisse', 'duveteux'], 0),
      ('Which word means the OPPOSITE of EARLY?', 'Quel mot signifie le CONTRAIRE de TÔT?', ['late', 'soon', 'before', 'prompt'], ['tard', 'bientôt', 'avant', 'prompt'], 0),
      ('Which word means the OPPOSITE of WET?', 'Quel mot signifie le CONTRAIRE de MOUILLÉ?', ['dry', 'damp', 'moist', 'soaked'], ['sec', 'humide', 'moite', 'trempé'], 0),
      ('Which word means the OPPOSITE of RICH?', 'Quel mot signifie le CONTRAIRE de RICHE?', ['poor', 'wealthy', 'loaded', 'abundant'], ['pauvre', 'fortuné', 'chargé', 'abondant'], 0),
      ('Which word means the OPPOSITE of SAFE?', 'Quel mot signifie le CONTRAIRE de SÛR?', ['dangerous', 'secure', 'protected', 'guarded'], ['dangereux', 'sécurisé', 'protégé', 'gardé'], 0),
    ] : level == CCATLevel.level11 ? [
      ('Which word means the OPPOSITE of ANCIENT?', 'Quel mot signifie le CONTRAIRE de ANCIEN?', ['modern', 'old', 'antique', 'aged'], ['moderne', 'vieux', 'antique', 'âgé'], 0),
      ('Which word means the OPPOSITE of EXPAND?', 'Quel mot signifie le CONTRAIRE de ÉTENDRE?', ['contract', 'grow', 'enlarge', 'spread'], ['contracter', 'grandir', 'agrandir', 'répandre'], 0),
      ('Which word means the OPPOSITE of VICTORY?', 'Quel mot signifie le CONTRAIRE de VICTOIRE?', ['defeat', 'triumph', 'success', 'win'], ['défaite', 'triomphe', 'succès', 'gagner'], 0),
      ('Which word means the OPPOSITE of GENEROUS?', 'Quel mot signifie le CONTRAIRE de GÉNÉREUX?', ['stingy', 'giving', 'kind', 'liberal'], ['radin', 'donnant', 'gentil', 'libéral'], 0),
      ('Which word means the OPPOSITE of BRAVE?', 'Quel mot signifie le CONTRAIRE de COURAGEUX?', ['cowardly', 'heroic', 'bold', 'daring'], ['lâche', 'héroïque', 'audacieux', 'osé'], 0),
      ('Which word means the OPPOSITE of ACCEPT?', 'Quel mot signifie le CONTRAIRE de ACCEPTER?', ['reject', 'receive', 'take', 'welcome'], ['rejeter', 'recevoir', 'prendre', 'accueillir'], 0),
      ('Which word means the OPPOSITE of ARTIFICIAL?', 'Quel mot signifie le CONTRAIRE de ARTIFICIEL?', ['natural', 'fake', 'synthetic', 'man-made'], ['naturel', 'faux', 'synthétique', 'artificiel'], 0),
      ('Which word means the OPPOSITE of SHALLOW?', 'Quel mot signifie le CONTRAIRE de PEU PROFOND?', ['deep', 'surface', 'light', 'thin'], ['profond', 'surface', 'léger', 'mince'], 0),
      ('Which word means the OPPOSITE of OPTIMISTIC?', 'Quel mot signifie le CONTRAIRE de OPTIMISTE?', ['pessimistic', 'hopeful', 'positive', 'cheerful'], ['pessimiste', 'plein d\'espoir', 'positif', 'joyeux'], 0),
      ('Which word means the OPPOSITE of TEMPORARY?', 'Quel mot signifie le CONTRAIRE de TEMPORAIRE?', ['permanent', 'brief', 'short', 'fleeting'], ['permanent', 'bref', 'court', 'fugace'], 0),
      ('Which word means the OPPOSITE of MAXIMUM?', 'Quel mot signifie le CONTRAIRE de MAXIMUM?', ['minimum', 'highest', 'greatest', 'most'], ['minimum', 'le plus haut', 'le plus grand', 'le plus'], 0),
      ('Which word means the OPPOSITE of INNOCENT?', 'Quel mot signifie le CONTRAIRE de INNOCENT?', ['guilty', 'pure', 'blameless', 'naive'], ['coupable', 'pur', 'irréprochable', 'naïf'], 0),
      ('Which word means the OPPOSITE of HUMBLE?', 'Quel mot signifie le CONTRAIRE de HUMBLE?', ['arrogant', 'modest', 'meek', 'shy'], ['arrogant', 'modeste', 'doux', 'timide'], 0),
      ('Which word means the OPPOSITE of HARMONY?', 'Quel mot signifie le CONTRAIRE de HARMONIE?', ['discord', 'peace', 'unity', 'agreement'], ['discorde', 'paix', 'unité', 'accord'], 0),
      ('Which word means the OPPOSITE of FLEXIBLE?', 'Quel mot signifie le CONTRAIRE de FLEXIBLE?', ['rigid', 'bendable', 'elastic', 'adaptable'], ['rigide', 'pliable', 'élastique', 'adaptable'], 0),
      ('Which word means the OPPOSITE of EXTERIOR?', 'Quel mot signifie le CONTRAIRE de EXTÉRIEUR?', ['interior', 'outside', 'outer', 'external'], ['intérieur', 'dehors', 'externe', 'externe'], 0),
    ] : [
      ('Which word means the OPPOSITE of BENEVOLENT?', 'Quel mot signifie le CONTRAIRE de BIENVEILLANT?', ['malevolent', 'kind', 'generous', 'charitable'], ['malveillant', 'gentil', 'généreux', 'charitable'], 0),
      ('Which word means the OPPOSITE of EPHEMERAL?', 'Quel mot signifie le CONTRAIRE de ÉPHÉMÈRE?', ['permanent', 'brief', 'fleeting', 'temporary'], ['permanent', 'bref', 'fugace', 'temporaire'], 0),
      ('Which word means the OPPOSITE of VERBOSE?', 'Quel mot signifie le CONTRAIRE de VERBEUX?', ['concise', 'wordy', 'lengthy', 'prolonged'], ['concis', 'bavard', 'long', 'prolongé'], 0),
      ('Which word means the OPPOSITE of PRUDENT?', 'Quel mot signifie le CONTRAIRE de PRUDENT?', ['reckless', 'wise', 'careful', 'cautious'], ['imprudent', 'sage', 'soigneux', 'cautieux'], 0),
      ('Which word means the OPPOSITE of ENIGMATIC?', 'Quel mot signifie le CONTRAIRE de ÉNIGMATIQUE?', ['obvious', 'mysterious', 'puzzling', 'cryptic'], ['évident', 'mystérieux', 'déroutant', 'cryptique'], 0),
      ('Which word means the OPPOSITE of LOQUACIOUS?', 'Quel mot signifie le CONTRAIRE de LOQUACE?', ['taciturn', 'talkative', 'chatty', 'garrulous'], ['taciturne', 'bavard', 'causant', 'volubile'], 0),
      ('Which word means the OPPOSITE of METICULOUS?', 'Quel mot signifie le CONTRAIRE de MÉTICULEUX?', ['careless', 'precise', 'thorough', 'detailed'], ['négligent', 'précis', 'minutieux', 'détaillé'], 0),
      ('Which word means the OPPOSITE of AFFLUENT?', 'Quel mot signifie le CONTRAIRE de OPULENT?', ['impoverished', 'wealthy', 'rich', 'prosperous'], ['appauvri', 'fortuné', 'riche', 'prospère'], 0),
      ('Which word means the OPPOSITE of SANGUINE?', 'Quel mot signifie le CONTRAIRE de SANGUIN?', ['pessimistic', 'optimistic', 'hopeful', 'confident'], ['pessimiste', 'optimiste', 'plein d\'espoir', 'confiant'], 0),
      ('Which word means the OPPOSITE of RETICENT?', 'Quel mot signifie le CONTRAIRE de RÉTICENT?', ['forthcoming', 'reserved', 'quiet', 'shy'], ['communicatif', 'réservé', 'calme', 'timide'], 0),
      ('Which word means the OPPOSITE of PARSIMONIOUS?', 'Quel mot signifie le CONTRAIRE de PARCIMONIEUX?', ['lavish', 'frugal', 'thrifty', 'economical'], ['prodigue', 'frugal', 'économe', 'économique'], 0),
      ('Which word means the OPPOSITE of OBSEQUIOUS?', 'Quel mot signifie le CONTRAIRE de OBSÉQUIEUX?', ['defiant', 'servile', 'fawning', 'submissive'], ['défiant', 'servile', 'flatteur', 'soumis'], 0),
      ('Which word means the OPPOSITE of NEFARIOUS?', 'Quel mot signifie le CONTRAIRE de INFÂME?', ['virtuous', 'wicked', 'evil', 'villainous'], ['vertueux', 'méchant', 'mauvais', 'scélérat'], 0),
      ('Which word means the OPPOSITE of MUNDANE?', 'Quel mot signifie le CONTRAIRE de MONDAIN?', ['extraordinary', 'ordinary', 'common', 'dull'], ['extraordinaire', 'ordinaire', 'commun', 'terne'], 0),
      ('Which word means the OPPOSITE of LANGUID?', 'Quel mot signifie le CONTRAIRE de LANGUIDE?', ['energetic', 'sluggish', 'listless', 'lethargic'], ['énergique', 'lent', 'apathique', 'léthargique'], 0),
      ('Which word means the OPPOSITE of INDIGENOUS?', 'Quel mot signifie le CONTRAIRE de INDIGÈNE?', ['foreign', 'native', 'local', 'endemic'], ['étranger', 'natif', 'local', 'endémique'], 0),
    ];

    for (var i = 0; i < antonyms.length; i++) {
      final (stem, stemFr, options, optionsFr, correct) = antonyms[i];
      questions.add(Question(
        id: '${level.value}_verbal_antonyms_$i',
        type: QuestionType.verbal,
        subType: VerbalSubType.antonyms.value,
        stem: stem,
        stemFrench: stemFr,
        options: options,
        optionsFrench: optionsFr,
        correctAnswer: correct,
        explanation: 'The correct answer is ${options[correct]}, which means the opposite of the given word.',
        explanationFrench: 'La bonne réponse est ${optionsFr[correct]}.',
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
      ('The cat was very _____ and purred loudly.', 'Le chat était très _____ et ronronnait bruyamment.', ['happy', 'angry', 'scared', 'tired'], ['heureux', 'en colère', 'effrayé', 'fatigué'], 0),
      ('After running, I felt very _____.', 'Après avoir couru, je me sentais très _____.', ['tired', 'excited', 'hungry', 'cold'], ['fatigué', 'excité', 'affamé', 'froid'], 0),
      ('The sun was bright, so I wore my _____.', 'Le soleil brillait, alors j\'ai mis mes _____.', ['sunglasses', 'boots', 'jacket', 'hat'], ['lunettes de soleil', 'bottes', 'veste', 'chapeau'], 0),
      ('The dog barked _____ at the mailman.', 'Le chien a aboyé _____ après le facteur.', ['loudly', 'quietly', 'softly', 'gently'], ['bruyamment', 'doucement', 'doucement', 'gentiment'], 0),
      ('I need an umbrella because it is _____.', 'J\'ai besoin d\'un parapluie car il _____.', ['raining', 'sunny', 'windy', 'cold'], ['pleut', 'fait du soleil', 'venteux', 'froid'], 0),
      ('The ice cream was so _____ on a hot day.', 'La glace était si _____ par une chaude journée.', ['refreshing', 'boring', 'loud', 'fast'], ['rafraîchissante', 'ennuyeuse', 'bruyante', 'rapide'], 0),
      ('She _____ her homework before going out to play.', 'Elle a _____ ses devoirs avant de sortir jouer.', ['finished', 'forgot', 'lost', 'broke'], ['fini', 'oublié', 'perdu', 'cassé'], 0),
      ('The birthday cake was _____ with colorful frosting.', 'Le gâteau d\'anniversaire était _____ avec un glaçage coloré.', ['decorated', 'empty', 'broken', 'lost'], ['décoré', 'vide', 'cassé', 'perdu'], 0),
      ('We plant seeds in _____ to grow flowers.', 'Nous plantons des graines au _____ pour faire pousser des fleurs.', ['spring', 'winter', 'night', 'space'], ['printemps', 'hiver', 'nuit', 'espace'], 0),
      ('The library is a _____ place to read books.', 'La bibliothèque est un endroit _____ pour lire des livres.', ['quiet', 'loud', 'fast', 'wet'], ['calme', 'bruyant', 'rapide', 'humide'], 0),
      ('Mom uses a _____ to cook dinner.', 'Maman utilise une _____ pour préparer le dîner.', ['stove', 'bed', 'chair', 'book'], ['cuisinière', 'lit', 'chaise', 'livre'], 0),
      ('Birds build _____ in trees.', 'Les oiseaux construisent des _____ dans les arbres.', ['nests', 'houses', 'cars', 'boats'], ['nids', 'maisons', 'voitures', 'bateaux'], 0),
    ] : level == CCATLevel.level11 ? [
      ('The scientist\'s hypothesis was _____ by the results.', 'L\'hypothèse du scientifique a été _____ par les résultats.', ['validated', 'ignored', 'created', 'changed'], ['validée', 'ignorée', 'créée', 'changée'], 0),
      ('Despite her shy appearance, she was actually quite _____.', 'Malgré son apparence timide, elle était en fait assez _____.', ['outgoing', 'quiet', 'nervous', 'boring'], ['extravertie', 'calme', 'nerveuse', 'ennuyeuse'], 0),
      ('The ancient ruins were _____ preserved.', 'Les ruines antiques étaient _____ conservées.', ['remarkably', 'poorly', 'quickly', 'loudly'], ['remarquablement', 'mal', 'rapidement', 'bruyamment'], 0),
      ('The detective found a _____ clue at the crime scene.', 'Le détective a trouvé un indice _____ sur la scène du crime.', ['crucial', 'useless', 'broken', 'loud'], ['crucial', 'inutile', 'cassé', 'bruyant'], 0),
      ('The medicine helped _____ her headache.', 'Le médicament a aidé à _____ son mal de tête.', ['relieve', 'increase', 'ignore', 'create'], ['soulager', 'augmenter', 'ignorer', 'créer'], 0),
      ('The _____ weather forced us to cancel the picnic.', 'Le temps _____ nous a obligés à annuler le pique-nique.', ['inclement', 'beautiful', 'sunny', 'warm'], ['inclément', 'beau', 'ensoleillé', 'chaud'], 0),
      ('His _____ attitude made everyone uncomfortable.', 'Son attitude _____ a mis tout le monde mal à l\'aise.', ['hostile', 'friendly', 'helpful', 'kind'], ['hostile', 'amicale', 'serviable', 'gentille'], 0),
      ('The _____ student received an award for excellence.', 'L\'étudiant _____ a reçu un prix d\'excellence.', ['outstanding', 'mediocre', 'lazy', 'absent'], ['exceptionnel', 'médiocre', 'paresseux', 'absent'], 0),
      ('We need to _____ our resources carefully.', 'Nous devons _____ nos ressources avec soin.', ['conserve', 'waste', 'ignore', 'destroy'], ['conserver', 'gaspiller', 'ignorer', 'détruire'], 0),
      ('The project requires _____ between team members.', 'Le projet nécessite une _____ entre les membres de l\'équipe.', ['collaboration', 'competition', 'isolation', 'conflict'], ['collaboration', 'compétition', 'isolement', 'conflit'], 0),
      ('Her _____ explanation helped everyone understand.', 'Son explication _____ a aidé tout le monde à comprendre.', ['lucid', 'confusing', 'unclear', 'vague'], ['claire', 'confuse', 'peu claire', 'vague'], 0),
      ('The _____ bridge connected the two cities.', 'Le pont _____ reliait les deux villes.', ['magnificent', 'tiny', 'broken', 'invisible'], ['magnifique', 'minuscule', 'cassé', 'invisible'], 0),
    ] : [
      ('The politician\'s _____ speech failed to convince the audience.', 'Le discours _____ du politicien n\'a pas réussi à convaincre le public.', ['bombastic', 'sincere', 'brief', 'eloquent'], ['grandiloquent', 'sincère', 'bref', 'éloquent'], 0),
      ('Her _____ nature made her popular among colleagues.', 'Sa nature _____ l\'a rendue populaire auprès de ses collègues.', ['affable', 'hostile', 'indifferent', 'withdrawn'], ['affable', 'hostile', 'indifférente', 'renfermée'], 0),
      ('The judge\'s _____ ruling satisfied neither party.', 'La décision _____ du juge n\'a satisfait aucune des parties.', ['ambiguous', 'clear', 'fair', 'harsh'], ['ambiguë', 'claire', 'juste', 'sévère'], 0),
      ('The professor\'s _____ lecture captivated the students.', 'La conférence _____ du professeur a captivé les étudiants.', ['erudite', 'boring', 'simple', 'short'], ['érudite', 'ennuyeuse', 'simple', 'courte'], 0),
      ('His _____ behavior during the meeting was unprofessional.', 'Son comportement _____ pendant la réunion n\'était pas professionnel.', ['obstreperous', 'calm', 'polite', 'quiet'], ['turbulent', 'calme', 'poli', 'silencieux'], 0),
      ('The _____ evidence proved the defendant\'s innocence.', 'La preuve _____ a prouvé l\'innocence de l\'accusé.', ['exculpatory', 'damning', 'irrelevant', 'missing'], ['disculpatoire', 'accablante', 'non pertinente', 'manquante'], 0),
      ('Her _____ approach to problem-solving impressed everyone.', 'Son approche _____ de la résolution de problèmes a impressionné tout le monde.', ['pragmatic', 'impractical', 'emotional', 'random'], ['pragmatique', 'impraticable', 'émotionnelle', 'aléatoire'], 0),
      ('The CEO\'s _____ decision saved the company millions.', 'La décision _____ du PDG a permis à l\'entreprise d\'économiser des millions.', ['perspicacious', 'foolish', 'hasty', 'random'], ['perspicace', 'insensée', 'hâtive', 'aléatoire'], 0),
      ('The _____ landscape stretched for miles.', 'Le paysage _____ s\'étendait sur des kilomètres.', ['bucolic', 'urban', 'industrial', 'barren'], ['bucolique', 'urbain', 'industriel', 'stérile'], 0),
      ('His _____ comments during the debate won him supporters.', 'Ses commentaires _____ lors du débat lui ont valu des partisans.', ['trenchant', 'vague', 'timid', 'irrelevant'], ['tranchants', 'vagues', 'timides', 'non pertinents'], 0),
      ('The _____ nature of the virus made it difficult to study.', 'La nature _____ du virus a rendu son étude difficile.', ['protean', 'stable', 'predictable', 'simple'], ['protéiforme', 'stable', 'prévisible', 'simple'], 0),
      ('Her _____ wit always entertained dinner guests.', 'Son esprit _____ divertissait toujours les invités du dîner.', ['sardonic', 'dull', 'predictable', 'boring'], ['sardonique', 'terne', 'prévisible', 'ennuyeux'], 0),
    ];

    for (var i = 0; i < sentences.length; i++) {
      final (stem, stemFr, options, optionsFr, correct) = sentences[i];
      questions.add(Question(
        id: '${level.value}_verbal_sentence_$i',
        type: QuestionType.verbal,
        subType: VerbalSubType.sentenceCompletion.value,
        stem: stem,
        stemFrench: stemFr,
        options: options,
        optionsFrench: optionsFr,
        correctAnswer: correct,
        explanation: 'The correct answer is ${options[correct]}.',
        explanationFrench: 'La bonne réponse est ${optionsFr[correct]}.',
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
      ('Which doesn\'t belong? Apple, Banana, Carrot, Orange', 'Lequel n\'appartient pas ? Pomme, Banane, Carotte, Orange', ['Carrot', 'Apple', 'Banana', 'Orange'], ['Carotte', 'Pomme', 'Banane', 'Orange'], 0),
      ('Which doesn\'t belong? Dog, Cat, Bird, Table', 'Lequel n\'appartient pas ? Chien, Chat, Oiseau, Table', ['Table', 'Dog', 'Cat', 'Bird'], ['Table', 'Chien', 'Chat', 'Oiseau'], 0),
      ('Which doesn\'t belong? Red, Blue, Green, Happy', 'Lequel n\'appartient pas ? Rouge, Bleu, Vert, Heureux', ['Happy', 'Red', 'Blue', 'Green'], ['Heureux', 'Rouge', 'Bleu', 'Vert'], 0),
      ('Which doesn\'t belong? Chair, Sofa, Bed, Pizza', 'Lequel n\'appartient pas ? Chaise, Canapé, Lit, Pizza', ['Pizza', 'Chair', 'Sofa', 'Bed'], ['Pizza', 'Chaise', 'Canapé', 'Lit'], 0),
      ('Which doesn\'t belong? Car, Bus, Train, Apple', 'Lequel n\'appartient pas ? Voiture, Bus, Train, Pomme', ['Apple', 'Car', 'Bus', 'Train'], ['Pomme', 'Voiture', 'Bus', 'Train'], 0),
      ('Which doesn\'t belong? Monday, Tuesday, January, Friday', 'Lequel n\'appartient pas ? Lundi, Mardi, Janvier, Vendredi', ['January', 'Monday', 'Tuesday', 'Friday'], ['Janvier', 'Lundi', 'Mardi', 'Vendredi'], 0),
      ('Which doesn\'t belong? Milk, Juice, Water, Bread', 'Lequel n\'appartient pas ? Lait, Jus, Eau, Pain', ['Bread', 'Milk', 'Juice', 'Water'], ['Pain', 'Lait', 'Jus', 'Eau'], 0),
      ('Which doesn\'t belong? Soccer, Tennis, Reading, Basketball', 'Lequel n\'appartient pas ? Football, Tennis, Lecture, Basket-ball', ['Reading', 'Soccer', 'Tennis', 'Basketball'], ['Lecture', 'Football', 'Tennis', 'Basket-ball'], 0),
      ('Which doesn\'t belong? Spring, Summer, Winter, Afternoon', 'Lequel n\'appartient pas ? Printemps, Été, Hiver, Après-midi', ['Afternoon', 'Spring', 'Summer', 'Winter'], ['Après-midi', 'Printemps', 'Été', 'Hiver'], 0),
      ('Which doesn\'t belong? Eye, Ear, Nose, Shoe', 'Lequel n\'appartient pas ? Œil, Oreille, Nez, Chaussure', ['Shoe', 'Eye', 'Ear', 'Nose'], ['Chaussure', 'Œil', 'Oreille', 'Nez'], 0),
      ('Which doesn\'t belong? Lion, Tiger, Bear, Flower', 'Lequel n\'appartient pas ? Lion, Tigre, Ours, Fleur', ['Flower', 'Lion', 'Tiger', 'Bear'], ['Fleur', 'Lion', 'Tigre', 'Ours'], 0),
      ('Which doesn\'t belong? Shirt, Pants, Hat, Table', 'Lequel n\'appartient pas ? Chemise, Pantalon, Chapeau, Table', ['Table', 'Shirt', 'Pants', 'Hat'], ['Table', 'Chemise', 'Pantalon', 'Chapeau'], 0),
    ] : level == CCATLevel.level11 ? [
      ('Which doesn\'t belong? Mercury, Venus, Sun, Mars', 'Lequel n\'appartient pas ? Mercure, Vénus, Soleil, Mars', ['Sun', 'Mercury', 'Venus', 'Mars'], ['Soleil', 'Mercure', 'Vénus', 'Mars'], 0),
      ('Which doesn\'t belong? Piano, Violin, Drum, Painting', 'Lequel n\'appartient pas ? Piano, Violon, Tambour, Peinture', ['Painting', 'Piano', 'Violin', 'Drum'], ['Peinture', 'Piano', 'Violon', 'Tambour'], 0),
      ('Which doesn\'t belong? Triangle, Square, Circle, Cube', 'Lequel n\'appartient pas ? Triangle, Carré, Cercle, Cube', ['Cube', 'Triangle', 'Square', 'Circle'], ['Cube', 'Triangle', 'Carré', 'Cercle'], 0),
      ('Which doesn\'t belong? Nitrogen, Oxygen, Carbon, Water', 'Lequel n\'appartient pas ? Azote, Oxygène, Carbone, Eau', ['Water', 'Nitrogen', 'Oxygen', 'Carbon'], ['Eau', 'Azote', 'Oxygène', 'Carbone'], 0),
      ('Which doesn\'t belong? Shakespeare, Hemingway, Einstein, Dickens', 'Lequel n\'appartient pas ? Shakespeare, Hemingway, Einstein, Dickens', ['Einstein', 'Shakespeare', 'Hemingway', 'Dickens'], ['Einstein', 'Shakespeare', 'Hemingway', 'Dickens'], 0),
      ('Which doesn\'t belong? Atlantic, Pacific, Indian, Nile', 'Lequel n\'appartient pas ? Atlantique, Pacifique, Indien, Nil', ['Nile', 'Atlantic', 'Pacific', 'Indian'], ['Nil', 'Atlantique', 'Pacifique', 'Indien'], 0),
      ('Which doesn\'t belong? Fraction, Decimal, Percentage, Paragraph', 'Lequel n\'appartient pas ? Fraction, Décimale, Pourcentage, Paragraphe', ['Paragraph', 'Fraction', 'Decimal', 'Percentage'], ['Paragraphe', 'Fraction', 'Décimale', 'Pourcentage'], 0),
      ('Which doesn\'t belong? Noun, Verb, Adjective, Mathematics', 'Lequel n\'appartient pas ? Nom, Verbe, Adjectif, Mathématiques', ['Mathematics', 'Noun', 'Verb', 'Adjective'], ['Mathématiques', 'Nom', 'Verbe', 'Adjectif'], 0),
      ('Which doesn\'t belong? Heart, Lung, Brain, Pencil', 'Lequel n\'appartient pas ? Cœur, Poumon, Cerveau, Crayon', ['Pencil', 'Heart', 'Lung', 'Brain'], ['Crayon', 'Cœur', 'Poumon', 'Cerveau'], 0),
      ('Which doesn\'t belong? Canada, France, Japan, Toronto', 'Lequel n\'appartient pas ? Canada, France, Japon, Toronto', ['Toronto', 'Canada', 'France', 'Japan'], ['Toronto', 'Canada', 'France', 'Japon'], 0),
      ('Which doesn\'t belong? Celsius, Fahrenheit, Kelvin, Kilogram', 'Lequel n\'appartient pas ? Celsius, Fahrenheit, Kelvin, Kilogramme', ['Kilogram', 'Celsius', 'Fahrenheit', 'Kelvin'], ['Kilogramme', 'Celsius', 'Fahrenheit', 'Kelvin'], 0),
      ('Which doesn\'t belong? Democracy, Monarchy, Republic, Photosynthesis', 'Lequel n\'appartient pas ? Démocratie, Monarchie, République, Photosynthèse', ['Photosynthesis', 'Democracy', 'Monarchy', 'Republic'], ['Photosynthèse', 'Démocratie', 'Monarchie', 'République'], 0),
    ] : [
      ('Which doesn\'t belong? Monarchy, Democracy, Republic, Capitalism', 'Lequel n\'appartient pas ? Monarchie, Démocratie, République, Capitalisme', ['Capitalism', 'Monarchy', 'Democracy', 'Republic'], ['Capitalisme', 'Monarchie', 'Démocratie', 'République'], 0),
      ('Which doesn\'t belong? Metaphor, Simile, Hyperbole, Paragraph', 'Lequel n\'appartient pas ? Métaphore, Comparaison, Hyperbole, Paragraphe', ['Paragraph', 'Metaphor', 'Simile', 'Hyperbole'], ['Paragraphe', 'Métaphore', 'Comparaison', 'Hyperbole'], 0),
      ('Which doesn\'t belong? Photosynthesis, Respiration, Digestion, Gravity', 'Lequel n\'appartient pas ? Photosynthèse, Respiration, Digestion, Gravité', ['Gravity', 'Photosynthesis', 'Respiration', 'Digestion'], ['Gravité', 'Photosynthèse', 'Respiration', 'Digestion'], 0),
      ('Which doesn\'t belong? Baroque, Renaissance, Romanticism, Algebra', 'Lequel n\'appartient pas ? Baroque, Renaissance, Romantisme, Algèbre', ['Algebra', 'Baroque', 'Renaissance', 'Romanticism'], ['Algèbre', 'Baroque', 'Renaissance', 'Romantisme'], 0),
      ('Which doesn\'t belong? Aristotle, Plato, Socrates, Newton', 'Lequel n\'appartient pas ? Aristote, Platon, Socrate, Newton', ['Newton', 'Aristotle', 'Plato', 'Socrates'], ['Newton', 'Aristote', 'Platon', 'Socrate'], 0),
      ('Which doesn\'t belong? Irony, Sarcasm, Satire, Algorithm', 'Lequel n\'appartient pas ? Ironie, Sarcasme, Satire, Algorithme', ['Algorithm', 'Irony', 'Sarcasm', 'Satire'], ['Algorithme', 'Ironie', 'Sarcasme', 'Satire'], 0),
      ('Which doesn\'t belong? Mitochondria, Nucleus, Ribosome, Equation', 'Lequel n\'appartient pas ? Mitochondrie, Noyau, Ribosome, Équation', ['Equation', 'Mitochondria', 'Nucleus', 'Ribosome'], ['Équation', 'Mitochondrie', 'Noyau', 'Ribosome'], 0),
      ('Which doesn\'t belong? Empiricism, Rationalism, Existentialism, Thermodynamics', 'Lequel n\'appartient pas ? Empirisme, Rationalisme, Existentialisme, Thermodynamique', ['Thermodynamics', 'Empiricism', 'Rationalism', 'Existentialism'], ['Thermodynamique', 'Empirisme', 'Rationalisme', 'Existentialisme'], 0),
      ('Which doesn\'t belong? Sonnet, Haiku, Limerick, Thesis', 'Lequel n\'appartient pas ? Sonnet, Haïku, Limerick, Thèse', ['Thesis', 'Sonnet', 'Haiku', 'Limerick'], ['Thèse', 'Sonnet', 'Haïku', 'Limerick'], 0),
      ('Which doesn\'t belong? Impressionism, Cubism, Surrealism, Calculus', 'Lequel n\'appartient pas ? Impressionnisme, Cubisme, Surréalisme, Calcul', ['Calculus', 'Impressionism', 'Cubism', 'Surrealism'], ['Calcul', 'Impressionnisme', 'Cubisme', 'Surréalisme'], 0),
      ('Which doesn\'t belong? Syntax, Semantics, Pragmatics, Velocity', 'Lequel n\'appartient pas ? Syntaxe, Sémantique, Pragmatique, Vélocité', ['Velocity', 'Syntax', 'Semantics', 'Pragmatics'], ['Vélocité', 'Syntaxe', 'Sémantique', 'Pragmatique'], 0),
      ('Which doesn\'t belong? Mozart, Beethoven, Bach, Darwin', 'Lequel n\'appartient pas ? Mozart, Beethoven, Bach, Darwin', ['Darwin', 'Mozart', 'Beethoven', 'Bach'], ['Darwin', 'Mozart', 'Beethoven', 'Bach'], 0),
    ];

    for (var i = 0; i < items.length; i++) {
      final (stem, stemFr, options, optionsFr, correct) = items[i];
      questions.add(Question(
        id: '${level.value}_verbal_classification_$i',
        type: QuestionType.verbal,
        subType: VerbalSubType.classification.value,
        stem: stem,
        stemFrench: stemFr,
        options: options,
        optionsFrench: optionsFr,
        correctAnswer: correct,
        explanation: 'The correct answer is ${options[correct]}.',
        explanationFrench: 'La bonne réponse est ${optionsFr[correct]}.',
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
      ('Which is greater? A: 5 + 3, B: 4 + 2', 'Lequel est plus grand ? A: 5 + 3, B: 4 + 2', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 0),
      ('Which is less? A: 10 - 2, B: 5 + 4', 'Lequel est plus petit ? A: 10 - 2, B: 5 + 4', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 0),
      ('Compare: A: 2 x 3, B: 3 + 3', 'Comparer : A: 2 x 3, B: 3 + 3', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], ['A est plus grand', 'B est plus grand', 'Égal', 'Impossible à dire'], 2),
      ('Which is greater? A: 4 x 2, B: 3 x 3', 'Lequel est plus grand ? A: 4 x 2, B: 3 x 3', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 1),
      ('Compare: A: 15 - 5, B: 2 x 5', 'Comparer : A: 15 - 5, B: 2 x 5', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], ['A est plus grand', 'B est plus grand', 'Égal', 'Impossible à dire'], 2),
      ('Which is less? A: 6 + 6, B: 4 x 4', 'Lequel est plus petit ? A: 6 + 6, B: 4 x 4', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 0),
      ('Compare: A: 20 ÷ 4, B: 10 ÷ 2', 'Comparer : A: 20 ÷ 4, B: 10 ÷ 2', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], ['A est plus grand', 'B est plus grand', 'Égal', 'Impossible à dire'], 2),
      ('Which is greater? A: 7 + 8, B: 5 x 3', 'Lequel est plus grand ? A: 7 + 8, B: 5 x 3', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 2),
      ('Which is less? A: 3 x 4, B: 2 x 7', 'Lequel est plus petit ? A: 3 x 4, B: 2 x 7', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 0),
      ('Compare: A: 18 ÷ 3, B: 12 ÷ 2', 'Comparer : A: 18 ÷ 3, B: 12 ÷ 2', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], ['A est plus grand', 'B est plus grand', 'Égal', 'Impossible à dire'], 2),
      ('Which is greater? A: 9 + 5, B: 7 + 6', 'Lequel est plus grand ? A: 9 + 5, B: 7 + 6', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 0),
      ('Which is less? A: 5 x 5, B: 4 x 7', 'Lequel est plus petit ? A: 5 x 5, B: 4 x 7', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 1),
      ('Compare: A: 24 ÷ 6, B: 16 ÷ 4', 'Comparer : A: 24 ÷ 6, B: 16 ÷ 4', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], ['A est plus grand', 'B est plus grand', 'Égal', 'Impossible à dire'], 2),
      ('Which is greater? A: 11 - 3, B: 4 + 5', 'Lequel est plus grand ? A: 11 - 3, B: 4 + 5', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 1),
      ('Which is less? A: 6 x 3, B: 9 x 2', 'Lequel est plus petit ? A: 6 x 3, B: 9 x 2', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 2),
      ('Compare: A: 30 ÷ 5, B: 18 ÷ 3', 'Comparer : A: 30 ÷ 5, B: 18 ÷ 3', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], ['A est plus grand', 'B est plus grand', 'Égal', 'Impossible à dire'], 2),
    ] : level == CCATLevel.level11 ? [
      ('Which is greater? A: 1/2 of 10, B: 1/3 of 12', 'Lequel est plus grand ? A: 1/2 de 10, B: 1/3 de 12', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 0),
      ('Which is less? A: 0.5, B: 0.05', 'Lequel est plus petit ? A: 0.5, B: 0.05', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 1),
      ('Compare: A: 3 squared, B: 2 cubed', 'Comparer : A: 3 au carré, B: 2 au cube', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], ['A est plus grand', 'B est plus grand', 'Égal', 'Impossible à dire'], 0),
      ('Which is greater? A: 2/3 of 9, B: 3/4 of 8', 'Lequel est plus grand ? A: 2/3 de 9, B: 3/4 de 8', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 2),
      ('Compare: A: 0.25, B: 1/4', 'Comparer : A: 0.25, B: 1/4', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], ['A est plus grand', 'B est plus grand', 'Égal', 'Impossible à dire'], 2),
      ('Which is less? A: 4 squared, B: 3 cubed', 'Lequel est plus petit ? A: 4 au carré, B: 3 au cube', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 0),
      ('Compare: A: 15%, B: 0.15', 'Comparer : A: 15%, B: 0.15', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], ['A est plus grand', 'B est plus grand', 'Égal', 'Impossible à dire'], 2),
      ('Which is greater? A: 5/8, B: 7/12', 'Lequel est plus grand ? A: 5/8, B: 7/12', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 0),
      ('Which is less? A: 0.75, B: 4/5', 'Lequel est plus petit ? A: 0.75, B: 4/5', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 0),
      ('Compare: A: 5 squared, B: 6 x 4', 'Comparer : A: 5 au carré, B: 6 x 4', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], ['A est plus grand', 'B est plus grand', 'Égal', 'Impossible à dire'], 0),
      ('Which is greater? A: 1/5 of 100, B: 1/4 of 80', 'Lequel est plus grand ? A: 1/5 de 100, B: 1/4 de 80', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 2),
      ('Which is less? A: 0.6, B: 2/3', 'Lequel est plus petit ? A: 0.6, B: 2/3', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 0),
      ('Compare: A: 25%, B: 0.3', 'Comparer : A: 25%, B: 0.3', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], ['A est plus grand', 'B est plus grand', 'Égal', 'Impossible à dire'], 1),
      ('Which is greater? A: 7/9, B: 8/11', 'Lequel est plus grand ? A: 7/9, B: 8/11', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 0),
      ('Which is less? A: 6 cubed, B: 200', 'Lequel est plus petit ? A: 6 au cube, B: 200', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 1),
      ('Compare: A: 2.5, B: 5/2', 'Comparer : A: 2.5, B: 5/2', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], ['A est plus grand', 'B est plus grand', 'Égal', 'Impossible à dire'], 2),
    ] : [
      ('Compare: A: sqrt(144), B: 12', 'Comparer : A: sqrt(144), B: 12', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], ['A est plus grand', 'B est plus grand', 'Égal', 'Impossible à dire'], 2),
      ('Which is less? A: -5, B: -10', 'Lequel est plus petit ? A: -5, B: -10', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 1),
      ('Compare: A: 2^4, B: 4^2', 'Comparer : A: 2^4, B: 4^2', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], ['A est plus grand', 'B est plus grand', 'Égal', 'Impossible à dire'], 2),
      ('Which is greater? A: π, B: 3.14', 'Lequel est plus grand ? A: π, B: 3.14', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 0),
      ('Compare: A: sqrt(2), B: 1.5', 'Comparer : A: sqrt(2), B: 1.5', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], ['A est plus grand', 'B est plus grand', 'Égal', 'Impossible à dire'], 1),
      ('Which is less? A: 3^3, B: 2^5', 'Lequel est plus petit ? A: 3^3, B: 2^5', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 0),
      ('Compare: A: log₁₀(100), B: 2', 'Comparer : A: log₁₀(100), B: 2', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], ['A est plus grand', 'B est plus grand', 'Égal', 'Impossible à dire'], 2),
      ('Which is greater? A: |-7|, B: |5|', 'Lequel est plus grand ? A: |-7|, B: |5|', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 0),
      ('Which is less? A: sqrt(50), B: 7', 'Lequel est plus petit ? A: sqrt(50), B: 7', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 0),
      ('Compare: A: 5^3, B: 3^5', 'Comparer : A: 5^3, B: 3^5', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], ['A est plus grand', 'B est plus grand', 'Égal', 'Impossible à dire'], 1),
      ('Which is greater? A: e, B: 2.71', 'Lequel est plus grand ? A: e, B: 2.71', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 0),
      ('Compare: A: sqrt(3) + sqrt(5), B: sqrt(8)', 'Comparer : A: sqrt(3) + sqrt(5), B: sqrt(8)', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], ['A est plus grand', 'B est plus grand', 'Égal', 'Impossible à dire'], 0),
      ('Which is less? A: log₂(8), B: log₃(27)', 'Lequel est plus petit ? A: log₂(8), B: log₃(27)', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 2),
      ('Compare: A: 1/sqrt(2), B: sqrt(2)/2', 'Comparer : A: 1/sqrt(2), B: sqrt(2)/2', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], ['A est plus grand', 'B est plus grand', 'Égal', 'Impossible à dire'], 2),
      ('Which is greater? A: (2/3)^2, B: 2/3', 'Lequel est plus grand ? A: (2/3)^2, B: 2/3', ['A', 'B', 'Equal', 'Cannot tell'], ['A', 'B', 'Égal', 'Impossible à dire'], 1),
      ('Compare: A: 10^(-2), B: 0.01', 'Comparer : A: 10^(-2), B: 0.01', ['A is greater', 'B is greater', 'Equal', 'Cannot tell'], ['A est plus grand', 'B est plus grand', 'Égal', 'Impossible à dire'], 2),
    ];

    for (var i = 0; i < relations.length; i++) {
      final (stem, stemFr, options, optionsFr, correct) = relations[i];
      questions.add(Question(
        id: '${level.value}_quant_relations_$i',
        type: QuestionType.quantitative,
        subType: QuantitativeSubType.quantitativeRelations.value,
        stem: stem,
        stemFrench: stemFr,
        options: options,
        optionsFrench: optionsFr,
        correctAnswer: correct,
        explanation: 'The correct answer is ${options[correct]}.',
        explanationFrench: 'La bonne réponse est ${optionsFr[correct]}.',
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

  // MARK: - Non-Verbal Questions Generation (Visual)

  List<Question> _createFigureMatrices(CCATLevel level) {
    final difficulty = _getDifficultyForLevel(level);
    List<Question> questions = [];
    
    void addMatrix(String idSuffix, String stem, String stemFr, List<List<String>> matrix, List<String> options, int correct) {
      questions.add(Question(
        id: '${level.value}_nv_mat_$idSuffix',
        type: QuestionType.nonVerbal,
        subType: NonVerbalSubType.figureMatrices.value,
        stem: stem,
        stemFrench: stemFr,
        options: options,
        optionsFrench: options,
        correctAnswer: correct,
        explanation: 'Observe the pattern across rows and columns.',
        explanationFrench: 'Observez le motif à travers les lignes et les colonnes.',
        difficulty: difficulty,
        level: level,
        visualData: {
          'type': 'matrixPattern',
          'matrix': matrix,
        }
      ));
    }

    if (level == CCATLevel.level10) {
      addMatrix('1', 'Complete the pattern.', 'Complétez le motif.',
        [['circle', 'circle', 'circle'], ['square', 'square', 'square'], ['triangle', 'triangle', '?']],
        ['Triangle', 'Square', 'Circle', 'Star'], 0);
        
      addMatrix('2', 'Complete the pattern.', 'Complétez le motif.',
        [['circle', 'square', 'triangle'], ['square', 'triangle', 'circle'], ['triangle', 'circle', '?']],
        ['Square', 'Triangle', 'Circle', 'Star'], 0);

      addMatrix('3', 'Complete the pattern.', 'Complétez le motif.',
        [['filled_circle', 'circle', 'filled_circle'], ['filled_square', 'square', 'filled_square'], ['filled_circle', 'circle', '?']],
        ['filled_circle', 'circle', 'square', 'filled_square'], 0);
        
      addMatrix('4', 'Complete the pattern.', 'Complétez le motif.',
        [['x', 'x', 'x'], ['+', '+', '+'], ['dot', 'dot', '?']],
        ['dot', 'x', '+', 'circle'], 0);
        
      addMatrix('5', 'Complete the pattern.', 'Complétez le motif.',
        [['circle', 'dot', 'circle'], ['square', 'dot', 'square'], ['triangle', 'dot', '?']],
        ['triangle', 'dot', 'circle', 'square'], 0);

    } else if (level == CCATLevel.level11) {
      addMatrix('1', 'Complete the pattern.', 'Complétez le motif.',
        [['x', '+', 'x'], ['+', 'x', '+'], ['x', '+', '?']],
        ['x', '+', 'circle', 'square'], 0);
        
      addMatrix('2', 'Complete the pattern.', 'Complétez le motif.',
        [['dot', 'circle', 'filled_circle'], ['dot', 'square', 'filled_square'], ['dot', 'triangle', '?']],
        ['triangle', 'filled_triangle', 'circle', 'square'], 0); // Note: filled_triangle not supported, using triangle as placeholder or need to update painter
        
      addMatrix('3', 'Complete the pattern.', 'Complétez le motif.',
        [['circle', 'square', 'triangle'], ['triangle', 'circle', 'square'], ['square', 'triangle', '?']],
        ['circle', 'square', 'triangle', 'dot'], 0);
        
      addMatrix('4', 'Complete the pattern.', 'Complétez le motif.',
        [['empty', 'dot', 'empty'], ['dot', 'empty', 'dot'], ['empty', 'dot', '?']],
        ['empty', 'dot', 'circle', 'square'], 0);
        
      addMatrix('5', 'Complete the pattern.', 'Complétez le motif.',
        [['x', 'x', 'x'], ['x', '+', 'x'], ['x', '+', '?']],
        ['+', 'x', 'dot', 'circle'], 0);

    } else { // Level 12
      addMatrix('1', 'Complete the pattern.', 'Complétez le motif.',
        [['circle', 'square', 'circle'], ['square', 'triangle', 'square'], ['triangle', 'circle', '?']],
        ['triangle', 'circle', 'square', 'dot'], 0);
        
      addMatrix('2', 'Complete the pattern.', 'Complétez le motif.',
        [['filled_circle', 'empty', 'filled_circle'], ['empty', 'filled_square', 'empty'], ['filled_circle', 'empty', '?']],
        ['filled_circle', 'empty', 'filled_square', 'circle'], 0);
        
      addMatrix('3', 'Complete the pattern.', 'Complétez le motif.',
        [['x', '+', 'dot'], ['dot', 'x', '+'], ['+', 'dot', '?']],
        ['x', '+', 'dot', 'circle'], 0);
        
      addMatrix('4', 'Complete the pattern.', 'Complétez le motif.',
        [['circle', 'circle', 'filled_circle'], ['square', 'square', 'filled_square'], ['triangle', 'triangle', '?']],
        ['triangle', 'filled_triangle', 'circle', 'square'], 0);
        
      addMatrix('5', 'Complete the pattern.', 'Complétez le motif.',
        [['x', 'x', 'x'], ['+', '+', '+'], ['x', 'x', '?']],
        ['x', '+', 'dot', 'circle'], 0);
    }
    
    return questions;
  }

  List<Question> _createFigureClassification(CCATLevel level) {
    final difficulty = _getDifficultyForLevel(level);
    List<Question> questions = [];
    
    void addOddOneOut(String idSuffix, String stem, String stemFr, List<String> items, List<Color> colors, List<String> options, int correct) {
      questions.add(Question(
        id: '${level.value}_nv_class_$idSuffix',
        type: QuestionType.nonVerbal,
        subType: NonVerbalSubType.figureClassification.value,
        stem: stem,
        stemFrench: stemFr,
        options: options,
        optionsFrench: options,
        correctAnswer: correct,
        explanation: 'Find the item that is different.',
        explanationFrench: 'Trouvez l\'élément qui est différent.',
        difficulty: difficulty,
        level: level,
        visualData: {
          'type': 'oddOneOut',
          'items': items,
          'colors': colors,
        }
      ));
    }

    if (level == CCATLevel.level10) {
      addOddOneOut('1', 'Which shape is different?', 'Quelle forme est différente ?',
        ['circle', 'circle', 'square', 'circle'],
        [Colors.blue, Colors.blue, Colors.blue, Colors.blue],
        ['Circle', 'Circle', 'Square', 'Circle'], 2);
        
      addOddOneOut('2', 'Which color is different?', 'Quelle couleur est différente ?',
        ['triangle', 'triangle', 'triangle', 'triangle'],
        [Colors.red, Colors.red, Colors.green, Colors.red],
        ['Red', 'Red', 'Green', 'Red'], 2);
        
      addOddOneOut('3', 'Which shape is different?', 'Quelle forme est différente ?',
        ['star', 'star', 'star', 'circle'],
        [Colors.orange, Colors.orange, Colors.orange, Colors.orange],
        ['Star', 'Star', 'Star', 'Circle'], 3);
        
      addOddOneOut('4', 'Which shape is different?', 'Quelle forme est différente ?',
        ['square', 'rectangle', 'square', 'square'],
        [Colors.purple, Colors.purple, Colors.purple, Colors.purple],
        ['Square', 'Rectangle', 'Square', 'Square'], 1);
        
      addOddOneOut('5', 'Which color is different?', 'Quelle couleur est différente ?',
        ['circle', 'circle', 'circle', 'circle'],
        [Colors.yellow, Colors.blue, Colors.yellow, Colors.yellow],
        ['Yellow', 'Blue', 'Yellow', 'Yellow'], 1);

    } else if (level == CCATLevel.level11) {
      addOddOneOut('1', 'Which shape is different?', 'Quelle forme est différente ?',
        ['pentagon', 'hexagon', 'pentagon', 'pentagon'],
        [Colors.green, Colors.green, Colors.green, Colors.green],
        ['Pentagon', 'Hexagon', 'Pentagon', 'Pentagon'], 1);
        
      addOddOneOut('2', 'Which shape is different?', 'Quelle forme est différente ?',
        ['diamond', 'diamond', 'star', 'diamond'],
        [Colors.cyan, Colors.cyan, Colors.cyan, Colors.cyan],
        ['Diamond', 'Diamond', 'Star', 'Diamond'], 2);
        
      addOddOneOut('3', 'Which color is different?', 'Quelle couleur est différente ?',
        ['square', 'square', 'square', 'square'],
        [Colors.red, Colors.red, Colors.red, Colors.blue],
        ['Red', 'Red', 'Red', 'Blue'], 3);
        
      addOddOneOut('4', 'Which shape is different?', 'Quelle forme est différente ?',
        ['triangle', 'triangle', 'triangle', 'square'],
        [Colors.orange, Colors.orange, Colors.orange, Colors.orange],
        ['Triangle', 'Triangle', 'Triangle', 'Square'], 3);
        
      addOddOneOut('5', 'Which shape is different?', 'Quelle forme est différente ?',
        ['heart', 'heart', 'circle', 'heart'],
        [Colors.pink, Colors.pink, Colors.pink, Colors.pink],
        ['Heart', 'Heart', 'Circle', 'Heart'], 2);

    } else { // Level 12
      addOddOneOut('1', 'Which shape is different?', 'Quelle forme est différente ?',
        ['hexagon', 'hexagon', 'pentagon', 'hexagon'],
        [Colors.teal, Colors.teal, Colors.teal, Colors.teal],
        ['Hexagon', 'Hexagon', 'Pentagon', 'Hexagon'], 2);
        
      addOddOneOut('2', 'Which shape is different?', 'Quelle forme est différente ?',
        ['star', 'star', 'star', 'diamond'],
        [Colors.indigo, Colors.indigo, Colors.indigo, Colors.indigo],
        ['Star', 'Star', 'Star', 'Diamond'], 3);
        
      addOddOneOut('3', 'Which color is different?', 'Quelle couleur est différente ?',
        ['triangle', 'triangle', 'triangle', 'triangle'],
        [Colors.blue, Colors.red, Colors.blue, Colors.blue],
        ['Blue', 'Red', 'Blue', 'Blue'], 1);
        
      addOddOneOut('4', 'Which shape is different?', 'Quelle forme est différente ?',
        ['oval', 'circle', 'oval', 'oval'],
        [Colors.brown, Colors.brown, Colors.brown, Colors.brown],
        ['Oval', 'Circle', 'Oval', 'Oval'], 1);
        
      addOddOneOut('5', 'Which shape is different?', 'Quelle forme est différente ?',
        ['rectangle', 'rectangle', 'square', 'rectangle'],
        [Colors.grey, Colors.grey, Colors.grey, Colors.grey],
        ['Rectangle', 'Rectangle', 'Square', 'Rectangle'], 2);
    }
    
    return questions;
  }

  List<Question> _createFigureSeries(CCATLevel level) {
    final difficulty = _getDifficultyForLevel(level);
    List<Question> questions = [];
    
    void addSequence(String idSuffix, String stem, String stemFr, List<String> patterns, List<String> options, int correct) {
      questions.add(Question(
        id: '${level.value}_nv_series_$idSuffix',
        type: QuestionType.nonVerbal,
        subType: NonVerbalSubType.figureSeries.value,
        stem: stem,
        stemFrench: stemFr,
        options: options,
        optionsFrench: options,
        correctAnswer: correct,
        explanation: 'Find the next item in the sequence.',
        explanationFrench: 'Trouvez l\'élément suivant dans la séquence.',
        difficulty: difficulty,
        level: level,
        visualData: {
          'type': 'sequencePattern',
          'patterns': patterns,
        }
      ));
    }

    if (level == CCATLevel.level10) {
      addSequence('1', 'What comes next?', 'Quelle est la suite ?',
        ['circle', 'square', 'triangle', 'question'],
        ['Circle', 'Square', 'Triangle', 'Star'], 0);
        
      addSequence('2', 'What comes next?', 'Quelle est la suite ?',
        ['filled_circle', 'circle', 'filled_circle', 'question'],
        ['filled_circle', 'circle', 'square', 'filled_square'], 1);
        
      addSequence('3', 'What comes next?', 'Quelle est la suite ?',
        ['square', 'filled_square', 'square', 'question'],
        ['square', 'filled_square', 'circle', 'filled_circle'], 1);
        
      addSequence('4', 'What comes next?', 'Quelle est la suite ?',
        ['triangle', 'circle', 'triangle', 'question'],
        ['triangle', 'circle', 'square', 'star'], 1);
        
      addSequence('5', 'What comes next?', 'Quelle est la suite ?',
        ['filled_square', 'filled_square', 'square', 'question'],
        ['filled_square', 'square', 'circle', 'triangle'], 1);

    } else if (level == CCATLevel.level11) {
      addSequence('1', 'What comes next?', 'Quelle est la suite ?',
        ['circle', 'square', 'triangle', 'circle', 'question'],
        ['Square', 'Triangle', 'Circle', 'Star'], 0);
        
      addSequence('2', 'What comes next?', 'Quelle est la suite ?',
        ['filled_square', 'filled_circle', 'filled_square', 'question'],
        ['filled_square', 'filled_circle', 'square', 'circle'], 1);
        
      addSequence('3', 'What comes next?', 'Quelle est la suite ?',
        ['triangle', 'square', 'triangle', 'square', 'question'],
        ['triangle', 'square', 'circle', 'star'], 0);
        
      addSequence('4', 'What comes next?', 'Quelle est la suite ?',
        ['circle', 'circle', 'filled_circle', 'filled_circle', 'question'],
        ['circle', 'filled_circle', 'square', 'filled_square'], 0);
        
      addSequence('5', 'What comes next?', 'Quelle est la suite ?',
        ['square', 'triangle', 'circle', 'square', 'question'],
        ['triangle', 'circle', 'square', 'star'], 0);

    } else { // Level 12
      addSequence('1', 'What comes next?', 'Quelle est la suite ?',
        ['circle', 'square', 'triangle', 'circle', 'square', 'question'],
        ['Triangle', 'Circle', 'Square', 'Star'], 0);
        
      addSequence('2', 'What comes next?', 'Quelle est la suite ?',
        ['filled_circle', 'filled_square', 'filled_circle', 'filled_square', 'question'],
        ['filled_circle', 'filled_square', 'circle', 'square'], 0);
        
      addSequence('3', 'What comes next?', 'Quelle est la suite ?',
        ['triangle', 'triangle', 'square', 'square', 'question'],
        ['triangle', 'square', 'circle', 'star'], 0);
        
      addSequence('4', 'What comes next?', 'Quelle est la suite ?',
        ['square', 'circle', 'square', 'circle', 'square', 'question'],
        ['circle', 'square', 'triangle', 'star'], 0);
        
      addSequence('5', 'What comes next?', 'Quelle est la suite ?',
        ['filled_square', 'square', 'filled_circle', 'circle', 'question'],
        ['filled_square', 'filled_triangle', 'triangle', 'star'], 0);
    }
    
    return questions;
  }

  List<Question> _createKindergartenQuestions() {
    List<Question> questions = [];
    
    // 1. Shape Recognition (Visual)
    final shapes = [
      ('circle', 'Circle', 'Cercle', Colors.red),
      ('square', 'Square', 'Carré', Colors.blue),
      ('triangle', 'Triangle', 'Triangle', Colors.green),
      ('star', 'Star', 'Étoile', Colors.orange),
      ('heart', 'Heart', 'Cœur', Colors.pink),
    ];

    for (var i = 0; i < 10; i++) {
      final targetShape = shapes[i % shapes.length];
      final options = List<String>.from(shapes.map((s) => s.$2))..shuffle();
      // Ensure target is in options
      if (!options.contains(targetShape.$2)) {
        options[0] = targetShape.$2;
      }
      final correctIndex = options.indexOf(targetShape.$2);
      
      // French options
      final optionsFrench = options.map((opt) {
        return shapes.firstWhere((s) => s.$2 == opt).$3;
      }).toList();

      questions.add(Question(
        id: 'level_k_shape_$i',
        type: QuestionType.nonVerbal,
        subType: 'shape_recognition',
        stem: 'Which shape is this?',
        stemFrench: 'Quelle est cette forme?',
        options: options,
        optionsFrench: optionsFrench,
        correctAnswer: correctIndex,
        explanation: 'This is a ${targetShape.$2}.',
        explanationFrench: 'C\'est un ${targetShape.$3}.',
        difficulty: Difficulty.easy,
        level: CCATLevel.levelK,
        visualData: {
          'type': 'shapePattern', // Using shapePattern to display single shape
          'data': {
            'patterns': [targetShape.$1],
            'colors': [targetShape.$4.value], // Store color value as int
          }
        },
      ));
    }

    // 2. Counting (Visual)
    for (var i = 0; i < 10; i++) {
      final count = i + 1;
      final options = [count.toString(), (count + 1).toString(), (count + 2).toString(), (count > 1 ? count - 1 : count + 3).toString()]..shuffle();
      final correctIndex = options.indexOf(count.toString());

      questions.add(Question(
        id: 'level_k_counting_$i',
        type: QuestionType.quantitative,
        subType: 'counting',
        stem: 'How many stars are there?',
        stemFrench: 'Combien d\'étoiles y a-t-il?',
        options: options,
        optionsFrench: options,
        correctAnswer: correctIndex,
        explanation: 'There are $count stars.',
        explanationFrench: 'Il y a $count étoiles.',
        difficulty: Difficulty.easy,
        level: CCATLevel.levelK,
        visualData: {
          'type': 'countingObjects',
          'data': {
            'count': count,
            'icon': 0xe5f9, // Icons.star code point
            'color': Colors.amber.value,
          }
        },
      ));
    }

    // 3. Color Recognition
    final colors = [
      (Colors.red, 'Red', 'Rouge'),
      (Colors.blue, 'Blue', 'Bleu'),
      (Colors.green, 'Green', 'Vert'),
      (Colors.yellow, 'Yellow', 'Jaune'),
      (Colors.purple, 'Purple', 'Violet'),
      (Colors.orange, 'Orange', 'Orange'),
    ];

    for (var i = 0; i < 10; i++) {
      final targetColor = colors[i % colors.length];
      final options = List<String>.from(colors.map((c) => c.$2))..shuffle();
      if (!options.contains(targetColor.$2)) {
        options[0] = targetColor.$2;
      }
      final correctIndex = options.indexOf(targetColor.$2);
      
      final optionsFrench = options.map((opt) {
        return colors.firstWhere((c) => c.$2 == opt).$3;
      }).toList();

      questions.add(Question(
        id: 'level_k_color_$i',
        type: QuestionType.nonVerbal,
        subType: 'color_recognition',
        stem: 'What color is this?',
        stemFrench: 'Quelle est cette couleur?',
        options: options,
        optionsFrench: optionsFrench,
        correctAnswer: correctIndex,
        explanation: 'This is ${targetColor.$2}.',
        explanationFrench: 'C\'est ${targetColor.$3}.',
        difficulty: Difficulty.easy,
        level: CCATLevel.levelK,
        visualData: {
          'type': 'colorPattern',
          'data': {
            'colors': [targetColor.$1.value],
          }
        },
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
