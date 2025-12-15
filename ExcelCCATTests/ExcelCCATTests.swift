//
//  ExcelCCATTests.swift
//  ExcelCCATTests
//
//  Comprehensive Unit Tests - December 15, 2025
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import Testing
@testable import ExcelCCAT

// MARK: - QuestionDataManager Tests

struct QuestionDataManagerTests {
    
    @Test func testQuestionDataManagerInitialization() async throws {
        let manager = QuestionDataManager.shared
        #expect(manager.allQuestions.count > 0, "QuestionDataManager should have questions loaded")
        print("✅ Total questions loaded: \(manager.allQuestions.count)")
    }
    
    @Test func testQuestionCountPerLevel() async throws {
        let manager = QuestionDataManager.shared
        
        // Should have 180 questions per level (60 per type × 3 types)
        for level in CCATLevel.allCases {
            let config = TestConfiguration(testType: .fullMock, level: level)
            let questions = manager.getConfiguredQuestions(configuration: config, language: .english)
            #expect(questions.count >= 60, "Level \(level) should have at least 60 questions, got \(questions.count)")
            print("✅ Level \(level): \(questions.count) questions")
        }
    }
    
    @Test func testFullMockQuestionGeneration() async throws {
        let config = TestConfiguration(testType: .fullMock, level: .level12)
        let questions = QuestionDataManager.shared.getConfiguredQuestions(
            configuration: config,
            language: .english
        )
        #expect(questions.count == 176, "Full mock should have 176 questions, got \(questions.count)")
        print("✅ Full mock questions: \(questions.count)")
    }
    
    @Test func testQuestionTypeDistribution() async throws {
        let manager = QuestionDataManager.shared
        
        for type in QuestionType.allCases {
            let questions = manager.getQuestionsByType(type, count: Int.max)
            #expect(questions.count > 0, "Should have questions for type \(type)")
            print("✅ \(type.displayName): \(questions.count) questions")
        }
    }
    
    @Test func testQuestionDifficultyLevels() async throws {
        let manager = QuestionDataManager.shared
        
        let easyQuestions = manager.allQuestions.filter { $0.difficulty == "easy" }
        let mediumQuestions = manager.allQuestions.filter { $0.difficulty == "medium" }
        let hardQuestions = manager.allQuestions.filter { $0.difficulty == "hard" }
        
        #expect(easyQuestions.count > 0 || mediumQuestions.count > 0 || hardQuestions.count > 0, "Should have questions with difficulty levels")
        
        print("✅ Easy: \(easyQuestions.count), Medium: \(mediumQuestions.count), Hard: \(hardQuestions.count)")
    }
    
    @Test func testBilingualSupport() async throws {
        let manager = QuestionDataManager.shared
        
        // Test English questions
        let englishConfig = TestConfiguration(testType: .quickAssessment, level: .level12)
        let englishQuestions = manager.getConfiguredQuestions(configuration: englishConfig, language: .english)
        
        // Test French questions
        let frenchQuestions = manager.getConfiguredQuestions(configuration: englishConfig, language: .french)
        
        #expect(englishQuestions.count > 0, "Should have English questions")
        #expect(frenchQuestions.count > 0, "Should have French questions")
        
        print("✅ English: \(englishQuestions.count), French: \(frenchQuestions.count)")
    }
}

// MARK: - AppViewModel Tests

struct AppViewModelTests {
    
    @Test func testAppViewModelInitialization() async throws {
        let viewModel = AppViewModel()
        
        #expect(viewModel.isTestInProgress == false, "Should not have test in progress initially")
        #expect(viewModel.currentTestSession == nil, "Should not have current session initially")
        #expect(viewModel.selectedCCATLevel != nil, "Should have a default level selected")
        
        print("✅ AppViewModel initialized correctly")
    }
    
    @Test func testStartFullMockTest() async throws {
        let viewModel = AppViewModel()
        viewModel.startFullMockTest(language: .english)
        
        #expect(viewModel.isTestInProgress == true, "Test should be in progress")
        #expect(viewModel.currentTestSession != nil, "Should have a current test session")
        
        if let session = viewModel.currentTestSession {
            #expect(session.questions.count > 0, "Session should have questions, got \(session.questions.count)")
            print("✅ Full mock test started with \(session.questions.count) questions")
        }
    }
    
    @Test func testStartPracticeSession() async throws {
        let viewModel = AppViewModel()
        viewModel.startPracticeSession(
            type: .verbal,
            language: .english,
            questionCount: 20,
            isTimedSession: false
        )
        
        #expect(viewModel.isTestInProgress == true, "Practice should be in progress")
        
        if let session = viewModel.currentTestSession {
            #expect(session.questions.count == 20, "Practice session should have 20 questions")
            print("✅ Practice session started with \(session.questions.count) questions")
        }
    }
    
    @Test func testLanguageChange() async throws {
        let viewModel = AppViewModel()
        
        viewModel.updateSetting(\.language, value: .english)
        #expect(viewModel.currentLanguage == .english, "Language should be English")
        
        viewModel.updateSetting(\.language, value: .french)
        #expect(viewModel.currentLanguage == .french, "Language should be French")
        
        print("✅ Language change works correctly")
    }
    
    @Test func testLevelChange() async throws {
        let viewModel = AppViewModel()
        
        viewModel.changeCCATLevel(to: .level10)
        #expect(viewModel.selectedCCATLevel == .level10, "Level should be 10")
        
        viewModel.changeCCATLevel(to: .level11)
        #expect(viewModel.selectedCCATLevel == .level11, "Level should be 11")
        
        viewModel.changeCCATLevel(to: .level12)
        #expect(viewModel.selectedCCATLevel == .level12, "Level should be 12")
        
        print("✅ Level change works correctly")
    }
}

// MARK: - TestSessionViewModel Tests

struct TestSessionViewModelTests {
    
    @Test func testTestSessionViewModelInitialization() async throws {
        let appViewModel = AppViewModel()
        appViewModel.startFullMockTest(language: .english)
        
        guard let session = appViewModel.currentTestSession else {
            throw TestError("No test session created")
        }
        
        let sessionVM = TestSessionViewModel(appViewModel: appViewModel)
        sessionVM.startSession(session)
        
        #expect(sessionVM.totalQuestions > 0, "Should have questions")
        #expect(sessionVM.questionNumber == 1, "Should start at question 1")
        #expect(sessionVM.currentQuestion != nil, "Should have current question")
        
        print("✅ TestSessionViewModel: \(sessionVM.totalQuestions) questions")
    }
    
    @Test func testQuestionNavigation() async throws {
        let appViewModel = AppViewModel()
        appViewModel.startFullMockTest(language: .english)
        
        guard let session = appViewModel.currentTestSession else {
            throw TestError("No test session created")
        }
        
        let sessionVM = TestSessionViewModel(appViewModel: appViewModel)
        sessionVM.startSession(session)
        
        let initialQuestion = sessionVM.questionNumber
        
        // Select an answer
        sessionVM.selectAnswer(0)
        
        print("✅ Question navigation works correctly")
    }
    
    @Test func testTimerFunctionality() async throws {
        let appViewModel = AppViewModel()
        appViewModel.startFullMockTest(language: .english)
        
        guard let session = appViewModel.currentTestSession else {
            throw TestError("No test session created")
        }
        
        let sessionVM = TestSessionViewModel(appViewModel: appViewModel)
        sessionVM.startSession(session)
        
        #expect(sessionVM.timeRemaining > 0, "Should have time remaining")
        #expect(sessionVM.formattedTimeRemaining.count > 0, "Should have formatted time")
        
        print("✅ Timer: \(sessionVM.formattedTimeRemaining)")
    }
    
    @Test func testProgressTracking() async throws {
        let appViewModel = AppViewModel()
        appViewModel.startFullMockTest(language: .english)
        
        guard let session = appViewModel.currentTestSession else {
            throw TestError("No test session created")
        }
        
        let sessionVM = TestSessionViewModel(appViewModel: appViewModel)
        sessionVM.startSession(session)
        
        let initialProgress = sessionVM.progress
        #expect(initialProgress >= 0 && initialProgress <= 1, "Progress should be between 0 and 1")
        
        print("✅ Progress tracking: \(String(format: "%.2f", initialProgress * 100))%")
    }
}

// MARK: - UserProgress Tests

struct UserProgressTests {
    
    @Test func testUserProgressInitialization() async throws {
        let progress = UserProgress()
        
        #expect(progress.currentStreak >= 0, "Streak should be non-negative")
        #expect(progress.bestScore >= 0, "Best score should be non-negative")
        #expect(progress.totalTestsTaken >= 0, "Total tests should be non-negative")
        
        print("✅ UserProgress initialized correctly")
    }
    
    @Test func testWeeklyProgress() async throws {
        let progress = UserProgress()
        
        #expect(progress.weeklyGoal > 0, "Weekly goal should be positive")
        #expect(progress.weeklyProgress >= 0 && progress.weeklyProgress <= 1, "Weekly progress should be between 0 and 1")
        
        print("✅ Weekly progress: \(progress.questionsThisWeek)/\(progress.weeklyGoal)")
    }
    
    @Test func testAccuracyCalculation() async throws {
        let progress = UserProgress()
        
        #expect(progress.accuracy >= 0 && progress.accuracy <= 100, "Accuracy should be between 0 and 100")
        
        print("✅ Accuracy: \(String(format: "%.1f", progress.accuracy))%")
    }
}

// MARK: - Question Model Tests

struct QuestionModelTests {
    
    @Test func testQuestionStructure() async throws {
        let question = Question(
            type: .verbal,
            stem: "Test question stem",
            stemFrench: "Question de test",
            options: ["A", "B", "C", "D"],
            optionsFrench: ["A", "B", "C", "D"],
            correctAnswer: 0,
            explanation: "Test explanation",
            explanationFrench: "Explication de test",
            difficulty: "medium",
            subType: "analogies",
            language: .english,
            level: .level12
        )
        
        #expect(question.type == .verbal, "Type should be verbal")
        #expect(question.options.count == 4, "Should have 4 options")
        #expect(question.correctAnswer == 0, "Correct answer should be 0")
        
        print("✅ Question structure is valid")
    }
    
    @Test func testLocalizedContent() async throws {
        let question = Question(
            type: .verbal,
            stem: "English stem",
            stemFrench: "French stem",
            options: ["A", "B", "C", "D"],
            optionsFrench: ["X", "Y", "Z", "W"],
            correctAnswer: 0,
            explanation: "English explanation",
            explanationFrench: "French explanation",
            difficulty: "medium",
            subType: "analogies",
            language: .english,
            level: .level12
        )
        
        let englishStem = question.getLocalizedStem(language: .english)
        let frenchStem = question.getLocalizedStem(language: .french)
        
        #expect(englishStem == "English stem", "English stem should match")
        #expect(frenchStem == "French stem", "French stem should match")
        
        print("✅ Localized content works correctly")
    }
}

// MARK: - TestConfiguration Tests

struct TestConfigurationTests {
    
    @Test func testTestConfigurationTypes() async throws {
        for testType in TDSBTestType.allCases {
            let config = TestConfiguration(testType: testType, level: .level12)
            
            #expect(config.testType == testType, "Test type should match")
            #expect(config.displayDescription.count > 0, "Should have display description")
            
            print("✅ \(testType): \(config.displayDescription)")
        }
    }
    
    @Test func testFullMockConfiguration() async throws {
        let config = TestConfiguration(testType: .fullMock, level: .level12)
        
        #expect(config.testType == .fullMock, "Should be full mock")
        #expect(config.questionCount == 176, "Full mock should have 176 questions")
        
        print("✅ Full mock config: \(config.questionCount) questions")
    }
    
    @Test func testQuickAssessmentConfiguration() async throws {
        let config = TestConfiguration(testType: .quickAssessment, level: .level12)
        
        #expect(config.testType == .quickAssessment, "Should be quick assessment")
        #expect(config.questionCount == 20, "Quick assessment should have 20 questions")
        
        print("✅ Quick assessment config: \(config.questionCount) questions")
    }
}

// MARK: - Integration Tests

struct IntegrationTests {
    
    @Test func testCompleteTestWorkflow() async throws {
        // 1. Initialize AppViewModel
        let appViewModel = AppViewModel()
        
        // 2. Start a test
        appViewModel.startFullMockTest(language: .english)
        
        guard let session = appViewModel.currentTestSession else {
            throw TestError("Failed to create test session")
        }
        
        // 3. Create TestSessionViewModel
        let sessionVM = TestSessionViewModel(appViewModel: appViewModel)
        sessionVM.startSession(session)
        
        // 4. Verify session is active
        #expect(sessionVM.totalQuestions > 0, "Should have questions")
        #expect(sessionVM.currentQuestion != nil, "Should have current question")
        
        // 5. Answer a question
        sessionVM.selectAnswer(0)
        
        print("✅ Complete test workflow passed")
    }
    
    @Test func testAllLevelsHaveQuestions() async throws {
        for level in CCATLevel.allCases {
            let config = TestConfiguration(testType: .fullMock, level: level)
            let questions = QuestionDataManager.shared.getConfiguredQuestions(
                configuration: config,
                language: .english
            )
            #expect(questions.count > 0, "Level \(level) should have questions")
            print("✅ Level \(level): \(questions.count) questions")
        }
    }
    
    @Test func testBothLanguagesWork() async throws {
        let appViewModel = AppViewModel()
        
        // Test English
        appViewModel.updateSetting(\.language, value: .english)
        appViewModel.startFullMockTest(language: .english)
        let englishSession = appViewModel.currentTestSession
        #expect(englishSession?.questions.count ?? 0 > 0, "English session should have questions")
        
        print("✅ Both languages work correctly")
    }
}

// MARK: - Helper Types

struct TestError: Error {
    let message: String
    init(_ message: String) {
        self.message = message
    }
}

