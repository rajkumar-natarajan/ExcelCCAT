//
//  HomeView.swift
//  ExcelCCAT
//
//  Modern UI Redesign - December 15, 2025
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
            ZStack {
                // Modern background gradient
                backgroundGradient
                
                ScrollView {
                    VStack(spacing: AppTheme.Spacing.sectionSpacing) {
                        // Welcome Header
                        welcomeHeader
                        
                        // Stats Overview (Modern Cards)
                        statsOverview
                        
                        // Level Selection
                        levelSelectionSection
                        
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
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .refreshable {
                appViewModel.loadUserData()
            }
        }
        .onAppear {
            withAnimation(AppTheme.Animation.smooth.delay(0.2)) {
                isAnimating = true
            }
        }
        .sheet(isPresented: $showingCustomTestConfig) {
            CustomTestConfigView()
                .environment(appViewModel)
        }
    }
    
    // MARK: - Background Gradient
    
    private var backgroundGradient: some View {
        Group {
            if colorScheme == .dark {
                LinearGradient(
                    colors: [
                        AppTheme.Colors.slate900,
                        Color(hex: "1E1B4B").opacity(0.8)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            } else {
                LinearGradient(
                    colors: [
                        AppTheme.Colors.slate50,
                        Color(hex: "EEF2FF")
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Welcome Header
    
    private var welcomeHeader: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(timeBasedGreeting)
                        .font(AppTheme.Typography.callout)
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.slate400 : AppTheme.Colors.slate500)
                    
                    Text(NSLocalizedString("welcome_message", comment: ""))
                        .font(AppTheme.Typography.title)
                        .fontWeight(.bold)
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.slate900)
                }
                
                Spacer()
                
                // Language & Mood
                HStack(spacing: AppTheme.Spacing.sm) {
                    // Language indicator
                    Text(appViewModel.currentLanguage.flag)
                        .font(.title)
                        .padding(AppTheme.Spacing.sm)
                        .background(
                            Circle()
                                .fill(colorScheme == .dark ? AppTheme.Colors.slate800 : Color.white)
                                .shadow(color: AppTheme.Shadows.soft, radius: 8, x: 0, y: 4)
                        )
                    
                    // Mood picker
                    Button(action: { showingMoodPicker.toggle() }) {
                        Text(selectedMood.emoji)
                            .font(.title2)
                            .padding(AppTheme.Spacing.sm)
                            .background(
                                Circle()
                                    .fill(colorScheme == .dark ? AppTheme.Colors.slate800 : Color.white)
                                    .shadow(color: AppTheme.Shadows.soft, radius: 8, x: 0, y: 4)
                            )
                    }
                    .scaleEffect(isAnimating ? 1.0 : 0.5)
                    .animation(AppTheme.Animation.bounce.delay(0.5), value: isAnimating)
                }
            }
            .padding(.top, AppTheme.Spacing.lg)
        }
        .opacity(isAnimating ? 1.0 : 0.0)
        .offset(y: isAnimating ? 0 : -20)
        .animation(AppTheme.Animation.smooth, value: isAnimating)
    }
    
    // MARK: - Stats Overview (Modern Design)
    
    private var statsOverview: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            ModernStatCard(
                title: NSLocalizedString("current_streak", comment: ""),
                value: "\(appViewModel.userProgress.currentStreak)",
                subtitle: NSLocalizedString("days", comment: ""),
                icon: "flame.fill",
                gradient: LinearGradient(
                    colors: [Color(hex: "F97316"), Color(hex: "FB923C")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            ModernStatCard(
                title: NSLocalizedString("best_score", comment: ""),
                value: "\(Int(appViewModel.userProgress.bestScore))%",
                subtitle: "",
                icon: "star.fill",
                gradient: LinearGradient(
                    colors: [AppTheme.Colors.accentAmber, Color(hex: "FCD34D")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            ModernStatCard(
                title: NSLocalizedString("total_tests", comment: ""),
                value: "\(appViewModel.userProgress.totalTestsTaken)",
                subtitle: NSLocalizedString("completed", comment: ""),
                icon: "checkmark.circle.fill",
                gradient: LinearGradient(
                    colors: [AppTheme.Colors.accentEmerald, Color(hex: "34D399")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        .opacity(isAnimating ? 1.0 : 0.0)
        .offset(y: isAnimating ? 0 : 30)
        .animation(AppTheme.Animation.stagger.delay(0.2), value: isAnimating)
    }
    
    // MARK: - Level Selection Section
    
    private var levelSelectionSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Test Level")
                .font(AppTheme.Typography.headline)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.slate900)
            
            HStack(spacing: AppTheme.Spacing.sm) {
                ForEach([CCATLevel.level10, CCATLevel.level11, CCATLevel.level12], id: \.self) { level in
                    ModernLevelButton(
                        level: level,
                        isSelected: appViewModel.selectedCCATLevel == level,
                        action: { appViewModel.changeCCATLevel(to: level) }
                    )
                }
            }
        }
        .padding(AppTheme.Spacing.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                .fill(colorScheme == .dark ? AppTheme.Colors.slate800.opacity(0.8) : Color.white.opacity(0.9))
                .shadow(color: AppTheme.Shadows.medium, radius: 10, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                .stroke(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.05), lineWidth: 1)
        )
        .opacity(isAnimating ? 1.0 : 0.0)
        .offset(y: isAnimating ? 0 : 20)
        .animation(AppTheme.Animation.stagger.delay(0.3), value: isAnimating)
    }
    
    // MARK: - Main Action Section (Modern Design)
    
    private var mainActionSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            // Modern Progress Ring
            ZStack {
                ProgressRingStyle(
                    progress: appViewModel.userProgress.weeklyProgress,
                    size: 140,
                    lineWidth: 14,
                    color: AppTheme.Colors.primaryIndigo,
                    showGlow: true
                )
                
                VStack(spacing: AppTheme.Spacing.xs) {
                    Text("\(appViewModel.userProgress.questionsThisWeek)")
                        .font(AppTheme.Typography.statNumber)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.Colors.primaryIndigo)
                    
                    Text("/ \(appViewModel.userProgress.weeklyGoal)")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.slate400 : AppTheme.Colors.slate500)
                }
            }
            .scaleEffect(isAnimating ? 1.0 : 0.8)
            .opacity(isAnimating ? 1.0 : 0.0)
            .animation(AppTheme.Animation.bounce.delay(0.4), value: isAnimating)
            
            // Modern CTA Button
            Button(action: startFullMock) {
                HStack(spacing: AppTheme.Spacing.md) {
                    // Animated play icon
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "play.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xxs) {
                        Text(NSLocalizedString("start_full_mock", comment: ""))
                            .font(AppTheme.Typography.headline)
                            .fontWeight(.bold)
                        
                        Text("\(appViewModel.currentTestConfiguration.displayDescription)")
                            .font(AppTheme.Typography.caption)
                            .opacity(0.85)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding(AppTheme.Spacing.lg)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                        .fill(appViewModel.currentLanguage == .french ?
                              AppTheme.Colors.frenchModeGradient :
                              AppTheme.Colors.primaryGradient)
                )
                .shadow(color: AppTheme.Shadows.indigoShadow, radius: 16, x: 0, y: 8)
            }
            .scaleEffect(isAnimating ? 1.0 : 0.9)
            .opacity(isAnimating ? 1.0 : 0.0)
            .animation(AppTheme.Animation.bounce.delay(0.5), value: isAnimating)
        }
        .padding(AppTheme.Spacing.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                .fill(colorScheme == .dark ? AppTheme.Colors.slate800.opacity(0.8) : Color.white.opacity(0.9))
                .shadow(color: AppTheme.Shadows.medium, radius: 10, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                .stroke(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.05), lineWidth: 1)
        )
    }
    
    // MARK: - Quick Practice Section (Modern Design)
    
    private var quickPracticeSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text(NSLocalizedString("practice_mode", comment: ""))
                .font(AppTheme.Typography.headline)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.slate900)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: AppTheme.Spacing.md), count: 2), spacing: AppTheme.Spacing.md) {
                ForEach(QuestionType.allCases, id: \.self) { type in
                    ModernPracticeCard(
                        type: type,
                        icon: type.icon,
                        color: modernColor(for: type),
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
                        AppTheme.Animation.stagger.delay(0.6 + Double(QuestionType.allCases.firstIndex(of: type) ?? 0) * 0.1),
                        value: isAnimating
                    )
                }
            }
        }
        .opacity(isAnimating ? 1.0 : 0.0)
        .animation(AppTheme.Animation.smooth.delay(0.5), value: isAnimating)
    }
    
    private func modernColor(for type: QuestionType) -> Color {
        switch type {
        case .verbal: return AppTheme.Colors.primaryPurple
        case .quantitative: return AppTheme.Colors.primaryCyan
        case .nonVerbal: return AppTheme.Colors.accentRose
        }
    }
    
    // MARK: - Recent Activity (Modern Design)
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack {
                Text(NSLocalizedString("recent_activity", comment: "Recent Activity"))
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.slate900)
                
                Spacer()
                
                NavigationLink(destination: ProgressView()) {
                    HStack(spacing: AppTheme.Spacing.xs) {
                        Text(NSLocalizedString("view_all", comment: "View All"))
                            .font(AppTheme.Typography.caption)
                        Image(systemName: "arrow.right")
                            .font(.caption)
                    }
                    .foregroundColor(AppTheme.Colors.primaryIndigo)
                }
            }
            
            if appViewModel.userProgress.testHistory.isEmpty {
                ModernEmptyStateView(
                    icon: "brain.head.profile",
                    title: NSLocalizedString("no_tests_yet", comment: "No tests taken yet"),
                    subtitle: NSLocalizedString("start_first_test", comment: "Take your first test to see results here")
                )
            } else {
                VStack(spacing: AppTheme.Spacing.sm) {
                    ForEach(appViewModel.userProgress.testHistory.suffix(3).reversed(), id: \.id) { result in
                        ModernActivityRow(result: result)
                    }
                }
            }
        }
        .padding(AppTheme.Spacing.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                .fill(colorScheme == .dark ? AppTheme.Colors.slate800.opacity(0.8) : Color.white.opacity(0.9))
                .shadow(color: AppTheme.Shadows.medium, radius: 10, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                .stroke(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.05), lineWidth: 1)
        )
        .opacity(isAnimating ? 1.0 : 0.0)
        .offset(y: isAnimating ? 0 : 30)
        .animation(AppTheme.Animation.stagger.delay(0.7), value: isAnimating)
    }
    
    // MARK: - Motivational Section (Modern Design)
    
    private var motivationalSection: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            if appViewModel.userProgress.currentStreak >= 5 {
                ModernMotivationalCard(
                    type: .achievement,
                    title: NSLocalizedString("streak_achievement", comment: "Great Streak!"),
                    message: NSLocalizedString("streak_message", comment: "You're on fire! Keep up the great work."),
                    gradient: LinearGradient(colors: [Color(hex: "F97316"), Color(hex: "FB923C")], startPoint: .leading, endPoint: .trailing)
                )
            } else if appViewModel.userProgress.bestScore >= 85 {
                ModernMotivationalCard(
                    type: .gifted,
                    title: NSLocalizedString("gifted_range_title", comment: "Gifted Range"),
                    message: NSLocalizedString("gifted_range_message", comment: "You're performing in the gifted range!"),
                    gradient: LinearGradient(colors: [AppTheme.Colors.accentAmber, Color(hex: "FCD34D")], startPoint: .leading, endPoint: .trailing)
                )
            } else {
                ModernMotivationalCard(
                    type: .encouragement,
                    title: NSLocalizedString("keep_practicing", comment: "Keep Practicing"),
                    message: getEncouragementMessage(),
                    gradient: AppTheme.Colors.primaryGradient
                )
            }
        }
        .opacity(isAnimating ? 1.0 : 0.0)
        .offset(y: isAnimating ? 0 : 20)
        .animation(AppTheme.Animation.stagger.delay(0.8), value: isAnimating)
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
        print("🔥 BUTTON DEBUG: Full Mock button clicked!")
        print("🔥 BUTTON DEBUG: Current language: \(appViewModel.currentLanguage)")
        print("🔥 BUTTON DEBUG: Current test configuration before click: \(appViewModel.currentTestConfiguration)")
        
        appViewModel.playHapticFeedback(.selection)
        appViewModel.startFullMockTest(language: appViewModel.currentLanguage)
        
        print("🔥 BUTTON DEBUG: startFullMockTest called successfully")
    }
}

// MARK: - Modern Supporting Views

struct ModernStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let gradient: LinearGradient
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            // Icon with gradient background
            ZStack {
                Circle()
                    .fill(gradient)
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))
            }
            
            Text(value)
                .font(AppTheme.Typography.title2)
                .fontWeight(.bold)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.slate900)
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xxs) {
                Text(title)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.slate400 : AppTheme.Colors.slate500)
                
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(AppTheme.Typography.caption2)
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.slate500 : AppTheme.Colors.slate400)
                }
            }
        }
        .padding(AppTheme.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(colorScheme == .dark ? AppTheme.Colors.slate800.opacity(0.8) : Color.white.opacity(0.9))
                .shadow(color: AppTheme.Shadows.soft, radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .stroke(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.05), lineWidth: 1)
        )
    }
}

struct ModernLevelButton: View {
    let level: CCATLevel
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppTheme.Spacing.xs) {
                Text(level.displayName)
                    .font(AppTheme.Typography.caption)
                    .fontWeight(.semibold)
                
                Text(level.targetGrades)
                    .font(AppTheme.Typography.caption2)
                    .opacity(0.8)
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.vertical, AppTheme.Spacing.sm)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(isSelected ?
                          AppTheme.Colors.primaryGradient :
                          LinearGradient(colors: [colorScheme == .dark ? AppTheme.Colors.slate700 : AppTheme.Colors.slate100], startPoint: .leading, endPoint: .trailing))
            )
            .foregroundColor(isSelected ? .white : (colorScheme == .dark ? AppTheme.Colors.slate300 : AppTheme.Colors.slate600))
            .shadow(color: isSelected ? AppTheme.Shadows.indigoShadow : .clear, radius: 6, x: 0, y: 3)
        }
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(AppTheme.Animation.scale, value: isSelected)
    }
}

struct ModernPracticeCard: View {
    let type: QuestionType
    let icon: String
    let color: Color
    let questionCount: Int
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppTheme.Spacing.md) {
                // Icon with colored background
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(color)
                }
                
                VStack(spacing: AppTheme.Spacing.xs) {
                    Text(type.displayName)
                        .font(AppTheme.Typography.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.slate900)
                        .multilineTextAlignment(.center)
                    
                    Text("\(questionCount) questions")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.slate400 : AppTheme.Colors.slate500)
                }
            }
            .padding(AppTheme.Spacing.lg)
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                    .fill(colorScheme == .dark ? AppTheme.Colors.slate800.opacity(0.8) : Color.white.opacity(0.9))
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: color.opacity(0.15), radius: 8, x: 0, y: 4)
        }
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(AppTheme.Animation.buttonTap, value: isPressed)
        .pressEvents {
            isPressed = true
        } onRelease: {
            isPressed = false
        }
    }
}

struct ModernActivityRow: View {
    let result: TestResult
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            // Test Type Icon with gradient
            ZStack {
                Circle()
                    .fill(result.sessionType.color.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: result.sessionType.icon)
                    .foregroundColor(result.sessionType.color)
                    .font(.system(size: 16, weight: .medium))
            }
            
            // Test Info
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xxs) {
                Text(result.sessionType.displayName)
                    .font(AppTheme.Typography.callout)
                    .fontWeight(.medium)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.slate900)
                
                Text(formatDate(result.date))
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.slate400 : AppTheme.Colors.slate500)
            }
            
            Spacer()
            
            // Score with badge style
            Text("\(Int(result.percentageScore))%")
                .font(AppTheme.Typography.callout)
                .fontWeight(.bold)
                .foregroundColor(result.giftedRange ? AppTheme.Colors.accentEmerald : AppTheme.Colors.primaryIndigo)
                .padding(.horizontal, AppTheme.Spacing.sm)
                .padding(.vertical, AppTheme.Spacing.xs)
                .background(
                    Capsule()
                        .fill((result.giftedRange ? AppTheme.Colors.accentEmerald : AppTheme.Colors.primaryIndigo).opacity(0.1))
                )
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

struct ModernMotivationalCard: View {
    let type: MotivationType
    let title: String
    let message: String
    let gradient: LinearGradient
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            // Icon with gradient background
            ZStack {
                Circle()
                    .fill(gradient)
                    .frame(width: 48, height: 48)
                
                Image(systemName: type.icon)
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .semibold))
            }
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(title)
                    .font(AppTheme.Typography.callout)
                    .fontWeight(.bold)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.slate900)
                
                Text(message)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.slate400 : AppTheme.Colors.slate500)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(AppTheme.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                .fill(colorScheme == .dark ? AppTheme.Colors.slate800.opacity(0.8) : Color.white.opacity(0.9))
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                .stroke(AppTheme.Colors.primaryIndigo.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: AppTheme.Shadows.medium, radius: 8, x: 0, y: 4)
    }
}

struct ModernEmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            ZStack {
                Circle()
                    .fill(AppTheme.Colors.primaryIndigo.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(AppTheme.Colors.primaryIndigo.opacity(0.5))
            }
            
            VStack(spacing: AppTheme.Spacing.xs) {
                Text(title)
                    .font(AppTheme.Typography.callout)
                    .fontWeight(.medium)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.slate400 : AppTheme.Colors.slate500)
                
                Text(subtitle)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.slate500 : AppTheme.Colors.slate400)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(AppTheme.Spacing.xl)
    }
}

// MARK: - Press Events Extension

extension View {
    func pressEvents(onPress: @escaping () -> Void, onRelease: @escaping () -> Void) -> some View {
        modifier(PressEventsModifier(onPress: onPress, onRelease: onRelease))
    }
}

struct PressEventsModifier: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in onPress() }
                    .onEnded { _ in onRelease() }
            )
    }
}

// MARK: - Legacy Supporting Views (for backward compatibility)

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    let icon: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 16, weight: .semibold))
            }
            
            Text(value)
                .font(AppTheme.Typography.title2)
                .fontWeight(.bold)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.slate900)
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xxs) {
                Text(title)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.slate400 : AppTheme.Colors.slate500)
                
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(AppTheme.Typography.caption2)
                        .foregroundColor(color)
                }
            }
        }
        .padding(AppTheme.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(colorScheme == .dark ? AppTheme.Colors.slate800.opacity(0.8) : Color.white.opacity(0.9))
                .shadow(color: AppTheme.Shadows.soft, radius: 8, x: 0, y: 4)
        )
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
