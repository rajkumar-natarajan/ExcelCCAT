//
//  Question.swift
//  ExcelCCAT
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import Foundation
import SwiftUI

enum QuestionType: String, CaseIterable, Codable {
    case verbal = "verbal"
    case quantitative = "quantitative"
    case nonVerbal = "non_verbal"
    
    var displayName: String {
        switch self {
        case .verbal:
            return NSLocalizedString("verbal", comment: "Verbal reasoning")
        case .quantitative:
            return NSLocalizedString("quantitative", comment: "Quantitative reasoning")
        case .nonVerbal:
            return NSLocalizedString("non_verbal", comment: "Non-verbal reasoning")
        }
    }
}

enum VerbalSubType: String, CaseIterable, Codable {
    case analogies = "analogies"
    case sentenceCompletion = "sentence_completion"
    case classification = "classification"
    
    var displayName: String {
        switch self {
        case .analogies:
            return NSLocalizedString("analogies", comment: "Analogies")
        case .sentenceCompletion:
            return NSLocalizedString("sentence_completion", comment: "Sentence Completion")
        case .classification:
            return NSLocalizedString("classification", comment: "Classification")
        }
    }
}

enum QuantitativeSubType: String, CaseIterable, Codable {
    case numberAnalogies = "number_analogies"
    case quantitativeAnalogies = "quantitative_analogies"
    case equationBuilding = "equation_building"
    
    var displayName: String {
        switch self {
        case .numberAnalogies:
            return NSLocalizedString("number_analogies", comment: "Number Analogies")
        case .quantitativeAnalogies:
            return NSLocalizedString("quantitative_analogies", comment: "Quantitative Analogies")
        case .equationBuilding:
            return NSLocalizedString("equation_building", comment: "Equation Building")
        }
    }
}

enum NonVerbalSubType: String, CaseIterable, Codable {
    case figureMatrices = "figure_matrices"
    case figureClassification = "figure_classification"
    case figureSeries = "figure_series"
    
    var displayName: String {
        switch self {
        case .figureMatrices:
            return NSLocalizedString("figure_matrices", comment: "Figure Matrices")
        case .figureClassification:
            return NSLocalizedString("figure_classification", comment: "Figure Classification")
        case .figureSeries:
            return NSLocalizedString("figure_series", comment: "Figure Series")
        }
    }
}

enum Language: String, CaseIterable, Codable {
    case english = "en"
    case french = "fr"
    
    var displayName: String {
        switch self {
        case .english:
            return "English"
        case .french:
            return "Français"
        }
    }
    
    var flag: String {
        switch self {
        case .english:
            return "🇨🇦"
        case .french:
            return "🇨🇦" // Canadian French, not France French
        }
    }
}

// MARK: - TDSB Test Configuration
enum TDSBTestType: String, CaseIterable, Codable {
    case quickAssessment = "quick_assessment"
    case standardPractice = "standard_practice"
    case fullMock = "full_mock"
    case customTest = "custom_test"
    
    var displayName: String {
        switch self {
        case .quickAssessment:
            return NSLocalizedString("quick_assessment", comment: "Quick Assessment")
        case .standardPractice:
            return NSLocalizedString("standard_practice", comment: "Standard Practice")
        case .fullMock:
            return NSLocalizedString("full_mock", comment: "Full Mock Test")
        case .customTest:
            return NSLocalizedString("custom_test", comment: "Custom Test")
        }
    }
    
    var description: String {
        switch self {
        case .quickAssessment:
            return NSLocalizedString("quick_assessment_desc", comment: "Perfect for daily practice")
        case .standardPractice:
            return NSLocalizedString("standard_practice_desc", comment: "Balanced practice session")
        case .fullMock:
            return NSLocalizedString("full_mock_desc", comment: "Complete test experience")
        case .customTest:
            return NSLocalizedString("custom_test_desc", comment: "Customize your practice")
        }
    }
    
    var questionCount: Int {
        switch self {
        case .quickAssessment:
            return 20
        case .standardPractice:
            return 50
        case .fullMock:
            return 176 // Full CCAT test
        case .customTest:
            return 30 // Default, can be customized
        }
    }
    
    var timeInMinutes: Int {
        switch self {
        case .quickAssessment:
            return 15
        case .standardPractice:
            return 35
        case .fullMock:
            return 120 // 2 hours
        case .customTest:
            return 20 // Default, can be customized
        }
    }
    
    func questionCountRange(for level: CCATLevel) -> ClosedRange<Int> {
        switch self {
        case .quickAssessment:
            return 10...30
        case .standardPractice:
            return 30...80
        case .fullMock:
            return level.questionCount...level.questionCount
        case .customTest:
            return 10...200
        }
    }
    
    func timeRange(for level: CCATLevel) -> ClosedRange<Int> {
        switch self {
        case .quickAssessment:
            return 5...20
        case .standardPractice:
            return 20...50
        case .fullMock:
            return 60...150
        case .customTest:
            return 5...180
        }
    }
    
    func defaultQuestionCount(for level: CCATLevel) -> Int {
        switch self {
        case .quickAssessment:
            return 20
        case .standardPractice:
            return 50
        case .fullMock:
            return level.questionCount
        case .customTest:
            return 30
        }
    }
    
    func defaultTime(for level: CCATLevel) -> Int {
        switch self {
        case .quickAssessment:
            return 15
        case .standardPractice:
            return 35
        case .fullMock:
            return 120
        case .customTest:
            return 20
        }
    }
}

// MARK: - CCAT Level System
enum CCATLevel: String, CaseIterable, Codable {
    case level10 = "level_10"
    case level11 = "level_11"
    case level12 = "level_12"
    
    var displayName: String {
        switch self {
        case .level10:
            return NSLocalizedString("level_10", comment: "Level 10")
        case .level11:
            return NSLocalizedString("level_11", comment: "Level 11")
        case .level12:
            return NSLocalizedString("level_12", comment: "Level 12")
        }
    }
    
    var description: String {
        switch self {
        case .level10:
            return NSLocalizedString("level_10_desc", comment: "Grades 2-3: Foundation Level")
        case .level11:
            return NSLocalizedString("level_11_desc", comment: "Grades 4-5: Intermediate Level")
        case .level12:
            return NSLocalizedString("level_12_desc", comment: "Grade 6: Advanced Level (Gifted)")
        }
    }
    
    var targetGrades: String {
        switch self {
        case .level10:
            return NSLocalizedString("grades_2_3", comment: "Grades 2-3")
        case .level11:
            return NSLocalizedString("grades_4_5", comment: "Grades 4-5")
        case .level12:
            return NSLocalizedString("grade_6", comment: "Grade 6")
        }
    }
    
    var icon: String {
        switch self {
        case .level10:
            return "1.circle.fill"
        case .level11:
            return "2.circle.fill"
        case .level12:
            return "3.circle.fill"
        }
    }
    
    var color: String {
        switch self {
        case .level10:
            return "green"
        case .level11:
            return "blue"
        case .level12:
            return "purple"
        }
    }
    
    // Time per question in seconds for proper pacing
    var secondsPerQuestion: Int {
        switch self {
        case .level10:
            return 90 // 1.5 minutes per question for younger students
        case .level11:
            return 75 // 1.25 minutes per question for intermediate
        case .level12:
            return 60 // 1 minute per question for advanced
        }
    }
    
    // Default question count for full tests by level
    var questionCount: Int {
        switch self {
        case .level10:
            return 100 // Shorter test for younger students
        case .level11:
            return 140 // Intermediate length
        case .level12:
            return 176 // Full CCAT test
        }
    }
    
    var gradeRange: String {
        return targetGrades
    }
}

// MARK: - Test Configuration
struct TestConfiguration: Codable {
    var level: CCATLevel
    var testType: TDSBTestType
    var questionCount: Int
    var timeInMinutes: Int
    var selectedTypes: [QuestionType]
    var isTimedSession: Bool
    
    var timeLimit: Int {
        return timeInMinutes
    }
    
    var displayDescription: String {
        let typeDescription = testType.displayName
        let levelDescription = level.displayName
        return "\(typeDescription) - \(levelDescription)"
    }
    
    init(testType: TDSBTestType = .standardPractice, level: CCATLevel = .level12) {
        self.level = level
        self.testType = testType
        self.questionCount = testType.questionCount
        self.timeInMinutes = testType.timeInMinutes
        self.selectedTypes = QuestionType.allCases
        self.isTimedSession = true
    }
    
    init(testType: TDSBTestType, level: CCATLevel, questionCount: Int, timeLimit: Int, isTimedSession: Bool) {
        self.level = level
        self.testType = testType
        self.questionCount = questionCount
        self.timeInMinutes = timeLimit
        self.selectedTypes = QuestionType.allCases
        self.isTimedSession = isTimedSession
    }
    
    // Calculate recommended time based on level and question count
    func calculateRecommendedTime() -> Int {
        let totalSeconds = questionCount * level.secondsPerQuestion
        return max(1, totalSeconds / 60) // Convert to minutes, minimum 1 minute
    }
    
    // Static method for calculating recommended time
    static func calculateRecommendedTime(for questionCount: Int, level: CCATLevel, testType: TDSBTestType = .customTest) -> Int {
        let totalSeconds = questionCount * level.secondsPerQuestion
        return max(1, totalSeconds / 60) // Convert to minutes, minimum 1 minute
    }
    
    // Update question count and auto-adjust time
    func withUpdatedQuestionCount(_ count: Int) -> TestConfiguration {
        var config = self
        config.questionCount = count
        config.timeInMinutes = config.calculateRecommendedTime()
        return config
    }
}

struct Question: Identifiable, Codable {
    let id = UUID()
    let type: QuestionType
    let subType: String
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
    let difficulty: String
    let language: Language
    let level: CCATLevel
    
    // Additional properties for bilingual support
    let stem: String?
    let stemFrench: String?
    let optionsFrench: [String]?
    let explanationFrench: String?
    
    init(type: QuestionType, subType: String, question: String, options: [String], correctAnswer: Int, explanation: String, difficulty: String, language: Language, level: CCATLevel) {
        self.type = type
        self.subType = subType
        self.question = question
        self.options = options
        self.correctAnswer = correctAnswer
        self.explanation = explanation
        self.difficulty = difficulty
        self.language = language
        self.level = level
        self.stem = nil
        self.stemFrench = nil
        self.optionsFrench = nil
        self.explanationFrench = nil
    }
    
    init(type: QuestionType, stem: String, stemFrench: String? = nil, options: [String], optionsFrench: [String]? = nil, correctAnswer: Int, explanation: String, explanationFrench: String? = nil, difficulty: String = "medium", subType: String? = nil, language: Language = .english, level: CCATLevel = .level12) {
        self.type = type
        self.subType = subType ?? type.rawValue
        self.question = stem
        self.options = options
        self.correctAnswer = correctAnswer
        self.explanation = explanation
        self.difficulty = difficulty
        self.language = language
        self.level = level
        self.stem = stem
        self.stemFrench = stemFrench
        self.optionsFrench = optionsFrench
        self.explanationFrench = explanationFrench
    }
    
    // MARK: - Localization Methods
    
    func getLocalizedStem(language: Language) -> String {
        switch language {
        case .french:
            return stemFrench ?? stem ?? question
        case .english:
            return stem ?? question
        }
    }
    
    func getLocalizedExplanation(language: Language) -> String {
        switch language {
        case .french:
            return explanationFrench ?? explanation
        case .english:
            return explanation
        }
    }
    
    func getLocalizedOptions(language: Language) -> [String] {
        switch language {
        case .french:
            return optionsFrench ?? options
        case .english:
            return options
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case type, subType, question, options, correctAnswer, explanation, difficulty, language, level
        case stem, stemFrench, optionsFrench, explanationFrench
    }
}

struct SessionResult: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let totalQuestions: Int
    let correctAnswers: Int
    let timeSpent: TimeInterval
    let questionTypes: [QuestionType]
    let language: Language
    let level: CCATLevel
    let testType: TDSBTestType
    
    var accuracy: Double {
        guard totalQuestions > 0 else { return 0.0 }
        return Double(correctAnswers) / Double(totalQuestions)
    }
    
    var percentageScore: Int {
        return Int(accuracy * 100)
    }
    
    private enum CodingKeys: String, CodingKey {
        case date, totalQuestions, correctAnswers, timeSpent, questionTypes, language, level, testType
    }
}

struct QuestionAnswer: Identifiable, Codable {
    let id = UUID()
    let question: Question
    let selectedAnswer: Int?
    let isCorrect: Bool
    let timeSpent: TimeInterval
    
    private enum CodingKeys: String, CodingKey {
        case question, selectedAnswer, isCorrect, timeSpent
    }
}

// MARK: - Session Types

enum SessionType: String, CaseIterable, Codable {
    case fullMock = "full_mock"
    case practice = "practice"
    case verbalOnly = "verbal_only"
    case quantitativeOnly = "quantitative_only"
    case nonVerbalOnly = "non_verbal_only"
    
    var displayName: String {
        switch self {
        case .fullMock:
            return NSLocalizedString("full_mock", comment: "Full Mock Test")
        case .practice:
            return NSLocalizedString("practice", comment: "Practice Mode")
        case .verbalOnly:
            return NSLocalizedString("verbal_only", comment: "Verbal Only")
        case .quantitativeOnly:
            return NSLocalizedString("quantitative_only", comment: "Quantitative Only")
        case .nonVerbalOnly:
            return NSLocalizedString("non_verbal_only", comment: "Non-Verbal Only")
        }
    }
    
    var timeLimit: TimeInterval {
        switch self {
        case .fullMock:
            return 4500 // 75 minutes
        case .practice:
            return 1800 // 30 minutes
        case .verbalOnly, .quantitativeOnly, .nonVerbalOnly:
            return 1200 // 20 minutes
        }
    }
    
    var icon: String {
        switch self {
        case .fullMock:
            return "doc.text.fill"
        case .practice:
            return "brain.head.profile.fill"
        case .verbalOnly:
            return "text.bubble.fill"
        case .quantitativeOnly:
            return "number.circle.fill"
        case .nonVerbalOnly:
            return "square.on.square"
        }
    }
}

// MARK: - Test Session

struct TestSession: Identifiable, Codable {
    let id: UUID
    let questions: [Question]
    let sessionType: SessionType
    let language: Language
    let level: CCATLevel
    let testType: TDSBTestType
    var startTime: Date
    var endTime: Date?
    var currentQuestionIndex: Int
    var answers: [UUID: Int] // questionId -> selectedAnswer
    var timeRemaining: TimeInterval
    var isCompleted: Bool
    var isPaused: Bool
    
    init(questions: [Question], sessionType: SessionType, language: Language, level: CCATLevel = .level12, testType: TDSBTestType = .fullMock, timeRemaining: TimeInterval = 0) {
        self.id = UUID()
        self.questions = questions
        self.sessionType = sessionType
        self.language = language
        self.level = level
        self.testType = testType
        self.startTime = Date()
        self.endTime = nil
        self.currentQuestionIndex = 0
        self.answers = [:]
        self.timeRemaining = timeRemaining > 0 ? timeRemaining : sessionType.timeLimit
        self.isCompleted = false
        self.isPaused = false
    }
    
    var totalQuestions: Int {
        return questions.count
    }
    
    var answeredQuestions: Int {
        return answers.count
    }
    
    var score: Int {
        var correctAnswers = 0
        for question in questions {
            if let userAnswer = answers[question.id],
               userAnswer == question.correctAnswer {
                correctAnswers += 1
            }
        }
        return correctAnswers
    }
    
    var percentageScore: Double {
        guard totalQuestions > 0 else { return 0.0 }
        return Double(score) / Double(totalQuestions) * 100.0
    }
    
    var timeSpent: TimeInterval {
        let endTime = self.endTime ?? Date()
        return endTime.timeIntervalSince(startTime)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, questions, sessionType, language, level, testType, startTime, endTime
        case currentQuestionIndex, answers, timeRemaining, isCompleted, isPaused
    }
}

// MARK: - Test Result

struct TestResult: Identifiable, Codable {
    let id: UUID
    let sessionType: SessionType
    let language: Language
    let level: CCATLevel
    let testType: TDSBTestType
    let date: Date
    let totalQuestions: Int
    let score: Int
    let timeSpent: TimeInterval
    let verbalScore: Int
    let quantitativeScore: Int
    let nonVerbalScore: Int
    let verbalTotal: Int
    let quantitativeTotal: Int
    let nonVerbalTotal: Int
    
    init(session: TestSession) {
        self.id = UUID()
        self.sessionType = session.sessionType
        self.language = session.language
        self.level = session.level
        self.testType = session.testType
        self.date = session.endTime ?? Date()
        self.totalQuestions = session.totalQuestions
        self.score = session.score
        self.timeSpent = session.timeSpent
        
        // Calculate breakdown by question type
        var verbalCorrect = 0, verbalTotal = 0
        var quantitativeCorrect = 0, quantitativeTotal = 0
        var nonVerbalCorrect = 0, nonVerbalTotal = 0
        
        for question in session.questions {
            switch question.type {
            case .verbal:
                verbalTotal += 1
                if let userAnswer = session.answers[question.id],
                   userAnswer == question.correctAnswer {
                    verbalCorrect += 1
                }
            case .quantitative:
                quantitativeTotal += 1
                if let userAnswer = session.answers[question.id],
                   userAnswer == question.correctAnswer {
                    quantitativeCorrect += 1
                }
            case .nonVerbal:
                nonVerbalTotal += 1
                if let userAnswer = session.answers[question.id],
                   userAnswer == question.correctAnswer {
                    nonVerbalCorrect += 1
                }
            }
        }
        
        self.verbalScore = verbalCorrect
        self.quantitativeScore = quantitativeCorrect
        self.nonVerbalScore = nonVerbalCorrect
        self.verbalTotal = verbalTotal
        self.quantitativeTotal = quantitativeTotal
        self.nonVerbalTotal = nonVerbalTotal
    }
    
    var percentageScore: Double {
        guard totalQuestions > 0 else { return 0.0 }
        return Double(score) / Double(totalQuestions) * 100.0
    }
    
    var giftedRange: Bool {
        return percentageScore >= 85.0 // 85th percentile considered gifted range
    }
    
    var percentileRank: Double {
        // Simplified percentile calculation based on score
        return min(99.0, percentageScore)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, sessionType, language, level, testType, date, totalQuestions, score, timeSpent
        case verbalScore, quantitativeScore, nonVerbalScore
        case verbalTotal, quantitativeTotal, nonVerbalTotal
    }
}

// MARK: - Practice Result

struct PracticeResult: Identifiable, Codable {
    let id = UUID()
    let questionType: QuestionType
    let subType: String?
    let language: Language
    let level: CCATLevel
    let date: Date
    let score: Int
    let totalQuestions: Int
    let timeSpent: TimeInterval
    
    var percentageScore: Double {
        guard totalQuestions > 0 else { return 0.0 }
        return Double(score) / Double(totalQuestions) * 100.0
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, questionType, subType, language, level, date, score, totalQuestions, timeSpent
    }
}

// MARK: - Support Types

enum Difficulty: String, CaseIterable, Codable {
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"
    
    var displayName: String {
        switch self {
        case .easy:
            return NSLocalizedString("difficulty_easy", comment: "Easy")
        case .medium:
            return NSLocalizedString("difficulty_medium", comment: "Medium")
        case .hard:
            return NSLocalizedString("difficulty_hard", comment: "Hard")
        }
    }
}

// MARK: - Sample Questions for Each Level

extension Question {
    static func sampleQuestions(for level: CCATLevel, type: QuestionType, language: Language) -> [Question] {
        switch (level, type) {
        case (.level10, .verbal):
            return level10VerbalQuestions(language: language)
        case (.level10, .quantitative):
            return level10QuantitativeQuestions(language: language)
        case (.level10, .nonVerbal):
            return level10NonVerbalQuestions(language: language)
        case (.level11, .verbal):
            return level11VerbalQuestions(language: language)
        case (.level11, .quantitative):
            return level11QuantitativeQuestions(language: language)
        case (.level11, .nonVerbal):
            return level11NonVerbalQuestions(language: language)
        case (.level12, .verbal):
            return level12VerbalQuestions(language: language)
        case (.level12, .quantitative):
            return level12QuantitativeQuestions(language: language)
        case (.level12, .nonVerbal):
            return level12NonVerbalQuestions(language: language)
        }
    }
    
    // MARK: - Level 10 Questions (Grades 2-3)
    
    static func level10VerbalQuestions(language: Language) -> [Question] {
        if language == .french {
            return [
                Question(
                    type: .verbal,
                    subType: VerbalSubType.analogies.rawValue,
                    question: "Chat est à miauler comme chien est à :",
                    options: ["courir", "aboyer", "manger", "dormir"],
                    correctAnswer: 1,
                    explanation: "Un chat miaule et un chien aboie.",
                    difficulty: "facile",
                    language: .french,
                    level: .level10
                ),
                Question(
                    type: .verbal,
                    subType: VerbalSubType.classification.rawValue,
                    question: "Lequel n'appartient pas au groupe?",
                    options: ["pomme", "banane", "carotte", "orange"],
                    correctAnswer: 2,
                    explanation: "La carotte est un légume, les autres sont des fruits.",
                    difficulty: "facile",
                    language: .french,
                    level: .level10
                )
            ]
        } else {
            return [
                Question(
                    type: .verbal,
                    subType: VerbalSubType.analogies.rawValue,
                    question: "Cat is to meow as dog is to:",
                    options: ["run", "bark", "eat", "sleep"],
                    correctAnswer: 1,
                    explanation: "A cat meows and a dog barks.",
                    difficulty: "easy",
                    language: .english,
                    level: .level10
                ),
                Question(
                    type: .verbal,
                    subType: VerbalSubType.classification.rawValue,
                    question: "Which one doesn't belong?",
                    options: ["apple", "banana", "carrot", "orange"],
                    correctAnswer: 2,
                    explanation: "Carrot is a vegetable, others are fruits.",
                    difficulty: "easy",
                    language: .english,
                    level: .level10
                )
            ]
        }
    }
    
    static func level10QuantitativeQuestions(language: Language) -> [Question] {
        if language == .french {
            return [
                Question(
                    type: .quantitative,
                    subType: QuantitativeSubType.numberAnalogies.rawValue,
                    question: "2 est à 4 comme 3 est à :",
                    options: ["5", "6", "7", "8"],
                    correctAnswer: 1,
                    explanation: "2 × 2 = 4, donc 3 × 2 = 6",
                    difficulty: "facile",
                    language: .french,
                    level: .level10
                ),
                Question(
                    type: .quantitative,
                    subType: QuantitativeSubType.equationBuilding.rawValue,
                    question: "5 + 3 = ?",
                    options: ["6", "7", "8", "9"],
                    correctAnswer: 2,
                    explanation: "5 + 3 = 8",
                    difficulty: "facile",
                    language: .french,
                    level: .level10
                )
            ]
        } else {
            return [
                Question(
                    type: .quantitative,
                    subType: QuantitativeSubType.numberAnalogies.rawValue,
                    question: "2 is to 4 as 3 is to:",
                    options: ["5", "6", "7", "8"],
                    correctAnswer: 1,
                    explanation: "2 × 2 = 4, so 3 × 2 = 6",
                    difficulty: "easy",
                    language: .english,
                    level: .level10
                ),
                Question(
                    type: .quantitative,
                    subType: QuantitativeSubType.equationBuilding.rawValue,
                    question: "5 + 3 = ?",
                    options: ["6", "7", "8", "9"],
                    correctAnswer: 2,
                    explanation: "5 + 3 = 8",
                    difficulty: "easy",
                    language: .english,
                    level: .level10
                )
            ]
        }
    }
    
    static func level10NonVerbalQuestions(language: Language) -> [Question] {
        return [
            Question(
                type: .nonVerbal,
                subType: NonVerbalSubType.figureMatrices.rawValue,
                question: "Complete the pattern: ○ △ ○ △ ?",
                options: ["○", "△", "□", "◇"],
                correctAnswer: 0,
                explanation: language == .french ? "Le motif alterne entre cercle et triangle." : "The pattern alternates between circle and triangle.",
                difficulty: language == .french ? "facile" : "easy",
                language: language,
                level: .level10
            ),
            Question(
                type: .nonVerbal,
                subType: NonVerbalSubType.figureSeries.rawValue,
                question: "What comes next: ● ●● ●●● ?",
                options: ["●", "●●", "●●●●", "●●●●●"],
                correctAnswer: 2,
                explanation: language == .french ? "Chaque forme a un point de plus que la précédente." : "Each shape has one more dot than the previous.",
                difficulty: language == .french ? "facile" : "easy",
                language: language,
                level: .level10
            )
        ]
    }
    
    // MARK: - Level 11 Questions (Grades 4-5)
    
    static func level11VerbalQuestions(language: Language) -> [Question] {
        if language == .french {
            return [
                Question(
                    type: .verbal,
                    subType: VerbalSubType.analogies.rawValue,
                    question: "Livre est à lire comme télescope est à :",
                    options: ["voir", "observer", "acheter", "nettoyer"],
                    correctAnswer: 1,
                    explanation: "On lit un livre et on observe avec un télescope.",
                    difficulty: "moyen",
                    language: .french,
                    level: .level11
                ),
                Question(
                    type: .verbal,
                    subType: VerbalSubType.sentenceCompletion.rawValue,
                    question: "Le scientifique était très _____ dans ses recherches.",
                    options: ["paresseux", "méticuleux", "rapide", "bruyant"],
                    correctAnswer: 1,
                    explanation: "Méticuleux signifie très soigneux et précis.",
                    difficulty: "moyen",
                    language: .french,
                    level: .level11
                )
            ]
        } else {
            return [
                Question(
                    type: .verbal,
                    subType: VerbalSubType.analogies.rawValue,
                    question: "Book is to read as telescope is to:",
                    options: ["see", "observe", "buy", "clean"],
                    correctAnswer: 1,
                    explanation: "You read a book and observe with a telescope.",
                    difficulty: "medium",
                    language: .english,
                    level: .level11
                ),
                Question(
                    type: .verbal,
                    subType: VerbalSubType.sentenceCompletion.rawValue,
                    question: "The scientist was very _____ in his research.",
                    options: ["lazy", "meticulous", "fast", "loud"],
                    correctAnswer: 1,
                    explanation: "Meticulous means very careful and precise.",
                    difficulty: "medium",
                    language: .english,
                    level: .level11
                )
            ]
        }
    }
    
    static func level11QuantitativeQuestions(language: Language) -> [Question] {
        if language == .french {
            return [
                Question(
                    type: .quantitative,
                    subType: QuantitativeSubType.numberAnalogies.rawValue,
                    question: "6 est à 36 comme 4 est à :",
                    options: ["12", "16", "20", "24"],
                    correctAnswer: 1,
                    explanation: "6² = 36, donc 4² = 16",
                    difficulty: "moyen",
                    language: .french,
                    level: .level11
                ),
                Question(
                    type: .quantitative,
                    subType: QuantitativeSubType.equationBuilding.rawValue,
                    question: "Si x + 5 = 12, alors x = ?",
                    options: ["5", "6", "7", "8"],
                    correctAnswer: 2,
                    explanation: "x = 12 - 5 = 7",
                    difficulty: "moyen",
                    language: .french,
                    level: .level11
                )
            ]
        } else {
            return [
                Question(
                    type: .quantitative,
                    subType: QuantitativeSubType.numberAnalogies.rawValue,
                    question: "6 is to 36 as 4 is to:",
                    options: ["12", "16", "20", "24"],
                    correctAnswer: 1,
                    explanation: "6² = 36, so 4² = 16",
                    difficulty: "medium",
                    language: .english,
                    level: .level11
                ),
                Question(
                    type: .quantitative,
                    subType: QuantitativeSubType.equationBuilding.rawValue,
                    question: "If x + 5 = 12, then x = ?",
                    options: ["5", "6", "7", "8"],
                    correctAnswer: 2,
                    explanation: "x = 12 - 5 = 7",
                    difficulty: "medium",
                    language: .english,
                    level: .level11
                )
            ]
        }
    }
    
    static func level11NonVerbalQuestions(language: Language) -> [Question] {
        return [
            Question(
                type: .nonVerbal,
                subType: NonVerbalSubType.figureMatrices.rawValue,
                question: "Complete the matrix: [●○] [○●] [●○] [?]",
                options: ["[○●]", "[●●]", "[○○]", "[●○]"],
                correctAnswer: 0,
                explanation: language == .french ? "Le motif alterne les positions des cercles pleins et vides." : "The pattern alternates the positions of filled and empty circles.",
                difficulty: language == .french ? "moyen" : "medium",
                language: language,
                level: .level11
            ),
            Question(
                type: .nonVerbal,
                subType: NonVerbalSubType.figureClassification.rawValue,
                question: "Which figure doesn't belong: △ ○ □ ⬟",
                options: ["△", "○", "□", "⬟"],
                correctAnswer: 3,
                explanation: language == .french ? "Le pentagone a 5 côtés, les autres ont 3, 0 et 4 côtés respectivement." : "The pentagon has 5 sides, others have 3, 0, and 4 sides respectively.",
                difficulty: language == .french ? "moyen" : "medium",
                language: language,
                level: .level11
            )
        ]
    }
    
    // MARK: - Level 12 Questions (Grade 6 - Gifted)
    
    static func level12VerbalQuestions(language: Language) -> [Question] {
        if language == .french {
            return [
                Question(
                    type: .verbal,
                    subType: VerbalSubType.analogies.rawValue,
                    question: "Sculpture est à sculpteur comme symphonie est à :",
                    options: ["musicien", "compositeur", "instrument", "orchestre"],
                    correctAnswer: 1,
                    explanation: "Un sculpteur crée une sculpture, un compositeur crée une symphonie.",
                    difficulty: "difficile",
                    language: .french,
                    level: .level12
                ),
                Question(
                    type: .verbal,
                    subType: VerbalSubType.sentenceCompletion.rawValue,
                    question: "Malgré son apparente _____, le discours contenait des idées profondes.",
                    options: ["complexité", "simplicité", "longueur", "importance"],
                    correctAnswer: 1,
                    explanation: "Simplicité contraste avec 'idées profondes' introduit par 'malgré'.",
                    difficulty: "difficile",
                    language: .french,
                    level: .level12
                )
            ]
        } else {
            return [
                Question(
                    type: .verbal,
                    subType: VerbalSubType.analogies.rawValue,
                    question: "Sculpture is to sculptor as symphony is to:",
                    options: ["musician", "composer", "instrument", "orchestra"],
                    correctAnswer: 1,
                    explanation: "A sculptor creates a sculpture, a composer creates a symphony.",
                    difficulty: "hard",
                    language: .english,
                    level: .level12
                ),
                Question(
                    type: .verbal,
                    subType: VerbalSubType.sentenceCompletion.rawValue,
                    question: "Despite its apparent _____, the speech contained profound ideas.",
                    options: ["complexity", "simplicity", "length", "importance"],
                    correctAnswer: 1,
                    explanation: "Simplicity contrasts with 'profound ideas' introduced by 'despite'.",
                    difficulty: "hard",
                    language: .english,
                    level: .level12
                )
            ]
        }
    }
    
    static func level12QuantitativeQuestions(language: Language) -> [Question] {
        if language == .french {
            return [
                Question(
                    type: .quantitative,
                    subType: QuantitativeSubType.numberAnalogies.rawValue,
                    question: "8 est à 64 comme 5 est à :",
                    options: ["25", "30", "35", "40"],
                    correctAnswer: 0,
                    explanation: "8² = 64, donc 5² = 25",
                    difficulty: "difficile",
                    language: .french,
                    level: .level12
                ),
                Question(
                    type: .quantitative,
                    subType: QuantitativeSubType.equationBuilding.rawValue,
                    question: "Si 2x + 3 = 11, alors x = ?",
                    options: ["3", "4", "5", "6"],
                    correctAnswer: 1,
                    explanation: "2x = 11 - 3 = 8, donc x = 4",
                    difficulty: "difficile",
                    language: .french,
                    level: .level12
                )
            ]
        } else {
            return [
                Question(
                    type: .quantitative,
                    subType: QuantitativeSubType.numberAnalogies.rawValue,
                    question: "8 is to 64 as 5 is to:",
                    options: ["25", "30", "35", "40"],
                    correctAnswer: 0,
                    explanation: "8² = 64, so 5² = 25",
                    difficulty: "hard",
                    language: .english,
                    level: .level12
                ),
                Question(
                    type: .quantitative,
                    subType: QuantitativeSubType.equationBuilding.rawValue,
                    question: "If 2x + 3 = 11, then x = ?",
                    options: ["3", "4", "5", "6"],
                    correctAnswer: 1,
                    explanation: "2x = 11 - 3 = 8, so x = 4",
                    difficulty: "hard",
                    language: .english,
                    level: .level12
                )
            ]
        }
    }
    
    static func level12NonVerbalQuestions(language: Language) -> [Question] {
        return [
            Question(
                type: .nonVerbal,
                subType: NonVerbalSubType.figureMatrices.rawValue,
                question: "Complete the pattern: [●●○] [○●●] [●○●] [?]",
                options: ["[●●○]", "[○○●]", "[●○○]", "[○●○]"],
                correctAnswer: 1,
                explanation: language == .french ? "Le motif suit une rotation des cercles pleins." : "The pattern follows a rotation of filled circles.",
                difficulty: language == .french ? "difficile" : "hard",
                language: language,
                level: .level12
            ),
            Question(
                type: .nonVerbal,
                subType: NonVerbalSubType.figureSeries.rawValue,
                question: "Continue the series: ▲ ▲▲ ▲▲▲ ?",
                options: ["▲", "▲▲", "▲▲▲▲", "▲▲▲▲▲"],
                correctAnswer: 2,
                explanation: language == .french ? "Chaque terme ajoute un triangle de plus." : "Each term adds one more triangle.",
                difficulty: language == .french ? "difficile" : "hard",
                language: language,
                level: .level12
            )
        ]
    }
}

// MARK: - App Settings

struct AppSettings: Codable {
    var language: Language = .english
    var isDarkMode: Bool = false
    var fontSize: FontSize = .medium
    var isReducedMotionEnabled: Bool = false
    var isHapticsEnabled: Bool = true
    var isSoundEnabled: Bool = true
    var autoSubmitOnTimeout: Bool = true
    var showTimeWarnings: Bool = true
    var timerWarnings: Bool = true
    var reminderNotifications: Bool = true
    
    init() {}
}

// MARK: - User Progress

struct UserProgress: Codable {
    var totalTestsTaken: Int = 0
    var totalQuestionsAnswered: Int = 0
    var totalCorrectAnswers: Int = 0
    var bestScore: Double = 0.0
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var lastActiveDate: Date = Date()
    var weeklyGoal: Int = 50
    var questionsThisWeek: Int = 0
    var testHistory: [TestResult] = []
    var practiceHistory: [PracticeResult] = []
    var preferredLanguage: Language = .english
    
    var accuracy: Double {
        guard totalQuestionsAnswered > 0 else { return 0.0 }
        return Double(totalCorrectAnswers) / Double(totalQuestionsAnswered) * 100.0
    }
    
    var averageScore: Double {
        guard !testHistory.isEmpty else { return 0.0 }
        let totalPercentage = testHistory.reduce(0.0) { $0 + $1.percentageScore }
        return totalPercentage / Double(testHistory.count)
    }
    
    var weeklyProgress: Double {
        guard weeklyGoal > 0 else { return 0.0 }
        return min(1.0, Double(questionsThisWeek) / Double(weeklyGoal))
    }
    
    init() {}
}

// MARK: - Extensions

extension QuestionType {
    var icon: String {
        switch self {
        case .verbal:
            return "text.bubble.fill"
        case .quantitative:
            return "number.circle.fill"
        case .nonVerbal:
            return "square.on.square"
        }
    }
    
    var color: Color {
        switch self {
        case .verbal:
            return AppTheme.Colors.skyBlue
        case .quantitative:
            return AppTheme.Colors.sageGreen
        case .nonVerbal:
            return AppTheme.Colors.sunnyYellow
        }
    }
}

extension SessionType {
    var color: Color {
        switch self {
        case .fullMock:
            return AppTheme.Colors.skyBlue
        case .practice:
            return AppTheme.Colors.sageGreen
        case .verbalOnly:
            return AppTheme.Colors.skyBlue
        case .quantitativeOnly:
            return AppTheme.Colors.sageGreen
        case .nonVerbalOnly:
            return AppTheme.Colors.sunnyYellow
        }
    }
}
