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
    
    var body: some View {
        NavigationStack {
            Group {
                if appViewModel.showingOnboarding {
                    OnboardingView()
                } else if appViewModel.isTestInProgress {
                    if let sessionVM = testSessionViewModel {
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
            setupAppViewModel()
        }
        .onChange(of: appViewModel.isTestInProgress) { oldValue, newValue in
            if newValue && testSessionViewModel == nil {
                setupTestSession()
            } else if !newValue {
                testSessionViewModel = nil
            }
        }
    }
    
    private func setupAppViewModel() {
        if testSessionViewModel == nil {
            testSessionViewModel = TestSessionViewModel(appViewModel: appViewModel)
        }
        
        // Try to resume any existing session
        appViewModel.resumeSession()
    }
    
    private func setupTestSession() {
        if let session = appViewModel.currentTestSession {
            let sessionVM = TestSessionViewModel(appViewModel: appViewModel)
            sessionVM.startSession(session)
            testSessionViewModel = sessionVM
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
