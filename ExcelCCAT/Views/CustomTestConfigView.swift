//
//  CustomTestConfigView.swift
//  ExcelCCAT
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

struct CustomTestConfigView: View {
    @Environment(AppViewModel.self) private var appViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State private var selectedQuestionCount: Int = 50
    @State private var selectedTimeLimit: Int = 30
    @State private var isTimedSession: Bool = true
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text("Customize your test according to TDSB standards for your grade level.")
                            .font(AppTheme.Typography.body)
                            .foregroundColor(colorScheme == .dark ? .white : AppTheme.Colors.softGray)
                        
                        HStack {
                            Text("Current Level:")
                                .font(AppTheme.Typography.callout)
                                .fontWeight(.medium)
                            
                            Text("\(appViewModel.selectedCCATLevel.displayName) (\(appViewModel.selectedCCATLevel.gradeRange))")
                                .font(AppTheme.Typography.callout)
                                .foregroundColor(AppTheme.Colors.skyBlue)
                        }
                    }
                } header: {
                    Text("Test Configuration")
                }
                
                Section {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        HStack {
                            Text("Questions:")
                                .font(AppTheme.Typography.callout)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Text("\(selectedQuestionCount)")
                                .font(AppTheme.Typography.callout)
                                .foregroundColor(AppTheme.Colors.skyBlue)
                                .fontWeight(.semibold)
                        }
                        
                        Slider(
                            value: Binding(
                                get: { Double(selectedQuestionCount) },
                                set: { 
                                    selectedQuestionCount = Int($0)
                                    // Auto-adjust time based on question count
                                    if isTimedSession {
                                        selectedTimeLimit = TestConfiguration.calculateRecommendedTime(
                                            for: selectedQuestionCount, 
                                            level: appViewModel.selectedCCATLevel, 
                                            testType: .customTest
                                        )
                                    }
                                }
                            ),
                            in: Double(questionRange.lowerBound)...Double(questionRange.upperBound),
                            step: 5
                        )
                        .accentColor(AppTheme.Colors.skyBlue)
                        
                        HStack {
                            Text("\(questionRange.lowerBound)")
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(AppTheme.Colors.mediumGray)
                            
                            Spacer()
                            
                            Text("\(questionRange.upperBound)")
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(AppTheme.Colors.mediumGray)
                        }
                    }
                } header: {
                    Text("Number of Questions")
                } footer: {
                    Text("Recommended range for \(appViewModel.selectedCCATLevel.gradeRange): \(recommendedQuestionRange.lowerBound)-\(recommendedQuestionRange.upperBound) questions")
                }
                
                Section {
                    Toggle("Timed Session", isOn: $isTimedSession)
                        .font(AppTheme.Typography.callout)
                        .toggleStyle(SwitchToggleStyle(tint: AppTheme.Colors.sageGreen))
                    
                    if isTimedSession {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                            HStack {
                                Text("Time Limit:")
                                    .font(AppTheme.Typography.callout)
                                    .fontWeight(.medium)
                                
                                Spacer()
                                
                                Text("\(selectedTimeLimit) min")
                                    .font(AppTheme.Typography.callout)
                                    .foregroundColor(AppTheme.Colors.sageGreen)
                                    .fontWeight(.semibold)
                            }
                            
                            Slider(
                                value: Binding(
                                    get: { Double(selectedTimeLimit) },
                                    set: { selectedTimeLimit = Int($0) }
                                ),
                                in: Double(timeRange.lowerBound)...Double(timeRange.upperBound),
                                step: 5
                            )
                            .accentColor(AppTheme.Colors.sageGreen)
                            
                            HStack {
                                Text("\(timeRange.lowerBound) min")
                                    .font(AppTheme.Typography.caption)
                                    .foregroundColor(AppTheme.Colors.mediumGray)
                                
                                Spacer()
                                
                                Text("\(timeRange.upperBound) min")
                                    .font(AppTheme.Typography.caption)
                                    .foregroundColor(AppTheme.Colors.mediumGray)
                            }
                        }
                    }
                } header: {
                    Text("Timing")
                } footer: {
                    if isTimedSession {
                        Text("Recommended time for \(appViewModel.selectedCCATLevel.gradeRange): \(recommendedTimeRange.lowerBound)-\(recommendedTimeRange.upperBound) minutes")
                    } else {
                        Text("Practice at your own pace without time pressure")
                    }
                }
                
                Section {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text("Test Summary")
                            .font(AppTheme.Typography.headline)
                            .fontWeight(.semibold)
                        
                        HStack {
                            Image(systemName: "number.circle.fill")
                                .foregroundColor(AppTheme.Colors.skyBlue)
                            Text("\(selectedQuestionCount) questions")
                                .font(AppTheme.Typography.callout)
                        }
                        
                        HStack {
                            Image(systemName: isTimedSession ? "clock.fill" : "infinity.circle.fill")
                                .foregroundColor(AppTheme.Colors.sageGreen)
                            Text(isTimedSession ? "\(selectedTimeLimit) minutes" : "Untimed")
                                .font(AppTheme.Typography.callout)
                        }
                        
                        HStack {
                            Image(systemName: "graduationcap.fill")
                                .foregroundColor(AppTheme.Colors.sunnyYellow)
                            Text("\(appViewModel.selectedCCATLevel.displayName) (\(appViewModel.selectedCCATLevel.gradeRange))")
                                .font(AppTheme.Typography.callout)
                        }
                    }
                    .padding(.vertical, AppTheme.Spacing.sm)
                }
            }
            .navigationTitle("Custom Test")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Start Test") {
                        appViewModel.updateCustomTestParameters(
                            questionCount: selectedQuestionCount,
                            timeLimit: selectedTimeLimit,
                            isTimedSession: isTimedSession
                        )
                        dismiss()
                        appViewModel.startConfiguredTest()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.Colors.skyBlue)
                }
            }
        }
        .onAppear {
            setupInitialValues()
        }
    }
    
    // MARK: - Computed Properties
    
    private var questionRange: ClosedRange<Int> {
        TDSBTestType.customTest.questionCountRange(for: appViewModel.selectedCCATLevel)
    }
    
    private var timeRange: ClosedRange<Int> {
        TDSBTestType.customTest.timeRange(for: appViewModel.selectedCCATLevel)
    }
    
    private var recommendedQuestionRange: ClosedRange<Int> {
        TDSBTestType.standardPractice.questionCountRange(for: appViewModel.selectedCCATLevel)
    }
    
    private var recommendedTimeRange: ClosedRange<Int> {
        TDSBTestType.standardPractice.timeRange(for: appViewModel.selectedCCATLevel)
    }
    
    // MARK: - Helper Methods
    
    private func setupInitialValues() {
        selectedQuestionCount = TDSBTestType.customTest.defaultQuestionCount(for: appViewModel.selectedCCATLevel)
        selectedTimeLimit = TDSBTestType.customTest.defaultTime(for: appViewModel.selectedCCATLevel)
    }
}

#Preview {
    CustomTestConfigView()
        .environment(AppViewModel())
}
