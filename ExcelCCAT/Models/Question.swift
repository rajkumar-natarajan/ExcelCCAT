//
//  Question.swift
//  ExcelCCAT
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import Foundation

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
            return "��" // Canadian French, not France French
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
            return NSLocalizedString("quick_assessment_desc", comment: "20-30 questions, 15-20 minutes")
        case .standardPractice:
            return NSLocalizedString("standard_practice_desc", comment: "60-80 questions, 30-40 minutes")
        case .fullMock:
            return NSLocalizedString("full_mock_desc", comment: "Full test simulation")
        case .customTest:
            return NSLocalizedString("custom_test_desc", comment: "Choose your own parameters")
        }
    }
    
    func questionCountRange(for level: CCATLevel) -> ClosedRange<Int> {
        switch (self, level) {
        case (.quickAssessment, .level10):
            return 15...25
        case (.quickAssessment, .level11):
            return 20...30
        case (.quickAssessment, .level12):
            return 25...35
        case (.standardPractice, .level10):
            return 40...60
        case (.standardPractice, .level11):
            return 60...80
        case (.standardPractice, .level12):
            return 80...100
        case (.fullMock, _):
            return level.questionCount...level.questionCount
        case (.customTest, .level10):
            return 10...120
        case (.customTest, .level11):
            return 10...150
        case (.customTest, .level12):
            return 10...176
        }
    }
    
    func defaultQuestionCount(for level: CCATLevel) -> Int {
        switch (self, level) {
        case (.quickAssessment, .level10):
            return 20
        case (.quickAssessment, .level11):
            return 25
        case (.quickAssessment, .level12):
            return 30
        case (.standardPractice, .level10):
            return 50
        case (.standardPractice, .level11):
            return 70
        case (.standardPractice, .level12):
            return 90
        case (.fullMock, _):
            return level.questionCount
        case (.customTest, _):
            return level.questionCount
        }
    }
    
    func timeRange(for level: CCATLevel) -> ClosedRange<Int> {
        switch (self, level) {
        case (.quickAssessment, .level10):
            return 10...20  // minutes
        case (.quickAssessment, .level11):
            return 15...25
        case (.quickAssessment, .level12):
            return 20...30
        case (.standardPractice, .level10):
            return 25...40
        case (.standardPractice, .level11):
            return 35...50
        case (.standardPractice, .level12):
            return 45...60
        case (.fullMock, _):
            return Int(level.timeLimit / 60)...Int(level.timeLimit / 60)
        case (.customTest, .level10):
            return 5...60
        case (.customTest, .level11):
            return 5...75
        case (.customTest, .level12):
            return 5...90
        }
    }
    
    func defaultTime(for level: CCATLevel) -> Int {
        switch (self, level) {
        case (.quickAssessment, .level10):
            return 15
        case (.quickAssessment, .level11):
            return 20
        case (.quickAssessment, .level12):
            return 25
        case (.standardPractice, .level10):
            return 30
        case (.standardPractice, .level11):
            return 40
        case (.standardPractice, .level12):
            return 50
        case (.fullMock, _):
            return Int(level.timeLimit / 60)
        case (.customTest, _):
            return Int(level.timeLimit / 60)
        }
    }
}

struct TestConfiguration {
    let testType: TDSBTestType
    let level: CCATLevel
    let questionCount: Int
    let timeLimit: Int // in minutes
    let isTimedSession: Bool
    
    init(testType: TDSBTestType, level: CCATLevel, questionCount: Int? = nil, timeLimit: Int? = nil, isTimedSession: Bool = true) {
        self.testType = testType
        self.level = level
        self.questionCount = questionCount ?? testType.defaultQuestionCount(for: level)
        self.timeLimit = timeLimit ?? testType.defaultTime(for: level)
        self.isTimedSession = isTimedSession
    }
    
    var displayDescription: String {
        let timeText = isTimedSession ? "\(timeLimit) minutes" : "Untimed"
        return "\(questionCount) questions • \(timeText)"
    }
}

enum CCATLevel: Int, CaseIterable, Codable {
    case level10 = 10  // Grades 2-3
    case level11 = 11  // Grades 4-5
    case level12 = 12  // Grade 6 (Gifted Program)
    
    var displayName: String {
        switch self {
        case .level10:
            return NSLocalizedString("ccat_level_10", comment: "CCAT Level 10")
        case .level11:
            return NSLocalizedString("ccat_level_11", comment: "CCAT Level 11")
        case .level12:
            return NSLocalizedString("ccat_level_12", comment: "CCAT Level 12")
        }
    }
    
    var gradeRange: String {
        switch self {
        case .level10:
            return NSLocalizedString("grades_2_3", comment: "Grades 2-3")
        case .level11:
            return NSLocalizedString("grades_4_5", comment: "Grades 4-5")
        case .level12:
            return NSLocalizedString("grade_6", comment: "Grade 6")
        }
    }
    
    var description: String {
        switch self {
        case .level10:
            return NSLocalizedString("level_10_description", comment: "Basic cognitive skills for early elementary")
        case .level11:
            return NSLocalizedString("level_11_description", comment: "Intermediate cognitive skills for upper elementary")
        case .level12:
            return NSLocalizedString("level_12_description", comment: "Advanced cognitive skills for gifted program")
        }
    }
    
    var questionCount: Int {
        switch self {
        case .level10:
            return 120  // Shorter test for younger students
        case .level11:
            return 150  // Medium length test
        case .level12:
            return 176  // Full length gifted program test
        }
    }
    
    var timeLimit: TimeInterval {
        switch self {
        case .level10:
            return 45 * 60  // 45 minutes for younger students
        case .level11:
            return 60 * 60  // 60 minutes
        case .level12:
            return 75 * 60  // 75 minutes for gifted program
        }
    }
}

enum Difficulty: Int, CaseIterable, Codable {
    case easy = 1
    case medium = 2
    case hard = 3
    
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

struct Question: Identifiable, Codable, Hashable {
    let id: UUID
    let type: QuestionType
    let level: CCATLevel
    let stem: String
    let stemFrench: String
    let options: [String]
    let optionsFrench: [String]
    let correctAnswer: Int // 0-based index
    let explanation: String
    let explanationFrench: String
    let difficulty: Difficulty
    let subType: String // Can be VerbalSubType, QuantitativeSubType, or NonVerbalSubType
    let imageName: String? // For non-verbal questions
    let timeAllocated: TimeInterval? // Optional time limit for this question
    
    init(id: UUID = UUID(),
         type: QuestionType,
         level: CCATLevel = .level12,
         stem: String,
         stemFrench: String,
         options: [String],
         optionsFrench: [String],
         correctAnswer: Int,
         explanation: String,
         explanationFrench: String,
         difficulty: Difficulty,
         subType: String,
         imageName: String? = nil,
         timeAllocated: TimeInterval? = nil) {
        self.id = id
        self.type = type
        self.level = level
        self.stem = stem
        self.stemFrench = stemFrench
        self.options = options
        self.optionsFrench = optionsFrench
        self.correctAnswer = correctAnswer
        self.explanation = explanation
        self.explanationFrench = explanationFrench
        self.difficulty = difficulty
        self.subType = subType
        self.imageName = imageName
        self.timeAllocated = timeAllocated
    }
    
    func getLocalizedStem(language: Language) -> String {
        return language == .french ? stemFrench : stem
    }
    
    func getLocalizedOptions(language: Language) -> [String] {
        return language == .french ? optionsFrench : options
    }
    
    func getLocalizedExplanation(language: Language) -> String {
        return language == .french ? explanationFrench : explanation
    }
}

// MARK: - Test Session Models

struct TestSession: Identifiable, Codable {
    let id: UUID
    let questions: [Question]
    let sessionType: SessionType
    let language: Language
    let startTime: Date
    var endTime: Date?
    var currentQuestionIndex: Int
    var answers: [UUID: Int] // questionId -> selectedOptionIndex
    var isCompleted: Bool
    var timeRemaining: TimeInterval
    
    init(id: UUID = UUID(),
         questions: [Question],
         sessionType: SessionType,
         language: Language,
         currentQuestionIndex: Int = 0,
         timeRemaining: TimeInterval = 30 * 60) { // 30 minutes default
        self.id = id
        self.questions = questions
        self.sessionType = sessionType
        self.language = language
        self.startTime = Date()
        self.currentQuestionIndex = currentQuestionIndex
        self.answers = [:]
        self.isCompleted = false
        self.timeRemaining = timeRemaining
    }
    
    var currentQuestion: Question? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    var progress: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(currentQuestionIndex) / Double(questions.count)
    }
    
    var score: Int {
        return answers.compactMap { (questionId, selectedAnswer) in
            guard let question = questions.first(where: { $0.id == questionId }) else { return nil }
            return question.correctAnswer == selectedAnswer ? 1 : 0
        }.reduce(0, +)
    }
    
    var totalQuestions: Int {
        return questions.count
    }
    
    var percentageScore: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(score) / Double(totalQuestions) * 100
    }
}

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
            return 30 * 60 // 30 minutes
        case .practice:
            return 0 // No time limit
        case .verbalOnly, .quantitativeOnly, .nonVerbalOnly:
            return 10 * 60 // 10 minutes
        }
    }
    
    var questionCount: Int {
        switch self {
        case .fullMock:
            return 176
        case .practice:
            return 50 // Default practice set
        case .verbalOnly, .quantitativeOnly, .nonVerbalOnly:
            return 59
        }
    }
}

// MARK: - User Progress Models

struct UserProgress: Codable {
    var totalTestsTaken: Int
    var totalQuestionsAnswered: Int
    var totalCorrectAnswers: Int
    var averageScore: Double
    var bestScore: Double
    var currentStreak: Int
    var longestStreak: Int
    var testHistory: [TestResult]
    var practiceHistory: [PracticeResult]
    var lastActiveDate: Date
    var preferredLanguage: Language
    var weeklyGoal: Int
    var questionsThisWeek: Int
    
    init() {
        self.totalTestsTaken = 0
        self.totalQuestionsAnswered = 0
        self.totalCorrectAnswers = 0
        self.averageScore = 0.0
        self.bestScore = 0.0
        self.currentStreak = 0
        self.longestStreak = 0
        self.testHistory = []
        self.practiceHistory = []
        self.lastActiveDate = Date()
        self.preferredLanguage = .english
        self.weeklyGoal = 50
        self.questionsThisWeek = 0
    }
    
    var accuracy: Double {
        guard totalQuestionsAnswered > 0 else { return 0 }
        return Double(totalCorrectAnswers) / Double(totalQuestionsAnswered) * 100
    }
    
    var weeklyProgress: Double {
        guard weeklyGoal > 0 else { return 0 }
        return min(Double(questionsThisWeek) / Double(weeklyGoal), 1.0)
    }
}

struct TestResult: Identifiable, Codable {
    let id: UUID
    let sessionType: SessionType
    let language: Language
    let score: Int
    let totalQuestions: Int
    let percentageScore: Double
    let timeTaken: TimeInterval
    let date: Date
    let verbalScore: Int
    let quantitativeScore: Int
    let nonVerbalScore: Int
    let answers: [UUID: Int] // questionId -> selectedAnswer
    
    init(session: TestSession) {
        self.id = UUID()
        self.sessionType = session.sessionType
        self.language = session.language
        self.score = session.score
        self.totalQuestions = session.totalQuestions
        self.percentageScore = session.percentageScore
        self.timeTaken = Date().timeIntervalSince(session.startTime)
        self.date = Date()
        self.answers = session.answers
        
        // Calculate sub-scores
        let verbalQuestions = session.questions.filter { $0.type == .verbal }
        let quantitativeQuestions = session.questions.filter { $0.type == .quantitative }
        let nonVerbalQuestions = session.questions.filter { $0.type == .nonVerbal }
        
        self.verbalScore = verbalQuestions.compactMap { question in
            guard let selectedAnswer = session.answers[question.id] else { return nil }
            return question.correctAnswer == selectedAnswer ? 1 : 0
        }.reduce(0, +)
        
        self.quantitativeScore = quantitativeQuestions.compactMap { question in
            guard let selectedAnswer = session.answers[question.id] else { return nil }
            return question.correctAnswer == selectedAnswer ? 1 : 0
        }.reduce(0, +)
        
        self.nonVerbalScore = nonVerbalQuestions.compactMap { question in
            guard let selectedAnswer = session.answers[question.id] else { return nil }
            return question.correctAnswer == selectedAnswer ? 1 : 0
        }.reduce(0, +)
    }
    
    var percentileRank: Double {
        // Hardcoded CCAT-7 Level 12 norms for Grade 6 students
        // These are approximate percentiles based on typical CCAT scoring
        switch percentageScore {
        case 90...:
            return 99
        case 85..<90:
            return 95
        case 80..<85:
            return 90
        case 75..<80:
            return 85
        case 70..<75:
            return 75
        case 65..<70:
            return 65
        case 60..<65:
            return 55
        case 55..<60:
            return 45
        case 50..<55:
            return 35
        case 45..<50:
            return 25
        case 40..<45:
            return 15
        case 35..<40:
            return 10
        default:
            return 5
        }
    }
    
    var giftedRange: Bool {
        return percentileRank >= 85 // TDSB typically uses 85th percentile or higher
    }
}

struct PracticeResult: Identifiable, Codable {
    let id: UUID
    let questionType: QuestionType
    let subType: String?
    let language: Language
    let score: Int
    let totalQuestions: Int
    let percentageScore: Double
    let date: Date
    let timeSpent: TimeInterval
    
    init(questionType: QuestionType, subType: String?, language: Language, score: Int, totalQuestions: Int, timeSpent: TimeInterval) {
        self.id = UUID()
        self.questionType = questionType
        self.subType = subType
        self.language = language
        self.score = score
        self.totalQuestions = totalQuestions
        self.percentageScore = Double(score) / Double(totalQuestions) * 100
        self.date = Date()
        self.timeSpent = timeSpent
    }
}

// MARK: - Settings Model

struct AppSettings: Codable {
    var language: Language
    var isDarkMode: Bool
    var isHapticsEnabled: Bool
    var isSoundEnabled: Bool
    var timerWarnings: Bool
    var autoSubmitOnTimeout: Bool
    var fontSize: FontSize
    var isReducedMotionEnabled: Bool
    var parentalReportsEnabled: Bool
    var lastBackupDate: Date?
    
    init() {
        self.language = .english
        self.isDarkMode = false
        self.isHapticsEnabled = true
        self.isSoundEnabled = true
        self.timerWarnings = true
        self.autoSubmitOnTimeout = true
        self.fontSize = .medium
        self.isReducedMotionEnabled = false
        self.parentalReportsEnabled = false
        self.lastBackupDate = nil
    }
}

enum FontSize: String, CaseIterable, Codable {
    case small = "small"
    case medium = "medium"
    case large = "large"
    case extraLarge = "extra_large"
    
    var displayName: String {
        switch self {
        case .small:
            return NSLocalizedString("font_size_small", comment: "Small")
        case .medium:
            return NSLocalizedString("font_size_medium", comment: "Medium")
        case .large:
            return NSLocalizedString("font_size_large", comment: "Large")
        case .extraLarge:
            return NSLocalizedString("font_size_extra_large", comment: "Extra Large")
        }
    }
    
    var scaleFactor: CGFloat {
        switch self {
        case .small:
            return 0.9
        case .medium:
            return 1.0
        case .large:
            return 1.2
        case .extraLarge:
            return 1.4
        }
    }
}
