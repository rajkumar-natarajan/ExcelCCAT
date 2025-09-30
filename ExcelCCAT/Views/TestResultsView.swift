//
//  TestResultsView.swift
//  ExcelCCAT
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

struct TestResultsView: View {
    let result: TestResult
    @Environment(AppViewModel.self) private var appViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var showingConfetti = false
    @State private var showingDetailedResults = false
    @State private var animateScore = false
    @State private var animateBreakdown = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    // Background
                    backgroundColor
                        .ignoresSafeArea()
                    
                    // Confetti overlay
                    if showingConfetti && result.giftedRange {
                        ConfettiView()
                            .ignoresSafeArea()
                    }
                    
                    ScrollView {
                        VStack(spacing: AppTheme.Spacing.xl) {
                            // Header
                            headerSection
                            
                            // Score Section
                            scoreSection
                            
                            // Breakdown Section
                            breakdownSection
                            
                            // Insights Section
                            insightsSection
                            
                            // Actions Section
                            actionsSection
                        }
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .padding(.bottom, AppTheme.Spacing.xl)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { appViewModel.showingResults = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppTheme.Colors.softGray)
                    }
                }
            }
        }
        .onAppear {
            setupAnimations()
        }
    }
    
    // MARK: - Background
    
    private var backgroundColor: some View {
        Group {
            if result.giftedRange {
                AppTheme.Colors.successGradient.opacity(0.1)
            } else {
                AppTheme.Colors.primaryGradient.opacity(0.05)
            }
        }
        .background(colorScheme == .dark ? AppTheme.Colors.darkBackground : AppTheme.Colors.offWhite)
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            // Success Icon
            Image(systemName: result.giftedRange ? "star.circle.fill" : "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(result.giftedRange ? AppTheme.Colors.sunnyYellow : AppTheme.Colors.sageGreen)
                .scaleEffect(animateScore ? 1.0 : 0.5)
                .animation(AppTheme.Animation.bounce.delay(0.3), value: animateScore)
            
            // Title
            Text(NSLocalizedString("test_completed", comment: ""))
                .font(AppTheme.Typography.largeTitle)
                .fontWeight(.thin)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
                .opacity(animateScore ? 1.0 : 0.0)
                .offset(y: animateScore ? 0 : 20)
                .animation(AppTheme.Animation.smooth.delay(0.5), value: animateScore)
            
            // Subtitle
            Text(result.giftedRange ? NSLocalizedString("gifted_range", comment: "") : NSLocalizedString("great_job", comment: ""))
                .font(AppTheme.Typography.title3)
                .foregroundColor(result.giftedRange ? AppTheme.Colors.sunnyYellow : AppTheme.Colors.sageGreen)
                .opacity(animateScore ? 1.0 : 0.0)
                .offset(y: animateScore ? 0 : 20)
                .animation(AppTheme.Animation.smooth.delay(0.7), value: animateScore)
        }
    }
    
    // MARK: - Score Section
    
    private var scoreSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            // Main Score Circle
            ZStack {
                // Background Circle
                Circle()
                    .stroke(AppTheme.Colors.lightGray, lineWidth: 8)
                    .frame(width: 160, height: 160)
                
                // Progress Circle
                Circle()
                    .trim(from: 0, to: animateScore ? result.percentageScore / 100 : 0)
                    .stroke(
                        result.giftedRange ? AppTheme.Colors.successGradient : AppTheme.Colors.primaryGradient,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 160, height: 160)
                    .rotationEffect(.degrees(-90))
                    .animation(AppTheme.Animation.smooth.delay(1.0), value: animateScore)
                
                // Score Text
                VStack(spacing: AppTheme.Spacing.xs) {
                    Text("\(Int(result.percentageScore))%")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
                    
                    Text("\(result.score)/\(result.totalQuestions)")
                        .font(AppTheme.Typography.callout)
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.7) : AppTheme.Colors.softGray.opacity(0.7))
                }
                .scaleEffect(animateScore ? 1.0 : 0.0)
                .animation(AppTheme.Animation.bounce.delay(1.2), value: animateScore)
            }
            
            // Percentile Rank
            VStack(spacing: AppTheme.Spacing.sm) {
                Text(String(format: NSLocalizedString("percentile_rank", comment: ""), Int(result.percentileRank)))
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(result.giftedRange ? AppTheme.Colors.sageGreen : AppTheme.Colors.skyBlue)
                
                if result.giftedRange {
                    HStack(spacing: AppTheme.Spacing.xs) {
                        Image(systemName: "star.fill")
                            .foregroundColor(AppTheme.Colors.sunnyYellow)
                            .font(.caption)
                        
                        Text(NSLocalizedString("gifted_range", comment: ""))
                            .font(AppTheme.Typography.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(AppTheme.Colors.sageGreen)
                    }
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.vertical, AppTheme.Spacing.sm)
                    .background(
                        Capsule()
                            .fill(AppTheme.Colors.sageGreen.opacity(0.1))
                    )
                }
            }
            .opacity(animateScore ? 1.0 : 0.0)
            .offset(y: animateScore ? 0 : 30)
            .animation(AppTheme.Animation.smooth.delay(1.4), value: animateScore)
            
            // Time Taken
            Text(String(format: NSLocalizedString("time_taken", comment: ""), formatTime(result.timeSpent)))
                .font(AppTheme.Typography.callout)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.7) : AppTheme.Colors.softGray.opacity(0.7))
                .opacity(animateScore ? 1.0 : 0.0)
                .animation(AppTheme.Animation.smooth.delay(1.6), value: animateScore)
        }
        .cardStyle()
    }
    
    // MARK: - Breakdown Section
    
    private var breakdownSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text(NSLocalizedString("breakdown_by_type", comment: ""))
                .font(AppTheme.Typography.headline)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
            
            VStack(spacing: AppTheme.Spacing.sm) {
                ScoreBreakdownRow(
                    title: NSLocalizedString("verbal", comment: ""),
                    score: result.verbalScore,
                    total: getQuestionCount(for: .verbal),
                    color: AppTheme.Colors.skyBlue,
                    animate: animateBreakdown
                )
                
                ScoreBreakdownRow(
                    title: NSLocalizedString("quantitative", comment: ""),
                    score: result.quantitativeScore,
                    total: getQuestionCount(for: .quantitative),
                    color: AppTheme.Colors.sageGreen,
                    animate: animateBreakdown
                )
                
                ScoreBreakdownRow(
                    title: NSLocalizedString("non_verbal", comment: ""),
                    score: result.nonVerbalScore,
                    total: getQuestionCount(for: .nonVerbal),
                    color: AppTheme.Colors.sunnyYellow,
                    animate: animateBreakdown
                )
            }
        }
        .cardStyle()
    }
    
    // MARK: - Insights Section
    
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text(NSLocalizedString("insights", comment: "Insights"))
                .font(AppTheme.Typography.headline)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
            
            VStack(spacing: AppTheme.Spacing.sm) {
                InsightCard(
                    icon: "trophy.fill",
                    title: getStrongestArea(),
                    subtitle: NSLocalizedString("strongest_area", comment: ""),
                    color: AppTheme.Colors.sageGreen
                )
                
                if !result.giftedRange {
                    InsightCard(
                        icon: "target",
                        title: getWeakestArea(),
                        subtitle: NSLocalizedString("improvement_area", comment: ""),
                        color: AppTheme.Colors.sunnyYellow
                    )
                    
                    InsightCard(
                        icon: "lightbulb.fill",
                        title: getRecommendation(),
                        subtitle: NSLocalizedString("recommendation", comment: ""),
                        color: AppTheme.Colors.skyBlue
                    )
                }
            }
        }
        .cardStyle()
        .opacity(animateBreakdown ? 1.0 : 0.0)
        .offset(y: animateBreakdown ? 0 : 20)
        .animation(AppTheme.Animation.smooth.delay(2.0), value: animateBreakdown)
    }
    
    // MARK: - Actions Section
    
    private var actionsSection: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            // Primary Actions
            HStack(spacing: AppTheme.Spacing.md) {
                Button(action: {
                    showingDetailedResults = true
                }) {
                    HStack {
                        Image(systemName: "doc.text.magnifyingglass")
                        Text(NSLocalizedString("view_detailed_results", comment: ""))
                    }
                    .font(AppTheme.Typography.callout)
                    .fontWeight(.medium)
                }
                .secondaryButtonStyle()
                
                Button(action: retakeTest) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text(NSLocalizedString("retake_test", comment: ""))
                    }
                    .font(AppTheme.Typography.callout)
                    .fontWeight(.semibold)
                }
                .primaryButtonStyle()
            }
            
            // Secondary Action
            if !result.giftedRange {
                Button(action: practiceWeakAreas) {
                    HStack {
                        Image(systemName: "brain.head.profile")
                        Text(NSLocalizedString("practice_weak_areas", comment: ""))
                    }
                    .font(AppTheme.Typography.callout)
                    .fontWeight(.medium)
                }
                .secondaryButtonStyle()
            }
            
            // Done Button
            Button(action: { appViewModel.showingResults = false }) {
                Text(NSLocalizedString("done", comment: ""))
                    .font(AppTheme.Typography.headline)
                    .frame(maxWidth: .infinity)
            }
            .primaryButtonStyle()
        }
        .opacity(animateBreakdown ? 1.0 : 0.0)
        .animation(AppTheme.Animation.smooth.delay(2.2), value: animateBreakdown)
    }
    
    // MARK: - Helper Methods
    
    private func setupAnimations() {
        withAnimation(AppTheme.Animation.smooth.delay(0.1)) {
            animateScore = true
        }
        
        withAnimation(AppTheme.Animation.smooth.delay(1.8)) {
            animateBreakdown = true
        }
        
        if result.giftedRange {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(AppTheme.Animation.confetti) {
                    showingConfetti = true
                }
            }
        }
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func getQuestionCount(for type: QuestionType) -> Int {
        // Approximate distribution for full mock
        switch type {
        case .verbal, .quantitative:
            return 59
        case .nonVerbal:
            return 58
        }
    }
    
    private func getStrongestArea() -> String {
        let verbal = Double(result.verbalScore) / Double(getQuestionCount(for: .verbal))
        let quantitative = Double(result.quantitativeScore) / Double(getQuestionCount(for: .quantitative))
        let nonVerbal = Double(result.nonVerbalScore) / Double(getQuestionCount(for: .nonVerbal))
        
        if verbal >= quantitative && verbal >= nonVerbal {
            return NSLocalizedString("strength_verbal", comment: "")
        } else if quantitative >= nonVerbal {
            return NSLocalizedString("strength_quantitative", comment: "")
        } else {
            return NSLocalizedString("strength_non_verbal", comment: "")
        }
    }
    
    private func getWeakestArea() -> String {
        let verbal = Double(result.verbalScore) / Double(getQuestionCount(for: .verbal))
        let quantitative = Double(result.quantitativeScore) / Double(getQuestionCount(for: .quantitative))
        let nonVerbal = Double(result.nonVerbalScore) / Double(getQuestionCount(for: .nonVerbal))
        
        if verbal <= quantitative && verbal <= nonVerbal {
            return NSLocalizedString("verbal", comment: "")
        } else if quantitative <= nonVerbal {
            return NSLocalizedString("quantitative", comment: "")
        } else {
            return NSLocalizedString("non_verbal", comment: "")
        }
    }
    
    private func getRecommendation() -> String {
        let weakest = getWeakestArea()
        
        if weakest.contains("Verbal") || weakest.contains("verbal") {
            return NSLocalizedString("practice_more_analogies", comment: "")
        } else if weakest.contains("Quantitative") || weakest.contains("quantitative") {
            return NSLocalizedString("work_on_time_management", comment: "")
        } else {
            return NSLocalizedString("focus_on_patterns", comment: "")
        }
    }
    
    private func retakeTest() {
        appViewModel.showingResults = false
        appViewModel.startFullMockTest(language: appViewModel.currentLanguage)
    }
    
    private func practiceWeakAreas() {
        let weakest = getWeakestArea()
        var type: QuestionType = .verbal
        
        if weakest.contains("Quantitative") || weakest.contains("quantitative") {
            type = .quantitative
        } else if weakest.contains("Non-Verbal") || weakest.contains("non_verbal") {
            type = .nonVerbal
        }
        
        appViewModel.showingResults = false
        appViewModel.startPracticeSession(
            type: type,
            language: appViewModel.currentLanguage,
            questionCount: 25,
            isTimedSession: true
        )
    }
}

// MARK: - Supporting Views

struct ScoreBreakdownRow: View {
    let title: String
    let score: Int
    let total: Int
    let color: Color
    let animate: Bool
    @Environment(\.colorScheme) var colorScheme
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(score) / Double(total)
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppTheme.Typography.callout)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
                .frame(width: 100, alignment: .leading)
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(AppTheme.Colors.lightGray)
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: animate ? geometry.size.width * percentage : 0, height: 8)
                        .cornerRadius(4)
                        .animation(AppTheme.Animation.smooth.delay(0.5), value: animate)
                }
            }
            .frame(height: 8)
            
            Text("\(score)/\(total)")
                .font(AppTheme.Typography.callout)
                .fontWeight(.medium)
                .foregroundColor(color)
                .frame(width: 50, alignment: .trailing)
        }
    }
}

struct InsightCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(subtitle)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.7) : AppTheme.Colors.softGray.opacity(0.7))
                
                Text(title)
                    .font(AppTheme.Typography.callout)
                    .fontWeight(.medium)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
            }
            
            Spacer()
        }
        .padding(.vertical, AppTheme.Spacing.sm)
    }
}

struct ConfettiView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            ForEach(0..<50) { index in
                Circle()
                    .fill([AppTheme.Colors.sunnyYellow, AppTheme.Colors.sageGreen, AppTheme.Colors.skyBlue].randomElement() ?? AppTheme.Colors.sunnyYellow)
                    .frame(width: CGFloat.random(in: 4...8))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: isAnimating ? UIScreen.main.bounds.height + 20 : -20
                    )
                    .animation(
                        Animation.linear(duration: Double.random(in: 2...4))
                            .repeatForever(autoreverses: false)
                            .delay(Double.random(in: 0...2)),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    TestResultsView(result: TestResult(
        session: TestSession(
            questions: [],
            sessionType: .fullMock,
            language: .english
        )
    ))
    .environment(AppViewModel())
}
