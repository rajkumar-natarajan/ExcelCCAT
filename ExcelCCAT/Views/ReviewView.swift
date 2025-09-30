//
//  ReviewView.swift
//  ExcelCCAT
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

struct ReviewView: View {
    @Environment(AppViewModel.self) private var appViewModel
    @State private var weakAreas: [WeakArea] = []
    @State private var isAnalyzing = false
    @State private var showingPracticeSetup = false
    @State private var selectedWeakArea: WeakArea?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if appViewModel.userProgress.totalTestsTaken == 0 {
                    emptyStateView
                } else {
                    if isAnalyzing {
                        analyzingView
                    } else {
                        resultsView
                    }
                }
            }
            .navigationTitle(NSLocalizedString("review_title", comment: "Review"))
            .onAppear {
                analyzeWeakAreas()
            }
        }
        .sheet(isPresented: $showingPracticeSetup) {
            if let weakArea = selectedWeakArea {
                PracticeSessionSetupView(weakArea: weakArea)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "chart.line.uptrend.xyaxis.circle")
                .font(.system(size: 80))
                .foregroundStyle(AppTheme.Colors.skyBlue.opacity(0.6))
            
            Text(NSLocalizedString("no_test_data_title", comment: "No Test Data"))
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            
            Text(NSLocalizedString("no_test_data_message", comment: "Complete some practice sessions or mock tests to see your weak area analysis."))
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var analyzingView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            SwiftUI.ProgressView()
                .scaleEffect(1.5)
                .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.skyBlue))
            
            Text(NSLocalizedString("analyzing_performance", comment: "Analyzing Performance..."))
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            
            Spacer()
        }
    }
    
    private var resultsView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                headerSection
                
                if weakAreas.isEmpty {
                    noWeakAreasView
                } else {
                    ForEach(weakAreas) { weakArea in
                        WeakAreaCard(weakArea: weakArea) {
                            selectedWeakArea = weakArea
                            showingPracticeSetup = true
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(NSLocalizedString("weak_areas_analysis", comment: "Weak Areas Analysis"))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            Text(NSLocalizedString("weak_areas_subtitle", comment: "Areas that need improvement based on your recent performance"))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var noWeakAreasView: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.green)
            
            Text(NSLocalizedString("no_weak_areas_title", comment: "Great Performance!"))
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            
            Text(NSLocalizedString("no_weak_areas_message", comment: "You're performing well across all question types. Keep up the excellent work!"))
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.green.opacity(0.1))
        )
    }
    
    private func analyzeWeakAreas() {
        guard appViewModel.userProgress.totalTestsTaken > 0 else { return }
        
        isAnalyzing = true
        
        Task {
            let analyzer = WeakAreaAnalyzer()
            let analyzedAreas = analyzer.analyzePerformance(from: appViewModel.userProgress)
            
            await MainActor.run {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.weakAreas = analyzedAreas
                    self.isAnalyzing = false
                }
            }
        }
    }
}

struct WeakAreaCard: View {
    let weakArea: WeakArea
    let onPractice: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(weakArea.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    
                    Text(weakArea.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                severityBadge
            }
            
            progressSection
            
            recommendationSection
            
            HStack {
                Spacer()
                
                Button(action: onPractice) {
                    HStack(spacing: 8) {
                        Image(systemName: "play.fill")
                            .font(.caption)
                        Text(NSLocalizedString("practice_now", comment: "Practice Now"))
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(AppTheme.Colors.skyBlue)
                    .clipShape(Capsule())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .stroke(severityColor.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var severityBadge: some View {
        Text(severityDisplayName)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(severityColor)
            .clipShape(Capsule())
    }
    
    private var severityDisplayName: String {
        switch weakArea.severity {
        case .critical:
            return NSLocalizedString("critical", comment: "Critical")
        case .moderate:
            return NSLocalizedString("moderate", comment: "Moderate")
        case .minor:
            return NSLocalizedString("minor", comment: "Minor")
        }
    }
    
    private var severityColor: Color {
        switch weakArea.severity {
        case .critical:
            return .red
        case .moderate:
            return .orange
        case .minor:
            return .yellow
        }
    }
    
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(NSLocalizedString("accuracy", comment: "Accuracy"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("\(Int(weakArea.averageScore))%")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
            }
            
            SwiftUI.ProgressView(value: weakArea.averageScore / 100.0)
                .progressViewStyle(LinearProgressViewStyle(tint: severityColor))
                .scaleEffect(y: 0.8)
        }
    }
    
    private var recommendationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(NSLocalizedString("recommendations", comment: "Recommendations"))
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            
            HStack(alignment: .top, spacing: 8) {
                Text("•")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(getRecommendationText())
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    private func getRecommendationText() -> String {
        switch weakArea.severity {
        case .critical:
            return NSLocalizedString("focus_immediate_attention", comment: "Focus immediate attention on this area")
        case .moderate:
            return NSLocalizedString("regular_practice_needed", comment: "Regular practice needed to improve")
        case .minor:
            return NSLocalizedString("minor_improvements_possible", comment: "Minor improvements possible with targeted practice")
        }
    }
}

struct PracticeSessionSetupView: View {
    let weakArea: WeakArea
    @Environment(\.dismiss) private var dismiss
    @Environment(AppViewModel.self) private var appViewModel
    @State private var questionCount = 25
    @State private var isTimedSession = true
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                headerSection
                
                configurationSection
                
                Spacer()
                
                startButton
            }
            .padding()
            .navigationTitle(NSLocalizedString("targeted_practice", comment: "Targeted Practice"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(NSLocalizedString("cancel", comment: "Cancel")) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text(weakArea.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            Text(NSLocalizedString("targeted_practice_description", comment: "Focus on improving your weakest areas with a customized practice session"))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var configurationSection: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text(NSLocalizedString("question_count", comment: "Question Count"))
                    .font(.headline)
                    .fontWeight(.medium)
                
                Picker("Question Count", selection: $questionCount) {
                    Text("10").tag(10)
                    Text("25").tag(25)
                    Text("50").tag(50)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Toggle(isOn: $isTimedSession) {
                    Text(NSLocalizedString("timed_session", comment: "Timed Session"))
                        .font(.headline)
                        .fontWeight(.medium)
                }
                .toggleStyle(SwitchToggleStyle(tint: AppTheme.Colors.skyBlue))
                
                Text(NSLocalizedString("timed_session_description", comment: "Simulates real test conditions with time pressure"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
    
    private var startButton: some View {
        Button(action: startPracticeSession) {
            HStack {
                Image(systemName: "play.fill")
                Text(NSLocalizedString("start_practice_session", comment: "Start Practice Session"))
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(AppTheme.Colors.skyBlue)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func startPracticeSession() {
        // Start a practice session focused on the weak area
        dismiss()
        
        // This would integrate with the existing practice session system
        // For now, we'll just dismiss the sheet
    }
}

#Preview {
    ReviewView()
        .environment(AppViewModel())
}