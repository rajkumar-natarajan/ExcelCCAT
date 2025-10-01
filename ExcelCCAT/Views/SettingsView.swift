//
//  SettingsView.swift
//  ExcelCCAT
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI
import AudioToolbox

struct SettingsView: View {
    @Environment(AppViewModel.self) private var appViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var showingResetConfirmation = false
    @State private var showingAbout = false
    @State private var showingPrivacyPolicy = false
    
    var body: some View {
        NavigationView {
            List {
                // User Profile Summary
                userProfileSection
                
                // Language Section
                languageSection
                
                // Appearance Section
                appearanceSection
                
                // Audio & Haptics Section
                audioHapticsSection
                
                // Test Settings Section
                testSettingsSection
                
                // Data Management Section
                dataManagementSection
                
                // About Section
                aboutSection
            }
            .navigationTitle("Settings")
        }
        .alert("Reset Progress", isPresented: $showingResetConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                appViewModel.resetAllProgress()
            }
        } message: {
            Text("This action cannot be undone. All your progress and statistics will be permanently deleted.")
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
        .sheet(isPresented: $showingPrivacyPolicy) {
            PrivacyPolicyView()
        }
    }
    
    // MARK: - User Profile Section
    
    private var userProfileSection: some View {
        Section {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Progress")
                        .font(AppTheme.Typography.headline)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Total Questions")
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(.secondary)
                            Text("1,247")
                                .font(AppTheme.Typography.title3)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.Colors.skyBlue)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Accuracy")
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(.secondary)
                            Text("85%")
                                .font(AppTheme.Typography.title3)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.Colors.sageGreen)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Current Streak")
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(.secondary)
                            Text("12 days")
                                .font(AppTheme.Typography.title3)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.Colors.coral)
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(colorScheme == .dark ? AppTheme.Colors.darkSurface : AppTheme.Colors.offWhite)
            )
        } header: {
            Text("Profile")
        }
    }
    
    // MARK: - Language Section
    
    private var languageSection: some View {
        Section("Language") {
            HStack {
                Image(systemName: "globe")
                    .foregroundColor(AppTheme.Colors.skyBlue)
                    .frame(width: 20)
                
                Text(NSLocalizedString("language", comment: ""))
                
                Spacer()
                
                Picker("Language", selection: Binding(
                    get: { appViewModel.appSettings.language },
                    set: { appViewModel.updateSetting(\.language, value: $0) }
                )) {
                    Text("English").tag(Language.english)
                    Text("Français").tag(Language.french)
                }
                .pickerStyle(MenuPickerStyle())
            }
        }
    }
    
    // MARK: - Appearance Section
    
    private var appearanceSection: some View {
        Section("Appearance") {
            // Dark Mode Toggle
            HStack {
                Image(systemName: "paintbrush")
                    .foregroundColor(AppTheme.Colors.skyBlue)
                    .frame(width: 20)
                
                Text(NSLocalizedString("dark_mode", comment: ""))
                
                Spacer()
                
                Toggle("", isOn: Binding(
                    get: { appViewModel.appSettings.isDarkMode },
                    set: { appViewModel.updateSetting(\.isDarkMode, value: $0) }
                ))
                .toggleStyle(SwitchToggleStyle(tint: AppTheme.Colors.skyBlue))
            }
            
            // Font Size
            HStack {
                Image(systemName: "textformat.size")
                    .foregroundColor(AppTheme.Colors.skyBlue)
                    .frame(width: 20)
                
                Text(NSLocalizedString("font_size", comment: ""))
                
                Spacer()
                
                Picker("Font Size", selection: Binding(
                    get: { appViewModel.appSettings.fontSize },
                    set: { appViewModel.updateSetting(\.fontSize, value: $0) }
                )) {
                    ForEach(FontSize.allCases, id: \.self) { size in
                        Text(size.displayName).tag(size)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
        }
    }
    
    // MARK: - Audio & Haptics Section
    
    private var audioHapticsSection: some View {
        Section("Audio & Haptics") {
            // Sound Effects
            HStack {
                Image(systemName: "speaker.wave.2")
                    .foregroundColor(AppTheme.Colors.skyBlue)
                    .frame(width: 20)
                
                Text(NSLocalizedString("sound_effects", comment: ""))
                
                Spacer()
                
                Toggle("", isOn: Binding(
                    get: { appViewModel.appSettings.isSoundEnabled },
                    set: { appViewModel.updateSetting(\.isSoundEnabled, value: $0) }
                ))
                .toggleStyle(SwitchToggleStyle(tint: AppTheme.Colors.skyBlue))
            }
            
            // Haptic Feedback
            HStack {
                Image(systemName: "iphone.radiowaves.left.and.right")
                    .foregroundColor(AppTheme.Colors.skyBlue)
                    .frame(width: 20)
                
                Text(NSLocalizedString("haptic_feedback", comment: ""))
                
                Spacer()
                
                Toggle("", isOn: Binding(
                    get: { appViewModel.appSettings.isHapticsEnabled },
                    set: { appViewModel.updateSetting(\.isHapticsEnabled, value: $0) }
                ))
                .toggleStyle(SwitchToggleStyle(tint: AppTheme.Colors.skyBlue))
            }
        }
    }
    
    // MARK: - Test Settings Section
    
    private var testSettingsSection: some View {
        Section("Test Settings") {
            // Timer Warnings
            HStack {
                Image(systemName: "clock.badge.exclamationmark")
                    .foregroundColor(AppTheme.Colors.skyBlue)
                    .frame(width: 20)
                
                Text(NSLocalizedString("timer_warnings", comment: ""))
                
                Spacer()
                
                Toggle("", isOn: Binding(
                    get: { appViewModel.appSettings.timerWarnings },
                    set: { appViewModel.updateSetting(\.timerWarnings, value: $0) }
                ))
                .toggleStyle(SwitchToggleStyle(tint: AppTheme.Colors.skyBlue))
            }
            
            // Auto Submit
            HStack {
                Image(systemName: "clock.arrow.circlepath")
                    .foregroundColor(AppTheme.Colors.skyBlue)
                    .frame(width: 20)
                
                Text(NSLocalizedString("auto_submit", comment: ""))
                
                Spacer()
                
                Toggle("", isOn: Binding(
                    get: { appViewModel.appSettings.autoSubmitOnTimeout },
                    set: { appViewModel.updateSetting(\.autoSubmitOnTimeout, value: $0) }
                ))
                .toggleStyle(SwitchToggleStyle(tint: AppTheme.Colors.skyBlue))
            }
            
            // Weekly Goal
            NavigationLink(destination: WeeklyGoalView()) {
                HStack {
                    Image(systemName: "target")
                        .foregroundColor(AppTheme.Colors.skyBlue)
                        .frame(width: 20)
                    
                    Text(NSLocalizedString("weekly_goal", comment: ""))
                    
                    Spacer()
                    
                    Text("\(appViewModel.userProgress.weeklyGoal)")
                        .foregroundColor(AppTheme.Colors.mediumGray)
                }
            }
        }
    }
    
    // MARK: - Data Management Section
    
    private var dataManagementSection: some View {
        Section("Data Management") {
            // Export Progress
            Button(action: exportProgress) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(AppTheme.Colors.skyBlue)
                        .frame(width: 20)
                    
                    Text(NSLocalizedString("export_progress", comment: ""))
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
                }
            }
            
            // Reset Progress
            Button(action: { showingResetConfirmation = true }) {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundColor(AppTheme.Colors.softRed)
                        .frame(width: 20)
                    
                    Text(NSLocalizedString("reset_progress", comment: ""))
                        .foregroundColor(AppTheme.Colors.softRed)
                }
            }
        }
    }
    
    // MARK: - About Section
    
    private var aboutSection: some View {
        Section("About") {
            // App Version
            HStack {
                Image(systemName: "info.circle")
                    .foregroundColor(AppTheme.Colors.skyBlue)
                    .frame(width: 20)
                
                Text("Version")
                
                Spacer()
                
                Text(getAppVersion())
                    .foregroundColor(AppTheme.Colors.mediumGray)
            }
            
            // About App
            Button(action: { showingAbout = true }) {
                HStack {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(AppTheme.Colors.skyBlue)
                        .frame(width: 20)
                    
                    Text(NSLocalizedString("about_app", comment: ""))
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
                }
            }
            
            // Privacy Policy
            Button(action: { showingPrivacyPolicy = true }) {
                HStack {
                    Image(systemName: "hand.raised")
                        .foregroundColor(AppTheme.Colors.skyBlue)
                        .frame(width: 20)
                    
                    Text(NSLocalizedString("privacy_policy", comment: ""))
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
                }
            }
            
            // Contact Support
            Button(action: contactSupport) {
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(AppTheme.Colors.skyBlue)
                        .frame(width: 20)
                    
                    Text(NSLocalizedString("contact_support", comment: ""))
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func exportProgress() {
        let progressReport = appViewModel.exportProgressReport()
        
        let activityVC = UIActivityViewController(
            activityItems: [progressReport],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
    
    private func getAppVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }
    
    private func contactSupport() {
        if let url = URL(string: "mailto:support@ccatprep.com") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Supporting Views

struct WeeklyGoalView: View {
    @Environment(AppViewModel.self) private var appViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var goalValue: Double = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: AppTheme.Spacing.lg) {
                Text("Set Your Weekly Goal")
                    .font(AppTheme.Typography.headline)
                    .padding()
                
                VStack(spacing: AppTheme.Spacing.md) {
                    Text("\(Int(goalValue)) questions per week")
                        .font(AppTheme.Typography.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.Colors.skyBlue)
                    
                    Slider(
                        value: $goalValue,
                        in: 10...100,
                        step: 5
                    )
                    .accentColor(AppTheme.Colors.skyBlue)
                    .padding(.horizontal)
                    
                    HStack {
                        Text("10")
                        Spacer()
                        Text("100")
                    }
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                }
                .padding()
                
                Spacer()
                
                Button(action: {
                    appViewModel.updateWeeklyGoal(Int(goalValue))
                    dismiss()
                }) {
                    Text("Save Goal")
                        .font(AppTheme.Typography.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.Colors.skyBlue)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                }
                .padding()
            }
            .navigationTitle("Weekly Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            goalValue = Double(appViewModel.userProgress.weeklyGoal)
        }
    }
}

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.xl) {
                    // App Icon and Title
                    VStack(spacing: AppTheme.Spacing.md) {
                        Image(systemName: "brain.head.profile.fill")
                            .font(.system(size: 80))
                            .foregroundColor(AppTheme.Colors.skyBlue)
                        
                        Text(NSLocalizedString("app_name", comment: ""))
                            .font(AppTheme.Typography.largeTitle)
                            .fontWeight(.thin)
                            .multilineTextAlignment(.center)
                        
                        Text(NSLocalizedString("app_subtitle", comment: ""))
                            .font(AppTheme.Typography.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Features Section
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        Text("Features")
                            .font(AppTheme.Typography.headline)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            FeatureRow(icon: "brain", title: "CCAT-7 Practice", description: "Comprehensive test preparation")
                            FeatureRow(icon: "globe", title: "Bilingual Support", description: "English and French content")
                            FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Progress Tracking", description: "Monitor your improvement")
                            FeatureRow(icon: "target", title: "Adaptive Learning", description: "Personalized question difficulty")
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(AppTheme.Colors.skyBlue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppTheme.Typography.body)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    Text("Privacy Policy")
                        .font(AppTheme.Typography.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Your privacy is important to us. This privacy policy explains how we collect, use, and protect your information when you use ExcelCCAT.")
                        .font(AppTheme.Typography.body)
                    
                    Text("Data Collection")
                        .font(AppTheme.Typography.headline)
                        .fontWeight(.semibold)
                    
                    Text("We collect only the data necessary to provide you with the best learning experience. This includes your test scores, progress data, and app usage statistics.")
                        .font(AppTheme.Typography.body)
                    
                    Text("Data Usage")
                        .font(AppTheme.Typography.headline)
                        .fontWeight(.semibold)
                    
                    Text("Your data is used solely to improve your learning experience and provide personalized recommendations. We do not share your personal data with third parties.")
                        .font(AppTheme.Typography.body)
                    
                    Text("Contact Us")
                        .font(AppTheme.Typography.headline)
                        .fontWeight(.semibold)
                    
                    Text("If you have any questions about this privacy policy, please contact us at support@ccatprep.com")
                        .font(AppTheme.Typography.body)
                }
                .padding()
            }
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
