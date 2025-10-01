//
//  ExcelCCATComprehensiveTests.swift
//  ExcelCCAT Tests
//
//  Created by GitHub Copilot on 2025-09-30.
//

import XCTest
import SwiftUI
@testable import ExcelCCAT

/// Comprehensive test suite for ExcelCCAT app functionality
/// Tests all major features, screens, and user flows
class ExcelCCATComprehensiveTests: XCTestCase {
    
    var appViewModel: AppViewModel!
    var questionDataManager: QuestionDataManager!
    var testSessionViewModel: TestSessionViewModel!
    
    override func setUp() {
        super.setUp()
        appViewModel = AppViewModel()
        questionDataManager = QuestionDataManager.shared
        testSessionViewModel = TestSessionViewModel(appViewModel: appViewModel)
    }
    
    override func tearDown() {
        appViewModel = nil
        questionDataManager = nil
        testSessionViewModel = nil
        super.tearDown()
    }
    
    // MARK: - Core Data Tests
    
    func testQuestionDataManagerInitialization() {
        XCTAssertNotNil(questionDataManager, "QuestionDataManager should initialize successfully")
    }
    
    func testQuestionGeneration() {
        let questions = questionDataManager.getConfiguredQuestions(
            configuration: TestConfiguration(testType: .fullMock, level: .level12),
            language: .english
        )
        
        XCTAssertFalse(questions.isEmpty, "Should generate questions")
        XCTAssertEqual(questions.count, 176, "Should generate 176 questions for full mock test")
        
        // Verify question types are present
        let verbalQuestions = questions.filter { $0.type == .verbal }
        let quantitativeQuestions = questions.filter { $0.type == .quantitative }
        let nonVerbalQuestions = questions.filter { $0.type == .nonVerbal }
        
        XCTAssertFalse(verbalQuestions.isEmpty, "Should contain verbal questions")
        XCTAssertFalse(quantitativeQuestions.isEmpty, "Should contain quantitative questions")
        XCTAssertFalse(nonVerbalQuestions.isEmpty, "Should contain non-verbal questions")
    }
    
    func testQuestionsByLevel() {
        for level in CCATLevel.allCases {
            let questions = questionDataManager.getConfiguredQuestions(
                configuration: TestConfiguration(testType: .standardPractice, level: level),
                language: .english
            )
            
            XCTAssertFalse(questions.isEmpty, "Should generate questions for level \(level)")
            
            // Verify all questions are for the correct level
            for question in questions {
                XCTAssertEqual(question.level, level, "Question should be for level \(level)")
            }
        }
    }
    
    func testBilingualQuestions() {
        let questions = questionDataManager.getConfiguredQuestions(
            configuration: TestConfiguration(testType: .quickAssessment, level: .level12),
            language: .french
        )
        
        XCTAssertFalse(questions.isEmpty, "Should generate questions for French")
        
        // Verify questions have French content
        for question in questions {
            XCTAssertFalse(question.stemFrench.isEmpty, "Question should have French stem")
            XCTAssertFalse(question.optionsFrench.isEmpty, "Question should have French options")
            XCTAssertFalse(question.explanationFrench.isEmpty, "Question should have French explanation")
        }
    }
    
    func testPracticeQuestions() {
        for type in QuestionType.allCases {
            let questions = questionDataManager.getPracticeQuestions(
                type: type,
                language: .english,
                count: 25,
                level: .level12
            )
            
            XCTAssertFalse(questions.isEmpty, "Should generate practice questions for \(type)")
            XCTAssertLessthan(questions.count, 26, "Should not exceed requested count")
            
            // Verify all questions are of correct type
            for question in questions {
                XCTAssertEqual(question.type, type, "Question should be of type \(type)")
            }
        }
    }
    
    // MARK: - App State Management Tests
    
    func testAppViewModelInitialization() {
        XCTAssertNotNil(appViewModel, "AppViewModel should initialize")
        XCTAssertEqual(appViewModel.currentLanguage, .english, "Default language should be English")
        XCTAssertEqual(appViewModel.selectedCCATLevel, .level12, "Default level should be Level 12")
        XCTAssertFalse(appViewModel.isTestInProgress, "Should not have test in progress initially")
        XCTAssertFalse(appViewModel.showingResults, "Should not be showing results initially")
    }
    
    func testLanguageSwitching() {
        // Test switching to French
        appViewModel.updateSetting(\.language, value: .french)
        XCTAssertEqual(appViewModel.appSettings.language, .french, "Language should switch to French")
        
        // Test switching back to English
        appViewModel.updateSetting(\.language, value: .english)
        XCTAssertEqual(appViewModel.appSettings.language, .english, "Language should switch back to English")
    }
    
    func testLevelSelection() {
        for level in CCATLevel.allCases {
            appViewModel.selectedCCATLevel = level
            XCTAssertEqual(appViewModel.selectedCCATLevel, level, "Should set level to \(level)")
        }
    }
    
    func testTestConfiguration() {
        let config = TestConfiguration(testType: .fullMock, level: .level11)
        appViewModel.currentTestConfiguration = config
        
        XCTAssertEqual(appViewModel.currentTestConfiguration.testType, .fullMock, "Should set test type")
        XCTAssertEqual(appViewModel.currentTestConfiguration.level, .level11, "Should set level")
        XCTAssertEqual(appViewModel.currentTestConfiguration.questionCount, 176, "Should have correct question count")
    }
    
    // MARK: - Settings Tests
    
    func testAppSettings() {
        // Test dark mode toggle
        appViewModel.updateSetting(\.isDarkMode, value: true)
        XCTAssertTrue(appViewModel.appSettings.isDarkMode, "Should enable dark mode")
        
        // Test font size changes
        for fontSize in FontSize.allCases {
            appViewModel.updateSetting(\.fontSize, value: fontSize)
            XCTAssertEqual(appViewModel.appSettings.fontSize, fontSize, "Should set font size to \(fontSize)")
        }
        
        // Test haptics toggle
        appViewModel.updateSetting(\.isHapticsEnabled, value: false)
        XCTAssertFalse(appViewModel.appSettings.isHapticsEnabled, "Should disable haptics")
        
        // Test sound toggle
        appViewModel.updateSetting(\.isSoundEnabled, value: true)
        XCTAssertTrue(appViewModel.appSettings.isSoundEnabled, "Should enable sound")
    }
    
    func testUserProgress() {
        let initialTests = appViewModel.userProgress.totalTestsTaken
        let initialQuestions = appViewModel.userProgress.totalQuestionsAnswered
        
        // Simulate completing a test
        appViewModel.userProgress.totalTestsTaken += 1
        appViewModel.userProgress.totalQuestionsAnswered += 50
        appViewModel.userProgress.totalCorrectAnswers += 40
        
        XCTAssertEqual(appViewModel.userProgress.totalTestsTaken, initialTests + 1, "Should increment tests taken")
        XCTAssertEqual(appViewModel.userProgress.totalQuestionsAnswered, initialQuestions + 50, "Should increment questions answered")
        XCTAssertEqual(appViewModel.userProgress.totalCorrectAnswers, 40, "Should track correct answers")
    }
    
    func testWeeklyGoalManagement() {
        let newGoal = 100
        appViewModel.updateWeeklyGoal(newGoal)
        XCTAssertEqual(appViewModel.userProgress.weeklyGoal, newGoal, "Should update weekly goal")
    }
    
    // MARK: - Test Session Tests
    
    func testTestSessionCreation() {
        let questions = questionDataManager.getConfiguredQuestions(
            configuration: TestConfiguration(testType: .quickAssessment, level: .level12),
            language: .english
        )
        
        let session = TestSession(
            questions: questions,
            sessionType: .practice,
            language: .english,
            level: .level12,
            testType: .quickAssessment,
            timeRemaining: 900 // 15 minutes
        )
        
        XCTAssertEqual(session.questions.count, questions.count, "Session should contain all questions")
        XCTAssertEqual(session.sessionType, .practice, "Should set correct session type")
        XCTAssertEqual(session.language, .english, "Should set correct language")
        XCTAssertEqual(session.level, .level12, "Should set correct level")
        XCTAssertEqual(session.currentQuestionIndex, 0, "Should start at first question")
        XCTAssertFalse(session.isCompleted, "Should not be completed initially")
    }
    
    func testTestSessionViewModel() {
        let questions = questionDataManager.getConfiguredQuestions(
            configuration: TestConfiguration(testType: .quickAssessment, level: .level12),
            language: .english
        )
        
        let session = TestSession(
            questions: questions,
            sessionType: .practice,
            language: .english,
            level: .level12,
            testType: .quickAssessment,
            timeRemaining: 900
        )
        
        testSessionViewModel.startSession(session)
        
        XCTAssertTrue(testSessionViewModel.isActive, "Session should be active")
        XCTAssertEqual(testSessionViewModel.totalQuestions, questions.count, "Should track total questions")
        XCTAssertEqual(testSessionViewModel.questionNumber, 1, "Should start at question 1")
        XCTAssertNotNil(testSessionViewModel.currentQuestion, "Should have current question")
    }
    
    func testQuestionNavigation() {
        let questions = questionDataManager.getConfiguredQuestions(
            configuration: TestConfiguration(testType: .quickAssessment, level: .level12),
            language: .english
        )
        
        let session = TestSession(
            questions: questions,
            sessionType: .practice,
            language: .english,
            level: .level12,
            testType: .quickAssessment,
            timeRemaining: 900
        )
        
        testSessionViewModel.startSession(session)
        
        // Test next question
        let initialQuestion = testSessionViewModel.questionNumber
        testSessionViewModel.nextQuestion()
        XCTAssertEqual(testSessionViewModel.questionNumber, initialQuestion + 1, "Should advance to next question")
        
        // Test previous question (if allowed)
        if testSessionViewModel.canGoBack {
            testSessionViewModel.previousQuestion()
            XCTAssertEqual(testSessionViewModel.questionNumber, initialQuestion, "Should go back to previous question")
        }
    }
    
    func testAnswerSelection() {
        let questions = questionDataManager.getConfiguredQuestions(
            configuration: TestConfiguration(testType: .quickAssessment, level: .level12),
            language: .english
        )
        
        let session = TestSession(
            questions: questions,
            sessionType: .practice,
            language: .english,
            level: .level12,
            testType: .quickAssessment,
            timeRemaining: 900
        )
        
        testSessionViewModel.startSession(session)
        
        // Test answer selection
        testSessionViewModel.selectAnswer(2)
        XCTAssertEqual(testSessionViewModel.selectedAnswer, 2, "Should set selected answer")
        XCTAssertTrue(testSessionViewModel.hasAnsweredCurrentQuestion, "Should mark question as answered")
    }
    
    // MARK: - Practice Session Tests
    
    func testPracticeSessionCreation() {
        appViewModel.startPracticeSession(
            type: .verbal,
            language: .english,
            questionCount: 25,
            isTimedSession: false
        )
        
        XCTAssertTrue(appViewModel.isTestInProgress, "Should start practice session")
        XCTAssertNotNil(appViewModel.currentTestSession, "Should create test session")
        
        if let session = appViewModel.currentTestSession {
            XCTAssertEqual(session.sessionType, .practice, "Should be practice session")
            XCTAssertEqual(session.questions.count, 25, "Should have 25 questions")
        }
    }
    
    func testFullMockTestCreation() {
        appViewModel.startFullMockTest(language: .english)
        
        XCTAssertTrue(appViewModel.isTestInProgress, "Should start full mock test")
        XCTAssertNotNil(appViewModel.currentTestSession, "Should create test session")
        
        if let session = appViewModel.currentTestSession {
            XCTAssertEqual(session.sessionType, .fullMock, "Should be full mock session")
            XCTAssertEqual(session.questions.count, 176, "Should have 176 questions")
        }
    }
    
    // MARK: - Results and Progress Tests
    
    func testTestResultCreation() {
        let questions = questionDataManager.getConfiguredQuestions(
            configuration: TestConfiguration(testType: .quickAssessment, level: .level12),
            language: .english
        )
        
        var session = TestSession(
            questions: questions,
            sessionType: .fullMock,
            language: .english,
            level: .level12,
            testType: .quickAssessment,
            timeRemaining: 0
        )
        
        // Simulate answering some questions correctly
        for i in 0..<min(10, questions.count) {
            session.answers[questions[i].id] = questions[i].correctAnswer
        }
        
        session.isCompleted = true
        session.endTime = Date()
        
        let result = TestResult(session: session)
        
        XCTAssertEqual(result.sessionType, .fullMock, "Should match session type")
        XCTAssertEqual(result.language, .english, "Should match language")
        XCTAssertEqual(result.level, .level12, "Should match level")
        XCTAssertEqual(result.totalQuestions, questions.count, "Should match total questions")
        XCTAssertGreaterThan(result.score, 0, "Should have positive score")
    }
    
    func testPracticeResultCreation() {
        let practiceResult = PracticeResult(
            questionType: .verbal,
            subType: VerbalSubType.analogies.rawValue,
            language: .english,
            level: .level12,
            date: Date(),
            score: 8,
            totalQuestions: 10,
            timeSpent: 300
        )
        
        XCTAssertEqual(practiceResult.questionType, .verbal, "Should match question type")
        XCTAssertEqual(practiceResult.score, 8, "Should match score")
        XCTAssertEqual(practiceResult.totalQuestions, 10, "Should match total questions")
        XCTAssertGreaterThan(practiceResult.accuracy, 0.75, "Should calculate accuracy correctly")
    }
    
    // MARK: - Data Persistence Tests
    
    func testSettingsPersistence() {
        // Modify settings
        appViewModel.updateSetting(\.isDarkMode, value: true)
        appViewModel.updateSetting(\.fontSize, value: .large)
        appViewModel.updateSetting(\.language, value: .french)
        
        // Save data
        appViewModel.saveUserData()
        
        // Create new instance to simulate app restart
        let newAppViewModel = AppViewModel()
        
        XCTAssertTrue(newAppViewModel.appSettings.isDarkMode, "Dark mode should persist")
        XCTAssertEqual(newAppViewModel.appSettings.fontSize, .large, "Font size should persist")
        XCTAssertEqual(newAppViewModel.appSettings.language, .french, "Language should persist")
    }
    
    func testProgressPersistence() {
        // Modify progress
        appViewModel.userProgress.totalTestsTaken = 5
        appViewModel.userProgress.totalQuestionsAnswered = 250
        appViewModel.userProgress.weeklyGoal = 100
        
        // Save data
        appViewModel.saveUserData()
        
        // Create new instance to simulate app restart
        let newAppViewModel = AppViewModel()
        
        XCTAssertEqual(newAppViewModel.userProgress.totalTestsTaken, 5, "Tests taken should persist")
        XCTAssertEqual(newAppViewModel.userProgress.totalQuestionsAnswered, 250, "Questions answered should persist")
        XCTAssertEqual(newAppViewModel.userProgress.weeklyGoal, 100, "Weekly goal should persist")
    }
    
    // MARK: - Localization Tests
    
    func testLocalizationKeys() {
        // Test that common localization keys don't crash
        let keys = [
            "welcome_message",
            "settings_title",
            "start_test",
            "practice_mode",
            "full_mock_test",
            "language",
            "appearance",
            "about_app"
        ]
        
        for key in keys {
            let localizedString = NSLocalizedString(key, comment: "")
            XCTAssertFalse(localizedString.isEmpty, "Localization key '\(key)' should not be empty")
            XCTAssertNotEqual(localizedString, key, "Localization key '\(key)' should be translated")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testGracefulErrorHandling() {
        // Test with invalid configuration
        let invalidConfig = TestConfiguration(
            testType: .customTest,
            level: .level12,
            questionCount: 0,
            timeLimit: 0,
            isTimedSession: false
        )
        
        let questions = questionDataManager.getConfiguredQuestions(
            configuration: invalidConfig,
            language: .english
        )
        
        // Should still return some questions due to fallback mechanism
        XCTAssertFalse(questions.isEmpty, "Should handle invalid configuration gracefully")
    }
    
    func testEmptyQuestionDatabase() {
        // This tests the fallback mechanism when no questions are available
        let emptyManager = QuestionDataManager()
        let questions = emptyManager.getConfiguredQuestions(
            configuration: TestConfiguration(testType: .quickAssessment, level: .level12),
            language: .english
        )
        
        XCTAssertFalse(questions.isEmpty, "Should provide fallback questions when database is empty")
    }
    
    // MARK: - Performance Tests
    
    func testQuestionGenerationPerformance() {
        measure {
            _ = questionDataManager.getConfiguredQuestions(
                configuration: TestConfiguration(testType: .fullMock, level: .level12),
                language: .english
            )
        }
    }
    
    func testLargeSessionPerformance() {
        let questions = questionDataManager.getConfiguredQuestions(
            configuration: TestConfiguration(testType: .fullMock, level: .level12),
            language: .english
        )
        
        measure {
            let session = TestSession(
                questions: questions,
                sessionType: .fullMock,
                language: .english,
                level: .level12,
                testType: .fullMock,
                timeRemaining: 7200
            )
            testSessionViewModel.startSession(session)
        }
    }
    
    // MARK: - Integration Tests
    
    func testCompleteUserFlow() {
        // Simulate complete user flow: onboarding -> practice -> test -> results
        
        // 1. Complete onboarding
        appViewModel.completeOnboarding()
        XCTAssertFalse(appViewModel.showingOnboarding, "Should complete onboarding")
        
        // 2. Start practice session
        appViewModel.startPracticeSession(
            type: .verbal,
            language: .english,
            questionCount: 5,
            isTimedSession: false
        )
        XCTAssertTrue(appViewModel.isTestInProgress, "Should start practice session")
        
        // 3. Answer questions
        if let session = appViewModel.currentTestSession {
            testSessionViewModel.startSession(session)
            
            for _ in 0..<min(3, session.questions.count) {
                testSessionViewModel.selectAnswer(0)
                if !testSessionViewModel.isLastQuestion {
                    testSessionViewModel.nextQuestion()
                }
            }
            
            // 4. Complete session
            testSessionViewModel.completeSession()
            XCTAssertTrue(testSessionViewModel.showingResults, "Should show results after completion")
        }
    }
    
    func testLanguageSwitchingDuringSession() {
        // Start a session in English
        appViewModel.startPracticeSession(
            type: .verbal,
            language: .english,
            questionCount: 5,
            isTimedSession: false
        )
        
        // Switch language during session
        appViewModel.updateSetting(\.language, value: .french)
        
        // Verify session continues properly
        XCTAssertTrue(appViewModel.isTestInProgress, "Session should continue after language switch")
        XCTAssertEqual(appViewModel.appSettings.language, .french, "Language should be updated")
    }
    
    // MARK: - Accessibility Tests
    
    func testAccessibilityConfiguration() {
        // Test font size accessibility
        for fontSize in FontSize.allCases {
            appViewModel.updateSetting(\.fontSize, value: fontSize)
            XCTAssertEqual(appViewModel.appSettings.fontSize, fontSize, "Should support all font sizes")
        }
        
        // Test that app handles accessibility settings
        appViewModel.updateSetting(\.isHapticsEnabled, value: false)
        XCTAssertFalse(appViewModel.appSettings.isHapticsEnabled, "Should allow disabling haptics for accessibility")
    }
    
    // MARK: - Edge Cases Tests
    
    func testMinimumQuestionCounts() {
        let config = TestConfiguration(
            testType: .customTest,
            level: .level12,
            questionCount: 1,
            timeLimit: 1,
            isTimedSession: true
        )
        
        let questions = questionDataManager.getConfiguredQuestions(configuration: config, language: .english)
        XCTAssertGreaterThanOrEqual(questions.count, 1, "Should handle minimum question count")
    }
    
    func testMaximumQuestionCounts() {
        let config = TestConfiguration(
            testType: .customTest,
            level: .level12,
            questionCount: 1000,
            timeLimit: 120,
            isTimedSession: true
        )
        
        let questions = questionDataManager.getConfiguredQuestions(configuration: config, language: .english)
        XCTAssertLessThanOrEqual(questions.count, 1000, "Should handle large question counts")
    }
    
    func testSessionWithoutTimer() {
        appViewModel.startPracticeSession(
            type: .verbal,
            language: .english,
            questionCount: 5,
            isTimedSession: false
        )
        
        if let session = appViewModel.currentTestSession {
            testSessionViewModel.startSession(session)
            XCTAssertFalse(testSessionViewModel.isTimerRunning, "Should not run timer for untimed sessions")
        }
    }
    
    func testSessionWithTimer() {
        appViewModel.startPracticeSession(
            type: .verbal,
            language: .english,
            questionCount: 5,
            isTimedSession: true
        )
        
        if let session = appViewModel.currentTestSession {
            testSessionViewModel.startSession(session)
            XCTAssertTrue(testSessionViewModel.isTimerRunning, "Should run timer for timed sessions")
        }
    }
}

// MARK: - Test Extensions and Helpers

extension XCTestCase {
    func waitForExpectation(timeout: TimeInterval = 1.0, handler: @escaping () -> Void) {
        let expectation = XCTestExpectation(description: "Async operation")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            handler()
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeout)
    }
}
