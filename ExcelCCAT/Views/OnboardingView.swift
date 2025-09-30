//
//  OnboardingView.swift
//  ExcelCCAT
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(AppViewModel.self) private var appViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var currentPage = 0
    @State private var selectedLanguage: Language = .english
    @State private var isAnimating = false
    
    private let pages = [
        OnboardingPage(
            titleKey: "welcome_title",
            subtitleKey: "welcome_subtitle",
            imageName: "brain.head.profile",
            features: []
        ),
        OnboardingPage(
            titleKey: "onboarding_features",
            subtitleKey: "app_tagline",
            imageName: "star.circle.fill",
            features: [
                "onboarding_practice",
                "onboarding_mock_tests", 
                "onboarding_progress",
                "onboarding_bilingual"
            ]
        )
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background Gradient
                backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Language Picker
                    languageSelector
                        .padding(.top, geometry.safeAreaInsets.top + AppTheme.Spacing.md)
                    
                    // Content
                    TabView(selection: $currentPage) {
                        ForEach(pages.indices, id: \.self) { index in
                            pageView(pages[index], geometry: geometry)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(AppTheme.Animation.smooth, value: currentPage)
                    
                    // Controls
                    controlsView(geometry: geometry)
                        .padding(.bottom, geometry.safeAreaInsets.bottom + AppTheme.Spacing.md)
                }
            }
        }
        .onAppear {
            withAnimation(AppTheme.Animation.smooth.delay(0.5)) {
                isAnimating = true
            }
        }
    }
    
    // MARK: - Background
    
    private var backgroundGradient: some View {
        Group {
            if selectedLanguage == .french {
                AppTheme.Colors.frenchModeGradient
            } else {
                AppTheme.Colors.primaryGradient
            }
        }
        .animation(AppTheme.Animation.smooth, value: selectedLanguage)
    }
    
    // MARK: - Language Selector
    
    private var languageSelector: some View {
        HStack(spacing: AppTheme.Spacing.lg) {
            ForEach(Language.allCases, id: \.self) { language in
                Button(action: {
                    withAnimation(AppTheme.Animation.quick) {
                        selectedLanguage = language
                    }
                }) {
                    HStack(spacing: AppTheme.Spacing.sm) {
                        Text(language.flag)
                            .font(.title2)
                        
                        Text(language.displayName)
                            .font(AppTheme.Typography.callout)
                            .fontWeight(selectedLanguage == language ? .semibold : .medium)
                    }
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.vertical, AppTheme.Spacing.sm)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                            .fill(
                                selectedLanguage == language
                                ? Color.white.opacity(0.3)
                                : Color.white.opacity(0.1)
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                            .stroke(
                                selectedLanguage == language
                                ? Color.white
                                : Color.white.opacity(0.3),
                                lineWidth: selectedLanguage == language ? 2 : 1
                            )
                    )
                }
                .foregroundColor(.white)
                .scaleEffect(selectedLanguage == language ? 1.05 : 1.0)
                .animation(AppTheme.Animation.scale, value: selectedLanguage)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
    }
    
    // MARK: - Page View
    
    private func pageView(_ page: OnboardingPage, geometry: GeometryProxy) -> some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            Spacer()
            
            // Icon
            Image(systemName: page.imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(.white)
                .scaleEffect(isAnimating ? 1.0 : 0.5)
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(
                    AppTheme.Animation.smooth.delay(Double(currentPage) * 0.2),
                    value: isAnimating
                )
            
            // Title and Subtitle
            VStack(spacing: AppTheme.Spacing.md) {
                Text(NSLocalizedString(page.titleKey, comment: ""))
                    .font(AppTheme.Typography.largeTitle)
                    .fontWeight(.thin)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(
                        AppTheme.Animation.smooth.delay(Double(currentPage) * 0.2 + 0.3),
                        value: isAnimating
                    )
                
                Text(NSLocalizedString(page.subtitleKey, comment: ""))
                    .font(AppTheme.Typography.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(
                        AppTheme.Animation.smooth.delay(Double(currentPage) * 0.2 + 0.5),
                        value: isAnimating
                    )
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            
            // Features List (if present)
            if !page.features.isEmpty {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    ForEach(Array(page.features.enumerated()), id: \.offset) { index, feature in
                        featureRow(feature, index: index)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
                .opacity(isAnimating ? 1.0 : 0.0)
                .offset(y: isAnimating ? 0 : 30)
                .animation(
                    AppTheme.Animation.smooth.delay(Double(currentPage) * 0.2 + 0.7),
                    value: isAnimating
                )
            }
            
            Spacer()
        }
    }
    
    private func featureRow(_ featureKey: String, index: Int) -> some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.md) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(AppTheme.Colors.sageGreen)
                .font(.title3)
                .scaleEffect(isAnimating ? 1.0 : 0.0)
                .animation(
                    AppTheme.Animation.bounce.delay(0.8 + Double(index) * 0.1),
                    value: isAnimating
                )
            
            Text(NSLocalizedString(featureKey, comment: ""))
                .font(AppTheme.Typography.body)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.leading)
        }
    }
    
    // MARK: - Controls
    
    private func controlsView(geometry: GeometryProxy) -> some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            // Page Indicator
            HStack(spacing: AppTheme.Spacing.sm) {
                ForEach(pages.indices, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? Color.white : Color.white.opacity(0.4))
                        .frame(width: 8, height: 8)
                        .scaleEffect(currentPage == index ? 1.2 : 1.0)
                        .animation(AppTheme.Animation.quick, value: currentPage)
                }
            }
            
            // Buttons
            HStack(spacing: AppTheme.Spacing.md) {
                if currentPage > 0 {
                    Button(action: previousPage) {
                        Text(NSLocalizedString("previous", comment: ""))
                            .font(AppTheme.Typography.callout)
                            .foregroundColor(.white)
                            .padding(.horizontal, AppTheme.Spacing.lg)
                            .padding(.vertical, AppTheme.Spacing.md)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.button)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    }
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                }
                
                Spacer()
                
                Button(action: nextOrComplete) {
                    Text(isLastPage ? NSLocalizedString("get_started", comment: "") : NSLocalizedString("next", comment: ""))
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(selectedLanguage == .french ? AppTheme.Colors.lavender : AppTheme.Colors.skyBlue)
                        .padding(.horizontal, AppTheme.Spacing.xl)
                        .padding(.vertical, AppTheme.Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.button)
                                .fill(Color.white)
                        )
                        .shadow(color: AppTheme.Shadows.buttonShadow, radius: 4, x: 0, y: 2)
                }
                .scaleEffect(isAnimating ? 1.0 : 0.8)
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(
                    AppTheme.Animation.bounce.delay(1.0),
                    value: isAnimating
                )
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            
            // Skip Button
            if !isLastPage {
                Button(action: complete) {
                    Text(NSLocalizedString("skip_intro", comment: ""))
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(.white.opacity(0.7))
                        .underline()
                }
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(
                    AppTheme.Animation.smooth.delay(1.2),
                    value: isAnimating
                )
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var isLastPage: Bool {
        currentPage == pages.count - 1
    }
    
    // MARK: - Actions
    
    private func nextOrComplete() {
        if isLastPage {
            complete()
        } else {
            nextPage()
        }
    }
    
    private func nextPage() {
        withAnimation(AppTheme.Animation.smooth) {
            currentPage = min(currentPage + 1, pages.count - 1)
        }
    }
    
    private func previousPage() {
        withAnimation(AppTheme.Animation.smooth) {
            currentPage = max(currentPage - 1, 0)
        }
    }
    
    private func complete() {
        appViewModel.changeLanguage(to: selectedLanguage)
        
        withAnimation(AppTheme.Animation.smooth) {
            appViewModel.completeOnboarding()
        }
    }
}

// MARK: - Supporting Types

struct OnboardingPage {
    let titleKey: String
    let subtitleKey: String
    let imageName: String
    let features: [String]
}

#Preview {
    OnboardingView()
        .environment(AppViewModel())
}
