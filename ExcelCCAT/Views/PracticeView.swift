//
//  PracticeView.swift
//  ExcelCCAT
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

struct PracticeView: View {
    @Environment(AppViewModel.self) private var appViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedType: QuestionType = .verbal
    @State private var selectedSubType: String? = nil
    @State private var selectedDifficulty: Difficulty = .medium
    @State private var questionCount: Double = 25
    @State private var isTimedSession: Bool = false
    @State private var showingCustomPractice = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    // Header
                    headerSection
                    
                    // Quick Practice Options
                    quickPracticeSection
                    
                    // Custom Practice
                    customPracticeSection
                    
                    // Recent Practice History
                    recentPracticeSection
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.bottom, AppTheme.Spacing.xl)
            }
            .background(colorScheme == .dark ? AppTheme.Colors.darkBackground : AppTheme.Colors.offWhite)
            .navigationTitle(NSLocalizedString("practice_title", comment: ""))
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(NSLocalizedString("practice_title", comment: ""))
                        .font(AppTheme.Typography.largeTitle)
                        .fontWeight(.thin)
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
                    
                    Text("Improve your skills with targeted practice")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.7) : AppTheme.Colors.softGray.opacity(0.7))
                }
                
                Spacer()
                
                // Practice Stats
                VStack(alignment: .trailing, spacing: AppTheme.Spacing.xs) {
                    Text("\(appViewModel.userProgress.practiceHistory.count)")
                        .font(AppTheme.Typography.title2)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.Colors.skyBlue)
                    
                    Text("Practice Sessions")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.6) : AppTheme.Colors.softGray.opacity(0.6))
                }
            }
            
            // Level Selection
            levelSelectionSection
        }
    }
    
    // MARK: - Level Selection Section
    
    private var levelSelectionSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("Practice Level")
                .font(AppTheme.Typography.headline)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
            
            HStack(spacing: AppTheme.Spacing.sm) {
                ForEach([CCATLevel.level10, CCATLevel.level11, CCATLevel.level12], id: \.self) { level in
                    practiceButton(for: level)
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
    }
    
    private func practiceButton(for level: CCATLevel) -> some View {
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
    
    // MARK: - Quick Practice Section
    
    private var quickPracticeSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Quick Practice")
                .font(AppTheme.Typography.headline)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: AppTheme.Spacing.md), count: 2), spacing: AppTheme.Spacing.md) {
                QuickPracticeCard(
                    type: .verbal,
                    icon: "text.bubble.fill",
                    color: AppTheme.Colors.skyBlue,
                    questionCount: 25
                ) {
                    startQuickPractice(.verbal)
                }
                
                QuickPracticeCard(
                    type: .quantitative,
                    icon: "number.circle.fill",
                    color: AppTheme.Colors.sageGreen,
                    questionCount: 25
                ) {
                    startQuickPractice(.quantitative)
                }
                
                QuickPracticeCard(
                    type: .nonVerbal,
                    icon: "square.on.square",
                    color: AppTheme.Colors.sunnyYellow,
                    questionCount: 25
                ) {
                    startQuickPractice(.nonVerbal)
                }
                
                MixedPracticeCard {
                    startMixedPractice()
                }
            }
        }
        .cardStyle()
    }
    
    // MARK: - Custom Practice Section
    
    private var customPracticeSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text(NSLocalizedString("custom_practice", comment: ""))
                .font(AppTheme.Typography.headline)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
            
            VStack(spacing: AppTheme.Spacing.lg) {
                // Question Type Picker
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Text(NSLocalizedString("select_question_type", comment: ""))
                        .font(AppTheme.Typography.callout)
                        .fontWeight(.medium)
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
                    
                    Picker("Question Type", selection: $selectedType) {
                        ForEach(QuestionType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Sub-Type Picker (if applicable)
                if !getSubTypes(for: selectedType).isEmpty {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text("Sub-Category")
                            .font(AppTheme.Typography.callout)
                            .fontWeight(.medium)
                            .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppTheme.Spacing.sm) {
                                Button(action: { selectedSubType = nil }) {
                                    Text("All")
                                        .font(AppTheme.Typography.caption)
                                        .padding(.horizontal, AppTheme.Spacing.md)
                                        .padding(.vertical, AppTheme.Spacing.sm)
                                        .background(
                                            Capsule()
                                                .fill(selectedSubType == nil ? AppTheme.Colors.skyBlue : AppTheme.Colors.lightGray)
                                        )
                                        .foregroundColor(selectedSubType == nil ? .white : AppTheme.Colors.softGray)
                                }
                                
                                ForEach(getSubTypes(for: selectedType), id: \.self) { subType in
                                    Button(action: { selectedSubType = subType }) {
                                        Text(getSubTypeDisplayName(subType))
                                            .font(AppTheme.Typography.caption)
                                            .padding(.horizontal, AppTheme.Spacing.md)
                                            .padding(.vertical, AppTheme.Spacing.sm)
                                            .background(
                                                Capsule()
                                                    .fill(selectedSubType == subType ? AppTheme.Colors.skyBlue : AppTheme.Colors.lightGray)
                                            )
                                            .foregroundColor(selectedSubType == subType ? .white : AppTheme.Colors.softGray)
                                    }
                                }
                            }
                            .padding(.horizontal, AppTheme.Spacing.md)
                        }
                    }
                }
                
                // Difficulty Picker
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Text(NSLocalizedString("select_difficulty", comment: ""))
                        .font(AppTheme.Typography.callout)
                        .fontWeight(.medium)
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
                    
                    Picker("Difficulty", selection: $selectedDifficulty) {
                        ForEach(Difficulty.allCases, id: \.self) { difficulty in
                            Text(difficulty.displayName).tag(difficulty)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Question Count Slider
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    HStack {
                        Text(NSLocalizedString("number_of_questions", comment: ""))
                            .font(AppTheme.Typography.callout)
                            .fontWeight(.medium)
                            .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
                        
                        Spacer()
                        
                        Text("\(Int(questionCount))")
                            .font(AppTheme.Typography.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(AppTheme.Colors.skyBlue)
                    }
                    
                    Slider(value: $questionCount, in: 10...50, step: 5)
                        .tint(AppTheme.Colors.skyBlue)
                }
                
                // Timer Toggle
                HStack {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                        Text(isTimedSession ? NSLocalizedString("timed_practice", comment: "") : NSLocalizedString("untimed_practice", comment: ""))
                            .font(AppTheme.Typography.callout)
                            .fontWeight(.medium)
                            .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
                        
                        if isTimedSession {
                            Text("\(Int(questionCount)) minutes")
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.7) : AppTheme.Colors.softGray.opacity(0.7))
                        }
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $isTimedSession)
                        .toggleStyle(SwitchToggleStyle(tint: AppTheme.Colors.skyBlue))
                }
                
                // Start Custom Practice Button
                Button(action: startCustomPractice) {
                    HStack {
                        Image(systemName: "play.circle.fill")
                        Text("Start Custom Practice")
                    }
                    .font(AppTheme.Typography.headline)
                    .frame(maxWidth: .infinity)
                }
                .primaryButtonStyle()
            }
        }
        .cardStyle()
    }
    
    // MARK: - Recent Practice Section
    
    private var recentPracticeSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack {
                Text("Recent Practice")
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
                
                Spacer()
                
                NavigationLink(destination: ProgressView()) {
                    Text("View All")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.skyBlue)
                }
            }
            
            if appViewModel.userProgress.practiceHistory.isEmpty {
                EmptyPracticeHistoryView()
            } else {
                VStack(spacing: AppTheme.Spacing.sm) {
                    ForEach(appViewModel.userProgress.practiceHistory.suffix(3).reversed(), id: \.id) { result in
                        PracticeHistoryRow(result: result)
                    }
                }
            }
        }
        .cardStyle()
    }
    
    // MARK: - Helper Methods
    
    private func getSubTypes(for type: QuestionType) -> [String] {
        switch type {
        case .verbal:
            return VerbalSubType.allCases.map { $0.rawValue }
        case .quantitative:
            return QuantitativeSubType.allCases.map { $0.rawValue }
        case .nonVerbal:
            return NonVerbalSubType.allCases.map { $0.rawValue }
        }
    }
    
    private func getSubTypeDisplayName(_ subType: String) -> String {
        if let verbal = VerbalSubType(rawValue: subType) {
            return verbal.displayName
        } else if let quantitative = QuantitativeSubType(rawValue: subType) {
            return quantitative.displayName
        } else if let nonVerbal = NonVerbalSubType(rawValue: subType) {
            return nonVerbal.displayName
        }
        return subType.capitalized
    }
    
    private func startQuickPractice(_ type: QuestionType) {
        appViewModel.playHapticFeedback(.selection)
        appViewModel.startPracticeSession(
            type: type,
            language: appViewModel.currentLanguage,
            questionCount: 25,
            isTimedSession: false
        )
    }
    
    private func startMixedPractice() {
        appViewModel.playHapticFeedback(.selection)
        // Create a mixed practice session with questions from all types
        appViewModel.startPracticeSession(
            type: .verbal, // We'll modify this to support mixed types later
            language: appViewModel.currentLanguage,
            questionCount: 30,
            isTimedSession: true
        )
    }
    
    private func startCustomPractice() {
        appViewModel.playHapticFeedback(.selection)
        appViewModel.startPracticeSession(
            type: selectedType,
            subType: selectedSubType,
            difficulty: selectedDifficulty,
            language: appViewModel.currentLanguage,
            questionCount: Int(questionCount),
            isTimedSession: isTimedSession
        )
    }
}

// MARK: - Supporting Views

struct QuickPracticeCard: View {
    let type: QuestionType
    let icon: String
    let color: Color
    let questionCount: Int
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppTheme.Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(color)
                
                VStack(spacing: AppTheme.Spacing.xs) {
                    Text(type.displayName)
                        .font(AppTheme.Typography.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
                        .multilineTextAlignment(.center)
                    
                    Text("\(questionCount) questions")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.6) : AppTheme.Colors.softGray.opacity(0.6))
                }
            }
            .padding(AppTheme.Spacing.lg)
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(colorScheme == .dark ? AppTheme.Colors.darkSurface : Color.white)
                    .shadow(color: AppTheme.Shadows.light, radius: 2, x: 0, y: 1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

struct MixedPracticeCard: View {
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppTheme.Spacing.md) {
                ZStack {
                    Image(systemName: "brain.head.profile.fill")
                        .font(.system(size: 30))
                        .foregroundColor(AppTheme.Colors.skyBlue)
                }
                
                VStack(spacing: AppTheme.Spacing.xs) {
                    Text("Mixed Practice")
                        .font(AppTheme.Typography.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
                        .multilineTextAlignment(.center)
                    
                    Text("30 questions • Timed")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.6) : AppTheme.Colors.softGray.opacity(0.6))
                }
            }
            .padding(AppTheme.Spacing.lg)
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(AppTheme.Colors.primaryGradient.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                            .stroke(AppTheme.Colors.skyBlue.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
}

struct PracticeHistoryRow: View {
    let result: PracticeResult
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            // Type Icon
            Image(systemName: result.questionType.icon)
                .foregroundColor(result.questionType.color)
                .font(.title3)
                .frame(width: 30)
            
            // Practice Info
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                HStack {
                    Text(result.questionType.displayName)
                        .font(AppTheme.Typography.callout)
                        .fontWeight(.medium)
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
                    
                    if let subType = result.subType {
                        Text("• \(subType.capitalized)")
                            .font(AppTheme.Typography.caption)
                            .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.6) : AppTheme.Colors.softGray.opacity(0.6))
                    }
                }
                
                Text(formatDate(result.date))
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.6) : AppTheme.Colors.softGray.opacity(0.6))
            }
            
            Spacer()
            
            // Score
            VStack(alignment: .trailing, spacing: AppTheme.Spacing.xs) {
                Text("\(Int(result.percentageScore))%")
                    .font(AppTheme.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(result.percentageScore >= 70 ? AppTheme.Colors.sageGreen : AppTheme.Colors.skyBlue)
                
                Text("\(result.score)/\(result.totalQuestions)")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.6) : AppTheme.Colors.softGray.opacity(0.6))
            }
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

struct EmptyPracticeHistoryView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 40))
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.4) : AppTheme.Colors.softGray.opacity(0.4))
            
            VStack(spacing: AppTheme.Spacing.xs) {
                Text("No practice sessions yet")
                    .font(AppTheme.Typography.callout)
                    .fontWeight(.medium)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.7) : AppTheme.Colors.softGray.opacity(0.7))
                
                Text("Start practicing to see your progress here")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.5) : AppTheme.Colors.softGray.opacity(0.5))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(AppTheme.Spacing.xl)
    }
}

#Preview {
    PracticeView()
        .environment(AppViewModel())
}
