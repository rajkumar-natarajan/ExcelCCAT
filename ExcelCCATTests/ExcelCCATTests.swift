//
//  ExcelCCATTests.swift
//  ExcelCCATTests
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import Testing
@testable import ExcelCCAT

struct ExcelCCATTests {

    @Test func testQuestionDataManagerInitialization() async throws {
        let manager = QuestionDataManager.shared
        #expect(manager.allQuestions.count > 0, "QuestionDataManager should have questions loaded")
        print("✅ Total questions loaded: \(manager.allQuestions.count)")
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
    
    @Test func testAppViewModelStartFullMockTest() async throws {
        let appViewModel = AppViewModel()
        appViewModel.startFullMockTest(language: .english)
        
        #expect(appViewModel.isTestInProgress == true, "Test should be in progress")
        #expect(appViewModel.currentTestSession != nil, "Should have a current test session")
        
        if let session = appViewModel.currentTestSession {
            #expect(session.questions.count > 0, "Session should have questions, got \(session.questions.count)")
            print("✅ Test session created with \(session.questions.count) questions")
        }
    }
    
    @Test func testTestSessionViewModelStartSession() async throws {
        let appViewModel = AppViewModel()
        appViewModel.startFullMockTest(language: .english)
        
        guard let session = appViewModel.currentTestSession else {
            throw TestError("No test session created")
        }
        
        let sessionVM = TestSessionViewModel(appViewModel: appViewModel)
        sessionVM.startSession(session)
        
        #expect(sessionVM.totalQuestions > 0, "Session VM should report total questions, got \(sessionVM.totalQuestions)")
        #expect(sessionVM.currentQuestion != nil, "Should have a current question")
        print("✅ TestSessionViewModel: \(sessionVM.totalQuestions) questions, question \(sessionVM.questionNumber)")
    }
}

struct TestError: Error {
    let message: String
    init(_ message: String) {
        self.message = message
    }
}
