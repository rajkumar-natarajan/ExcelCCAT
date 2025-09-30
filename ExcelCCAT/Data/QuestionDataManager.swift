//
//  QuestionDataManager.swift
//  ExcelCCAT
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import Foundation

class QuestionDataManager: ObservableObject {
    static let shared = QuestionDataManager()
    
    private var allQuestions: [Question] = []
    
    init() {
        loadQuestions()
    }
    
    private func loadQuestions() {
        allQuestions = generateHardcodedQuestions()
        ensureMinimumVolume()
    }
    
    // MARK: - Public Methods
    
    func getFullMockQuestions(language: Language, level: CCATLevel = .level12, set: Int = 1) -> [Question] {
        let levelQuestions = allQuestions.filter { $0.level == level }
        let questionCount = level.questionCount
        
        let base: [Question]
        switch set {
        case 2: base = Array(levelQuestions.shuffled().prefix(questionCount))
        case 3: base = Array(levelQuestions.shuffled().prefix(questionCount))
        default: base = Array(levelQuestions.shuffled().prefix(questionCount))
        }
        
        return base
    }
    
    func getConfiguredQuestions(configuration: TestConfiguration, language: Language) -> [Question] {
        let levelQuestions = allQuestions.filter { $0.level == configuration.level }
        let questionCount = configuration.questionCount
        
        // If we need more questions than available, cycle through them
        if levelQuestions.count >= questionCount {
            return Array(levelQuestions.shuffled().prefix(questionCount))
        } else {
            var questions = levelQuestions.shuffled()
            while questions.count < questionCount {
                questions.append(contentsOf: levelQuestions.shuffled().prefix(min(levelQuestions.count, questionCount - questions.count)))
            }
            return Array(questions.prefix(questionCount))
        }
    }
    
    func getPracticeQuestions(
        type: QuestionType,
        subType: String? = nil,
        difficulty: Difficulty? = nil,
        language: Language,
        count: Int,
        level: CCATLevel = .level12
    ) -> [Question] {
        var filteredQuestions = allQuestions.filter { $0.type == type && $0.level == level }
        
        if let subType = subType {
            filteredQuestions = filteredQuestions.filter { $0.subType == subType }
        }
        
        if let difficulty = difficulty {
            filteredQuestions = filteredQuestions.filter { $0.difficulty == difficulty }
        }
        
        return Array(filteredQuestions.shuffled().prefix(count))
    }
    
    func getQuestionsByType(_ type: QuestionType, level: CCATLevel = .level12, count: Int) -> [Question] {
        let typeQuestions = allQuestions.filter { $0.type == type && $0.level == level }
        if typeQuestions.count <= count { return typeQuestions }
        return Array(typeQuestions.shuffled().prefix(count))
    }
    
    func getQuestionsBySubType(_ subType: String, level: CCATLevel = .level12, count: Int) -> [Question] {
        let subTypeQuestions = allQuestions.filter { $0.subType == subType && $0.level == level }
        if subTypeQuestions.count <= count { return subTypeQuestions }
        return Array(subTypeQuestions.shuffled().prefix(count))
    }
    
    // MARK: - Question Generation
    
    private func generateHardcodedQuestions() -> [Question] {
        var questions: [Question] = []
        
        // Generate questions for all CCAT levels
        for level in CCATLevel.allCases {
            // Generate Verbal Questions for each level
            questions.append(contentsOf: generateVerbalAnalogies(for: level))
            questions.append(contentsOf: generateSentenceCompletion(for: level))
            questions.append(contentsOf: generateVerbalClassification(for: level))
            
            // Generate Quantitative Questions for each level
            questions.append(contentsOf: generateNumberAnalogies(for: level))
            questions.append(contentsOf: generateQuantitativeAnalogies(for: level))
            questions.append(contentsOf: generateEquationBuilding(for: level))
            
            // Generate Non-Verbal Questions for each level
            questions.append(contentsOf: generateFigureMatrices(for: level))
            questions.append(contentsOf: generateFigureClassification(for: level))
            questions.append(contentsOf: generateFigureSeries(for: level))
        }
        
        return questions
    }

    // MARK: - Volume Expansion Helpers
    // To reach the target (≈550+) we synthetically expand certain categories while preserving difficulty spread.
    private func ensureMinimumVolume(targetPerType: Int = 200) {
        QuestionType.allCases.forEach { type in
            let current = allQuestions.filter { $0.type == type }
            if current.count < targetPerType {
                let needed = targetPerType - current.count
                let generated = generateSyntheticQuestions(for: type, count: needed)
                allQuestions.append(contentsOf: generated)
            }
        }
    }
    
    private func generateSyntheticQuestions(for type: QuestionType, count: Int) -> [Question] {
        var synthetic: [Question] = []
        let difficulties: [Difficulty] = [.easy, .medium, .hard]
        for i in 0..<count {
            let difficulty = difficulties[i % difficulties.count]
            switch type {
            case .verbal:
                // Simple generated synonym analogy placeholders
                let stem = "SYN_\(i % 50) is to A as SYN_\(i % 50)B is to:"
                synthetic.append(Question(
                    type: .verbal,
                    stem: stem,
                    stemFrench: stem + " (FR)",
                    options: ["X", "Y", "Z", "W"],
                    optionsFrench: ["X", "Y", "Z", "W"],
                    correctAnswer: 0,
                    explanation: "Synthetic generated verbal analogy.",
                    explanationFrench: "Analogie verbale synthétique.",
                    difficulty: difficulty,
                    subType: VerbalSubType.analogies.rawValue
                ))
            case .quantitative:
                let a = (i % 20) + 2
                let b = a * a
                synthetic.append(Question(
                    type: .quantitative,
                    stem: "\(a) : \(b) :: (a+1) : ?",
                    stemFrench: "\(a) : \(b) :: (a+1) : ? (FR)",
                    options: ["\(b+1)", "\( (a+1)*(a+1) )", "\(b-1)", "\(b+2)"],
                    optionsFrench: ["\(b+1)", "\( (a+1)*(a+1) )", "\(b-1)", "\(b+2)"],
                    correctAnswer: 1,
                    explanation: "Square relationship synthetic.",
                    explanationFrench: "Relation de carré synthétique.",
                    difficulty: difficulty,
                    subType: QuantitativeSubType.numberAnalogies.rawValue
                ))
            case .nonVerbal:
                let stem = "Select the figure continuing pattern #\(i % 40)"
                synthetic.append(Question(
                    type: .nonVerbal,
                    stem: stem,
                    stemFrench: stem + " (FR)",
                    options: ["A", "B", "C", "D"],
                    optionsFrench: ["A", "B", "C", "D"],
                    correctAnswer: Int.random(in: 0...3),
                    explanation: "Synthetic non-verbal pattern.",
                    explanationFrench: "Motif non verbal synthétique.",
                    difficulty: difficulty,
                    subType: NonVerbalSubType.figureSeries.rawValue,
                    imageName: nil
                ))
            }
        }
        return synthetic
    }
    
    // MARK: - Verbal Questions
    
    private func generateVerbalAnalogies(for level: CCATLevel = .level12) -> [Question] {
        let difficulty: Difficulty = getDifficultyForLevel(level)
        let questionCount = getQuestionCountForType(level: level, type: .verbal, subType: VerbalSubType.analogies.rawValue)
        
        var questions: [Question] = []
        
        if level == .level10 {
            // Level 10: Simple, concrete analogies for grades 2-3
            questions.append(contentsOf: [
                Question(
                    type: .verbal,
                    level: level,
                    stem: "Dog is to puppy as cat is to:",
                    stemFrench: "Chien est à chiot comme chat est à:",
                    options: ["kitten", "mouse", "fish", "bird"],
                    optionsFrench: ["chaton", "souris", "poisson", "oiseau"],
                    correctAnswer: 0,
                    explanation: "A puppy is a baby dog, and a kitten is a baby cat.",
                    explanationFrench: "Un chiot est un bébé chien, et un chaton est un bébé chat.",
                    difficulty: difficulty,
                    subType: VerbalSubType.analogies.rawValue
                ),
                Question(
                    type: .verbal,
                    level: level,
                    stem: "Big is to small as tall is to:",
                    stemFrench: "Grand est à petit comme haut est à:",
                    options: ["short", "wide", "long", "fat"],
                    optionsFrench: ["court", "large", "long", "gros"],
                    correctAnswer: 0,
                    explanation: "Big and small are opposites, just like tall and short.",
                    explanationFrench: "Grand et petit sont opposés, tout comme haut et court.",
                    difficulty: difficulty,
                    subType: VerbalSubType.analogies.rawValue
                )
            ])
        } else if level == .level11 {
            // Level 11: Intermediate analogies for grades 4-5
            questions.append(contentsOf: [
                Question(
                    type: .verbal,
                    level: level,
                    stem: "Author is to book as composer is to:",
                    stemFrench: "Auteur est à livre comme compositeur est à:",
                    options: ["song", "instrument", "concert", "orchestra"],
                    optionsFrench: ["chanson", "instrument", "concert", "orchestre"],
                    correctAnswer: 0,
                    explanation: "An author creates a book, and a composer creates a song.",
                    explanationFrench: "Un auteur crée un livre, et un compositeur crée une chanson.",
                    difficulty: difficulty,
                    subType: VerbalSubType.analogies.rawValue
                ),
                Question(
                    type: .verbal,
                    level: level,
                    stem: "Library is to books as museum is to:",
                    stemFrench: "Bibliothèque est à livres comme musée est à:",
                    options: ["artifacts", "people", "tickets", "guides"],
                    optionsFrench: ["artefacts", "gens", "billets", "guides"],
                    correctAnswer: 0,
                    explanation: "A library contains books, and a museum contains artifacts.",
                    explanationFrench: "Une bibliothèque contient des livres, et un musée contient des artefacts.",
                    difficulty: difficulty,
                    subType: VerbalSubType.analogies.rawValue
                )
            ])
        } else {
            // Level 12: Advanced analogies for grade 6 gifted program
            questions.append(contentsOf: [
                Question(
                    type: .verbal,
                    level: level,
                    stem: "Cat is to meow as dog is to:",
                    stemFrench: "Chat est à miauler comme chien est à:",
                    options: ["bark", "run", "sleep", "eat"],
                    optionsFrench: ["aboyer", "courir", "dormir", "manger"],
                    correctAnswer: 0,
                    explanation: "Cats meow and dogs bark - both are the sounds these animals make.",
                    explanationFrench: "Les chats miaulent et les chiens aboient - ce sont les sons que ces animaux font.",
                    difficulty: difficulty,
                    subType: VerbalSubType.analogies.rawValue
                ),
                Question(
                    type: .verbal,
                    level: level,
                    stem: "Hot is to cold as fire is to:",
                    stemFrench: "Chaud est à froid comme feu est à:",
                    options: ["water", "ice", "snow", "wind"],
                    optionsFrench: ["eau", "glace", "neige", "vent"],
                    correctAnswer: 1,
                    explanation: "Hot and cold are opposites, just as fire and ice are opposites.",
                    explanationFrench: "Chaud et froid sont opposés, tout comme feu et glace sont opposés.",
                    difficulty: difficulty,
                    subType: VerbalSubType.analogies.rawValue
                )
            ])
        }
        
        // Generate additional questions if needed
        while questions.count < questionCount {
            questions.append(contentsOf: questions.prefix(min(questions.count, questionCount - questions.count)))
        }
        
        return Array(questions.prefix(questionCount))
    }
    
    private func generateVerbalSynonyms(for level: CCATLevel = .level12) -> [Question] {
        // Placeholder for verbal synonyms generation
        return []
    }
    
    private func generateVerbalAntonyms(for level: CCATLevel = .level12) -> [Question] {
        // Placeholder for verbal antonyms generation
        return []
    }
    
    // MARK: - Sample Questions (for reference)
    
    private func getSampleQuestions() -> [Question] {
        return [
            Question(
                type: .verbal,
                stem: "Teacher is to school as doctor is to:",
                stemFrench: "Enseignant est à école comme médecin est à:",
                options: ["medicine", "hospital", "patient", "stethoscope"],
                optionsFrench: ["médecine", "hôpital", "patient", "stéthoscope"],
                correctAnswer: 1,
                explanation: "A teacher works at a school, and a doctor works at a hospital.",
                explanationFrench: "Un enseignant travaille à l'école, et un médecin travaille à l'hôpital.",
                difficulty: .easy,
                subType: VerbalSubType.analogies.rawValue
            ),
            
            // Medium Level
            Question(
                type: .verbal,
                stem: "Author is to novel as composer is to:",
                stemFrench: "Auteur est à roman comme compositeur est à:",
                options: ["music", "symphony", "piano", "orchestra"],
                optionsFrench: ["musique", "symphonie", "piano", "orchestre"],
                correctAnswer: 1,
                explanation: "An author creates a novel, and a composer creates a symphony.",
                explanationFrench: "Un auteur crée un roman, et un compositeur crée une symphonie.",
                difficulty: .medium,
                subType: VerbalSubType.analogies.rawValue
            ),
            Question(
                type: .verbal,
                stem: "Petal is to flower as page is to:",
                stemFrench: "Pétale est à fleur comme page est à:",
                options: ["word", "book", "sentence", "paper"],
                optionsFrench: ["mot", "livre", "phrase", "papier"],
                correctAnswer: 1,
                explanation: "A petal is part of a flower, and a page is part of a book.",
                explanationFrench: "Un pétale fait partie d'une fleur, et une page fait partie d'un livre.",
                difficulty: .medium,
                subType: VerbalSubType.analogies.rawValue
            ),
            Question(
                type: .verbal,
                stem: "Archipelago is to islands as constellation is to:",
                stemFrench: "Archipel est à îles comme constellation est à:",
                options: ["planets", "stars", "galaxies", "comets"],
                optionsFrench: ["planètes", "étoiles", "galaxies", "comètes"],
                correctAnswer: 1,
                explanation: "An archipelago is a group of islands, and a constellation is a group of stars.",
                explanationFrench: "Un archipel est un groupe d'îles, et une constellation est un groupe d'étoiles.",
                difficulty: .medium,
                subType: VerbalSubType.analogies.rawValue
            ),
            
            // Hard Level
            Question(
                type: .verbal,
                stem: "Ephemeral is to permanent as cacophony is to:",
                stemFrench: "Éphémère est à permanent comme cacophonie est à:",
                options: ["harmony", "silence", "music", "noise"],
                optionsFrench: ["harmonie", "silence", "musique", "bruit"],
                correctAnswer: 0,
                explanation: "Ephemeral and permanent are opposites, as are cacophony (harsh sound) and harmony (pleasant sound).",
                explanationFrench: "Éphémère et permanent sont opposés, comme cacophonie (son dur) et harmonie (son agréable).",
                difficulty: .hard,
                subType: VerbalSubType.analogies.rawValue
            ),
            Question(
                type: .verbal,
                stem: "Meticulous is to careless as frugal is to:",
                stemFrench: "Méticuleux est à négligent comme frugal est à:",
                options: ["careful", "wasteful", "generous", "poor"],
                optionsFrench: ["prudent", "gaspilleur", "généreux", "pauvre"],
                correctAnswer: 1,
                explanation: "Meticulous and careless are opposites, as are frugal (careful with money) and wasteful.",
                explanationFrench: "Méticuleux et négligent sont opposés, comme frugal (prudent avec l'argent) et gaspilleur.",
                difficulty: .hard,
                subType: VerbalSubType.analogies.rawValue
            )
        ]
    }
    
    private func generateSentenceCompletion() -> [Question] {
        return [
            // Easy Level
            Question(
                type: .verbal,
                stem: "The cat was very _____ and purred loudly when petted.",
                stemFrench: "Le chat était très _____ et ronronnait fort quand on le caressait.",
                options: ["angry", "happy", "tired", "hungry"],
                optionsFrench: ["en colère", "heureux", "fatigué", "affamé"],
                correctAnswer: 1,
                explanation: "Purring loudly when petted indicates the cat is happy and content.",
                explanationFrench: "Ronronner fort quand on le caresse indique que le chat est heureux et content.",
                difficulty: .easy,
                subType: VerbalSubType.sentenceCompletion.rawValue
            ),
            Question(
                type: .verbal,
                stem: "After running the marathon, Sarah felt completely _____.",
                stemFrench: "Après avoir couru le marathon, Sarah se sentait complètement _____.",
                options: ["energetic", "exhausted", "excited", "confused"],
                optionsFrench: ["énergique", "épuisée", "excitée", "confuse"],
                correctAnswer: 1,
                explanation: "Running a marathon is very tiring, so Sarah would feel exhausted.",
                explanationFrench: "Courir un marathon est très fatigant, donc Sarah se sentirait épuisée.",
                difficulty: .easy,
                subType: VerbalSubType.sentenceCompletion.rawValue
            ),
            
            // Medium Level
            Question(
                type: .verbal,
                stem: "The scientist's hypothesis was _____ by the experimental results.",
                stemFrench: "L'hypothèse du scientifique était _____ par les résultats expérimentaux.",
                options: ["ignored", "validated", "created", "questioned"],
                optionsFrench: ["ignorée", "validée", "créée", "questionnée"],
                correctAnswer: 1,
                explanation: "Experimental results typically validate or disprove a hypothesis.",
                explanationFrench: "Les résultats expérimentaux valident ou réfutent généralement une hypothèse.",
                difficulty: .medium,
                subType: VerbalSubType.sentenceCompletion.rawValue
            ),
            Question(
                type: .verbal,
                stem: "Despite her _____ appearance, she was actually quite friendly.",
                stemFrench: "Malgré son apparence _____, elle était en fait très amicale.",
                options: ["cheerful", "intimidating", "beautiful", "casual"],
                optionsFrench: ["joyeuse", "intimidante", "belle", "décontractée"],
                correctAnswer: 1,
                explanation: "'Despite' indicates contrast - intimidating appearance contrasts with being friendly.",
                explanationFrench: "'Malgré' indique un contraste - une apparence intimidante contraste avec être amicale.",
                difficulty: .medium,
                subType: VerbalSubType.sentenceCompletion.rawValue
            ),
            
            // Hard Level
            Question(
                type: .verbal,
                stem: "The politician's _____ speech failed to convince the skeptical audience.",
                stemFrench: "Le discours _____ du politicien n'a pas réussi à convaincre l'audience sceptique.",
                options: ["eloquent", "bombastic", "sincere", "brief"],
                optionsFrench: ["éloquent", "emphatique", "sincère", "bref"],
                correctAnswer: 1,
                explanation: "A bombastic (pompous, inflated) speech would fail to convince a skeptical audience.",
                explanationFrench: "Un discours emphatique (pompeux, gonflé) échouerait à convaincre une audience sceptique.",
                difficulty: .hard,
                subType: VerbalSubType.sentenceCompletion.rawValue
            )
        ]
    }
    
    // MARK: - Quantitative Questions
    
    private func generateNumberAnalogies() -> [Question] {
        return [
            // Easy Level
            Question(
                type: .quantitative,
                stem: "2 : 4 :: 3 : ?",
                stemFrench: "2 : 4 :: 3 : ?",
                options: ["5", "6", "7", "9"],
                optionsFrench: ["5", "6", "7", "9"],
                correctAnswer: 1,
                explanation: "2 × 2 = 4, so 3 × 2 = 6",
                explanationFrench: "2 × 2 = 4, donc 3 × 2 = 6",
                difficulty: .easy,
                subType: QuantitativeSubType.numberAnalogies.rawValue
            ),
            Question(
                type: .quantitative,
                stem: "5 : 25 :: 6 : ?",
                stemFrench: "5 : 25 :: 6 : ?",
                options: ["30", "36", "42", "48"],
                optionsFrench: ["30", "36", "42", "48"],
                correctAnswer: 1,
                explanation: "5² = 25, so 6² = 36",
                explanationFrench: "5² = 25, donc 6² = 36",
                difficulty: .easy,
                subType: QuantitativeSubType.numberAnalogies.rawValue
            ),
            
            // Medium Level
            Question(
                type: .quantitative,
                stem: "8 : 64 :: 5 : ?",
                stemFrench: "8 : 64 :: 5 : ?",
                options: ["20", "25", "125", "45"],
                optionsFrench: ["20", "25", "125", "45"],
                correctAnswer: 2,
                explanation: "8³ = 64, so 5³ = 125",
                explanationFrench: "8³ = 64, donc 5³ = 125",
                difficulty: .medium,
                subType: QuantitativeSubType.numberAnalogies.rawValue
            ),
            Question(
                type: .quantitative,
                stem: "12 : 6 :: 18 : ?",
                stemFrench: "12 : 6 :: 18 : ?",
                options: ["6", "9", "12", "24"],
                optionsFrench: ["6", "9", "12", "24"],
                correctAnswer: 1,
                explanation: "12 ÷ 2 = 6, so 18 ÷ 2 = 9",
                explanationFrench: "12 ÷ 2 = 6, donc 18 ÷ 2 = 9",
                difficulty: .medium,
                subType: QuantitativeSubType.numberAnalogies.rawValue
            ),
            
            // Hard Level
            Question(
                type: .quantitative,
                stem: "3 : 10 :: 7 : ?",
                stemFrench: "3 : 10 :: 7 : ?",
                options: ["21", "49", "50", "14"],
                optionsFrench: ["21", "49", "50", "14"],
                correctAnswer: 2,
                explanation: "3² + 1 = 10, so 7² + 1 = 50",
                explanationFrench: "3² + 1 = 10, donc 7² + 1 = 50",
                difficulty: .hard,
                subType: QuantitativeSubType.numberAnalogies.rawValue
            )
        ]
    }
    
    private func generateQuantitativeAnalogies() -> [Question] {
        return [
            // Easy Level
            Question(
                type: .quantitative,
                stem: "1/2 : 0.5 :: 1/4 : ?",
                stemFrench: "1/2 : 0,5 :: 1/4 : ?",
                options: ["0.2", "0.25", "0.3", "0.4"],
                optionsFrench: ["0,2", "0,25", "0,3", "0,4"],
                correctAnswer: 1,
                explanation: "1/2 = 0.5 (decimal form), so 1/4 = 0.25",
                explanationFrench: "1/2 = 0,5 (forme décimale), donc 1/4 = 0,25",
                difficulty: .easy,
                subType: QuantitativeSubType.quantitativeAnalogies.rawValue
            ),
            Question(
                type: .quantitative,
                stem: "10% : 0.1 :: 25% : ?",
                stemFrench: "10% : 0,1 :: 25% : ?",
                options: ["0.2", "0.25", "0.3", "2.5"],
                optionsFrench: ["0,2", "0,25", "0,3", "2,5"],
                correctAnswer: 1,
                explanation: "10% = 0.1, so 25% = 0.25",
                explanationFrench: "10% = 0,1, donc 25% = 0,25",
                difficulty: .easy,
                subType: QuantitativeSubType.quantitativeAnalogies.rawValue
            ),
            
            // Medium Level
            Question(
                type: .quantitative,
                stem: "Circle : π × r² :: Rectangle : ?",
                stemFrench: "Cercle : π × r² :: Rectangle : ?",
                options: ["2 × l + w", "l × w", "π × d", "r²"],
                optionsFrench: ["2 × l + w", "l × w", "π × d", "r²"],
                correctAnswer: 1,
                explanation: "The area of a circle is π × r², and the area of a rectangle is length × width.",
                explanationFrench: "L'aire d'un cercle est π × r², et l'aire d'un rectangle est longueur × largeur.",
                difficulty: .medium,
                subType: QuantitativeSubType.quantitativeAnalogies.rawValue
            ),
            
            // Hard Level
            Question(
                type: .quantitative,
                stem: "2⁴ : 16 :: 3³ : ?",
                stemFrench: "2⁴ : 16 :: 3³ : ?",
                options: ["9", "18", "27", "81"],
                optionsFrench: ["9", "18", "27", "81"],
                correctAnswer: 2,
                explanation: "2⁴ = 16, so 3³ = 27",
                explanationFrench: "2⁴ = 16, donc 3³ = 27",
                difficulty: .hard,
                subType: QuantitativeSubType.quantitativeAnalogies.rawValue
            )
        ]
    }
    
    private func generateEquationBuilding() -> [Question] {
        return [
            // Easy Level
            Question(
                type: .quantitative,
                stem: "If 5 + 3 = 8, then 5 + 3 + 2 = ?",
                stemFrench: "Si 5 + 3 = 8, alors 5 + 3 + 2 = ?",
                options: ["9", "10", "11", "12"],
                optionsFrench: ["9", "10", "11", "12"],
                correctAnswer: 1,
                explanation: "5 + 3 + 2 = 8 + 2 = 10",
                explanationFrench: "5 + 3 + 2 = 8 + 2 = 10",
                difficulty: .easy,
                subType: QuantitativeSubType.equationBuilding.rawValue
            ),
            Question(
                type: .quantitative,
                stem: "What number makes this equation true: 3 × ? = 15",
                stemFrench: "Quel nombre rend cette équation vraie: 3 × ? = 15",
                options: ["3", "4", "5", "6"],
                optionsFrench: ["3", "4", "5", "6"],
                correctAnswer: 2,
                explanation: "3 × 5 = 15",
                explanationFrench: "3 × 5 = 15",
                difficulty: .easy,
                subType: QuantitativeSubType.equationBuilding.rawValue
            ),
            
            // Medium Level
            Question(
                type: .quantitative,
                stem: "If 2x + 3 = 11, then x = ?",
                stemFrench: "Si 2x + 3 = 11, alors x = ?",
                options: ["2", "4", "6", "8"],
                optionsFrench: ["2", "4", "6", "8"],
                correctAnswer: 1,
                explanation: "2x = 11 - 3 = 8, so x = 4",
                explanationFrench: "2x = 11 - 3 = 8, donc x = 4",
                difficulty: .medium,
                subType: QuantitativeSubType.equationBuilding.rawValue
            ),
            
            // Hard Level
            Question(
                type: .quantitative,
                stem: "If 3x - 2y = 10 and x = 4, then y = ?",
                stemFrench: "Si 3x - 2y = 10 et x = 4, alors y = ?",
                options: ["1", "2", "3", "4"],
                optionsFrench: ["1", "2", "3", "4"],
                correctAnswer: 0,
                explanation: "3(4) - 2y = 10, so 12 - 2y = 10, therefore 2y = 2, so y = 1",
                explanationFrench: "3(4) - 2y = 10, donc 12 - 2y = 10, par conséquent 2y = 2, donc y = 1",
                difficulty: .hard,
                subType: QuantitativeSubType.equationBuilding.rawValue
            )
        ]
    }
    
    // MARK: - Non-Verbal Questions
    
    private func generateFigureMatrices() -> [Question] {
        return [
            // Easy Level - Pattern questions (described textually for this implementation)
            Question(
                type: .nonVerbal,
                stem: "Look at the pattern. The first box has a circle. The second box has a circle with a dot inside. What comes next?",
                stemFrench: "Regardez le motif. La première case a un cercle. La deuxième case a un cercle avec un point à l'intérieur. Que vient ensuite?",
                options: ["Circle with two dots", "Square", "Triangle", "Empty circle"],
                optionsFrench: ["Cercle avec deux points", "Carré", "Triangle", "Cercle vide"],
                correctAnswer: 0,
                explanation: "The pattern shows increasing dots inside the circle: 0, 1, 2.",
                explanationFrench: "Le motif montre des points croissants à l'intérieur du cercle: 0, 1, 2.",
                difficulty: .easy,
                subType: NonVerbalSubType.figureMatrices.rawValue,
                imageName: "matrix_easy_1"
            ),
            Question(
                type: .nonVerbal,
                stem: "In this 2×2 matrix, three corners have squares and the fourth has a circle. What should replace the question mark?",
                stemFrench: "Dans cette matrice 2×2, trois coins ont des carrés et le quatrième a un cercle. Que devrait remplacer le point d'interrogation?",
                options: ["Square", "Circle", "Triangle", "Diamond"],
                optionsFrench: ["Carré", "Cercle", "Triangle", "Losange"],
                correctAnswer: 1,
                explanation: "The pattern alternates diagonally between squares and circles.",
                explanationFrench: "Le motif alterne en diagonal entre carrés et cercles.",
                difficulty: .easy,
                subType: NonVerbalSubType.figureMatrices.rawValue,
                imageName: "matrix_easy_2"
            ),
            
            // Medium Level
            Question(
                type: .nonVerbal,
                stem: "Each row and column follows a pattern of rotation. What figure completes the matrix?",
                stemFrench: "Chaque ligne et colonne suit un motif de rotation. Quelle figure complète la matrice?",
                options: ["Arrow pointing up", "Arrow pointing right", "Arrow pointing down", "Arrow pointing left"],
                optionsFrench: ["Flèche pointant vers le haut", "Flèche pointant vers la droite", "Flèche pointant vers le bas", "Flèche pointant vers la gauche"],
                correctAnswer: 2,
                explanation: "Arrows rotate 90 degrees clockwise in each position.",
                explanationFrench: "Les flèches tournent de 90 degrés dans le sens horaire à chaque position.",
                difficulty: .medium,
                subType: NonVerbalSubType.figureMatrices.rawValue,
                imageName: "matrix_medium_1"
            ),
            
            // Hard Level
            Question(
                type: .nonVerbal,
                stem: "This complex matrix involves both shape transformation and position changes. What completes the pattern?",
                stemFrench: "Cette matrice complexe implique à la fois transformation de forme et changements de position. Qu'est-ce qui complète le motif?",
                options: ["Rotated triangle with dot", "Square with line", "Circle with cross", "Diamond with dot"],
                optionsFrench: ["Triangle tourné avec point", "Carré avec ligne", "Cercle avec croix", "Losange avec point"],
                correctAnswer: 0,
                explanation: "The pattern combines rotation and addition of elements following specific rules.",
                explanationFrench: "Le motif combine rotation et ajout d'éléments suivant des règles spécifiques.",
                difficulty: .hard,
                subType: NonVerbalSubType.figureMatrices.rawValue,
                imageName: "matrix_hard_1"
            )
        ]
    }
    
    private func generateFigureClassification() -> [Question] {
        return [
            // Easy Level
            Question(
                type: .nonVerbal,
                stem: "Which figure does NOT belong with the others?",
                stemFrench: "Quelle figure N'APPARTIENT PAS avec les autres?",
                options: ["Circle", "Square", "Triangle", "Line"],
                optionsFrench: ["Cercle", "Carré", "Triangle", "Ligne"],
                correctAnswer: 3,
                explanation: "Circle, square, and triangle are closed shapes. A line is not closed.",
                explanationFrench: "Cercle, carré et triangle sont des formes fermées. Une ligne n'est pas fermée.",
                difficulty: .easy,
                subType: NonVerbalSubType.figureClassification.rawValue,
                imageName: "classification_easy_1"
            ),
            Question(
                type: .nonVerbal,
                stem: "Three shapes are shaded, one is not. Which doesn't belong?",
                stemFrench: "Trois formes sont ombrées, une ne l'est pas. Laquelle n'appartient pas?",
                options: ["Shaded circle", "Shaded square", "Shaded triangle", "Empty diamond"],
                optionsFrench: ["Cercle ombré", "Carré ombré", "Triangle ombré", "Losange vide"],
                correctAnswer: 3,
                explanation: "Three shapes are shaded (filled), while the diamond is empty (not shaded).",
                explanationFrench: "Trois formes sont ombrées (remplies), tandis que le losange est vide (non ombré).",
                difficulty: .easy,
                subType: NonVerbalSubType.figureClassification.rawValue,
                imageName: "classification_easy_2"
            ),
            
            // Medium Level
            Question(
                type: .nonVerbal,
                stem: "Three figures have curved lines, one has only straight lines. Which is different?",
                stemFrench: "Trois figures ont des lignes courbes, une n'a que des lignes droites. Laquelle est différente?",
                options: ["Circle with arc", "Oval", "Curved triangle", "Rectangle"],
                optionsFrench: ["Cercle avec arc", "Ovale", "Triangle courbe", "Rectangle"],
                correctAnswer: 3,
                explanation: "The rectangle has only straight lines, while others have curved elements.",
                explanationFrench: "Le rectangle n'a que des lignes droites, tandis que les autres ont des éléments courbes.",
                difficulty: .medium,
                subType: NonVerbalSubType.figureClassification.rawValue,
                imageName: "classification_medium_1"
            ),
            
            // Hard Level
            Question(
                type: .nonVerbal,
                stem: "These figures follow a rule about symmetry. Which one breaks the pattern?",
                stemFrench: "Ces figures suivent une règle sur la symétrie. Laquelle brise le motif?",
                options: ["Symmetric star", "Symmetric hexagon", "Symmetric cross", "Asymmetric arrow"],
                optionsFrench: ["Étoile symétrique", "Hexagone symétrique", "Croix symétrique", "Flèche asymétrique"],
                correctAnswer: 3,
                explanation: "The arrow is asymmetric while all others have symmetrical properties.",
                explanationFrench: "La flèche est asymétrique tandis que toutes les autres ont des propriétés symétriques.",
                difficulty: .hard,
                subType: NonVerbalSubType.figureClassification.rawValue,
                imageName: "classification_hard_1"
            )
        ]
    }
    
    private func generateFigureSeries() -> [Question] {
        return [
            // Easy Level
            Question(
                type: .nonVerbal,
                stem: "What comes next in this series: Circle, Square, Circle, Square, ?",
                stemFrench: "Que vient ensuite dans cette série: Cercle, Carré, Cercle, Carré, ?",
                options: ["Circle", "Square", "Triangle", "Diamond"],
                optionsFrench: ["Cercle", "Carré", "Triangle", "Losange"],
                correctAnswer: 0,
                explanation: "The pattern alternates between circle and square, so next is circle.",
                explanationFrench: "Le motif alterne entre cercle et carré, donc le suivant est cercle.",
                difficulty: .easy,
                subType: NonVerbalSubType.figureSeries.rawValue,
                imageName: "series_easy_1"
            ),
            Question(
                type: .nonVerbal,
                stem: "In this series, each shape gains one side: Triangle (3), Square (4), Pentagon (5), ?",
                stemFrench: "Dans cette série, chaque forme gagne un côté: Triangle (3), Carré (4), Pentagone (5), ?",
                options: ["Hexagon", "Circle", "Octagon", "Triangle"],
                optionsFrench: ["Hexagone", "Cercle", "Octogone", "Triangle"],
                correctAnswer: 0,
                explanation: "Each shape has one more side than the previous: 3, 4, 5, 6 (hexagon).",
                explanationFrench: "Chaque forme a un côté de plus que la précédente: 3, 4, 5, 6 (hexagone).",
                difficulty: .easy,
                subType: NonVerbalSubType.figureSeries.rawValue,
                imageName: "series_easy_2"
            ),
            
            // Medium Level
            Question(
                type: .nonVerbal,
                stem: "Each figure rotates 45 degrees clockwise. What's next?",
                stemFrench: "Chaque figure tourne de 45 degrés dans le sens horaire. Que vient ensuite?",
                options: ["Arrow pointing NE", "Arrow pointing E", "Arrow pointing SE", "Arrow pointing S"],
                optionsFrench: ["Flèche pointant NE", "Flèche pointant E", "Flèche pointant SE", "Flèche pointant S"],
                correctAnswer: 2,
                explanation: "Following 45-degree clockwise rotation pattern from the sequence.",
                explanationFrench: "Suivant le motif de rotation de 45 degrés dans le sens horaire de la séquence.",
                difficulty: .medium,
                subType: NonVerbalSubType.figureSeries.rawValue,
                imageName: "series_medium_1"
            ),
            
            // Hard Level
            Question(
                type: .nonVerbal,
                stem: "This series involves both rotation and shape change. What continues the pattern?",
                stemFrench: "Cette série implique à la fois rotation et changement de forme. Qu'est-ce qui continue le motif?",
                options: ["Rotated complex shape A", "Rotated complex shape B", "Rotated complex shape C", "Rotated complex shape D"],
                optionsFrench: ["Forme complexe tournée A", "Forme complexe tournée B", "Forme complexe tournée C", "Forme complexe tournée D"],
                correctAnswer: 1,
                explanation: "The pattern combines rotation with systematic shape modifications.",
                explanationFrench: "Le motif combine rotation avec modifications systématiques de forme.",
                difficulty: .hard,
                subType: NonVerbalSubType.figureSeries.rawValue,
                imageName: "series_hard_1"
            )
        ]
    }
    
    // MARK: - Helper Methods for Multi-Level Support
    
    private func getDifficultyForLevel(_ level: CCATLevel) -> Difficulty {
        switch level {
        case .level10:
            return .easy
        case .level11:
            return .medium
        case .level12:
            return .hard
        }
    }
    
    private func getQuestionCountForType(level: CCATLevel, type: QuestionType, subType: Any) -> Int {
        // Base question counts per subtype for different levels
        let baseCount: Int
        switch level {
        case .level10:
            baseCount = 8  // Fewer questions for younger students
        case .level11:
            baseCount = 12 // Medium count
        case .level12:
            baseCount = 20 // Full count for gifted program
        }
        return baseCount
    }
    
    // Placeholder implementations for other generation methods
    // These would be updated similarly to generateVerbalAnalogies
    
    private func generateSentenceCompletion(for level: CCATLevel = .level12) -> [Question] {
        // Simplified placeholder - would be fully implemented
        let difficulty = getDifficultyForLevel(level)
        let questionCount = getQuestionCountForType(level: level, type: .verbal, subType: VerbalSubType.sentenceCompletion)
        
        var questions: [Question] = []
        for _ in 0..<questionCount {
            questions.append(Question(
                type: .verbal,
                level: level,
                stem: "The student was very _____ about the test results.",
                stemFrench: "L'étudiant était très _____ des résultats du test.",
                options: ["anxious", "happy", "tired", "hungry"],
                optionsFrench: ["anxieux", "heureux", "fatigué", "affamé"],
                correctAnswer: 0,
                explanation: "Students are typically anxious about test results.",
                explanationFrench: "Les étudiants sont généralement anxieux des résultats des tests.",
                difficulty: difficulty,
                subType: VerbalSubType.sentenceCompletion.rawValue
            ))
        }
        return questions
    }
    
    private func generateVerbalClassification(for level: CCATLevel = .level12) -> [Question] {
        let difficulty = getDifficultyForLevel(level)
        let questionCount = getQuestionCountForType(level: level, type: .verbal, subType: VerbalSubType.classification)
        
        var questions: [Question] = []
        for _ in 0..<questionCount {
            questions.append(Question(
                type: .verbal,
                level: level,
                stem: "Which word does NOT belong with the others?",
                stemFrench: "Quel mot n'appartient PAS avec les autres?",
                options: ["Apple", "Orange", "Banana", "Carrot"],
                optionsFrench: ["Pomme", "Orange", "Banane", "Carotte"],
                correctAnswer: 3,
                explanation: "Carrot is a vegetable, while the others are fruits.",
                explanationFrench: "La carotte est un légume, tandis que les autres sont des fruits.",
                difficulty: difficulty,
                subType: VerbalSubType.classification.rawValue
            ))
        }
        return questions
    }
    
    private func generateNumberAnalogies(for level: CCATLevel = .level12) -> [Question] {
        let difficulty = getDifficultyForLevel(level)
        let questionCount = getQuestionCountForType(level: level, type: .quantitative, subType: QuantitativeSubType.numberAnalogies)
        
        var questions: [Question] = []
        for index in 0..<questionCount {
            let base = level == .level10 ? 2 : (level == .level11 ? 3 : 4)
            let num1 = base + index % 10
            let num2 = num1 * 2
            let num3 = base + 1 + index % 10
            let num4 = num3 * 2
            
            questions.append(Question(
                type: .quantitative,
                level: level,
                stem: "\(num1) : \(num2) :: \(num3) : ?",
                stemFrench: "\(num1) : \(num2) :: \(num3) : ?",
                options: ["\(num4)", "\(num4-1)", "\(num4+1)", "\(num4*2)"],
                optionsFrench: ["\(num4)", "\(num4-1)", "\(num4+1)", "\(num4*2)"],
                correctAnswer: 0,
                explanation: "The relationship is multiply by 2.",
                explanationFrench: "La relation est multiplier par 2.",
                difficulty: difficulty,
                subType: QuantitativeSubType.numberAnalogies.rawValue
            ))
        }
        return questions
    }
    
    private func generateQuantitativeAnalogies(for level: CCATLevel = .level12) -> [Question] {
        let difficulty = getDifficultyForLevel(level)
        let questionCount = getQuestionCountForType(level: level, type: .quantitative, subType: QuantitativeSubType.quantitativeAnalogies)
        
        var questions: [Question] = []
        for _ in 0..<questionCount {
            questions.append(Question(
                type: .quantitative,
                level: level,
                stem: "If 5 + 3 = 8, then 7 + 4 = ?",
                stemFrench: "Si 5 + 3 = 8, alors 7 + 4 = ?",
                options: ["11", "10", "12", "9"],
                optionsFrench: ["11", "10", "12", "9"],
                correctAnswer: 0,
                explanation: "Simple addition: 7 + 4 = 11.",
                explanationFrench: "Addition simple: 7 + 4 = 11.",
                difficulty: difficulty,
                subType: QuantitativeSubType.quantitativeAnalogies.rawValue
            ))
        }
        return questions
    }
    
    private func generateEquationBuilding(for level: CCATLevel = .level12) -> [Question] {
        let difficulty = getDifficultyForLevel(level)
        let questionCount = getQuestionCountForType(level: level, type: .quantitative, subType: QuantitativeSubType.equationBuilding)
        
        var questions: [Question] = []
        for _ in 0..<questionCount {
            questions.append(Question(
                type: .quantitative,
                level: level,
                stem: "Using 2, 3, and 5, which equation equals 10?",
                stemFrench: "En utilisant 2, 3, et 5, quelle équation égale 10?",
                options: ["2 + 3 + 5", "2 × 3 + 4", "5 × 2", "3 + 5 + 2"],
                optionsFrench: ["2 + 3 + 5", "2 × 3 + 4", "5 × 2", "3 + 5 + 2"],
                correctAnswer: 2,
                explanation: "5 × 2 = 10.",
                explanationFrench: "5 × 2 = 10.",
                difficulty: difficulty,
                subType: QuantitativeSubType.equationBuilding.rawValue
            ))
        }
        return questions
    }
    
    private func generateFigureMatrices(for level: CCATLevel = .level12) -> [Question] {
        let difficulty = getDifficultyForLevel(level)
        let questionCount = getQuestionCountForType(level: level, type: .nonVerbal, subType: NonVerbalSubType.figureMatrices)
        
        var questions: [Question] = []
        for index in 0..<questionCount {
            questions.append(Question(
                type: .nonVerbal,
                level: level,
                stem: "Complete the pattern in this 2×2 matrix.",
                stemFrench: "Complétez le motif dans cette matrice 2×2.",
                options: ["Option A", "Option B", "Option C", "Option D"],
                optionsFrench: ["Option A", "Option B", "Option C", "Option D"],
                correctAnswer: 0,
                explanation: "The pattern follows logical progression.",
                explanationFrench: "Le motif suit une progression logique.",
                difficulty: difficulty,
                subType: NonVerbalSubType.figureMatrices.rawValue,
                imageName: "matrix_\(level.rawValue)_\(index)"
            ))
        }
        return questions
    }
    
    private func generateFigureClassification(for level: CCATLevel = .level12) -> [Question] {
        let difficulty = getDifficultyForLevel(level)
        let questionCount = getQuestionCountForType(level: level, type: .nonVerbal, subType: NonVerbalSubType.figureClassification)
        
        var questions: [Question] = []
        for index in 0..<questionCount {
            questions.append(Question(
                type: .nonVerbal,
                level: level,
                stem: "Which figure does NOT belong with the others?",
                stemFrench: "Quelle figure n'appartient PAS avec les autres?",
                options: ["Figure A", "Figure B", "Figure C", "Figure D"],
                optionsFrench: ["Figure A", "Figure B", "Figure C", "Figure D"],
                correctAnswer: 0,
                explanation: "One figure has different properties.",
                explanationFrench: "Une figure a des propriétés différentes.",
                difficulty: difficulty,
                subType: NonVerbalSubType.figureClassification.rawValue,
                imageName: "classification_\(level.rawValue)_\(index)"
            ))
        }
        return questions
    }
    
    private func generateFigureSeries(for level: CCATLevel = .level12) -> [Question] {
        let difficulty = getDifficultyForLevel(level)
        let questionCount = getQuestionCountForType(level: level, type: .nonVerbal, subType: NonVerbalSubType.figureSeries)
        
        var questions: [Question] = []
        for index in 0..<questionCount {
            questions.append(Question(
                type: .nonVerbal,
                level: level,
                stem: "What comes next in this series?",
                stemFrench: "Que vient ensuite dans cette série?",
                options: ["Next A", "Next B", "Next C", "Next D"],
                optionsFrench: ["Suivant A", "Suivant B", "Suivant C", "Suivant D"],
                correctAnswer: 0,
                explanation: "The series follows a logical pattern.",
                explanationFrench: "La série suit un motif logique.",
                difficulty: difficulty,
                subType: NonVerbalSubType.figureSeries.rawValue,
                imageName: "series_\(level.rawValue)_\(index)"
            ))
        }
        return questions
    }
}

// MARK: - Seeded Random Number Generator for Deterministic Tests

struct SeededRandomNumberGenerator: RandomNumberGenerator {
    private var state: UInt64
    
    init(seed: UInt64) {
        self.state = seed
    }
    
    mutating func next() -> UInt64 {
        state = state &* 1103515245 &+ 12345
        return state
    }
}
