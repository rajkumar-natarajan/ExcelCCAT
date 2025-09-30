//
//  HomeView.swift
//  ExcelCCAT
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

struct HomeView: View {
    @Environment(AppViewModel.self) private var appViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var showingMoodPicker = false
    @State private var selectedMood: Mood = .neutral
    @State private var isAnimating = false
    @State private var showingCustomTestConfig = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    // Welcome Header
                    welcomeHeader
                    
                    // Level Selection
                    levelSelectionSection
                    
                    // Test Configuration
                    testConfigurationSection
                    
                    // Stats Overview
                    statsOverview
                    
                    // Main Action
                    mainActionSection
                    
                    // Quick Practice Categories
                    quickPracticeSection
                    
                    // Recent Activity
                    recentActivitySection
                    
                    // Motivational Section
                    motivationalSection
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.bottom, AppTheme.Spacing.xl)
            }
            .background(colorScheme == .dark ? AppTheme.Colors.darkBackground : AppTheme.Colors.offWhite)
            .navigationTitle("")
            .navigationBarHidden(true)
            .refreshable {
                // Refresh user data
                appViewModel.loadUserData()
            }
        }
        .onAppear {
            withAnimation(AppTheme.Animation.smooth.delay(0.3)) {
                isAnimating = true
            }
        }
        .sheet(isPresented: $showingCustomTestConfig) {
            CustomTestConfigView()
                .environment(appViewModel)
        }
    }
    
    // MARK: - Welcome Header
    
    private var welcomeHeader: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(timeBasedGreeting)
                        .font(AppTheme.Typography.title3)
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.8) : AppTheme.Colors.softGray)
                    
                    Text(NSLocalizedString("welcome_message", comment: ""))
                        .font(AppTheme.Typography.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
                }
                
                Spacer()
                
                // Language indicator and mood picker
                VStack(spacing: AppTheme.Spacing.xs) {
                    Text(appViewModel.currentLanguage.flag)
                        .font(.title)
                    
                    Button(action: { showingMoodPicker.toggle() }) {
                        Text(selectedMood.emoji)
                            .font(.title2)
                            .scaleEffect(isAnimating ? 1.0 : 0.5)
                            .animation(AppTheme.Animation.bounce.delay(0.5), value: isAnimating)
                    }
                }
            }
            .padding(.top, AppTheme.Spacing.lg)
        }
        .opacity(isAnimating ? 1.0 : 0.0)
        .offset(y: isAnimating ? 0 : -20)
        .animation(AppTheme.Animation.smooth, value: isAnimating)
    }
    
    // MARK: - Stats Overview
    
    private var statsOverview: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            StatCard(
                title: NSLocalizedString("current_streak", comment: ""),
                value: "\(appViewModel.userProgress.currentStreak)",
                subtitle: NSLocalizedString("days", comment: ""),
                color: AppTheme.Colors.sageGreen,
                icon: "flame.fill"
            )
            
            StatCard(
                title: NSLocalizedString("best_score", comment: ""),
                value: "\(Int(appViewModel.userProgress.bestScore))%",
                subtitle: "",
                color: AppTheme.Colors.sunnyYellow,
                icon: "star.fill"
            )
            
            StatCard(
                title: NSLocalizedString("total_tests", comment: ""),
                value: "\(appViewModel.userProgress.totalTestsTaken)",
                subtitle: NSLocalizedString("completed", comment: ""),
                color: AppTheme.Colors.skyBlue,
                icon: "checkmark.circle.fill"
            )
        }
        .opacity(isAnimating ? 1.0 : 0.0)
        .offset(y: isAnimating ? 0 : 30)
        .animation(AppTheme.Animation.smooth.delay(0.2), value: isAnimating)
    }
    
    // MARK: - Level Selection Section
    
    private var levelSelectionSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("Test Level")
                .font(AppTheme.Typography.headline)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
            
            HStack(spacing: AppTheme.Spacing.sm) {
                ForEach([CCATLevel.level10, CCATLevel.level11, CCATLevel.level12], id: \.self) { level in
                    levelButton(for: level)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                .fill(colorScheme == .dark ? AppTheme.Colors.softGray : Color.white)
                .shadow(
                    color: AppTheme.Colors.lightGray.opacity(0.3),
                    radius: 4,
                    x: 0,
                    y: 2
                )
        )
        .opacity(isAnimating ? 1.0 : 0.0)
        .offset(y: isAnimating ? 0 : 20)
        .animation(AppTheme.Animation.smooth.delay(0.1), value: isAnimating)
    }
    
    private func levelButton(for level: CCATLevel) -> some View {
        Button(action: {
            appViewModel.changeCCATLevel(to: level)
        }) {
            VStack(spacing: AppTheme.Spacing.xs) {
                Text(level.displayName)
                    .font(AppTheme.Typography.caption)
                    .fontWeight(.medium)
                
                Text(level.targetGrades)
                    .font(AppTheme.Typography.caption)
                    .opacity(0.8)
            }
            .padding(.horizontal, AppTheme.Spacing.sm)
            .padding(.vertical, AppTheme.Spacing.xs)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(appViewModel.selectedCCATLevel == level ? 
                          AppTheme.Colors.skyBlue : 
                          (colorScheme == .dark ? AppTheme.Colors.softGray : Color.white))
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .stroke(appViewModel.selectedCCATLevel == level ? 
                            AppTheme.Colors.skyBlue : 
                            AppTheme.Colors.lightGray, lineWidth: 1)
            )
            .foregroundColor(appViewModel.selectedCCATLevel == level ? 
                            .white : 
                            (colorScheme == .dark ? .white : AppTheme.Colors.softGray))
        }
    }
    
    // MARK: - Test Configuration Section
    
    private var testConfigurationSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("Test Type (TDSB Standards)")
                .font(AppTheme.Typography.headline)
                .foregroundColor(colorScheme == .dark ? .white : AppTheme.Colors.softGray)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: AppTheme.Spacing.xs), count: 2), spacing: AppTheme.Spacing.xs) {
                ForEach(TDSBTestType.allCases, id: \.self) { testType in
                    testTypeButton(for: testType)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                .fill(colorScheme == .dark ? AppTheme.Colors.softGray : Color.white)
                .shadow(
                    color: AppTheme.Colors.lightGray.opacity(0.3),
                    radius: 4,
                    x: 0,
                    y: 2
                )
        )
        .opacity(isAnimating ? 1.0 : 0.0)
        .offset(y: isAnimating ? 0 : 20)
        .animation(AppTheme.Animation.smooth.delay(0.15), value: isAnimating)
    }
    
    private func testTypeButton(for testType: TDSBTestType) -> some View {
        Button(action: {
            if testType == .customTest {
                showingCustomTestConfig = true
            } else {
                appViewModel.setTestType(testType)
            }
        }) {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(testType.displayName)
                    .font(AppTheme.Typography.caption)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                
                Text(testType.description)
                    .font(AppTheme.Typography.footnote)
                    .opacity(0.8)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, AppTheme.Spacing.sm)
            .padding(.vertical, AppTheme.Spacing.xs)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
                    .fill(appViewModel.currentTestConfiguration.testType == testType ? 
                          AppTheme.Colors.sageGreen : 
                          (colorScheme == .dark ? AppTheme.Colors.mediumGray : AppTheme.Colors.lightGray))
            )
            .foregroundColor(appViewModel.currentTestConfiguration.testType == testType ? 
                            .white : 
                            (colorScheme == .dark ? .white : AppTheme.Colors.softGray))
        }
    }
    
    // MARK: - Main Action Section
    
    private var mainActionSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            // Progress Ring
            ZStack {
                ProgressRingStyle(
                    progress: appViewModel.userProgress.weeklyProgress,
                    size: 120,
                    lineWidth: 12,
                    color: AppTheme.Colors.skyBlue
                )
                
                VStack(spacing: AppTheme.Spacing.xs) {
                    Text("\(appViewModel.userProgress.questionsThisWeek)")
                        .font(AppTheme.Typography.title2)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.Colors.skyBlue)
                    
                    Text("/ \(appViewModel.userProgress.weeklyGoal)")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.7) : AppTheme.Colors.softGray.opacity(0.7))
                }
            }
            .scaleEffect(isAnimating ? 1.0 : 0.8)
            .opacity(isAnimating ? 1.0 : 0.0)
            .animation(AppTheme.Animation.bounce.delay(0.4), value: isAnimating)
            
            // Main CTA Button
            Button(action: startFullMock) {
                HStack(spacing: AppTheme.Spacing.md) {
                    Image(systemName: "play.circle.fill")
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                        Text(NSLocalizedString("start_full_mock", comment: ""))
                            .font(AppTheme.Typography.headline)
                            .fontWeight(.semibold)
                        
                        Text("\(appViewModel.currentTestConfiguration.displayDescription)")
                            .font(AppTheme.Typography.caption)
                            .opacity(0.9)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.callout)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding(AppTheme.Spacing.lg)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                        .fill(appViewModel.currentLanguage == .french ? AppTheme.Colors.frenchModeGradient : AppTheme.Colors.primaryGradient)
                )
                .shadow(color: AppTheme.Shadows.buttonShadow, radius: 8, x: 0, y: 4)
            }
            .scaleEffect(isAnimating ? 1.0 : 0.9)
            .opacity(isAnimating ? 1.0 : 0.0)
            .animation(AppTheme.Animation.bounce.delay(0.6), value: isAnimating)
        }
        .cardStyle()
    }
    
    // MARK: - Quick Practice Section
    
    private var quickPracticeSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text(NSLocalizedString("practice_mode", comment: ""))
                .font(AppTheme.Typography.headline)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: AppTheme.Spacing.sm), count: 2), spacing: AppTheme.Spacing.sm) {
                ForEach(QuestionType.allCases, id: \.self) { type in
                    QuickPracticeCard(
                        type: type,
                        icon: type.icon,
                        color: type.color,
                        questionCount: QuestionDataManager.shared.getQuestionsByType(type, count: Int.max).count,
                        action: {
                            appViewModel.playHapticFeedback(.selection)
                            appViewModel.startPracticeSession(
                                type: type,
                                language: appViewModel.currentLanguage,
                                questionCount: 20,
                                isTimedSession: false
                            )
                        }
                    )
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .offset(y: isAnimating ? 0 : 20)
                        .animation(
                            AppTheme.Animation.smooth.delay(0.8 + Double(QuestionType.allCases.firstIndex(of: type) ?? 0) * 0.1),
                            value: isAnimating
                        )
                }
            }
        }
    }
    
    // MARK: - Recent Activity
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack {
                Text(NSLocalizedString("recent_activity", comment: "Recent Activity"))
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
                
                Spacer()
                
                NavigationLink(destination: ProgressView()) {
                    Text(NSLocalizedString("view_all", comment: "View All"))
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.skyBlue)
                }
            }
            
            if appViewModel.userProgress.testHistory.isEmpty {
                EmptyStateView(
                    icon: "brain.head.profile",
                    title: NSLocalizedString("no_tests_yet", comment: "No tests taken yet"),
                    subtitle: NSLocalizedString("start_first_test", comment: "Take your first test to see results here")
                )
            } else {
                VStack(spacing: AppTheme.Spacing.sm) {
                    ForEach(appViewModel.userProgress.testHistory.suffix(3).reversed(), id: \.id) { result in
                        RecentActivityRow(result: result)
                    }
                }
            }
        }
        .cardStyle()
        .opacity(isAnimating ? 1.0 : 0.0)
        .offset(y: isAnimating ? 0 : 30)
        .animation(AppTheme.Animation.smooth.delay(1.0), value: isAnimating)
    }
    
    // MARK: - Motivational Section
    
    private var motivationalSection: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            if appViewModel.userProgress.currentStreak >= 5 {
                MotivationalCard(
                    type: .achievement,
                    title: NSLocalizedString("streak_achievement", comment: "Great Streak!"),
                    message: NSLocalizedString("streak_message", comment: "You're on fire! Keep up the great work."),
                    color: AppTheme.Colors.sageGreen
                )
            } else if appViewModel.userProgress.bestScore >= 85 {
                MotivationalCard(
                    type: .gifted,
                    title: NSLocalizedString("gifted_range_title", comment: "Gifted Range"),
                    message: NSLocalizedString("gifted_range_message", comment: "You're performing in the gifted range!"),
                    color: AppTheme.Colors.sunnyYellow
                )
            } else {
                MotivationalCard(
                    type: .encouragement,
                    title: NSLocalizedString("keep_practicing", comment: "Keep Practicing"),
                    message: getEncouragementMessage(),
                    color: AppTheme.Colors.skyBlue
                )
            }
        }
        .opacity(isAnimating ? 1.0 : 0.0)
        .offset(y: isAnimating ? 0 : 20)
        .animation(AppTheme.Animation.smooth.delay(1.2), value: isAnimating)
    }
    
    // MARK: - Helper Methods
    
    private var timeBasedGreeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return NSLocalizedString("good_morning", comment: "Good morning")
        case 12..<17:
            return NSLocalizedString("good_afternoon", comment: "Good afternoon")
        default:
            return NSLocalizedString("good_evening", comment: "Good evening")
        }
    }
    
    private func getEncouragementMessage() -> String {
        let accuracy = appViewModel.userProgress.accuracy
        
        if accuracy < 50 {
            return NSLocalizedString("focus_on_basics", comment: "Focus on understanding the basic patterns")
        } else if accuracy < 70 {
            return NSLocalizedString("good_progress", comment: "You're making good progress!")
        } else {
            return NSLocalizedString("almost_there", comment: "You're almost in the gifted range!")
        }
    }
    
    private func startFullMock() {
        appViewModel.playHapticFeedback(.selection)
        appViewModel.startFullMockTest(language: appViewModel.currentLanguage)
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    let icon: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title3)
                
                Spacer()
            }
            
            Text(value)
                .font(AppTheme.Typography.title2)
                .fontWeight(.bold)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(title)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.7) : AppTheme.Colors.softGray.opacity(0.7))
                
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(color)
                }
            }
        }
        .padding(AppTheme.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(colorScheme == .dark ? AppTheme.Colors.darkSurface : Color.white)
                .shadow(color: AppTheme.Shadows.light, radius: 2, x: 0, y: 1)
        )
    }
}

struct RecentActivityRow: View {
    let result: TestResult
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            // Test Type Icon
            Image(systemName: result.sessionType.icon)
                .foregroundColor(result.sessionType.color)
                .font(.title3)
                .frame(width: 30)
            
            // Test Info
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(result.sessionType.displayName)
                    .font(AppTheme.Typography.callout)
                    .fontWeight(.medium)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
                
                Text(formatDate(result.date))
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.6) : AppTheme.Colors.softGray.opacity(0.6))
            }
            
            Spacer()
            
            // Score
            Text("\(Int(result.percentageScore))%")
                .font(AppTheme.Typography.callout)
                .fontWeight(.semibold)
                .foregroundColor(result.giftedRange ? AppTheme.Colors.sageGreen : AppTheme.Colors.skyBlue)
        }
        .padding(.vertical, AppTheme.Spacing.xs)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct MotivationalCard: View {
    let type: MotivationType
    let title: String
    let message: String
    let color: Color
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: type.icon)
                .foregroundColor(color)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(title)
                    .font(AppTheme.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
                
                Text(message)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.7) : AppTheme.Colors.softGray.opacity(0.7))
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(AppTheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.4) : AppTheme.Colors.softGray.opacity(0.4))
            
            VStack(spacing: AppTheme.Spacing.xs) {
                Text(title)
                    .font(AppTheme.Typography.callout)
                    .fontWeight(.medium)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.7) : AppTheme.Colors.softGray.opacity(0.7))
                
                Text(subtitle)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.5) : AppTheme.Colors.softGray.opacity(0.5))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(AppTheme.Spacing.xl)
    }
}

// MARK: - Supporting Types

enum Mood: String, CaseIterable {
    case happy = "😊"
    case neutral = "😐"
    case sad = "😟"
    case excited = "🤩"
    case focused = "🧐"
    
    var emoji: String {
        return rawValue
    }
}

enum MotivationType {
    case achievement
    case gifted
    case encouragement
    
    var icon: String {
        switch self {
        case .achievement:
            return "trophy.fill"
        case .gifted:
            return "star.circle.fill"
        case .encouragement:
            return "heart.fill"
        }
    }
}

#Preview {
    HomeView()
        .environment(AppViewModel())
}
