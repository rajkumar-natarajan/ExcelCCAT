//
//  TestSessionViewModel.swift
//  ExcelCCAT
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import Foundation
import SwiftUI
import Combine
import UserNotifications

@Observable
class TestSessionViewModel {
    
    // MARK: - Published Properties
    var currentSession: TestSession?
    var isActive: Bool = false
    var timeRemaining: TimeInterval = 0
    var isTimerRunning: Bool = false
    var selectedAnswer: Int? = nil
    var showingResults: Bool = false
    var showingExitConfirmation: Bool = false
    var hasAnsweredCurrentQuestion: Bool = false
    
    // MARK: - Private Properties
    private var timer: Timer?
    private var appViewModel: AppViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed Properties
    var currentQuestion: Question? {
        guard let session = currentSession,
              session.currentQuestionIndex < session.questions.count else {
            return nil
        }
        return session.questions[session.currentQuestionIndex]
    }
    
    var progress: Double {
        guard let session = currentSession else { return 0 }
        return Double(session.currentQuestionIndex + 1) / Double(session.questions.count)
    }
    
    var questionNumber: Int {
        guard let session = currentSession else { return 0 }
        return session.currentQuestionIndex + 1
    }
    
    var totalQuestions: Int {
        return currentSession?.questions.count ?? 0
    }
    
    var isLastQuestion: Bool {
        guard let session = currentSession else { return false }
        return session.currentQuestionIndex >= session.questions.count - 1
    }
    
    var canGoBack: Bool {
        guard let session = currentSession else { return false }
        return session.currentQuestionIndex > 0 && session.sessionType != .fullMock
    }
    
    var formattedTimeRemaining: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var timeWarningLevel: TimeWarningLevel {
        let totalTime = currentSession?.sessionType.timeLimit ?? 1800 // 30 minutes default
        let percentageRemaining = timeRemaining / totalTime
        
        if percentageRemaining <= 0.1 { // 10% or less
            return .critical
        } else if percentageRemaining <= 0.25 { // 25% or less
            return .warning
        } else {
            return .normal
        }
    }
    
    // MARK: - Initialization
    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
    }
    
    // MARK: - Session Management
    func startSession(_ session: TestSession) {
        currentSession = session
        timeRemaining = session.timeRemaining
        isActive = true
        selectedAnswer = nil
        hasAnsweredCurrentQuestion = false
    UIDevice.current.isBatteryMonitoringEnabled = true
        
        // Check if there's already an answer for current question
        if let question = currentQuestion,
           let existingAnswer = session.answers[question.id] {
            selectedAnswer = existingAnswer
            hasAnsweredCurrentQuestion = true
        }
        
        // Start timer if session has time limit
        if session.sessionType.timeLimit > 0 {
            startTimer()
        }
        
        // Schedule low battery check
        scheduleBatteryCheck()
    }
    
    func resumeSession(_ session: TestSession) {
        startSession(session)
    }
    
    func pauseSession() {
        stopTimer()
        saveSession()
    }
    
    func exitSession() {
        stopTimer()
        clearSession()
        isActive = false
        showingExitConfirmation = false
    }
    
    func completeSession() {
        guard var session = currentSession else { return }
        
        stopTimer()
        session.isCompleted = true
        session.endTime = Date()
        currentSession = session
        
        // Create test result and update app state
        appViewModel.completeTest()
        
        isActive = false
        showingResults = true
    }
    
    // MARK: - Question Navigation
    func selectAnswer(_ answerIndex: Int) {
        guard var session = currentSession,
              let question = currentQuestion else { return }
        
        selectedAnswer = answerIndex
        hasAnsweredCurrentQuestion = true
        
        // Save answer to session
        session.answers[question.id] = answerIndex
        currentSession = session
        
        // Provide haptic feedback
        appViewModel.playHapticFeedback(.selection)
        
        saveSession()
    }
    
    func nextQuestion() {
        guard var session = currentSession else { return }
        
        if session.currentQuestionIndex < session.questions.count - 1 {
            session.currentQuestionIndex += 1
            currentSession = session
            
            // Reset UI state for new question
            resetQuestionState()
            
            saveSession()
        } else {
            // Last question - complete the session
            completeSession()
        }
    }
    
    func previousQuestion() {
        guard var session = currentSession,
              canGoBack else { return }
        
        session.currentQuestionIndex -= 1
        currentSession = session
        
        resetQuestionState()
        saveSession()
    }
    
    func goToQuestion(_ index: Int) {
        guard var session = currentSession,
              index >= 0 && index < session.questions.count else { return }
        
        session.currentQuestionIndex = index
        currentSession = session
        
        resetQuestionState()
        saveSession()
    }
    
    private func resetQuestionState() {
        // Check if current question has an existing answer
        if let question = currentQuestion,
           let existingAnswer = currentSession?.answers[question.id] {
            selectedAnswer = existingAnswer
            hasAnsweredCurrentQuestion = true
        } else {
            selectedAnswer = nil
            hasAnsweredCurrentQuestion = false
        }
    }
    
    // MARK: - Timer Management
    private func startTimer() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    private func stopTimer() {
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    private func updateTimer() {
        guard isTimerRunning else { return }
        
        timeRemaining -= 1
        
        // Update session time
        if var session = currentSession {
            session.timeRemaining = timeRemaining
            currentSession = session
        }
        
        // Check for warnings
        checkTimeWarnings()
        
        // Auto-submit when time expires
        if timeRemaining <= 0 {
            if appViewModel.appSettings.autoSubmitOnTimeout {
                completeSession()
            } else {
                stopTimer()
                // Show manual submit prompt
            }
        }
    }
    
    private func checkTimeWarnings() {
        guard appViewModel.appSettings.timerWarnings else { return }
        
        switch timeWarningLevel {
        case .critical:
            if Int(timeRemaining) % 30 == 0 { // Every 30 seconds in critical
                appViewModel.playHapticFeedback(.warning)
                scheduleNotification(title: NSLocalizedString("time_critical", comment: "Time Critical"), body: NSLocalizedString("less_than_minute", comment: "Less than a minute remaining"))
            }
        case .warning:
            if timeRemaining == 300 { // 5 minutes
                appViewModel.playHapticFeedback(.warning)
                scheduleNotification(title: NSLocalizedString("time_warning", comment: "Time Warning"), body: "5" + " " + NSLocalizedString("minutes_remaining", comment: "minutes remaining"))
            }
        case .normal:
            break
        }
    }
    
    // MARK: - Session Persistence
    private func saveSession() {
        guard let session = currentSession else { return }
        if let data = try? JSONEncoder().encode(session) {
            UserDefaults.standard.set(data, forKey: "CurrentTestSession")
        }
    }
    
    private func clearSession() {
        UserDefaults.standard.removeObject(forKey: "CurrentTestSession")
        currentSession = nil
    }
    
    // MARK: - Utilities
    private func scheduleBatteryCheck() {
        // Check battery level every 5 minutes during test
        Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { [weak self] timer in
            guard self?.isActive == true else {
                timer.invalidate()
                return
            }
            let batteryLevel = UIDevice.current.batteryLevel
            if batteryLevel > 0 && batteryLevel < 0.20 { // Less than 20%
                self?.showLowBatteryWarning()
            }
        }
    }
    
    private func showLowBatteryWarning() {
        scheduleNotification(
            title: NSLocalizedString("low_battery_warning", comment: "Low Battery"),
            body: NSLocalizedString("low_battery_message", comment: "Battery warning message")
        )
    }
    
    private func scheduleNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Review Mode
    func getReviewData() -> ReviewData? {
        guard let session = currentSession else { return nil }
        
        var correctAnswers = 0
        var incorrectAnswers = 0
        var skippedAnswers = 0
        
        var reviewItems: [ReviewItem] = []
        
        for (index, question) in session.questions.enumerated() {
            let userAnswer = session.answers[question.id]
            let isCorrect = userAnswer == question.correctAnswer
            let wasSkipped = userAnswer == nil
            
            if wasSkipped {
                skippedAnswers += 1
            } else if isCorrect {
                correctAnswers += 1
            } else {
                incorrectAnswers += 1
            }
            
            reviewItems.append(ReviewItem(
                questionIndex: index,
                question: question,
                userAnswer: userAnswer,
                isCorrect: isCorrect,
                wasSkipped: wasSkipped
            ))
        }
        
        return ReviewData(
            items: reviewItems,
            correctCount: correctAnswers,
            incorrectCount: incorrectAnswers,
            skippedCount: skippedAnswers,
            totalCount: session.questions.count
        )
    }
}

// MARK: - Supporting Types

enum TimeWarningLevel {
    case normal
    case warning
    case critical
    
    var color: Color {
        switch self {
        case .normal:
            return AppTheme.Colors.sageGreen
        case .warning:
            return AppTheme.Colors.sunnyYellow
        case .critical:
            return AppTheme.Colors.softRed
        }
    }
}

struct ReviewData {
    let items: [ReviewItem]
    let correctCount: Int
    let incorrectCount: Int
    let skippedCount: Int
    let totalCount: Int
    
    var accuracy: Double {
        guard totalCount > 0 else { return 0 }
        return Double(correctCount) / Double(totalCount - skippedCount) * 100
    }
}

struct ReviewItem: Identifiable {
    let id = UUID()
    let questionIndex: Int
    let question: Question
    let userAnswer: Int?
    let isCorrect: Bool
    let wasSkipped: Bool
    
    var displayQuestionNumber: Int {
        return questionIndex + 1
    }
}
