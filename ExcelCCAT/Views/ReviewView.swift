//
//  ReviewView.swift
//  ExcelCCAT
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

struct ReviewView: View {
    @Environment(AppViewModel.self) private var appViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var isAnalyzing = false
    @State private var weakAreas: [WeakArea] = []
    @State private var showingPracticeSession = false
    @State private var selectedWeakArea: WeakArea?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    headerSection
                    
                    if isAnalyzing {
                        analyzingSection
                    } else if weakAreas.isEmpty {
                        noDataSection
                    } else {
                        weakAreasSection
                        recommendationsSection
                    }
                }
                .padding(AppTheme.Spacing.lg)
            }
            .navigationTitle(NSLocalizedString("review_weak_areas", comment: "Review Weak Areas"))
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                analyzeWeakAreas()
            }
            .sheet(isPresented: $showingPracticeSession) {
                if let weakArea = selectedWeakArea {
                    PracticeSessionSetupView(
                        preselectedType: weakArea.questionType,
                        preselectedSubType: weakArea.subType,
                        preselectedDifficulty: weakArea.difficulty,
                        focusMode: true
                    )
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text(NSLocalizedString("performance_analysis", comment: "Performance Analysis"))
                .font(AppTheme.Typography.title2)
                .fontWeight(.bold)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
            
            Text(NSLocalizedString("review_description", comment: "Identify areas that need improvement based on your test history"))
                .font(AppTheme.Typography.body)
                .foregroundColor(.secondary)
        }
        .cardStyle()
    }
    
    private var analyzingSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            ProgressView()
                .scaleEffect(1.2)
            
            Text(NSLocalizedString("analyzing_performance", comment: "Analyzing your performance..."))
                .font(AppTheme.Typography.callout)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(AppTheme.Spacing.xl)
        .cardStyle()
    }
    
    private var noDataSection: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 48))
                .foregroundColor(AppTheme.Colors.skyBlue.opacity(0.6))
            
            Text(NSLocalizedString("no_test_data", comment: "No Test Data Available"))
                .font(AppTheme.Typography.headline)
                .fontWeight(.semibold)
            
            Text(NSLocalizedString("take_tests_first", comment: "Complete some practice sessions or mock tests to see your weak areas"))
                .font(AppTheme.Typography.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: { appViewModel.selectedTab = 0 }) {
                Text(NSLocalizedString("start_practicing", comment: "Start Practicing"))
                    .font(AppTheme.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppTheme.Colors.skyBlue)
                    .cornerRadius(AppTheme.CornerRadius.medium)
            }
        }
        .padding(AppTheme.Spacing.xl)
        .cardStyle()
    }
    
    private var weakAreasSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text(NSLocalizedString("areas_to_improve", comment: "Areas to Improve"))
                .font(AppTheme.Typography.headline)
                .fontWeight(.semibold)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
            
            LazyVStack(spacing: AppTheme.Spacing.sm) {
                ForEach(weakAreas, id: \.id) { weakArea in
                    WeakAreaCard(
                        weakArea: weakArea,
                        onPractice: {
                            selectedWeakArea = weakArea
                            showingPracticeSession = true
                        }
                    )
                }
            }
        }
    }
    
    private var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text(NSLocalizedString("recommendations", comment: "Recommendations"))
                .font(AppTheme.Typography.headline)
                .fontWeight(.semibold)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
            
            LazyVStack(spacing: AppTheme.Spacing.sm) {
                ForEach(generateRecommendations(), id: \.id) { recommendation in
                    RecommendationCard(
                        title: recommendation.title,
                        subtitle: recommendation.subtitle,
                        action: recommendation.actionText,
                        handler: recommendation.action
                    )
                }
            }
        }
    }
    
    private func analyzeWeakAreas() {
        isAnalyzing = true
        
        // Simulate analysis delay for better UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            weakAreas = WeakAreaAnalyzer.analyzePerformance(
                testResults: appViewModel.testHistory,
                practiceResults: appViewModel.practiceHistory
            )
            isAnalyzing = false
        }
    }
    
    private func generateRecommendations() -> [Recommendation] {
        var recommendations: [Recommendation] = []
        
        // Generate contextual recommendations based on weak areas
        if weakAreas.contains(where: { $0.questionType == .verbal }) {
            recommendations.append(Recommendation(
                id: UUID(),
                title: NSLocalizedString("improve_vocabulary", comment: "Improve Vocabulary"),
                subtitle: NSLocalizedString("vocabulary_tip", comment: "Focus on word relationships and analogies"),
                actionText: NSLocalizedString("practice_verbal", comment: "Practice Verbal"),
                action: {
                    appViewModel.startPracticeSession(
                        type: .verbal,
                        language: appViewModel.currentLanguage,
                        questionCount: 25,
                        isTimedSession: true
                    )
                }
            ))
        }
        
        if weakAreas.contains(where: { $0.questionType == .quantitative }) {
            recommendations.append(Recommendation(
                id: UUID(),
                title: NSLocalizedString("strengthen_math", comment: "Strengthen Math Skills"),
                subtitle: NSLocalizedString("math_tip", comment: "Practice number patterns and equations"),
                actionText: NSLocalizedString("practice_quantitative", comment: "Practice Quantitative"),
                action: {
                    appViewModel.startPracticeSession(
                        type: .quantitative,
                        language: appViewModel.currentLanguage,
                        questionCount: 25,
                        isTimedSession: true
                    )
                }
            ))
        }
        
        if weakAreas.contains(where: { $0.questionType == .nonVerbal }) {
            recommendations.append(Recommendation(
                id: UUID(),
                title: NSLocalizedString("enhance_visual_reasoning", comment: "Enhance Visual Reasoning"),
                subtitle: NSLocalizedString("visual_tip", comment: "Focus on pattern recognition and spatial relationships"),
                actionText: NSLocalizedString("practice_nonverbal", comment: "Practice Non-Verbal"),
                action: {
                    appViewModel.startPracticeSession(
                        type: .nonVerbal,
                        language: appViewModel.currentLanguage,
                        questionCount: 25,
                        isTimedSession: true
                    )
                }
            ))
        }
        
        // General recommendations
        if appViewModel.testHistory.isEmpty {
            recommendations.append(Recommendation(
                id: UUID(),
                title: NSLocalizedString("take_mock_test", comment: "Take a Full Mock Test"),
                subtitle: NSLocalizedString("mock_test_tip", comment: "Get a complete assessment of your abilities"),
                actionText: NSLocalizedString("start_mock_test", comment: "Start Mock Test"),
                action: {
                    appViewModel.startFullMockTest(language: appViewModel.currentLanguage)
                }
            ))
        }
        
        return recommendations
    }
}

// MARK: - Supporting Views

struct WeakAreaCard: View {
    let weakArea: WeakArea
    let onPractice: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            // Severity indicator
            VStack {
                Circle()
                    .fill(severityColor)
                    .frame(width: 12, height: 12)
                Text(severityText)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(severityColor)
            }
            
            // Content
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                HStack {
                    Text(weakArea.title)
                        .font(AppTheme.Typography.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
                    
                    Spacer()
                    
                    Text("\(Int(weakArea.averageScore))%")
                        .font(AppTheme.Typography.caption)
                        .fontWeight(.medium)
                        .foregroundColor(severityColor)
                }
                
                Text(weakArea.description)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 4)
                            .cornerRadius(2)
                        
                        Rectangle()
                            .fill(severityColor)
                            .frame(width: geometry.size.width * (weakArea.averageScore / 100), height: 4)
                            .cornerRadius(2)
                    }
                }
                .frame(height: 4)
            }
            
            // Action button
            Button(action: onPractice) {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.title3)
                    .foregroundColor(AppTheme.Colors.skyBlue)
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(colorScheme == .dark ? AppTheme.Colors.darkSurface : Color.white)
                .shadow(color: AppTheme.Shadows.light, radius: 2, x: 0, y: 1)
        )
    }
    
    private var severityColor: Color {
        switch weakArea.severity {
        case .critical: return .red
        case .moderate: return .orange
        case .minor: return .yellow
        }
    }
    
    private var severityText: String {
        switch weakArea.severity {
        case .critical: return NSLocalizedString("critical", comment: "Critical")
        case .moderate: return NSLocalizedString("moderate", comment: "Moderate")
        case .minor: return NSLocalizedString("minor", comment: "Minor")
        }
    }
}

// MARK: - Practice Session Setup View

struct PracticeSessionSetupView: View {
    @Environment(AppViewModel.self) private var appViewModel
    @Environment(\.dismiss) private var dismiss
    
    let preselectedType: QuestionType?
    let preselectedSubType: String?
    let preselectedDifficulty: Difficulty?
    let focusMode: Bool
    
    @State private var questionCount: Double = 20
    @State private var isTimedSession = true
    
    var body: some View {
        NavigationView {
            VStack(spacing: AppTheme.Spacing.lg) {
                if focusMode {
                    focusHeader
                }
                
                sessionSettings
                
                Spacer()
                
                startButton
            }
            .padding(AppTheme.Spacing.lg)
            .navigationTitle(NSLocalizedString("focused_practice", comment: "Focused Practice"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("cancel", comment: "Cancel")) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var focusHeader: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: "target")
                .font(.system(size: 48))
                .foregroundColor(AppTheme.Colors.skyBlue)
            
            Text(NSLocalizedString("targeted_practice", comment: "Targeted Practice"))
                .font(AppTheme.Typography.title3)
                .fontWeight(.semibold)
            
            if let type = preselectedType {
                Text("Focus: \(type.displayName)")
                    .font(AppTheme.Typography.callout)
                    .foregroundColor(.secondary)
            }
        }
        .cardStyle()
    }
    
    private var sessionSettings: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text(NSLocalizedString("session_settings", comment: "Session Settings"))
                .font(AppTheme.Typography.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: AppTheme.Spacing.md) {
                HStack {
                    Text(NSLocalizedString("question_count", comment: "Question Count"))
                    Spacer()
                    Text("\(Int(questionCount))")
                        .fontWeight(.semibold)
                }
                
                Slider(value: $questionCount, in: 10...50, step: 5)
                    .tint(AppTheme.Colors.skyBlue)
                
                Toggle(NSLocalizedString("timed_session", comment: "Timed Session"), isOn: $isTimedSession)
                    .tint(AppTheme.Colors.skyBlue)
            }
        }
        .cardStyle()
    }
    
    private var startButton: some View {
        Button(action: startPractice) {
            Text(NSLocalizedString("start_focused_practice", comment: "Start Focused Practice"))
                .font(AppTheme.Typography.callout)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppTheme.Colors.skyBlue)
                .cornerRadius(AppTheme.CornerRadius.medium)
        }
    }
    
    private func startPractice() {
        appViewModel.playHapticFeedback(.selection)
        
        if let type = preselectedType {
            appViewModel.startPracticeSession(
                type: type,
                subType: preselectedSubType,
                difficulty: preselectedDifficulty,
                language: appViewModel.currentLanguage,
                questionCount: Int(questionCount),
                isTimedSession: isTimedSession
            )
        }
        
        dismiss()
    }
}

#Preview {
    ReviewView()
        .environment(AppViewModel())
}
