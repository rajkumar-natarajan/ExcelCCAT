//
//  ContentView.swift
//  ExcelCCAT
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppViewModel.self) private var appViewModel
    @State private var testSessionViewModel: TestSessionViewModel?
    @State private var hasActiveSession: Bool = false
    
    var body: some View {
        NavigationStack {
            Group {
                if appViewModel.showingOnboarding {
                    OnboardingView()
                } else if appViewModel.isTestInProgress {
                    if hasActiveSession, let sessionVM = testSessionViewModel {
                        TestSessionView()
                            .environment(sessionVM)
                    } else {
                        LoadingView()
                            .onAppear {
                                setupTestSession()
                            }
                    }
                } else if appViewModel.showingResults {
                    if let result = appViewModel.lastTestResult {
                        TestResultsView(result: result)
                    }
                } else {
                    MainTabView()
                }
            }
            .animation(.easeInOut(duration: 0.3), value: appViewModel.showingOnboarding)
            .animation(.easeInOut(duration: 0.3), value: appViewModel.isTestInProgress)
            .animation(.easeInOut(duration: 0.3), value: appViewModel.showingResults)
        }
        .onAppear {
            // Try to resume any existing session
            appViewModel.resumeSession()
        }
        .onChange(of: appViewModel.isTestInProgress) { oldValue, newValue in
            print("🎯 onChange: isTestInProgress changed from \(oldValue) to \(newValue)")
            if newValue {
                // Always set up a new session when test starts
                setupTestSession()
            } else {
                // Reset when test ends
                testSessionViewModel = nil
                hasActiveSession = false
            }
        }
    }
    
    private func setupTestSession() {
        print("🎯 ContentView.setupTestSession() called")
        print("🎯 appViewModel.currentTestSession exists: \(appViewModel.currentTestSession != nil)")
        
        if let session = appViewModel.currentTestSession {
            print("🎯 Session has \(session.questions.count) questions")
            print("🎯 Session type: \(session.sessionType)")
            
            let sessionVM = TestSessionViewModel(appViewModel: appViewModel)
            sessionVM.startSession(session)
            testSessionViewModel = sessionVM
            hasActiveSession = true
            
            print("🎯 testSessionViewModel created and session started")
            print("🎯 sessionVM.totalQuestions: \(sessionVM.totalQuestions)")
            print("🎯 hasActiveSession set to true")
        } else {
            print("🚨 ERROR: No currentTestSession available!")
            hasActiveSession = false
        }
    }
}

// MARK: - Supporting Views

struct LoadingView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(AppTheme.Colors.skyBlue)
            
            Text("Loading...")
                .font(AppTheme.Typography.headline)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(colorScheme == .dark ? AppTheme.Colors.darkBackground : AppTheme.Colors.offWhite)
    }
}

#Preview {
    ContentView()
        .environment(AppViewModel())
}
