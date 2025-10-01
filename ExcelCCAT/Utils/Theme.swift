//
//  Theme.swift
//  ExcelCCAT
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

// MARK: - Supporting Types

enum FontSize: String, CaseIterable, Codable {
    case small = "small"
    case medium = "medium"
    case large = "large"
    case extraLarge = "extra_large"
    
    var displayName: String {
        switch self {
        case .small:
            return NSLocalizedString("font_size_small", comment: "")
        case .medium:
            return NSLocalizedString("font_size_medium", comment: "")
        case .large:
            return NSLocalizedString("font_size_large", comment: "")
        case .extraLarge:
            return NSLocalizedString("font_size_extra_large", comment: "")
        }
    }
}

enum Theme: String, CaseIterable, Codable {
    case light = "light"
    case dark = "dark"
    case system = "system"
    
    var displayName: String {
        switch self {
        case .light:
            return NSLocalizedString("theme_light", comment: "Light theme")
        case .dark:
            return NSLocalizedString("theme_dark", comment: "Dark theme")
        case .system:
            return NSLocalizedString("theme_system", comment: "System theme")
        }
    }
}

// MARK: - App Theme and Design System

struct AppTheme {
    
    // MARK: - Color Palette
    struct Colors {
        // Primary Colors - Bilingual-Adaptive
        static let skyBlue = Color(red: 74/255, green: 144/255, blue: 226/255) // #4A90E2
        static let sageGreen = Color(red: 126/255, green: 211/255, blue: 33/255) // #7ED321
        static let sunnyYellow = Color(red: 247/255, green: 220/255, blue: 111/255) // #F7DC6F
        static let softRed = Color(red: 231/255, green: 76/255, blue: 60/255) // #E74C3C
        
        // Neutral Colors
        static let offWhite = Color(red: 248/255, green: 249/255, blue: 250/255) // #F8F9FA
        static let softGray = Color(red: 52/255, green: 73/255, blue: 94/255) // #34495E
        static let lightGray = Color(red: 236/255, green: 240/255, blue: 241/255) // #ECF0F1
        static let mediumGray = Color(red: 149/255, green: 165/255, blue: 166/255) // #95A5A6
        
        // Accent Colors
        static let lavender = Color(red: 215/255, green: 189/255, blue: 226/255) // #D7BDE2
        static let coral = Color(red: 255/255, green: 154/255, blue: 162/255) // #FF9AA2
        static let mint = Color(red: 163/255, green: 228/255, blue: 215/255) // #A3E4D7
        
        // Gradients
        static let primaryGradient = LinearGradient(
            colors: [skyBlue, sageGreen],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let frenchModeGradient = LinearGradient(
            colors: [skyBlue, lavender],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let successGradient = LinearGradient(
            colors: [sageGreen, mint],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        static let warningGradient = LinearGradient(
            colors: [sunnyYellow, coral],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        static let timerGradient = LinearGradient(
            colors: [sageGreen, sunnyYellow, softRed],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        // Dark Mode Colors
        static let darkBackground = Color(red: 44/255, green: 62/255, blue: 80/255) // #2C3E50
        static let darkSurface = Color(red: 52/255, green: 73/255, blue: 94/255) // #34495E
        static let darkText = Color(red: 236/255, green: 240/255, blue: 241/255) // #ECF0F1
    }
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = Font.system(.largeTitle, design: .rounded, weight: .thin)
        static let title = Font.system(.title, design: .rounded, weight: .medium)
        static let title2 = Font.system(.title2, design: .rounded, weight: .medium)
        static let title3 = Font.system(.title3, design: .rounded, weight: .medium)
        static let headline = Font.system(.headline, design: .rounded, weight: .semibold)
        static let subheadline = Font.system(.subheadline, design: .rounded, weight: .medium)
        static let body = Font.system(.body, design: .rounded, weight: .regular)
        static let callout = Font.system(.callout, design: .rounded, weight: .medium)
        static let footnote = Font.system(.footnote, design: .rounded, weight: .regular)
        static let caption = Font.system(.caption, design: .rounded, weight: .regular)
        
        // Question-specific fonts
        static let questionStem = Font.system(size: 24, weight: .medium, design: .rounded)
        static let questionOptions = Font.system(size: 20, weight: .regular, design: .rounded)
        static let timerText = Font.system(size: 18, weight: .semibold, design: .rounded)
        
        // Accessibility support
        static func scaledFont(_ font: Font, with textSize: FontSize) -> Font {
            switch textSize {
            case .small:
                return font
            case .medium:
                return font
            case .large:
                return Font.system(size: 22, weight: .medium, design: .rounded)
            case .extraLarge:
                return Font.system(size: 26, weight: .medium, design: .rounded)
            }
        }
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        
        // Component-specific spacing
        static let cardPadding: CGFloat = 20
        static let buttonPadding: CGFloat = 16
        static let sectionSpacing: CGFloat = 24
        static let questionSpacing: CGFloat = 32
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 24
        
        // Component-specific radius
        static let card: CGFloat = 16
        static let button: CGFloat = 12
        static let choice: CGFloat = 24 // For circular choice buttons
    }
    
    // MARK: - Shadows
    struct Shadows {
        static let light = Color.black.opacity(0.1)
        static let medium = Color.black.opacity(0.15)
        static let heavy = Color.black.opacity(0.25)
        
        static let cardShadow = Color.black.opacity(0.08)
        static let buttonShadow = Color.black.opacity(0.12)
        static let modalShadow = Color.black.opacity(0.3)
    }
    
    // MARK: - Animation
    struct Animation {
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let smooth = SwiftUI.Animation.easeInOut(duration: 0.4)
        static let bounce = SwiftUI.Animation.spring(dampingFraction: 0.6)
        static let scale = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.8)
        
        // Component-specific animations
        static let buttonTap = SwiftUI.Animation.easeInOut(duration: 0.1)
        static let cardFlip = SwiftUI.Animation.easeInOut(duration: 0.5)
        static let slideTransition = SwiftUI.Animation.easeInOut(duration: 0.4)
        static let confetti = SwiftUI.Animation.easeOut(duration: 1.0)
    }
}

// MARK: - Custom View Modifiers

struct CardStyle: ViewModifier {
    let isSelected: Bool
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .padding(AppTheme.Spacing.cardPadding)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                    .fill(colorScheme == .dark ? AppTheme.Colors.darkSurface : Color.white)
                    .shadow(
                        color: isSelected ? AppTheme.Colors.skyBlue.opacity(0.3) : AppTheme.Shadows.cardShadow,
                        radius: isSelected ? 8 : 4,
                        x: 0,
                        y: isSelected ? 4 : 2
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                    .stroke(
                        isSelected ? AppTheme.Colors.skyBlue : Color.clear,
                        lineWidth: isSelected ? 2 : 0
                    )
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(AppTheme.Animation.scale, value: isSelected)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    let isEnabled: Bool
    @Environment(\.colorScheme) var colorScheme
    
    init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTheme.Typography.headline)
            .foregroundColor(.white)
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.button)
                    .fill(
                        isEnabled
                        ? AppTheme.Colors.primaryGradient
                        : LinearGradient(colors: [AppTheme.Colors.mediumGray], startPoint: .leading, endPoint: .trailing)
                    )
            )
            .shadow(
                color: AppTheme.Shadows.buttonShadow,
                radius: 4,
                x: 0,
                y: 2
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(AppTheme.Animation.buttonTap, value: configuration.isPressed)
            .disabled(!isEnabled)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTheme.Typography.callout)
            .foregroundColor(AppTheme.Colors.skyBlue)
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.vertical, AppTheme.Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.button)
                    .stroke(AppTheme.Colors.skyBlue, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(AppTheme.Animation.buttonTap, value: configuration.isPressed)
    }
}

struct ChoiceButtonStyle: ButtonStyle {
    let isSelected: Bool
    let isCorrect: Bool?
    let showResult: Bool
    @Environment(\.colorScheme) var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTheme.Typography.questionOptions)
            .foregroundColor(textColor)
            .multilineTextAlignment(.center)
            .padding(AppTheme.Spacing.md)
            .frame(minWidth: 60, minHeight: 60)
            .background(
                Circle()
                    .fill(backgroundColor)
                    .overlay(
                        Circle()
                            .stroke(borderColor, lineWidth: 2)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : (isSelected ? 1.05 : 1.0))
            .animation(AppTheme.Animation.scale, value: isSelected)
            .animation(AppTheme.Animation.buttonTap, value: configuration.isPressed)
    }
    
    private var textColor: Color {
        if showResult {
            if let isCorrect = isCorrect, isCorrect {
                return .white
            } else if isSelected {
                return .white
            }
        }
        return colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray
    }
    
    private var backgroundColor: Color {
        if showResult {
            if let isCorrect = isCorrect, isCorrect {
                return AppTheme.Colors.sageGreen
            } else if isSelected {
                return AppTheme.Colors.softRed
            }
        } else if isSelected {
            return AppTheme.Colors.skyBlue
        }
        return colorScheme == .dark ? AppTheme.Colors.darkSurface : Color.white
    }
    
    private var borderColor: Color {
        if showResult {
            if let isCorrect = isCorrect, isCorrect {
                return AppTheme.Colors.sageGreen
            } else if isSelected {
                return AppTheme.Colors.softRed
            }
        } else if isSelected {
            return AppTheme.Colors.skyBlue
        }
        return AppTheme.Colors.lightGray
    }
}

struct ProgressRingStyle: View {
    let progress: Double
    let size: CGFloat
    let lineWidth: CGFloat
    let color: Color
    
    init(progress: Double, size: CGFloat = 120, lineWidth: CGFloat = 12, color: Color = AppTheme.Colors.skyBlue) {
        self.progress = progress
        self.size = size
        self.lineWidth = lineWidth
        self.color = color
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(AppTheme.Colors.lightGray, lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(AppTheme.Animation.smooth, value: progress)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - View Extensions

extension View {
    func cardStyle(isSelected: Bool = false) -> some View {
        modifier(CardStyle(isSelected: isSelected))
    }
    
    func primaryButtonStyle(isEnabled: Bool = true) -> some View {
        buttonStyle(PrimaryButtonStyle(isEnabled: isEnabled))
    }
    
    func secondaryButtonStyle() -> some View {
        buttonStyle(SecondaryButtonStyle())
    }
    
    func choiceButtonStyle(isSelected: Bool, isCorrect: Bool? = nil, showResult: Bool = false) -> some View {
        buttonStyle(ChoiceButtonStyle(isSelected: isSelected, isCorrect: isCorrect, showResult: showResult))
    }
    
    func hapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> some View {
        onTapGesture {
            let impactFeedback = UIImpactFeedbackGenerator(style: style)
            impactFeedback.impactOccurred()
        }
    }
    
    func shimmer(isActive: Bool = true) -> some View {
        modifier(ShimmerEffect(isActive: isActive))
    }
}

// MARK: - Shimmer Effect for Loading States

struct ShimmerEffect: ViewModifier {
    let isActive: Bool
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.clear,
                                AppTheme.Colors.lightGray.opacity(0.6),
                                Color.clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: phase)
                    .opacity(isActive ? 1 : 0)
            )
            .onAppear {
                if isActive {
                    withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                        phase = 200
                    }
                }
            }
    }
}

// MARK: - Accessibility Support

struct AccessibilityLabel: View {
    let text: String
    let language: Language
    
    var body: some View {
        Text(text)
            .accessibilityLabel(text)
            .environment(\.locale, Locale(identifier: language.rawValue))
    }
}

// MARK: - Device Size Categories

extension UIDevice {
    var isIPad: Bool {
        userInterfaceIdiom == .pad
    }
    
    var isIPhone: Bool {
        userInterfaceIdiom == .phone
    }
}
