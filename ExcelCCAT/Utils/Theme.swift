//
//  Theme.swift
//  ExcelCCAT
//
//  Modern Design System with Glassmorphism
//  Created by Rajkumar Natarajan on 2025-09-30.
//  Updated: December 15, 2025 - Modern UI Redesign
//

import SwiftUI
import UIKit

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
    
    var scale: CGFloat {
        switch self {
        case .small: return 0.85
        case .medium: return 1.0
        case .large: return 1.15
        case .extraLarge: return 1.3
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

// MARK: - Modern App Theme

struct AppTheme {
    
    // MARK: - Modern Color Palette
    struct Colors {
        // Primary Brand Colors - Modern & Fresh
        static let primaryIndigo = Color(hex: "6366F1")     // Modern indigo
        static let primaryPurple = Color(hex: "8B5CF6")     // Vibrant purple
        static let primaryCyan = Color(hex: "06B6D4")       // Fresh cyan
        
        // Accent Colors
        static let accentRose = Color(hex: "F43F5E")        // Modern rose
        static let accentAmber = Color(hex: "F59E0B")       // Warm amber
        static let accentEmerald = Color(hex: "10B981")     // Success emerald
        static let accentSky = Color(hex: "0EA5E9")         // Sky blue
        
        // Legacy Color Names (for backward compatibility)
        static let skyBlue = primaryIndigo
        static let sageGreen = accentEmerald
        static let sunnyYellow = accentAmber
        static let softRed = accentRose
        static let lavender = primaryPurple
        static let coral = Color(hex: "FF6B6B")
        static let mint = Color(hex: "4ECDC4")
        
        // Neutral Colors - Modern Gray Scale
        static let slate900 = Color(hex: "0F172A")
        static let slate800 = Color(hex: "1E293B")
        static let slate700 = Color(hex: "334155")
        static let slate600 = Color(hex: "475569")
        static let slate500 = Color(hex: "64748B")
        static let slate400 = Color(hex: "94A3B8")
        static let slate300 = Color(hex: "CBD5E1")
        static let slate200 = Color(hex: "E2E8F0")
        static let slate100 = Color(hex: "F1F5F9")
        static let slate50 = Color(hex: "F8FAFC")
        
        // Legacy neutral names
        static let offWhite = slate50
        static let lightGray = slate200
        static let mediumGray = slate500
        static let softGray = slate700
        static let darkBackground = slate900
        static let darkSurface = slate800
        static let darkText = slate100
        
        // Glassmorphism Colors
        static let glassWhite = Color.white.opacity(0.15)
        static let glassDark = Color.black.opacity(0.2)
        static let glassBorder = Color.white.opacity(0.25)
        
        // Modern Gradients
        static let primaryGradient = LinearGradient(
            colors: [primaryIndigo, primaryPurple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let frenchModeGradient = LinearGradient(
            colors: [Color(hex: "3B82F6"), Color(hex: "8B5CF6")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let successGradient = LinearGradient(
            colors: [accentEmerald, Color(hex: "059669")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let warningGradient = LinearGradient(
            colors: [accentAmber, Color(hex: "D97706")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let dangerGradient = LinearGradient(
            colors: [accentRose, Color(hex: "DC2626")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let timerGradient = LinearGradient(
            colors: [primaryCyan, primaryIndigo],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        // Mesh Gradient Background
        static let meshGradient = LinearGradient(
            colors: [
                Color(hex: "667eea").opacity(0.15),
                Color(hex: "764ba2").opacity(0.15),
                Color(hex: "6B8DD6").opacity(0.15)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Background gradients
        static let backgroundGradient = LinearGradient(
            colors: [slate50, Color(hex: "EEF2FF")],
            startPoint: .top,
            endPoint: .bottom
        )
        
        static let darkBackgroundGradient = LinearGradient(
            colors: [slate900, Color(hex: "1E1B4B")],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    // MARK: - Modern Typography
    struct Typography {
        // Display fonts with SF Pro Display
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
        static let title = Font.system(size: 28, weight: .bold, design: .rounded)
        static let title2 = Font.system(size: 22, weight: .semibold, design: .rounded)
        static let title3 = Font.system(size: 20, weight: .semibold, design: .rounded)
        
        // Body fonts
        static let headline = Font.system(size: 17, weight: .semibold, design: .rounded)
        static let body = Font.system(size: 17, weight: .regular, design: .default)
        static let callout = Font.system(size: 16, weight: .medium, design: .default)
        static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
        static let footnote = Font.system(size: 13, weight: .regular, design: .default)
        static let caption = Font.system(size: 12, weight: .medium, design: .default)
        static let caption2 = Font.system(size: 11, weight: .regular, design: .default)
        
        // Special fonts
        static let questionStem = Font.system(size: 18, weight: .medium, design: .rounded)
        static let questionOptions = Font.system(size: 16, weight: .medium, design: .rounded)
        static let timerText = Font.system(size: 20, weight: .bold, design: .monospaced)
        static let scoreText = Font.system(size: 48, weight: .bold, design: .rounded)
        static let statNumber = Font.system(size: 28, weight: .bold, design: .rounded)
    }
    
    // MARK: - Modern Spacing
    struct Spacing {
        static let xxs: CGFloat = 2
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        static let xxxl: CGFloat = 64
        
        static let cardPadding: CGFloat = 20
        static let buttonPadding: CGFloat = 16
        static let sectionSpacing: CGFloat = 28
        static let questionSpacing: CGFloat = 36
    }
    
    // MARK: - Modern Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 24
        static let pill: CGFloat = 100
        
        static let card: CGFloat = 20
        static let button: CGFloat = 14
        static let choice: CGFloat = 28
    }
    
    // MARK: - Modern Shadows
    struct Shadows {
        // Soft shadows for depth
        static let soft = Color.black.opacity(0.04)
        static let medium = Color.black.opacity(0.08)
        static let strong = Color.black.opacity(0.12)
        
        // Colored shadows
        static let indigoShadow = Colors.primaryIndigo.opacity(0.3)
        static let emeraldShadow = Colors.accentEmerald.opacity(0.3)
        static let roseShadow = Colors.accentRose.opacity(0.3)
        
        // Legacy names
        static let light = soft
        static let heavy = strong
        static let cardShadow = medium
        static let buttonShadow = Color.black.opacity(0.15)
        static let modalShadow = Color.black.opacity(0.25)
    }
    
    // MARK: - Modern Animation
    struct Animation {
        static let quick = SwiftUI.Animation.easeOut(duration: 0.15)
        static let smooth = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let bounce = SwiftUI.Animation.spring(response: 0.4, dampingFraction: 0.7)
        static let scale = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.65)
        static let gentle = SwiftUI.Animation.spring(response: 0.5, dampingFraction: 0.8)
        
        static let buttonTap = SwiftUI.Animation.spring(response: 0.2, dampingFraction: 0.6)
        static let cardFlip = SwiftUI.Animation.spring(response: 0.5, dampingFraction: 0.7)
        static let slideTransition = SwiftUI.Animation.spring(response: 0.4, dampingFraction: 0.75)
        static let confetti = SwiftUI.Animation.spring(response: 0.6, dampingFraction: 0.5)
        static let stagger = SwiftUI.Animation.spring(response: 0.45, dampingFraction: 0.7)
    }
}

// MARK: - Color Extension for Hex Support

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Modern Glass Card Style

struct ModernGlassCard: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    let isSelected: Bool
    let cornerRadius: CGFloat
    
    init(isSelected: Bool = false, cornerRadius: CGFloat = AppTheme.CornerRadius.card) {
        self.isSelected = isSelected
        self.cornerRadius = cornerRadius
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // Glass background
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(colorScheme == .dark ?
                              AppTheme.Colors.slate800.opacity(0.8) :
                              Color.white.opacity(0.85))
                    
                    // Subtle gradient overlay
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(colorScheme == .dark ? 0.05 : 0.5),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        isSelected ?
                        AppTheme.Colors.primaryIndigo :
                        (colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.05)),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .shadow(
                color: isSelected ?
                AppTheme.Shadows.indigoShadow :
                (colorScheme == .dark ? Color.black.opacity(0.3) : AppTheme.Shadows.medium),
                radius: isSelected ? 12 : 8,
                x: 0,
                y: isSelected ? 6 : 4
            )
    }
}

// MARK: - Modern Card Style (Solid)

struct ModernCardStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    let isSelected: Bool
    
    func body(content: Content) -> some View {
        content
            .padding(AppTheme.Spacing.cardPadding)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                    .fill(colorScheme == .dark ? AppTheme.Colors.darkSurface : Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                    .stroke(
                        isSelected ? AppTheme.Colors.primaryIndigo : Color.clear,
                        lineWidth: isSelected ? 2 : 0
                    )
            )
            .shadow(
                color: colorScheme == .dark ? Color.black.opacity(0.3) : AppTheme.Shadows.cardShadow,
                radius: isSelected ? 12 : 6,
                x: 0,
                y: isSelected ? 6 : 3
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(AppTheme.Animation.scale, value: isSelected)
    }
}

// MARK: - Legacy Card Style (for backward compatibility)

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
                        color: isSelected ? AppTheme.Colors.primaryIndigo.opacity(0.3) : AppTheme.Shadows.cardShadow,
                        radius: isSelected ? 12 : 6,
                        x: 0,
                        y: isSelected ? 6 : 3
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                    .stroke(
                        isSelected ? AppTheme.Colors.primaryIndigo : Color.clear,
                        lineWidth: isSelected ? 2 : 0
                    )
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(AppTheme.Animation.scale, value: isSelected)
    }
}

// MARK: - Modern Primary Button Style

struct ModernPrimaryButtonStyle: ButtonStyle {
    let isEnabled: Bool
    let gradient: LinearGradient
    @Environment(\.colorScheme) var colorScheme
    
    init(isEnabled: Bool = true, gradient: LinearGradient = AppTheme.Colors.primaryGradient) {
        self.isEnabled = isEnabled
        self.gradient = gradient
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTheme.Typography.headline)
            .foregroundColor(.white)
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.button)
                    .fill(isEnabled ? gradient : LinearGradient(colors: [AppTheme.Colors.mediumGray], startPoint: .leading, endPoint: .trailing))
            )
            .shadow(
                color: isEnabled ? AppTheme.Shadows.indigoShadow : AppTheme.Shadows.soft,
                radius: configuration.isPressed ? 4 : 8,
                x: 0,
                y: configuration.isPressed ? 2 : 4
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(AppTheme.Animation.buttonTap, value: configuration.isPressed)
            .disabled(!isEnabled)
    }
}

// MARK: - Legacy Button Styles

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
                radius: 6,
                x: 0,
                y: 3
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(AppTheme.Animation.buttonTap, value: configuration.isPressed)
            .disabled(!isEnabled)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTheme.Typography.callout)
            .foregroundColor(AppTheme.Colors.primaryIndigo)
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.vertical, AppTheme.Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.button)
                    .stroke(AppTheme.Colors.primaryIndigo, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(AppTheme.Animation.buttonTap, value: configuration.isPressed)
    }
}

// MARK: - Modern Choice Button Style

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
            .shadow(
                color: shadowColor,
                radius: isSelected ? 8 : 4,
                x: 0,
                y: isSelected ? 4 : 2
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
        return isSelected ? .white : (colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
    }
    
    private var backgroundColor: Color {
        if showResult {
            if let isCorrect = isCorrect, isCorrect {
                return AppTheme.Colors.accentEmerald
            } else if isSelected {
                return AppTheme.Colors.accentRose
            }
        } else if isSelected {
            return AppTheme.Colors.primaryIndigo
        }
        return colorScheme == .dark ? AppTheme.Colors.darkSurface : Color.white
    }
    
    private var borderColor: Color {
        if showResult {
            if let isCorrect = isCorrect, isCorrect {
                return AppTheme.Colors.accentEmerald
            } else if isSelected {
                return AppTheme.Colors.accentRose
            }
        } else if isSelected {
            return AppTheme.Colors.primaryIndigo
        }
        return AppTheme.Colors.lightGray
    }
    
    private var shadowColor: Color {
        if showResult {
            if let isCorrect = isCorrect, isCorrect {
                return AppTheme.Shadows.emeraldShadow
            } else if isSelected {
                return AppTheme.Shadows.roseShadow
            }
        } else if isSelected {
            return AppTheme.Shadows.indigoShadow
        }
        return AppTheme.Shadows.soft
    }
}

// MARK: - Modern Progress Ring

struct ProgressRingStyle: View {
    let progress: Double
    let size: CGFloat
    let lineWidth: CGFloat
    let color: Color
    let showGlow: Bool
    
    init(progress: Double, size: CGFloat = 120, lineWidth: CGFloat = 12, color: Color = AppTheme.Colors.primaryIndigo, showGlow: Bool = true) {
        self.progress = progress
        self.size = size
        self.lineWidth = lineWidth
        self.color = color
        self.showGlow = showGlow
    }
    
    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(color.opacity(0.15), lineWidth: lineWidth)
            
            // Progress ring
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    LinearGradient(
                        colors: [color, color.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: showGlow ? color.opacity(0.4) : .clear, radius: 4, x: 0, y: 0)
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
    
    func modernCard(isSelected: Bool = false) -> some View {
        modifier(ModernCardStyle(isSelected: isSelected))
    }
    
    func glassCard(isSelected: Bool = false, cornerRadius: CGFloat = AppTheme.CornerRadius.card) -> some View {
        modifier(ModernGlassCard(isSelected: isSelected, cornerRadius: cornerRadius))
    }
    
    func primaryButtonStyle(isEnabled: Bool = true) -> some View {
        buttonStyle(PrimaryButtonStyle(isEnabled: isEnabled))
    }
    
    func modernPrimaryButton(isEnabled: Bool = true, gradient: LinearGradient = AppTheme.Colors.primaryGradient) -> some View {
        buttonStyle(ModernPrimaryButtonStyle(isEnabled: isEnabled, gradient: gradient))
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
    
    func floatingAnimation(isActive: Bool = true) -> some View {
        modifier(FloatingAnimation(isActive: isActive))
    }
}

// MARK: - Shimmer Effect

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
                                Color.white.opacity(0.4),
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

// MARK: - Floating Animation

struct FloatingAnimation: ViewModifier {
    let isActive: Bool
    @State private var isFloating = false
    
    func body(content: Content) -> some View {
        content
            .offset(y: isActive && isFloating ? -6 : 0)
            .animation(
                isActive ?
                Animation.easeInOut(duration: 2).repeatForever(autoreverses: true) :
                .default,
                value: isFloating
            )
            .onAppear {
                if isActive {
                    isFloating = true
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
