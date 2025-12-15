//
//  QuestionDataManager.swift
//  ExcelCCAT
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//  Simplified and robust implementation
//

import Foundation

// MARK: - Question Data Manager
class QuestionDataManager: ObservableObject {
    static let shared = QuestionDataManager()
    
    @Published private(set) var allQuestions: [Question] = []
    
    init() {
        print("📚 QuestionDataManager init() called")
        loadQuestions()
        print("📚 QuestionDataManager initialized with \(allQuestions.count) questions")
    }
    
    // MARK: - Public Methods
    
    func getConfiguredQuestions(configuration: TestConfiguration, language: Language) -> [Question] {
        print("📚 getConfiguredQuestions called")
        print("📚 Requested count: \(configuration.questionCount), Level: \(configuration.level)")
        print("📚 Current allQuestions count: \(allQuestions.count)")
        
        let requestedCount = configuration.questionCount
        let level = configuration.level
        
        // Ensure questions exist
        if allQuestions.isEmpty {
            print("📚 allQuestions is EMPTY! Loading questions...")
            loadQuestions()
            print("📚 After loading: \(allQuestions.count) questions")
        }
        
        // Filter by level
        var questions = allQuestions.filter { $0.level == level }
        print("📚 Questions for level \(level): \(questions.count)")
        
        // Fallback: use all questions if none for level
        if questions.isEmpty {
            print("📚 No questions for level, using all questions")
            questions = allQuestions
        }
        
        // Last resort: generate questions
        if questions.isEmpty {
            print("📚 Still empty! Generating emergency questions...")
            questions = generateQuestions(count: requestedCount, level: level)
            allQuestions.append(contentsOf: questions)
        }
        
        // Shuffle and ensure we have enough
        var result = questions.shuffled()
        while result.count < requestedCount {
            result.append(contentsOf: questions.shuffled())
        }
        
        let finalResult = Array(result.prefix(requestedCount))
        print("📚 Returning \(finalResult.count) questions")
        return finalResult
    }
    
    func getFullMockQuestions(language: Language, level: CCATLevel = .level12, set: Int = 1) -> [Question] {
        let config = TestConfiguration(testType: .fullMock, level: level)
        return getConfiguredQuestions(configuration: config, language: language)
    }
    
    func getPracticeQuestions(
        type: QuestionType,
        subType: String? = nil,
        difficulty: Difficulty? = nil,
        language: Language,
        count: Int,
        level: CCATLevel = .level12
    ) -> [Question] {
        var filtered = allQuestions.filter { $0.type == type && $0.level == level }
        
        if let subType = subType {
            filtered = filtered.filter { $0.subType == subType }
        }
        
        if let difficulty = difficulty {
            filtered = filtered.filter { $0.difficulty == difficulty.rawValue }
        }
        
        if filtered.isEmpty {
            filtered = generateQuestions(count: count, level: level, type: type)
        }
        
        return Array(filtered.shuffled().prefix(count))
    }
    
    func getQuestionsByType(_ type: QuestionType, level: CCATLevel = .level12, count: Int) -> [Question] {
        var filtered = allQuestions.filter { $0.type == type && $0.level == level }
        if filtered.isEmpty {
            filtered = generateQuestions(count: count, level: level, type: type)
        }
        return Array(filtered.shuffled().prefix(count))
    }
    
    func getQuestionsBySubType(_ subType: String, level: CCATLevel = .level12, count: Int) -> [Question] {
        var filtered = allQuestions.filter { $0.subType == subType && $0.level == level }
        if filtered.isEmpty {
            filtered = allQuestions.filter { $0.level == level }
        }
        return Array(filtered.shuffled().prefix(count))
    }
    
    // MARK: - Private Methods
    
    private func loadQuestions() {
        allQuestions = []
        
        // Generate questions for all levels
        for level in CCATLevel.allCases {
            let levelQuestions = generateQuestionsForLevel(level)
            allQuestions.append(contentsOf: levelQuestions)
        }
    }
    
    private func generateQuestionsForLevel(_ level: CCATLevel) -> [Question] {
        var questions: [Question] = []
        
        // 20 questions per subtype = 60 per type = 180 per level
        questions.append(contentsOf: createVerbalAnalogies(level: level))
        questions.append(contentsOf: createSentenceCompletion(level: level))
        questions.append(contentsOf: createVerbalClassification(level: level))
        
        questions.append(contentsOf: createNumberAnalogies(level: level))
        questions.append(contentsOf: createQuantitativeAnalogies(level: level))
        questions.append(contentsOf: createEquationBuilding(level: level))
        
        questions.append(contentsOf: createFigureMatrices(level: level))
        questions.append(contentsOf: createFigureClassification(level: level))
        questions.append(contentsOf: createFigureSeries(level: level))
        
        return questions
    }
    
    private func generateQuestions(count: Int, level: CCATLevel, type: QuestionType? = nil) -> [Question] {
        var questions: [Question] = []
        
        for i in 1...count {
            let qType = type ?? [QuestionType.verbal, .quantitative, .nonVerbal][i % 3]
            questions.append(createQuestion(type: qType, index: i, level: level))
        }
        
        return questions
    }
    
    private func createQuestion(type: QuestionType, index: Int, level: CCATLevel) -> Question {
        let difficulty = getDifficulty(for: level)
        let subType = getSubType(for: type)
        
        return Question(
            type: type,
            stem: "Question \(index): Select the best answer.",
            stemFrench: "Question \(index): Sélectionnez la meilleure réponse.",
            options: ["Option A", "Option B", "Option C", "Option D"],
            optionsFrench: ["Option A", "Option B", "Option C", "Option D"],
            correctAnswer: index % 4,
            explanation: "The correct answer is Option \(["A", "B", "C", "D"][index % 4]).",
            explanationFrench: "La bonne réponse est Option \(["A", "B", "C", "D"][index % 4]).",
            difficulty: difficulty,
            subType: subType,
            language: .english,
            level: level
        )
    }
    
    // MARK: - Verbal Questions
    
    private func createVerbalAnalogies(level: CCATLevel) -> [Question] {
        let difficulty = getDifficulty(for: level)
        var questions: [Question] = []
        
        let analogies: [(String, [String], Int)] = level == .level10 ? [
            ("Dog is to puppy as cat is to:", ["kitten", "mouse", "bird", "fish"], 0),
            ("Big is to small as tall is to:", ["short", "wide", "long", "thin"], 0),
            ("Sun is to day as moon is to:", ["night", "star", "sky", "cloud"], 0),
            ("Hand is to glove as foot is to:", ["sock", "shoe", "leg", "toe"], 1),
            ("Bird is to fly as fish is to:", ["swim", "walk", "run", "jump"], 0),
            ("Apple is to fruit as carrot is to:", ["vegetable", "food", "orange", "plant"], 0),
            ("Eye is to see as ear is to:", ["hear", "smell", "taste", "touch"], 0),
            ("Book is to read as movie is to:", ["watch", "listen", "play", "write"], 0),
            ("Happy is to sad as up is to:", ["down", "left", "right", "middle"], 0),
            ("Cow is to milk as hen is to:", ["egg", "meat", "feather", "chick"], 0),
            ("Hot is to cold as wet is to:", ["dry", "warm", "cool", "damp"], 0),
            ("Night is to dark as day is to:", ["light", "sun", "warm", "morning"], 0),
            ("Pen is to write as brush is to:", ["paint", "clean", "draw", "color"], 0),
            ("Mouth is to eat as nose is to:", ["smell", "breathe", "see", "hear"], 0),
            ("Tree is to leaf as flower is to:", ["petal", "stem", "root", "seed"], 0)
        ] : level == .level11 ? [
            ("Author is to book as composer is to:", ["song", "instrument", "concert", "band"], 0),
            ("Library is to books as museum is to:", ["artifacts", "tickets", "guides", "visitors"], 0),
            ("Chef is to kitchen as pilot is to:", ["cockpit", "plane", "airport", "sky"], 0),
            ("Brush is to paint as pen is to:", ["ink", "paper", "write", "letter"], 0),
            ("Doctor is to patient as teacher is to:", ["student", "school", "book", "class"], 0),
            ("Seed is to plant as egg is to:", ["bird", "nest", "fly", "feather"], 0),
            ("Clock is to time as thermometer is to:", ["temperature", "heat", "cold", "weather"], 0),
            ("Knife is to cut as hammer is to:", ["nail", "pound", "wood", "build"], 1),
            ("Wool is to sheep as silk is to:", ["worm", "spider", "bee", "ant"], 0),
            ("Mountain is to climb as river is to:", ["cross", "swim", "boat", "fish"], 0),
            ("Telescope is to stars as microscope is to:", ["cells", "glass", "light", "lens"], 0),
            ("Orchestra is to conductor as team is to:", ["coach", "player", "game", "field"], 0),
            ("Poem is to stanza as play is to:", ["act", "stage", "script", "actor"], 0),
            ("Map is to geography as atlas is to:", ["maps", "countries", "world", "travel"], 0),
            ("Electricity is to wire as water is to:", ["pipe", "faucet", "flow", "liquid"], 0)
        ] : [
            ("Ephemeral is to permanent as volatile is to:", ["stable", "explosive", "liquid", "gas"], 0),
            ("Meticulous is to careless as frugal is to:", ["wasteful", "careful", "poor", "rich"], 0),
            ("Archipelago is to islands as constellation is to:", ["stars", "planets", "galaxies", "moons"], 0),
            ("Taciturn is to talkative as somber is to:", ["cheerful", "dark", "serious", "quiet"], 0),
            ("Chronometer is to time as barometer is to:", ["pressure", "temperature", "distance", "speed"], 0),
            ("Eloquent is to inarticulate as benevolent is to:", ["malevolent", "generous", "kind", "wealthy"], 0),
            ("Hypothesis is to theory as sketch is to:", ["painting", "drawing", "color", "canvas"], 0),
            ("Nocturnal is to diurnal as aquatic is to:", ["terrestrial", "marine", "amphibian", "aerial"], 0),
            ("Catalyst is to reaction as stimulus is to:", ["response", "action", "cause", "effect"], 0),
            ("Symmetry is to balance as asymmetry is to:", ["imbalance", "order", "chaos", "harmony"], 0),
            ("Prolific is to unproductive as verbose is to:", ["concise", "wordy", "long", "short"], 0),
            ("Antidote is to poison as remedy is to:", ["disease", "cure", "medicine", "doctor"], 0),
            ("Monarchy is to king as democracy is to:", ["citizens", "president", "vote", "freedom"], 0),
            ("Plagiarism is to writing as forgery is to:", ["art", "crime", "fake", "copy"], 0),
            ("Omniscient is to knowledge as omnipotent is to:", ["power", "wisdom", "strength", "ability"], 0)
        ]
        
        for (stem, options, correct) in analogies {
            questions.append(Question(
                type: .verbal,
                stem: stem,
                stemFrench: stem + " (FR)",
                options: options,
                optionsFrench: options,
                correctAnswer: correct,
                explanation: "The correct answer is \(options[correct]).",
                explanationFrench: "La bonne réponse est \(options[correct]).",
                difficulty: difficulty,
                subType: VerbalSubType.analogies.rawValue,
                language: .english,
                level: level
            ))
        }
        
        // Ensure we have at least 20 questions
        while questions.count < 20 {
            questions.append(contentsOf: questions.prefix(20 - questions.count))
        }
        
        return Array(questions.prefix(20))
    }
    
    private func createSentenceCompletion(level: CCATLevel) -> [Question] {
        let difficulty = getDifficulty(for: level)
        var questions: [Question] = []
        
        let sentences: [(String, [String], Int)] = level == .level10 ? [
            ("The cat was very _____ and purred loudly.", ["happy", "angry", "scared", "tired"], 0),
            ("After running, I felt very _____.", ["tired", "excited", "hungry", "cold"], 0),
            ("The sun was bright, so I wore my _____.", ["sunglasses", "boots", "jacket", "hat"], 0),
            ("It was raining, so we stayed _____.", ["inside", "outside", "wet", "cold"], 0),
            ("The baby _____ when she was hungry.", ["cried", "laughed", "slept", "played"], 0),
            ("We use an umbrella when it _____.", ["rains", "snows", "shines", "winds"], 0),
            ("The dog wagged its _____ happily.", ["tail", "ear", "paw", "nose"], 0),
            ("I brush my _____ every morning.", ["teeth", "shoes", "bag", "desk"], 0),
            ("Birds build _____ in trees.", ["nests", "houses", "caves", "holes"], 0),
            ("We drink water when we are _____.", ["thirsty", "hungry", "tired", "happy"], 0)
        ] : level == .level11 ? [
            ("The scientist's hypothesis was _____ by the results.", ["validated", "ignored", "created", "changed"], 0),
            ("Despite her shy appearance, she was actually quite _____.", ["outgoing", "quiet", "nervous", "boring"], 0),
            ("The ancient ruins were _____ preserved.", ["remarkably", "poorly", "quickly", "loudly"], 0),
            ("The detective _____ the clues carefully.", ["examined", "ignored", "lost", "created"], 0),
            ("The team worked _____ to finish the project.", ["together", "alone", "slowly", "carelessly"], 0),
            ("The museum's collection was truly _____.", ["impressive", "boring", "small", "empty"], 0),
            ("The storm _____ the coastal town.", ["devastated", "created", "helped", "ignored"], 0),
            ("Her _____ speech inspired the audience.", ["eloquent", "boring", "quiet", "short"], 0),
            ("The _____ student always asked questions.", ["curious", "lazy", "quiet", "sleepy"], 0),
            ("The chef's _____ dish won the competition.", ["signature", "simple", "quick", "cold"], 0)
        ] : [
            ("The politician's _____ speech failed to convince the audience.", ["bombastic", "sincere", "brief", "eloquent"], 0),
            ("Her _____ nature made her popular among colleagues.", ["affable", "hostile", "indifferent", "withdrawn"], 0),
            ("The judge's _____ ruling satisfied neither party.", ["ambiguous", "clear", "fair", "harsh"], 0),
            ("The _____ evidence was insufficient for conviction.", ["circumstantial", "conclusive", "compelling", "overwhelming"], 0),
            ("Despite his _____, he remained humble.", ["achievements", "failures", "wealth", "poverty"], 0),
            ("The treaty brought a _____ end to the conflict.", ["precarious", "permanent", "sudden", "violent"], 0),
            ("Her _____ remarks offended everyone present.", ["caustic", "kind", "gentle", "thoughtful"], 0),
            ("The author's _____ style appealed to critics.", ["innovative", "derivative", "simple", "boring"], 0),
            ("The _____ nature of the issue required careful handling.", ["sensitive", "simple", "obvious", "trivial"], 0),
            ("His _____ behavior concerned his family.", ["erratic", "consistent", "normal", "expected"], 0)
        ]
        
        for (stem, options, correct) in sentences {
            questions.append(Question(
                type: .verbal,
                stem: stem,
                stemFrench: stem + " (FR)",
                options: options,
                optionsFrench: options,
                correctAnswer: correct,
                explanation: "The correct answer is \(options[correct]).",
                explanationFrench: "La bonne réponse est \(options[correct]).",
                difficulty: difficulty,
                subType: VerbalSubType.sentenceCompletion.rawValue,
                language: .english,
                level: level
            ))
        }
        
        while questions.count < 20 {
            questions.append(contentsOf: questions.prefix(20 - questions.count))
        }
        
        return Array(questions.prefix(20))
    }
    
    private func createVerbalClassification(level: CCATLevel) -> [Question] {
        let difficulty = getDifficulty(for: level)
        var questions: [Question] = []
        
        let classifications: [(String, [String], Int)] = level == .level10 ? [
            ("Which doesn't belong? Apple, Banana, Carrot, Orange", ["Carrot", "Apple", "Banana", "Orange"], 0),
            ("Which doesn't belong? Dog, Cat, Bird, Table", ["Table", "Dog", "Cat", "Bird"], 0),
            ("Which doesn't belong? Red, Blue, Green, Happy", ["Happy", "Red", "Blue", "Green"], 0),
            ("Which doesn't belong? Car, Truck, Bicycle, Tree", ["Tree", "Car", "Truck", "Bicycle"], 0),
            ("Which doesn't belong? One, Two, Three, Book", ["Book", "One", "Two", "Three"], 0),
            ("Which doesn't belong? Monday, Friday, Apple, Sunday", ["Apple", "Monday", "Friday", "Sunday"], 0),
            ("Which doesn't belong? Circle, Square, Triangle, Music", ["Music", "Circle", "Square", "Triangle"], 0),
            ("Which doesn't belong? Shirt, Pants, Hat, Pizza", ["Pizza", "Shirt", "Pants", "Hat"], 0),
            ("Which doesn't belong? Run, Jump, Sleep, Chair", ["Chair", "Run", "Jump", "Sleep"], 0),
            ("Which doesn't belong? Water, Juice, Milk, Bread", ["Bread", "Water", "Juice", "Milk"], 0)
        ] : level == .level11 ? [
            ("Which doesn't belong? Mercury, Venus, Sun, Mars", ["Sun", "Mercury", "Venus", "Mars"], 0),
            ("Which doesn't belong? Piano, Violin, Drum, Painting", ["Painting", "Piano", "Violin", "Drum"], 0),
            ("Which doesn't belong? Triangle, Square, Circle, Cube", ["Cube", "Triangle", "Square", "Circle"], 0),
            ("Which doesn't belong? Hydrogen, Oxygen, Water, Nitrogen", ["Water", "Hydrogen", "Oxygen", "Nitrogen"], 0),
            ("Which doesn't belong? Paris, London, Europe, Tokyo", ["Europe", "Paris", "London", "Tokyo"], 0),
            ("Which doesn't belong? Addition, Subtraction, Grammar, Division", ["Grammar", "Addition", "Subtraction", "Division"], 0),
            ("Which doesn't belong? Eagle, Sparrow, Penguin, Whale", ["Whale", "Eagle", "Sparrow", "Penguin"], 0),
            ("Which doesn't belong? January, March, Summer, December", ["Summer", "January", "March", "December"], 0),
            ("Which doesn't belong? Copper, Gold, Silver, Wood", ["Wood", "Copper", "Gold", "Silver"], 0),
            ("Which doesn't belong? Soccer, Tennis, Basketball, Reading", ["Reading", "Soccer", "Tennis", "Basketball"], 0)
        ] : [
            ("Which doesn't belong? Monarchy, Democracy, Republic, Capitalism", ["Capitalism", "Monarchy", "Democracy", "Republic"], 0),
            ("Which doesn't belong? Metaphor, Simile, Hyperbole, Paragraph", ["Paragraph", "Metaphor", "Simile", "Hyperbole"], 0),
            ("Which doesn't belong? Photosynthesis, Respiration, Digestion, Gravity", ["Gravity", "Photosynthesis", "Respiration", "Digestion"], 0),
            ("Which doesn't belong? Baroque, Renaissance, Gothic, Industrial", ["Industrial", "Baroque", "Renaissance", "Gothic"], 0),
            ("Which doesn't belong? Sonnet, Haiku, Limerick, Novel", ["Novel", "Sonnet", "Haiku", "Limerick"], 0),
            ("Which doesn't belong? Algebra, Geometry, Calculus, Literature", ["Literature", "Algebra", "Geometry", "Calculus"], 0),
            ("Which doesn't belong? Nitrogen, Helium, Argon, Iron", ["Iron", "Nitrogen", "Helium", "Argon"], 0),
            ("Which doesn't belong? Symphony, Concerto, Sonata, Sculpture", ["Sculpture", "Symphony", "Concerto", "Sonata"], 0),
            ("Which doesn't belong? Mitosis, Meiosis, Osmosis, Photosynthesis", ["Photosynthesis", "Mitosis", "Meiosis", "Osmosis"], 0),
            ("Which doesn't belong? Impressionism, Cubism, Romanticism, Capitalism", ["Capitalism", "Impressionism", "Cubism", "Romanticism"], 0)
        ]
        
        for (stem, options, correct) in classifications {
            questions.append(Question(
                type: .verbal,
                stem: stem,
                stemFrench: stem + " (FR)",
                options: options,
                optionsFrench: options,
                correctAnswer: correct,
                explanation: "The correct answer is \(options[correct]).",
                explanationFrench: "La bonne réponse est \(options[correct]).",
                difficulty: difficulty,
                subType: VerbalSubType.classification.rawValue,
                language: .english,
                level: level
            ))
        }
        
        while questions.count < 20 {
            questions.append(contentsOf: questions.prefix(20 - questions.count))
        }
        
        return Array(questions.prefix(20))
    }
    
    // MARK: - Quantitative Questions
    
    private func createNumberAnalogies(level: CCATLevel) -> [Question] {
        let difficulty = getDifficulty(for: level)
        var questions: [Question] = []
        
        let analogies: [(String, [String], Int)] = level == .level10 ? [
            ("2 : 4 :: 3 : ?", ["5", "6", "7", "8"], 1),
            ("1 : 2 :: 5 : ?", ["8", "9", "10", "11"], 2),
            ("3 : 9 :: 4 : ?", ["12", "14", "16", "18"], 2),
            ("10 : 5 :: 8 : ?", ["2", "3", "4", "6"], 2),
            ("2 : 6 :: 4 : ?", ["8", "10", "12", "14"], 2),
            ("5 : 10 :: 7 : ?", ["12", "13", "14", "15"], 2),
            ("1 : 1 :: 2 : ?", ["2", "3", "4", "5"], 0),
            ("6 : 3 :: 10 : ?", ["4", "5", "6", "7"], 1),
            ("4 : 8 :: 5 : ?", ["9", "10", "11", "12"], 1),
            ("3 : 6 :: 6 : ?", ["9", "10", "11", "12"], 3)
        ] : level == .level11 ? [
            ("5 : 25 :: 6 : ?", ["30", "36", "42", "48"], 1),
            ("8 : 64 :: 9 : ?", ["72", "81", "90", "99"], 1),
            ("2 : 8 :: 3 : ?", ["18", "24", "27", "30"], 2),
            ("12 : 4 :: 18 : ?", ["3", "6", "9", "12"], 1),
            ("7 : 49 :: 8 : ?", ["56", "64", "72", "80"], 1),
            ("4 : 16 :: 5 : ?", ["20", "25", "30", "35"], 1),
            ("9 : 27 :: 10 : ?", ["30", "33", "36", "39"], 0),
            ("6 : 36 :: 7 : ?", ["42", "49", "56", "63"], 1),
            ("3 : 12 :: 5 : ?", ["15", "20", "25", "30"], 1),
            ("11 : 121 :: 12 : ?", ["132", "144", "156", "168"], 1)
        ] : [
            ("3 : 27 :: 4 : ?", ["64", "48", "36", "16"], 0),
            ("2 : 16 :: 3 : ?", ["81", "72", "64", "54"], 0),
            ("5 : 125 :: 4 : ?", ["64", "80", "100", "120"], 0),
            ("1, 4, 9, 16, ?", ["20", "24", "25", "30"], 2),
            ("2, 6, 12, 20, ?", ["28", "30", "32", "36"], 1),
            ("1, 1, 2, 3, 5, ?", ["7", "8", "9", "10"], 1),
            ("2 : 32 :: 3 : ?", ["243", "81", "27", "9"], 0),
            ("4 : 256 :: 5 : ?", ["625", "125", "25", "5"], 0),
            ("1, 3, 6, 10, ?", ["13", "14", "15", "16"], 2),
            ("2, 3, 5, 7, 11, ?", ["12", "13", "14", "15"], 1)
        ]
        
        for (stem, options, correct) in analogies {
            questions.append(Question(
                type: .quantitative,
                stem: stem,
                stemFrench: stem,
                options: options,
                optionsFrench: options,
                correctAnswer: correct,
                explanation: "The correct answer is \(options[correct]).",
                explanationFrench: "La bonne réponse est \(options[correct]).",
                difficulty: difficulty,
                subType: QuantitativeSubType.numberAnalogies.rawValue,
                language: .english,
                level: level
            ))
        }
        
        while questions.count < 20 {
            questions.append(contentsOf: questions.prefix(20 - questions.count))
        }
        
        return Array(questions.prefix(20))
    }
    
    private func createQuantitativeAnalogies(level: CCATLevel) -> [Question] {
        let difficulty = getDifficulty(for: level)
        var questions: [Question] = []
        
        let analogies: [(String, [String], Int)] = level == .level10 ? [
            ("△ + △ = 6. What is △?", ["2", "3", "4", "5"], 1),
            ("○ + 2 = 7. What is ○?", ["4", "5", "6", "7"], 1),
            ("□ - 3 = 5. What is □?", ["6", "7", "8", "9"], 2),
            ("2 × ★ = 8. What is ★?", ["2", "3", "4", "5"], 2),
            ("◇ ÷ 2 = 3. What is ◇?", ["4", "5", "6", "7"], 2),
            ("△ + 5 = 9. What is △?", ["3", "4", "5", "6"], 1),
            ("10 - ○ = 4. What is ○?", ["4", "5", "6", "7"], 2),
            ("□ × 3 = 12. What is □?", ["2", "3", "4", "5"], 2),
            ("8 ÷ ★ = 2. What is ★?", ["2", "3", "4", "5"], 2),
            ("◇ + ◇ = 10. What is ◇?", ["4", "5", "6", "7"], 1)
        ] : level == .level11 ? [
            ("If △ × △ = 16, what is △?", ["2", "3", "4", "5"], 2),
            ("If ○ + ○ + ○ = 15, what is ○?", ["3", "4", "5", "6"], 2),
            ("If □ × 3 + 2 = 14, what is □?", ["3", "4", "5", "6"], 1),
            ("If ★ ÷ 4 = 5, what is ★?", ["16", "18", "20", "22"], 2),
            ("If 2◇ - 5 = 7, what is ◇?", ["4", "5", "6", "7"], 2),
            ("If △ × △ = 25, what is △?", ["4", "5", "6", "7"], 1),
            ("If 3○ + 3 = 18, what is ○?", ["4", "5", "6", "7"], 1),
            ("If □ ÷ 3 + 4 = 8, what is □?", ["9", "10", "11", "12"], 3),
            ("If 4★ = 24, what is ★?", ["4", "5", "6", "7"], 2),
            ("If ◇ × ◇ = 36, what is ◇?", ["4", "5", "6", "7"], 2)
        ] : [
            ("If △² + 1 = 26, what is △?", ["4", "5", "6", "7"], 1),
            ("If 3○ + 2○ = 25, what is ○?", ["4", "5", "6", "7"], 1),
            ("If □³ = 27, what is □?", ["2", "3", "4", "5"], 1),
            ("If √★ = 7, what is ★?", ["42", "49", "56", "63"], 1),
            ("If ◇! = 24, what is ◇?", ["2", "3", "4", "5"], 2),
            ("If 2^△ = 32, what is △?", ["4", "5", "6", "7"], 1),
            ("If ○² - 4 = 21, what is ○?", ["4", "5", "6", "7"], 1),
            ("If □/□ × 5 = 5, any value of □ works. If □ + □ = 10, what is □?", ["4", "5", "6", "7"], 1),
            ("If 2★ + 3★ = 35, what is ★?", ["5", "6", "7", "8"], 2),
            ("If ◇² = 144, what is ◇?", ["10", "11", "12", "13"], 2)
        ]
        
        for (stem, options, correct) in analogies {
            questions.append(Question(
                type: .quantitative,
                stem: stem,
                stemFrench: stem,
                options: options,
                optionsFrench: options,
                correctAnswer: correct,
                explanation: "The correct answer is \(options[correct]).",
                explanationFrench: "La bonne réponse est \(options[correct]).",
                difficulty: difficulty,
                subType: QuantitativeSubType.quantitativeAnalogies.rawValue,
                language: .english,
                level: level
            ))
        }
        
        while questions.count < 20 {
            questions.append(contentsOf: questions.prefix(20 - questions.count))
        }
        
        return Array(questions.prefix(20))
    }
    
    private func createEquationBuilding(level: CCATLevel) -> [Question] {
        let difficulty = getDifficulty(for: level)
        var questions: [Question] = []
        
        let equations: [(String, [String], Int)] = level == .level10 ? [
            ("Complete: 5 + ? = 12", ["6", "7", "8", "9"], 1),
            ("Complete: ? - 4 = 6", ["8", "9", "10", "11"], 2),
            ("Complete: 3 × ? = 15", ["4", "5", "6", "7"], 1),
            ("Complete: 20 ÷ ? = 4", ["4", "5", "6", "7"], 1),
            ("Complete: 8 + ? = 15", ["5", "6", "7", "8"], 2),
            ("Complete: ? × 2 = 14", ["5", "6", "7", "8"], 2),
            ("Complete: 18 - ? = 9", ["7", "8", "9", "10"], 2),
            ("Complete: ? ÷ 3 = 4", ["10", "11", "12", "13"], 2),
            ("Complete: 6 + 6 = ?", ["10", "11", "12", "13"], 2),
            ("Complete: 4 × 4 = ?", ["12", "14", "16", "18"], 2)
        ] : level == .level11 ? [
            ("Complete: (8 + ?) × 2 = 20", ["2", "3", "4", "5"], 0),
            ("What is ? if 15 ÷ ? = 3", ["3", "4", "5", "6"], 2),
            ("Complete: ? × 7 - 3 = 18", ["2", "3", "4", "5"], 1),
            ("Complete: 24 ÷ (? + 2) = 4", ["3", "4", "5", "6"], 1),
            ("Complete: (? - 5) × 3 = 12", ["7", "8", "9", "10"], 2),
            ("Complete: 5 × ? + 5 = 30", ["4", "5", "6", "7"], 1),
            ("Complete: 36 ÷ ? - 3 = 3", ["4", "5", "6", "7"], 2),
            ("Complete: (10 + ?) ÷ 3 = 5", ["3", "4", "5", "6"], 2),
            ("Complete: ? × ? = 49", ["6", "7", "8", "9"], 1),
            ("Complete: 2 × ? + 8 = 20", ["5", "6", "7", "8"], 1)
        ] : [
            ("Complete: (? + 3)² = 49", ["2", "3", "4", "5"], 2),
            ("If 2x + 5 = 17, what is x?", ["5", "6", "7", "8"], 1),
            ("Complete: √? + 5 = 9", ["12", "14", "16", "18"], 2),
            ("If 3(x - 2) = 15, what is x?", ["5", "6", "7", "8"], 2),
            ("Complete: ?² - 5 = 20", ["4", "5", "6", "7"], 1),
            ("If 4x - 3 = 2x + 7, what is x?", ["3", "4", "5", "6"], 2),
            ("Complete: (? × 3)² = 81", ["2", "3", "4", "5"], 1),
            ("If x/4 + 3 = 7, what is x?", ["12", "14", "16", "18"], 2),
            ("Complete: 2^? = 64", ["4", "5", "6", "7"], 2),
            ("If 5x = x + 20, what is x?", ["4", "5", "6", "7"], 1)
        ]
        
        for (stem, options, correct) in equations {
            questions.append(Question(
                type: .quantitative,
                stem: stem,
                stemFrench: stem,
                options: options,
                optionsFrench: options,
                correctAnswer: correct,
                explanation: "The correct answer is \(options[correct]).",
                explanationFrench: "La bonne réponse est \(options[correct]).",
                difficulty: difficulty,
                subType: QuantitativeSubType.equationBuilding.rawValue,
                language: .english,
                level: level
            ))
        }
        
        while questions.count < 20 {
            questions.append(contentsOf: questions.prefix(20 - questions.count))
        }
        
        return Array(questions.prefix(20))
    }
    
    // MARK: - Non-Verbal Questions
    
    private func createFigureMatrices(level: CCATLevel) -> [Question] {
        let difficulty = getDifficulty(for: level)
        var questions: [Question] = []
        
        let matrices: [(String, [String], Int)] = level == .level10 ? [
            ("Pattern: ○ → ○○ → ○○○. What comes next?", ["○○○○", "○○", "○", "○○○○○"], 0),
            ("Pattern: □ increases by 1 each step. □, □□, □□□, ?", ["□□□□", "□□", "□□□□□", "□"], 0),
            ("Pattern: Shape rotates 90° each step. Which is next?", ["Rotated 360°", "Rotated 180°", "Rotated 90°", "Rotated 270°"], 0),
            ("If top row has 2 shapes and bottom has 4, what's middle?", ["3", "2", "4", "5"], 0),
            ("Pattern: Big → Medium → Small → ?", ["Tiny", "Big", "Medium", "Large"], 0),
            ("Pattern adds 1 dot: •, ••, •••, ?", ["••••", "•", "••", "•••••"], 0),
            ("Color pattern: Red, Blue, Red, ?", ["Blue", "Red", "Green", "Yellow"], 0),
            ("Size pattern: 1, 2, 3, ?", ["4", "5", "6", "3"], 0),
            ("Shape sequence: △, □, ○, △, ?", ["□", "○", "△", "◇"], 0),
            ("Pattern: ↑, →, ↓, ?", ["←", "↑", "→", "↓"], 0)
        ] : level == .level11 ? [
            ("Matrix: Row 1 (○□△), Row 2 (□△○), Row 3 (△○?)", ["□", "○", "△", "◇"], 0),
            ("Pattern doubles: 1, 2, 4, 8, ?", ["12", "14", "16", "18"], 2),
            ("Shape gains 1 side: △→□→⬠→?", ["○", "⬡", "◇", "★"], 1),
            ("Pattern: Black, White, Black, White, ?", ["Black", "White", "Gray", "Both"], 0),
            ("Matrix adds one element per cell. R1: 1,2,3. R2: 2,3,?", ["4", "5", "6", "1"], 0),
            ("Rotation: 0°, 45°, 90°, 135°, ?", ["180°", "170°", "160°", "150°"], 0),
            ("Each row sums to 10. Row: 3, 4, ?", ["3", "4", "5", "6"], 0),
            ("Pattern: +2, +3, +4, ... Start 1: 1, 3, 6, 10, ?", ["14", "15", "16", "17"], 1),
            ("Grid: Each shape appears once per row/column. Missing?", ["Shape not in row/col", "Any", "None", "All"], 0),
            ("Sequence: ◐, ◑, ●, ○, ?", ["◐", "◑", "●", "○"], 0)
        ] : [
            ("3×3 Matrix: Each row and column has ○□△. Missing?", ["Shape not in row/col", "○", "□", "△"], 0),
            ("Pattern: Rotate 45° + add element each step. Step 4?", ["180° + 4 elements", "135° + 3", "90° + 4", "180° + 3"], 0),
            ("Matrix rule: Row elements combine. Apply rule.", ["Combined result", "All", "None", "Random"], 0),
            ("Pattern: Inner→outer swap each step. Step 3?", ["Triple swap", "Original", "Single", "Double"], 0),
            ("Fibonacci visual: 1,1,2,3,5. Position 7?", ["13", "8", "21", "5"], 0),
            ("Complex matrix: Diagonal sum = 15. Missing value?", ["Value making sum 15", "0", "15", "5"], 0),
            ("Pattern: Color intensity increases 25% each step. Step 5?", ["100% (full)", "75%", "125%", "50%"], 0),
            ("Matrix: Alternating +/- pattern. Complete grid.", ["Following pattern", "Random", "All +", "All -"], 0),
            ("Sequence: 2^n visual. n=6?", ["64", "32", "128", "16"], 0),
            ("Grid: Latin square completion. Missing?", ["Unique per row/col", "Any", "Repeat", "None"], 0)
        ]
        
        for (stem, options, correct) in matrices {
            questions.append(Question(
                type: .nonVerbal,
                stem: stem,
                stemFrench: stem + " (FR)",
                options: options,
                optionsFrench: options,
                correctAnswer: correct,
                explanation: "The correct answer is \(options[correct]).",
                explanationFrench: "La bonne réponse est \(options[correct]).",
                difficulty: difficulty,
                subType: NonVerbalSubType.figureMatrices.rawValue,
                language: .english,
                level: level
            ))
        }
        
        while questions.count < 20 {
            questions.append(contentsOf: questions.prefix(20 - questions.count))
        }
        
        return Array(questions.prefix(20))
    }
    
    private func createFigureClassification(level: CCATLevel) -> [Question] {
        let difficulty = getDifficulty(for: level)
        var questions: [Question] = []
        
        let classifications: [(String, [String], Int)] = level == .level10 ? [
            ("Which doesn't belong? ○ ○ ○ □", ["□", "○", "All same", "None"], 0),
            ("Which is different? △ △ △ △(filled)", ["Filled △", "Empty △", "All same", "None"], 0),
            ("All are circles except one. Which?", ["The square", "First", "Second", "Third"], 0),
            ("Which has different sides? △ □ ○ ⬠", ["○ (no sides)", "△", "□", "⬠"], 0),
            ("Which is biggest? Small○, Medium○, Large○, Small□", ["Large○", "Small○", "Medium○", "Small□"], 0),
            ("All pointing up except?", ["Down arrow", "Arrow 1", "Arrow 2", "Arrow 3"], 0),
            ("All same color except?", ["Different color", "Same 1", "Same 2", "Same 3"], 0),
            ("All have curves except?", ["Rectangle", "Circle", "Oval", "Arc"], 0),
            ("All filled except?", ["Hollow", "Filled 1", "Filled 2", "Filled 3"], 0),
            ("Which is smallest?", ["Smallest item", "Large", "Medium", "Small"], 0)
        ] : level == .level11 ? [
            ("Group: All have curved lines except?", ["Rectangle", "Circle", "Oval", "Arc"], 0),
            ("Group: All symmetrical except?", ["Irregular polygon", "Square", "Circle", "Rectangle"], 0),
            ("Group: All have 4 sides except?", ["Triangle", "Square", "Rectangle", "Rhombus"], 0),
            ("Group: All pointing up except?", ["Down arrow", "Up 1", "Up 2", "Up 3"], 0),
            ("Group: All filled except?", ["Hollow shape", "Filled 1", "Filled 2", "Filled 3"], 0),
            ("Group: All 2D shapes except?", ["Cube", "Square", "Circle", "Triangle"], 0),
            ("Group: All regular polygons except?", ["Irregular", "Square", "Pentagon", "Hexagon"], 0),
            ("Group: All have right angles except?", ["Circle", "Square", "Rectangle", "Right triangle"], 0),
            ("Group: All closed shapes except?", ["Arc", "Circle", "Square", "Triangle"], 0),
            ("Group: All convex except?", ["Star", "Circle", "Square", "Triangle"], 0)
        ] : [
            ("Group: All have rotational symmetry except?", ["Scalene triangle", "Square", "Circle", "Hexagon"], 0),
            ("Group: All are convex except?", ["Star (concave)", "Circle", "Triangle", "Square"], 0),
            ("Group: All have equal angles except?", ["Irregular quad", "Square", "Equilateral △", "Regular pentagon"], 0),
            ("Group: All follow same transform except?", ["Odd transform", "Same 1", "Same 2", "Same 3"], 0),
            ("Group: All have line symmetry except?", ["Parallelogram", "Isoceles △", "Rectangle", "Circle"], 0),
            ("Group: All are regular polygons except?", ["Trapezoid", "Square", "Hexagon", "Octagon"], 0),
            ("Group: All have acute angles only except?", ["Right triangle", "Acute △", "Equilateral △", "Acute quad"], 0),
            ("Group: All tessellate except?", ["Pentagon", "Square", "Triangle", "Hexagon"], 0),
            ("Group: All have point symmetry except?", ["Isoceles △", "Parallelogram", "Circle", "Rectangle"], 0),
            ("Group: All are similar figures except?", ["Different ratio", "Similar 1", "Similar 2", "Similar 3"], 0)
        ]
        
        for (stem, options, correct) in classifications {
            questions.append(Question(
                type: .nonVerbal,
                stem: stem,
                stemFrench: stem + " (FR)",
                options: options,
                optionsFrench: options,
                correctAnswer: correct,
                explanation: "The correct answer is \(options[correct]).",
                explanationFrench: "La bonne réponse est \(options[correct]).",
                difficulty: difficulty,
                subType: NonVerbalSubType.figureClassification.rawValue,
                language: .english,
                level: level
            ))
        }
        
        while questions.count < 20 {
            questions.append(contentsOf: questions.prefix(20 - questions.count))
        }
        
        return Array(questions.prefix(20))
    }
    
    private func createFigureSeries(level: CCATLevel) -> [Question] {
        let difficulty = getDifficulty(for: level)
        var questions: [Question] = []
        
        let series: [(String, [String], Int)] = level == .level10 ? [
            ("Series: ○, ○○, ○○○, ?", ["○○○○", "○○", "○", "○○○○○"], 0),
            ("Series: →, ↑, ←, ?", ["↓", "→", "↑", "↔"], 0),
            ("Series: Small, Medium, Large, ?", ["Extra Large", "Small", "Medium", "Tiny"], 0),
            ("Series: 1 dot, 2 dots, 3 dots, ?", ["4 dots", "1 dot", "5 dots", "3 dots"], 0),
            ("Series: White, Gray, Dark Gray, ?", ["Black", "White", "Light", "Clear"], 0),
            ("Series: △, □, △, □, ?", ["△", "□", "○", "◇"], 0),
            ("Series: +1 side each: △, □, ⬠, ?", ["⬡", "○", "◇", "★"], 0),
            ("Series: 90° rotation each step. Step 4?", ["360°", "180°", "270°", "90°"], 2),
            ("Series: Color lightens each step. Step 4?", ["Lightest", "Dark", "Medium", "Light"], 0),
            ("Series: Size doubles. 1, 2, 4, ?", ["8", "6", "5", "10"], 0)
        ] : level == .level11 ? [
            ("Series rotates 90° clockwise. Step 4?", ["270° total", "90°", "180°", "360°"], 0),
            ("Series: Add 1 line each step. Step 5?", ["5 lines", "4", "6", "3"], 0),
            ("Series: △, □, ⬠, ⬡, ?", ["⬢ (7 sides)", "○", "△", "◇"], 0),
            ("Series alternates: ●, ○, ●, ○, ?", ["●", "○", "◐", "None"], 0),
            ("Series: Shape shrinks 50% each. Step 3?", ["25% of original", "50%", "12.5%", "75%"], 0),
            ("Series: +45° rotation per step. Step 5?", ["225°", "180°", "270°", "315°"], 0),
            ("Series: Fibonacci dots. 1,1,2,3,?", ["5", "4", "6", "8"], 0),
            ("Series: Add then remove. +2,-1,+2,-1. From 3?", ["5", "4", "6", "3"], 0),
            ("Series: Inner grows, outer shrinks. Step 3?", ["Equal size", "Inner>Outer", "Inner<Outer", "Both gone"], 0),
            ("Series: Each step adds 1 element. Step 6?", ["6 elements", "5", "7", "4"], 0)
        ] : [
            ("Complex: Rotate 45° + flip each step. Step 4?", ["180°, double flip", "Original", "90°", "45°"], 0),
            ("Series: +2,-1,+2,-1 from 3. Step 5?", ["7", "6", "8", "5"], 0),
            ("Series: Nested shapes, add layer each. Step 4?", ["4 nested", "3", "5", "2"], 0),
            ("Fibonacci visual: 1,1,2,3,5,?", ["8", "6", "7", "9"], 0),
            ("Series: XOR pattern applied. Step 3?", ["Double XOR", "Original", "Single", "Triple"], 0),
            ("Series: Prime number of elements. 2,3,5,?", ["7", "6", "8", "9"], 0),
            ("Series: Rotate + scale × 0.5. Step 4?", ["180°, 1/16 size", "90°, 1/8", "270°, 1/4", "360°, 1/2"], 0),
            ("Series: Triangular numbers: 1,3,6,10,?", ["15", "12", "14", "16"], 0),
            ("Series: Powers of 2 dots: 1,2,4,8,?", ["16", "12", "10", "14"], 0),
            ("Series: Alternating transform: +90°,-45°,+90°,-45°,?", ["+90°", "-45°", "+45°", "-90°"], 0)
        ]
        
        for (stem, options, correct) in series {
            questions.append(Question(
                type: .nonVerbal,
                stem: stem,
                stemFrench: stem + " (FR)",
                options: options,
                optionsFrench: options,
                correctAnswer: correct,
                explanation: "The correct answer is \(options[correct]).",
                explanationFrench: "La bonne réponse est \(options[correct]).",
                difficulty: difficulty,
                subType: NonVerbalSubType.figureSeries.rawValue,
                language: .english,
                level: level
            ))
        }
        
        while questions.count < 20 {
            questions.append(contentsOf: questions.prefix(20 - questions.count))
        }
        
        return Array(questions.prefix(20))
    }
    
    // MARK: - Helper Methods
    
    private func getDifficulty(for level: CCATLevel) -> String {
        switch level {
        case .level10: return Difficulty.easy.rawValue
        case .level11: return Difficulty.medium.rawValue
        case .level12: return Difficulty.hard.rawValue
        }
    }
    
    private func getSubType(for type: QuestionType) -> String {
        switch type {
        case .verbal: return VerbalSubType.analogies.rawValue
        case .quantitative: return QuantitativeSubType.numberAnalogies.rawValue
        case .nonVerbal: return NonVerbalSubType.figureSeries.rawValue
        }
    }
}
