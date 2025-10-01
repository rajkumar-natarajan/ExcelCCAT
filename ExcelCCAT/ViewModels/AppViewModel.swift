//
//  AppViewModel.swift
//  ExcelCCAT
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI
import Foundation
import UserNotifications
import CoreHaptics

@Observable
class AppViewModel {
    
    // MARK: - Published Properties
    var currentLanguage: Language = .english
    var selectedCCATLevel: CCATLevel = .level12
    var currentTestConfiguration: TestConfiguration = TestConfiguration(testType: .fullMock, level: .level12)
    var appSettings: AppSettings = AppSettings()
    var userProgress: UserProgress = UserProgress()
    var isFirstLaunch: Bool = true
    var showingOnboarding: Bool = false
    var currentTestSession: TestSession?
    var isTestInProgress: Bool = false
    var showingResults: Bool = false
    var lastTestResult: TestResult?
    
    // MARK: - Haptic Engine
    private var hapticEngine: CHHapticEngine?
    
    // MARK: - Initialization
    init() {
        loadUserData()
        setupHaptics()
        checkFirstLaunch()
        setupNotifications()
    }
    
    // MARK: - User Data Management
    func loadUserData() {
        loadSettings()
        loadProgress()
        loadSelectedLevel()
        updateLanguage()
    }
    
    private func loadSettings() {
        if let data = UserDefaults.standard.data(forKey: "AppSettings"),
           let settings = try? JSONDecoder().decode(AppSettings.self, from: data) {
            self.appSettings = settings
            self.currentLanguage = settings.language
        }
    }
    
    private func loadProgress() {
        if let data = UserDefaults.standard.data(forKey: "UserProgress"),
           let progress = try? JSONDecoder().decode(UserProgress.self, from: data) {
            self.userProgress = progress
        }
    }
    
    private func loadSelectedLevel() {
        let levelRawValue = UserDefaults.standard.string(forKey: "SelectedCCATLevel") ?? ""
        if !levelRawValue.isEmpty, let level = CCATLevel(rawValue: levelRawValue) {
            self.selectedCCATLevel = level
        }
    }
    
    func saveUserData() {
        saveSettings()
        saveProgress()
        saveSelectedLevel()
    }
    
    private func saveSettings() {
        if let data = try? JSONEncoder().encode(appSettings) {
            UserDefaults.standard.set(data, forKey: "AppSettings")
        }
    }
    
    private func saveProgress() {
        if let data = try? JSONEncoder().encode(userProgress) {
            UserDefaults.standard.set(data, forKey: "UserProgress")
        }
    }
    
    private func saveSelectedLevel() {
        UserDefaults.standard.set(selectedCCATLevel.rawValue, forKey: "SelectedCCATLevel")
    }
    
    // MARK: - CCAT Level Management
    func changeCCATLevel(to level: CCATLevel) {
        selectedCCATLevel = level
        // Update test configuration to match new level
        currentTestConfiguration = TestConfiguration(
            testType: currentTestConfiguration.testType,
            level: level
        )
        saveSelectedLevel()
    }
    
    // MARK: - Test Configuration Management
    func updateTestConfiguration(_ configuration: TestConfiguration) {
        currentTestConfiguration = configuration
        selectedCCATLevel = configuration.level
        saveSelectedLevel()
    }
    
    func setTestType(_ testType: TDSBTestType) {
        currentTestConfiguration = TestConfiguration(
            testType: testType,
            level: selectedCCATLevel
        )
    }
    
    func updateCustomTestParameters(questionCount: Int, timeLimit: Int, isTimedSession: Bool) {
        currentTestConfiguration = TestConfiguration(
            testType: .customTest,
            level: selectedCCATLevel,
            questionCount: questionCount,
            timeLimit: timeLimit,
            isTimedSession: isTimedSession
        )
    }
    
    // MARK: - Language Management
    func updateLanguage() {
        // Update the app's locale based on current language
        UserDefaults.standard.set([currentLanguage.rawValue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    
    func changeLanguage(to language: Language) {
        currentLanguage = language
        appSettings.language = language
        userProgress.preferredLanguage = language
        updateLanguage()
        saveUserData()
    }
    
    // MARK: - First Launch Management
    private func checkFirstLaunch() {
        isFirstLaunch = !UserDefaults.standard.bool(forKey: "HasLaunchedBefore")
        if isFirstLaunch {
            showingOnboarding = true
        }
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "HasLaunchedBefore")
        isFirstLaunch = false
        showingOnboarding = false
        saveUserData()
    }
    
    // MARK: - Test Session Management
    func startConfiguredTest(language: Language = .english) {
        let questions = QuestionDataManager.shared.getConfiguredQuestions(
            configuration: currentTestConfiguration,
            language: language
        )
        let shuffledQuestions = questions.shuffled()
        
        let timeInSeconds = currentTestConfiguration.isTimedSession ? 
            TimeInterval(currentTestConfiguration.timeLimit * 60) : 0
        
        currentTestSession = TestSession(
            questions: shuffledQuestions,
            sessionType: .fullMock,
            language: language,
            timeRemaining: timeInSeconds
        )
        
        isTestInProgress = true
        saveCurrentSession()
    }
    
    func startFullMockTest(language: Language = .english) {
        // Set to full mock configuration
        setTestType(.fullMock)
        startConfiguredTest(language: language)
    }
    
    func startPracticeSession(
        type: QuestionType,
        subType: String? = nil,
        difficulty: Difficulty? = nil,
        language: Language = .english,
        questionCount: Int = 50,
        isTimedSession: Bool = false
    ) {
        let questions = QuestionDataManager.shared.getPracticeQuestions(
            type: type,
            subType: subType,
            difficulty: difficulty,
            language: language,
            count: questionCount,
            level: selectedCCATLevel
        )
        
        let timeLimit: TimeInterval = isTimedSession ? TimeInterval(questionCount * 60) : 0 // 1 minute per question
        
        currentTestSession = TestSession(
            questions: questions,
            sessionType: .practice,
            language: language,
            timeRemaining: timeLimit
        )
        
        isTestInProgress = true
        saveCurrentSession()
    }
    
    func resumeSession() {
        if let sessionData = UserDefaults.standard.data(forKey: "CurrentTestSession"),
           let session = try? JSONDecoder().decode(TestSession.self, from: sessionData) {
            currentTestSession = session
            isTestInProgress = !session.isCompleted
        }
    }
    
    private func saveCurrentSession() {
        guard let session = currentTestSession else { return }
        if let data = try? JSONEncoder().encode(session) {
            UserDefaults.standard.set(data, forKey: "CurrentTestSession")
        }
    }
    
    func answerQuestion(questionId: UUID, selectedOption: Int) {
        guard var session = currentTestSession else { return }
        
        session.answers[questionId] = selectedOption
        currentTestSession = session
        
        // Provide haptic feedback
        if appSettings.isHapticsEnabled {
            playHapticFeedback(.selection)
        }
        
        saveCurrentSession()
    }
    
    func nextQuestion() {
        guard var session = currentTestSession else { return }
        
        if session.currentQuestionIndex < session.questions.count - 1 {
            session.currentQuestionIndex += 1
            currentTestSession = session
            saveCurrentSession()
        } else {
            completeTest()
        }
    }
    
    func previousQuestion() {
        guard var session = currentTestSession else { return }
        
        if session.currentQuestionIndex > 0 {
            session.currentQuestionIndex -= 1
            currentTestSession = session
            saveCurrentSession()
        }
    }
    
    func completeTest() {
        guard var session = currentTestSession else { return }
        
        session.isCompleted = true
        session.endTime = Date()
        currentTestSession = session
        
        if session.sessionType == .practice {
            // Build a practice result instead of a full test result
            let score = session.score
            let practiceResult = PracticeResult(
                questionType: .verbal, // Placeholder aggregate; could refine by dominant type
                subType: nil,
                language: session.language,
                level: session.level,
                date: Date(),
                score: score,
                totalQuestions: session.totalQuestions,
                timeSpent: Date().timeIntervalSince(session.startTime)
            )
            updateUserProgressWithPracticeResult(practiceResult)
        } else {
            let result = TestResult(session: session)
            lastTestResult = result
            updateUserProgressWithTestResult(result)
        }
        
        // Clear current session
        UserDefaults.standard.removeObject(forKey: "CurrentTestSession")
        isTestInProgress = false
        showingResults = true
        
        // Play completion haptic
        if appSettings.isHapticsEnabled {
            playHapticFeedback(.success)
        }
        
        saveUserData()
    }
    
    func exitTest() {
        currentTestSession = nil
        isTestInProgress = false
        UserDefaults.standard.removeObject(forKey: "CurrentTestSession")
    }
    
    // MARK: - Progress Tracking
    private func updateUserProgressWithTestResult(_ result: TestResult) {
        userProgress.totalTestsTaken += 1
        userProgress.totalQuestionsAnswered += result.totalQuestions
        userProgress.totalCorrectAnswers += result.score
        
        // Update best score
        if result.percentageScore > userProgress.bestScore {
            userProgress.bestScore = result.percentageScore
        }
        
        // Update streak
        let calendar = Calendar.current
        if calendar.isDateInToday(userProgress.lastActiveDate) {
            // Same day, don't change streak
        } else if calendar.isDateInYesterday(userProgress.lastActiveDate) {
            userProgress.currentStreak += 1
        } else {
            userProgress.currentStreak = 1
        }
        
        if userProgress.currentStreak > userProgress.longestStreak {
            userProgress.longestStreak = userProgress.currentStreak
        }
        
        userProgress.lastActiveDate = Date()
        userProgress.testHistory.append(result)
        
        // Update weekly progress
        updateWeeklyProgress(questionsAnswered: result.totalQuestions)
    }
    
    func updateUserProgressWithPracticeResult(_ result: PracticeResult) {
        userProgress.totalQuestionsAnswered += result.totalQuestions
        userProgress.totalCorrectAnswers += result.score
        
        // Update streak for practice sessions
        let calendar = Calendar.current
        if calendar.isDateInToday(userProgress.lastActiveDate) {
            // Same day, don't change streak
        } else if calendar.isDateInYesterday(userProgress.lastActiveDate) {
            userProgress.currentStreak += 1
        } else {
            userProgress.currentStreak = 1
        }
        
        if userProgress.currentStreak > userProgress.longestStreak {
            userProgress.longestStreak = userProgress.currentStreak
        }
        
        userProgress.lastActiveDate = Date()
        userProgress.practiceHistory.append(result)
        
        // Update weekly progress
        updateWeeklyProgress(questionsAnswered: result.totalQuestions)
        
        saveUserData()
    }
    
    private func updateWeeklyProgress(questionsAnswered: Int) {
        let calendar = Calendar.current
        let now = Date()
        let weekOfYear = calendar.component(.weekOfYear, from: now)
        let savedWeek = calendar.component(.weekOfYear, from: userProgress.lastActiveDate)
        
        if weekOfYear != savedWeek {
            // New week, reset count
            userProgress.questionsThisWeek = questionsAnswered
        } else {
            // Same week, add to count
            userProgress.questionsThisWeek += questionsAnswered
        }
    }
    
    // MARK: - Settings Management
    func updateSetting<T>(_ keyPath: WritableKeyPath<AppSettings, T>, value: T) {
        appSettings[keyPath: keyPath] = value
        
        // Handle special settings
        if keyPath == \.language {
            if let language = value as? Language {
                changeLanguage(to: language)
            }
        }
        
        saveSettings()
    }
    
    func resetAllProgress() {
        userProgress = UserProgress()
        UserDefaults.standard.removeObject(forKey: "UserProgress")
        UserDefaults.standard.removeObject(forKey: "CurrentTestSession")
        currentTestSession = nil
        isTestInProgress = false
        showingResults = false
        lastTestResult = nil
    }
    
    func updateWeeklyGoal(_ goal: Int) {
        userProgress.weeklyGoal = goal
        saveUserData()
    }
    
    // MARK: - Haptic Feedback
    private func setupHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("Failed to start haptic engine: \(error)")
        }
    }
    
    func playHapticFeedback(_ type: HapticFeedbackType) {
        guard appSettings.isHapticsEnabled else { return }
        
        switch type {
        case .selection:
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        case .success:
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.success)
        case .error:
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.error)
        case .warning:
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.warning)
        }
    }
    
    // MARK: - Notifications
    private func setupNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            }
        }
    }
    
    func scheduleStudyReminder() {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("study_reminder_title", comment: "Study Reminder")
        content.body = NSLocalizedString("study_reminder_body", comment: "Don't forget to practice for the CCAT test today!")
        content.sound = .default
        
        // Schedule for 6 PM daily
        var dateComponents = DateComponents()
        dateComponents.hour = 18
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily_study_reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Data Export
    func exportProgressReport() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        var report = """
        CCAT Prep Progress Report
        Generated: \(dateFormatter.string(from: Date()))
        Language: \(currentLanguage.displayName)
        
        OVERALL STATISTICS
        • Total Tests Taken: \(userProgress.totalTestsTaken)
        • Total Questions Answered: \(userProgress.totalQuestionsAnswered)
        • Total Correct Answers: \(userProgress.totalCorrectAnswers)
        • Overall Accuracy: \(String(format: "%.1f", userProgress.accuracy))%
        • Average Score: \(String(format: "%.1f", userProgress.averageScore))%
        • Best Score: \(String(format: "%.1f", userProgress.bestScore))%
        • Current Streak: \(userProgress.currentStreak) days
        • Longest Streak: \(userProgress.longestStreak) days
        
        RECENT TEST HISTORY
        """
        
        let recentTests = userProgress.testHistory.suffix(5)
        for test in recentTests {
            report += "\n• \(dateFormatter.string(from: test.date)): \(String(format: "%.1f", test.percentageScore))% (\(test.sessionType.displayName))"
        }
        
        return report
    }
}

// MARK: - Haptic Feedback Types
enum HapticFeedbackType {
    case selection
    case success
    case error
    case warning
}

// MARK: - Notification Names
extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
    static let testCompleted = Notification.Name("testCompleted")
    static let settingsChanged = Notification.Name("settingsChanged")
}
