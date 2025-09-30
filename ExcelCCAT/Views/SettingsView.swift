//
//  SettingsView.swift
//  ExcelCCAT
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

struct SettingsView: View {
    @Environment(AppViewModel.self) private var appViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var showingResetConfirmation = false
    @State private var showingAbout = false
    @State private var showingPrivacyPolicy = false
    
    var body: some View {
        NavigationView {
            List {
                // Language Section
                languageSection
                
                // Appearance Section
                Section(header: Text("Appearance")) {
                    appearanceSection
                }
                
                // Audio & Haptics Section
                audioHapticsSection
                
                // Test Settings Section
                testSettingsSection
                
                // Data Management Section
                dataManagementSection
                
                // About Section
                aboutSection
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(NSLocalizedString("settings_title", comment: ""))
            .navigationBarTitleDisplayMode(.large)
        }
        .alert("Reset Progress", isPresented: $showingResetConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                appViewModel.resetAllProgress()
            }
        } message: {
            Text(NSLocalizedString("confirm_reset_progress_message", comment: ""))
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
        .sheet(isPresented: $showingPrivacyPolicy) {
            PrivacyPolicyView()
        }
    }
    
    // MARK: - Language Section
    
    private var languageSection: some View {
        Section {
            HStack {
                Image(systemName: "globe")
                    .foregroundColor(AppTheme.Colors.skyBlue)
                    .frame(width: 20)
                
                Text(NSLocalizedString("language_settings", comment: ""))
                
                Spacer()
                
                Picker("Language", selection: Binding(
                    get: { appViewModel.currentLanguage },
                    set: { appViewModel.changeLanguage(to: $0) }
                )) {
                    ForEach(Language.allCases, id: \.self) { language in
                        HStack {
                            Text(language.flag)
                            Text(language.displayName)
                        }
                        .tag(language)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
        } header: {
            Text("Language")
        } footer: {
            Text("Changing language will restart the current session if one is active.")
                .font(.caption)
        }
    }
    
    // MARK: - Appearance Section
    
    private var appearanceSection: some View {
        VStack(spacing: 16) {
            // Dark Mode Toggle
            HStack {
                Image(systemName: "moon")
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
            
            // Reduce Motion
            HStack {
                Image(systemName: "accessibility")
                    .foregroundColor(AppTheme.Colors.skyBlue)
                    .frame(width: 20)
                
                Text(NSLocalizedString("reduce_motion", comment: ""))
                
                Spacer()
                
                Toggle("", isOn: Binding(
                    get: { appViewModel.appSettings.isReducedMotionEnabled },
                    set: { appViewModel.updateSetting(\.isReducedMotionEnabled, value: $0) }
                ))
                .toggleStyle(SwitchToggleStyle(tint: AppTheme.Colors.skyBlue))
            }
        }
    }    // MARK: - Audio & Haptics Section
    
    private var audioHapticsSection: some View {
        Section("Audio & Haptics") {
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
            
            // Sound Effects
            HStack {
                Image(systemName: "speaker.2")
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
                    
                    Text(NSLocalizedString("about", comment: ""))
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
    @State private var goalValue: Double
    
    init() {
        _goalValue = State(initialValue: 50.0) // Default value, will be updated in onAppear
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: AppTheme.Spacing.xl) {
                VStack(spacing: AppTheme.Spacing.md) {
                    Text("Weekly Goal")
                        .font(AppTheme.Typography.largeTitle)
                        .fontWeight(.thin)
                    
                    Text("Set your weekly question target")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: AppTheme.Spacing.lg) {
                    Text("\(Int(goalValue))")
                        .font(.system(size: 60, weight: .thin, design: .rounded))
                        .foregroundColor(AppTheme.Colors.skyBlue)
                    
                    Text("questions per week")
                        .font(AppTheme.Typography.callout)
                        .foregroundColor(.secondary)
                    
                    Slider(value: $goalValue, in: 10...200, step: 5)
                        .tint(AppTheme.Colors.skyBlue)
                        .padding(.horizontal, AppTheme.Spacing.lg)
                }
                
                Spacer()
                
                Button("Save Goal") {
                    appViewModel.userProgress.weeklyGoal = Int(goalValue)
                    appViewModel.saveUserData()
                    dismiss()
                }
                .primaryButtonStyle()
                .padding(.horizontal, AppTheme.Spacing.lg)
            }
            .padding(AppTheme.Spacing.lg)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
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
                    
                    // App Description
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        Text("About This App")
                            .font(AppTheme.Typography.headline)
                        
                        Text("""
                        ExcelCCAT is designed specifically for students preparing for the Canadian Cognitive Abilities Test (CCAT-7 Level 12) used by the Toronto District School Board (TDSB) for gifted program screening.
                        
                        Our app provides:
                        • Full mock tests matching the real CCAT format
                        • Practice sessions for each question type
                        • Bilingual support (English/French)
                        • Detailed progress tracking
                        • Performance insights and recommendations
                        
                        All content is offline and designed to reduce test anxiety while building confidence.
                        """)
                        .font(AppTheme.Typography.body)
                        .foregroundColor(.secondary)
                    }
                    .cardStyle()
                    
                    // Contact Information
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        Text("Contact & Support")
                            .font(AppTheme.Typography.headline)
                        
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            Text("Email: support@ccatprep.com")
                            Text("Website: www.ccatprep.com")
                            Text("Version: \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0")")
                        }
                        .font(AppTheme.Typography.body)
                        .foregroundColor(.secondary)
                    }
                    .cardStyle()
                }
                .padding(AppTheme.Spacing.lg)
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

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    Text("""
                    Privacy Policy
                    
                    Last updated: September 30, 2025
                    
                    Data Collection
                    ExcelCCAT is designed with privacy in mind. We collect minimal data necessary for app functionality:
                    • Test scores and progress data (stored locally on your device)
                    • App usage analytics (anonymized)
                    • Crash reports (if you opt-in)
                    
                    Data Storage
                    All your personal test data and progress is stored locally on your device using secure iOS storage mechanisms. We do not upload your test results or personal information to external servers.
                    
                    Data Sharing
                    We do not share, sell, or distribute your personal information to third parties. Your test scores and progress remain private to you.
                    
                    Children's Privacy (COPPA Compliance)
                    This app is designed for students, including those under 13. We comply with COPPA requirements:
                    • No personal information is collected without parental consent
                    • All data processing is done locally on the device
                    • No behavioral advertising or data profiling
                    
                    Data Deletion
                    You can delete all your data at any time using the "Reset Progress" option in Settings. This action is irreversible.
                    
                    Contact Us
                    If you have questions about this privacy policy, contact us at privacy@ccatprep.com
                    """)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(.secondary)
                }
                .padding(AppTheme.Spacing.lg)
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

#Preview {
    SettingsView()
        .environment(AppViewModel())
}
