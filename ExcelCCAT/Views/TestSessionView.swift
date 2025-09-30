//
//  TestSessionView.swift
//  ExcelCCAT
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

struct TestSessionView: View {
    @Environment(TestSessionViewModel.self) private var sessionViewModel
    @Environment(AppViewModel.self) private var appViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var showingExitConfirmation = false
    @State private var showingTimeWarning = false
    @State private var selectedAnswer: Int? = nil
    @State private var showingExplanation = false
    @State private var isQuestionAnimating = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    headerView
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .padding(.top, geometry.safeAreaInsets.top + AppTheme.Spacing.sm)
                    
                    // Content
                    contentView
                        .padding(.horizontal, AppTheme.Spacing.md)
                    
                    // Controls
                    controlsView
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .padding(.bottom, geometry.safeAreaInsets.bottom + AppTheme.Spacing.md)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            setupView()
        }
        .onChange(of: sessionViewModel.questionNumber) { oldValue, newValue in
            if oldValue != newValue {
                animateQuestionTransition()
            }
        }
        .alert("Confirm Exit", isPresented: $showingExitConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Exit", role: .destructive) {
                sessionViewModel.exitSession()
            }
        } message: {
            Text("Are you sure you want to exit? Your progress will be lost.")
        }
        .alert("Time Warning", isPresented: $showingTimeWarning) {
            Button("Continue") { }
        } message: {
            Text("You have 5 minutes remaining!")
        }
    }
    
    // MARK: - Background
    
    private var backgroundColor: some View {
        Group {
            if appViewModel.currentLanguage == .french {
                AppTheme.Colors.frenchModeGradient.opacity(0.1)
            } else {
                AppTheme.Colors.primaryGradient.opacity(0.05)
            }
        }
        .background(colorScheme == .dark ? AppTheme.Colors.darkBackground : AppTheme.Colors.offWhite)
    }
    
    // MARK: - Header View
    
    private var headerView: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            // Top Bar
            HStack {
                // Exit Button
                Button(action: { showingExitConfirmation = true }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(AppTheme.Colors.softRed)
                }
                
                Spacer()
                
                // Timer (if applicable)
                if sessionViewModel.isTimerRunning {
                    timerView
                }
                
                Spacer()
                
                // Language Indicator
                Text(appViewModel.currentLanguage.flag)
                    .font(.title3)
            }
            
            // Progress Bar
            progressBar
            
            // Question Counter
            HStack {
                Text(String(format: NSLocalizedString("question_number", comment: "Question %d of %d"), sessionViewModel.questionNumber, sessionViewModel.totalQuestions))
                    .font(AppTheme.Typography.callout)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.7) : AppTheme.Colors.softGray.opacity(0.7))
                
                Spacer()
                
                if let session = sessionViewModel.currentSession {
                    Text(session.sessionType.displayName)
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.skyBlue)
                        .padding(.horizontal, AppTheme.Spacing.sm)
                        .padding(.vertical, AppTheme.Spacing.xs)
                        .background(
                            Capsule()
                                .fill(AppTheme.Colors.skyBlue.opacity(0.1))
                        )
                }
            }
        }
    }
    
    private var timerView: some View {
        HStack(spacing: AppTheme.Spacing.xs) {
            Image(systemName: "clock.fill")
                .foregroundColor(sessionViewModel.timeWarningLevel.color)
                .font(.caption)
            
            Text(sessionViewModel.formattedTimeRemaining)
                .font(AppTheme.Typography.timerText)
                .fontWeight(.semibold)
                .foregroundColor(sessionViewModel.timeWarningLevel.color)
                .monospacedDigit()
        }
        .padding(.horizontal, AppTheme.Spacing.sm)
        .padding(.vertical, AppTheme.Spacing.xs)
        .background(
            Capsule()
                .fill(sessionViewModel.timeWarningLevel.color.opacity(0.1))
        )
        .scaleEffect(sessionViewModel.timeWarningLevel == .critical ? 1.1 : 1.0)
    }
    
    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(AppTheme.Colors.lightGray.opacity(0.3))
                Capsule()
                    .fill(AppTheme.Colors.skyBlue)
                    .frame(width: max(0, geo.size.width * sessionViewModel.progress))
            }
        }
        .frame(height: 8)
    }
    
    // MARK: - Content View
    
    private var contentView: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.xl) {
                if let question = sessionViewModel.currentQuestion {
                    questionCard(question)
                        .opacity(isQuestionAnimating ? 1.0 : 0.0)
                        .offset(x: isQuestionAnimating ? 0 : 50)
                        .animation(AppTheme.Animation.slideTransition, value: isQuestionAnimating)
                }
            }
            .padding(.vertical, AppTheme.Spacing.lg)
        }
    }
    
    private func questionCard(_ question: Question) -> some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            // Question Stem
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text(question.getLocalizedStem(language: appViewModel.currentLanguage))
                    .font(AppTheme.Typography.questionStem)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Image for non-verbal questions
                if let imageName = question.imageName {
                    questionImage(imageName)
                }
            }
            .cardStyle()
            
            // Answer Options
            VStack(spacing: AppTheme.Spacing.md) {
                Text(NSLocalizedString("select_answer", comment: ""))
                    .font(AppTheme.Typography.callout)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.7) : AppTheme.Colors.softGray.opacity(0.7))
                
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: AppTheme.Spacing.md),
                    GridItem(.flexible(), spacing: AppTheme.Spacing.md)
                ], spacing: AppTheme.Spacing.md) {
                    ForEach(Array(question.getLocalizedOptions(language: appViewModel.currentLanguage).enumerated()), id: \.offset) { index, option in
                        answerOption(option, index: index, question: question)
                    }
                }
            }
            .cardStyle()
            
            // Explanation (Practice Mode)
            if sessionViewModel.currentSession?.sessionType == .practice && selectedAnswer != nil && showingExplanation {
                explanationCard(question)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .bottom).combined(with: .opacity)
                    ))
            }
        }
    }
    
    private func questionImage(_ imageName: String) -> some View {
        // Placeholder for question images
        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
            .fill(AppTheme.Colors.lightGray)
            .frame(height: 200)
            .overlay(
                VStack(spacing: AppTheme.Spacing.sm) {
                    Image(systemName: "photo")
                        .font(.system(size: 40))
                        .foregroundColor(AppTheme.Colors.mediumGray)
                    
                    Text("Question Diagram")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.mediumGray)
                    
                    Text(imageName)
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.mediumGray)
                }
            )
    }
    
    private func answerOption(_ option: String, index: Int, question: Question) -> some View {
        Button(action: {
            selectAnswer(index)
        }) {
            HStack(spacing: AppTheme.Spacing.sm) {
                // Option Letter
                Text(optionLetter(index))
                    .font(AppTheme.Typography.headline)
                    .fontWeight(.semibold)
                    .frame(width: 30, height: 30)
                    .background(Circle().fill(Color.clear))
                
                // Option Text
                Text(option)
                    .font(AppTheme.Typography.questionOptions)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer(minLength: 0)
            }
            .padding(AppTheme.Spacing.md)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 60)
        }
        .choiceButtonStyle(
            isSelected: selectedAnswer == index,
            isCorrect: sessionViewModel.currentSession?.sessionType == .practice && showingExplanation ? question.correctAnswer == index : nil,
            showResult: sessionViewModel.currentSession?.sessionType == .practice && showingExplanation
        )
        .disabled(sessionViewModel.currentSession?.sessionType == .practice && showingExplanation)
    }
    
    private func explanationCard(_ question: Question) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack {
                Image(systemName: selectedAnswer == question.correctAnswer ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(selectedAnswer == question.correctAnswer ? AppTheme.Colors.sageGreen : AppTheme.Colors.softRed)
                    .font(.title2)
                
                Text(selectedAnswer == question.correctAnswer ? "Correct!" : "Incorrect")
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(selectedAnswer == question.correctAnswer ? AppTheme.Colors.sageGreen : AppTheme.Colors.softRed)
                
                Spacer()
            }
            
            if selectedAnswer != question.correctAnswer {
                Text("Correct answer: \(optionLetter(question.correctAnswer))")
                    .font(AppTheme.Typography.callout)
                    .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
            }
            
            Text(NSLocalizedString("explanation", comment: ""))
                .font(AppTheme.Typography.callout)
                .fontWeight(.semibold)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
            
            Text(question.getLocalizedExplanation(language: appViewModel.currentLanguage))
                .font(AppTheme.Typography.body)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.8) : AppTheme.Colors.softGray.opacity(0.8))
        }
        .cardStyle()
    }
    
    // MARK: - Controls View
    
    private var controlsView: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            // Previous Button
            if sessionViewModel.canGoBack {
                Button(action: {
                    sessionViewModel.previousQuestion()
                }) {
                    HStack(spacing: AppTheme.Spacing.sm) {
                        Image(systemName: "chevron.left")
                        Text(NSLocalizedString("previous", comment: ""))
                    }
                    .font(AppTheme.Typography.callout)
                    .fontWeight(.medium)
                }
                .secondaryButtonStyle()
                .transition(.asymmetric(
                    insertion: .move(edge: .leading).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
            }
            
            Spacer()
            
            // Next/Finish Button
            Button(action: nextAction) {
                HStack(spacing: AppTheme.Spacing.sm) {
                    Text(sessionViewModel.isLastQuestion ? NSLocalizedString("finish", comment: "") : NSLocalizedString("next", comment: ""))
                    
                    if !sessionViewModel.isLastQuestion {
                        Image(systemName: "chevron.right")
                    }
                }
                .font(AppTheme.Typography.callout)
                .fontWeight(.semibold)
            }
            .primaryButtonStyle(isEnabled: canProceed)
        }
    }
    
    // MARK: - Helper Methods
    
    private func setupView() {
        selectedAnswer = sessionViewModel.selectedAnswer
        withAnimation(AppTheme.Animation.smooth) {
            isQuestionAnimating = true
        }
    }
    
    private func animateQuestionTransition() {
        // Reset state for new question
        selectedAnswer = sessionViewModel.selectedAnswer
        showingExplanation = false
        
        // Animate transition
        withAnimation(AppTheme.Animation.quick) {
            isQuestionAnimating = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(AppTheme.Animation.slideTransition) {
                isQuestionAnimating = true
            }
        }
    }
    
    private func selectAnswer(_ index: Int) {
        selectedAnswer = index
        // Persist selection through the session view model's API
        if sessionViewModel.currentQuestion != nil {
            sessionViewModel.selectAnswer(index)
        }
        
        // Show explanation in practice mode
        if sessionViewModel.currentSession?.sessionType == .practice {
            withAnimation(AppTheme.Animation.smooth.delay(0.5)) {
                showingExplanation = true
            }
        }
        
        appViewModel.playHapticFeedback(.selection)
    }
    
    private func nextAction() {
        if sessionViewModel.isLastQuestion {
            sessionViewModel.completeSession()
        } else {
            sessionViewModel.nextQuestion()
        }
        
        appViewModel.playHapticFeedback(.selection)
    }
    
    private var canProceed: Bool {
        if sessionViewModel.currentSession?.sessionType == .practice {
            return showingExplanation
        } else {
            return selectedAnswer != nil
        }
    }
    
    private func optionLetter(_ index: Int) -> String {
        return String(UnicodeScalar(65 + index)!) // A, B, C, D
    }
}

// MARK: - Extensions

// Removed custom Text formatter – used String(format:) inline instead.

#Preview {
    TestSessionView()
        .environment(TestSessionViewModel(appViewModel: AppViewModel()))
        .environment(AppViewModel())
}
