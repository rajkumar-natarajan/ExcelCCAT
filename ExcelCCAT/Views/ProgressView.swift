//
//  ProgressView.swift
//  ExcelCCAT
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

struct ProgressView: View {
    @Environment(AppViewModel.self) private var appViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTab: ProgressTab = .overview
    @State private var selectedTimeFilter: TimeFilter = .all
    @State private var selectedTypeFilter: QuestionType? = nil
    @State private var showingExportSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Tab Picker
                tabPicker
                
                // Content
                TabView(selection: $selectedTab) {
                    overviewTab
                        .tag(ProgressTab.overview)
                    
                    testHistoryTab
                        .tag(ProgressTab.tests)
                    
                    practiceHistoryTab
                        .tag(ProgressTab.practice)
                    
                    insightsTab
                        .tag(ProgressTab.insights)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .background(colorScheme == .dark ? AppTheme.Colors.darkBackground : AppTheme.Colors.offWhite)
            .navigationTitle(NSLocalizedString("progress_title", comment: ""))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingExportSheet = true }) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(AppTheme.Colors.skyBlue)
                    }
                }
            }
            .sheet(isPresented: $showingExportSheet) {
                ExportProgressSheet()
            }
        }
    }
    
    // MARK: - Tab Picker
    
    private var tabPicker: some View {
        HStack(spacing: 0) {
            ForEach(ProgressTab.allCases, id: \.self) { tab in
                Button(action: { selectedTab = tab }) {
                    VStack(spacing: AppTheme.Spacing.xs) {
                        Text(tab.displayName)
                            .font(AppTheme.Typography.callout)
                            .fontWeight(selectedTab == tab ? .semibold : .medium)
                            .foregroundColor(selectedTab == tab ? AppTheme.Colors.skyBlue : AppTheme.Colors.mediumGray)
                        
                        Rectangle()
                            .fill(selectedTab == tab ? AppTheme.Colors.skyBlue : Color.clear)
                            .frame(height: 2)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.bottom, AppTheme.Spacing.sm)
        .background(colorScheme == .dark ? AppTheme.Colors.darkSurface : Color.white)
    }
    
    // MARK: - Overview Tab
    
    private var overviewTab: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.lg) {
                // Overall Stats
                overallStatsSection
                
                // Performance Chart
                performanceChartSection
                
                // Category Breakdown
                categoryBreakdownSection
                
                // Weekly Progress
                weeklyProgressSection
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.bottom, AppTheme.Spacing.xl)
        }
    }
    
    private var overallStatsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Overall Statistics")
                .font(AppTheme.Typography.headline)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: AppTheme.Spacing.md), count: 2), spacing: AppTheme.Spacing.md) {
                StatCard(
                    title: NSLocalizedString("total_tests", comment: ""),
                    value: "\(appViewModel.userProgress.totalTestsTaken)",
                    subtitle: "completed",
                    color: AppTheme.Colors.skyBlue,
                    icon: "doc.text.fill"
                )
                
                StatCard(
                    title: NSLocalizedString("accuracy", comment: ""),
                    value: "\(Int(appViewModel.userProgress.accuracy))%",
                    subtitle: "overall",
                    color: AppTheme.Colors.sageGreen,
                    icon: "target"
                )
                
                StatCard(
                    title: NSLocalizedString("best_score", comment: ""),
                    value: "\(Int(appViewModel.userProgress.bestScore))%",
                    subtitle: "highest",
                    color: AppTheme.Colors.sunnyYellow,
                    icon: "star.fill"
                )
                
                StatCard(
                    title: NSLocalizedString("current_streak", comment: ""),
                    value: "\(appViewModel.userProgress.currentStreak)",
                    subtitle: NSLocalizedString("days", comment: ""),
                    color: AppTheme.Colors.coral,
                    icon: "flame.fill"
                )
            }
        }
        .cardStyle()
    }
    
    private var performanceChartSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text(NSLocalizedString("performance_trends", comment: ""))
                .font(AppTheme.Typography.headline)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
            
            PerformanceChart(testHistory: appViewModel.userProgress.testHistory)
        }
        .cardStyle()
    }
    
    private var categoryBreakdownSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Performance by Category")
                .font(AppTheme.Typography.headline)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
            
            VStack(spacing: AppTheme.Spacing.md) {
                CategoryPerformanceRow(
                    type: .verbal,
                    accuracy: getCategoryAccuracy(.verbal),
                    color: AppTheme.Colors.skyBlue
                )
                
                CategoryPerformanceRow(
                    type: .quantitative,
                    accuracy: getCategoryAccuracy(.quantitative),
                    color: AppTheme.Colors.sageGreen
                )
                
                CategoryPerformanceRow(
                    type: .nonVerbal,
                    accuracy: getCategoryAccuracy(.nonVerbal),
                    color: AppTheme.Colors.sunnyYellow
                )
            }
        }
        .cardStyle()
    }
    
    private var weeklyProgressSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text(NSLocalizedString("weekly_insights", comment: ""))
                .font(AppTheme.Typography.headline)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
            
            HStack {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Text("This Week")
                        .font(AppTheme.Typography.callout)
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText.opacity(0.7) : AppTheme.Colors.softGray.opacity(0.7))
                    
                    Text("\(appViewModel.userProgress.questionsThisWeek) questions answered")
                        .font(AppTheme.Typography.body)
                        .fontWeight(.medium)
                        .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
                }
                
                Spacer()
                
                CircularProgressView(
                    progress: appViewModel.userProgress.weeklyProgress,
                    color: AppTheme.Colors.skyBlue,
                    size: 60
                )
            }
        }
        .cardStyle()
    }
    
    // MARK: - Test History Tab
    
    private var testHistoryTab: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            // Filters
            filtersSection
            
            // Test History List
            ScrollView {
                LazyVStack(spacing: AppTheme.Spacing.sm) {
                    ForEach(filteredTestHistory, id: \.id) { result in
                        TestHistoryRow(result: result)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.bottom, AppTheme.Spacing.xl)
            }
        }
    }
    
    // MARK: - Practice History Tab
    
    private var practiceHistoryTab: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            // Filters
            filtersSection
            
            // Practice History List
            ScrollView {
                LazyVStack(spacing: AppTheme.Spacing.sm) {
                    ForEach(filteredPracticeHistory, id: \.id) { result in
                        PracticeHistoryDetailRow(result: result)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.bottom, AppTheme.Spacing.xl)
            }
        }
    }
    
    // MARK: - Insights Tab
    
    private var insightsTab: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.lg) {
                // Improvement Insights
                improvementInsightsSection
                
                // Recommendations
                recommendationsSection
                
                // Achievements
                achievementsSection
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.bottom, AppTheme.Spacing.xl)
        }
    }
    
    // MARK: - Filters Section
    
    private var filtersSection: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            // Time Filter
            Menu {
                ForEach(TimeFilter.allCases, id: \.self) { filter in
                    Button(filter.displayName) {
                        selectedTimeFilter = filter
                    }
                }
            } label: {
                HStack {
                    Text(selectedTimeFilter.displayName)
                        .font(AppTheme.Typography.callout)
                    Image(systemName: "chevron.down")
                        .font(.caption)
                }
                .foregroundColor(AppTheme.Colors.skyBlue)
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.vertical, AppTheme.Spacing.sm)
                .background(
                    Capsule()
                        .stroke(AppTheme.Colors.skyBlue, lineWidth: 1)
                )
            }
            
            // Type Filter
            Menu {
                Button("All Types") {
                    selectedTypeFilter = nil
                }
                ForEach(QuestionType.allCases, id: \.self) { type in
                    Button(type.displayName) {
                        selectedTypeFilter = type
                    }
                }
            } label: {
                HStack {
                    Text(selectedTypeFilter?.displayName ?? "All Types")
                        .font(AppTheme.Typography.callout)
                    Image(systemName: "chevron.down")
                        .font(.caption)
                }
                .foregroundColor(AppTheme.Colors.skyBlue)
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.vertical, AppTheme.Spacing.sm)
                .background(
                    Capsule()
                        .stroke(AppTheme.Colors.skyBlue, lineWidth: 1)
                )
            }
            
            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.md)
    }
    
    // MARK: - Helper Methods
    
    private func getCategoryAccuracy(_ type: QuestionType) -> Double {
        let relevantResults = appViewModel.userProgress.testHistory.filter { result in
            // This is a simplified calculation - in a real app you'd track category-specific scores
            return result.sessionType == .fullMock
        }
        
        guard !relevantResults.isEmpty else { return 0 }
        
        let totalScore = relevantResults.reduce(0.0) { sum, result in
            switch type {
            case .verbal:
                return sum + Double(result.verbalScore)
            case .quantitative:
                return sum + Double(result.quantitativeScore)
            case .nonVerbal:
                return sum + Double(result.nonVerbalScore)
            }
        }
        
        let maxPossibleScore = Double(relevantResults.count * 59) // Approximate questions per category
        return (totalScore / maxPossibleScore) * 100
    }
    
    private var filteredTestHistory: [TestResult] {
        var results = appViewModel.userProgress.testHistory
        
        // Apply time filter
        let now = Date()
        switch selectedTimeFilter {
        case .week:
            results = results.filter { Calendar.current.isDate($0.date, equalTo: now, toGranularity: .weekOfYear) }
        case .month:
            results = results.filter { Calendar.current.isDate($0.date, equalTo: now, toGranularity: .month) }
        case .all:
            break
        }
        
        return results.sorted { $0.date > $1.date }
    }
    
    private var filteredPracticeHistory: [PracticeResult] {
        var results = appViewModel.userProgress.practiceHistory
        
        // Apply filters
        let now = Date()
        switch selectedTimeFilter {
        case .week:
            results = results.filter { Calendar.current.isDate($0.date, equalTo: now, toGranularity: .weekOfYear) }
        case .month:
            results = results.filter { Calendar.current.isDate($0.date, equalTo: now, toGranularity: .month) }
        case .all:
            break
        }
        
        if let typeFilter = selectedTypeFilter {
            results = results.filter { $0.questionType == typeFilter }
        }
        
        return results.sorted { $0.date > $1.date }
    }
    
    // MARK: - Additional Sections (Implementation would continue...)
    
    private var improvementInsightsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Improvement Insights")
                .font(AppTheme.Typography.headline)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
            
            VStack(spacing: AppTheme.Spacing.sm) {
                InsightCard(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Steady Progress",
                    subtitle: "Your accuracy has improved by 12% this month",
                    color: AppTheme.Colors.sageGreen
                )
                
                InsightCard(
                    icon: "clock.fill",
                    title: "Time Management",
                    subtitle: "You're completing tests 15% faster",
                    color: AppTheme.Colors.skyBlue
                )
            }
        }
        .cardStyle()
    }
    
    private var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Recommendations")
                .font(AppTheme.Typography.headline)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
            
            VStack(spacing: AppTheme.Spacing.sm) {
                RecommendationCard(
                    title: "Focus on Quantitative",
                    subtitle: "Your weakest area - practice 15 minutes daily",
                    action: "Practice Now"
                ) {
                    // Action to start quantitative practice
                }
            }
        }
        .cardStyle()
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Achievements")
                .font(AppTheme.Typography.headline)
                .foregroundColor(colorScheme == .dark ? AppTheme.Colors.darkText : AppTheme.Colors.softGray)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: AppTheme.Spacing.md), count: 3), spacing: AppTheme.Spacing.md) {
                AchievementBadge(
                    icon: "flame.fill",
                    title: "5-Day Streak",
                    isUnlocked: appViewModel.userProgress.currentStreak >= 5,
                    color: AppTheme.Colors.coral
                )
                
                AchievementBadge(
                    icon: "star.fill",
                    title: "Perfect Score",
                    isUnlocked: appViewModel.userProgress.bestScore >= 100,
                    color: AppTheme.Colors.sunnyYellow
                )
                
                AchievementBadge(
                    icon: "brain.head.profile.fill",
                    title: "Gifted Range",
                    isUnlocked: appViewModel.userProgress.bestScore >= 85,
                    color: AppTheme.Colors.sageGreen
                )
            }
        }
        .cardStyle()
    }
}

// MARK: - Supporting Views and Types

enum ProgressTab: String, CaseIterable {
    case overview = "overview"
    case tests = "tests"
    case practice = "practice"
    case insights = "insights"
    
    var displayName: String {
        switch self {
        case .overview:
            return "Overview"
        case .tests:
            return "Tests"
        case .practice:
            return "Practice"
        case .insights:
            return "Insights"
        }
    }
}

enum TimeFilter: String, CaseIterable {
    case all = "all"
    case month = "month"
    case week = "week"
    
    var displayName: String {
        switch self {
        case .all:
            return "All Time"
        case .month:
            return "This Month"
        case .week:
            return "This Week"
        }
    }
}

// Additional supporting views would continue here...
// (PerformanceChart, CategoryPerformanceRow, TestHistoryRow, etc.)

// MARK: - Placeholder Supporting Views (to be refined)

struct ExportProgressSheet: View {
    @Environment(AppViewModel.self) private var appViewModel
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            ScrollView {
                Text(appViewModel.exportProgressReport())
                    .font(.footnote)
                    .monospaced()
                    .padding()
            }
            .navigationTitle("Export")
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { dismiss() } } }
        }
    }
}

struct PerformanceChart: View {
    let testHistory: [TestResult]
    var body: some View {
        GeometryReader { geo in
            let points = normalizedPoints(width: geo.size.width, height: geo.size.height)
            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(AppTheme.Colors.lightGray.opacity(0.2))
                if points.count > 1 {
                    Path { p in
                        p.move(to: points[0])
                        for pt in points.dropFirst() { p.addLine(to: pt) }
                    }
                    .stroke(AppTheme.Colors.skyBlue, style: StrokeStyle(lineWidth: 2, lineJoin: .round))
                }
            }
        }
        .frame(height: 140)
    }
    private func normalizedPoints(width: CGFloat, height: CGFloat) -> [CGPoint] {
        guard !testHistory.isEmpty else { return [] }
        let maxScore = 100.0
        return testHistory.enumerated().map { (idx, result) in
            let x = width * CGFloat(idx) / CGFloat(max(1, testHistory.count - 1))
            let y = height * (1 - CGFloat(result.percentageScore / maxScore))
            return CGPoint(x: x, y: y)
        }
    }
}

struct CategoryPerformanceRow: View {
    let type: QuestionType
    let accuracy: Double
    let color: Color
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Circle().fill(color.opacity(0.15)).frame(width: 42, height: 42)
                .overlay(Image(systemName: icon).foregroundColor(color))
            VStack(alignment: .leading, spacing: 4) {
                Text(type.displayName).font(AppTheme.Typography.callout).fontWeight(.medium)
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.gray.opacity(0.15))
                    Capsule().fill(color).frame(width: progressWidth)
                }.frame(height: 8)
            }
            Spacer()
            Text("\(Int(accuracy))%")
                .font(AppTheme.Typography.caption)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
    }
    private var icon: String {
        switch type { case .verbal: return "text.book.closed"; case .quantitative: return "function"; case .nonVerbal: return "square.grid.2x2" }
    }
    private var progressWidth: CGFloat { CGFloat(min(max(accuracy, 0), 100) / 100) * 120 }
}

struct CircularProgressView: View {
    let progress: Double
    let color: Color
    let size: CGFloat
    var body: some View {
        ZStack {
            Circle().stroke(color.opacity(0.15), lineWidth: 8)
            Circle()
                .trim(from: 0, to: min(progress, 1))
                .stroke(color, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text("\(Int(progress * 100))%")
                .font(.system(size: size * 0.28, weight: .medium, design: .rounded))
                .foregroundColor(color)
        }
        .frame(width: size, height: size)
    }
}

struct TestHistoryRow: View {
    let result: TestResult
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            VStack(alignment: .leading, spacing: 4) {
                Text(result.sessionType.displayName)
                    .font(AppTheme.Typography.callout)
                    .fontWeight(.medium)
                Text(result.date, style: .date)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text("\(Int(result.percentageScore))%")
                .font(AppTheme.Typography.headline)
                .foregroundColor(result.giftedRange ? AppTheme.Colors.sageGreen : AppTheme.Colors.skyBlue)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium).fill(Color.white.opacity(0.6)))
    }
}

struct PracticeHistoryDetailRow: View {
    let result: PracticeResult
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            VStack(alignment: .leading, spacing: 4) {
                Text(result.questionType.displayName)
                    .font(AppTheme.Typography.callout)
                    .fontWeight(.medium)
                Text(result.date, style: .date)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text("\(Int(result.percentageScore))%")
                .font(AppTheme.Typography.headline)
                .foregroundColor(AppTheme.Colors.skyBlue)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium).fill(Color.white.opacity(0.6)))
    }
}

struct RecommendationCard: View {
    let title: String
    let subtitle: String
    let action: String
    let handler: () -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text(title).font(AppTheme.Typography.callout).fontWeight(.semibold)
            Text(subtitle).font(AppTheme.Typography.caption).foregroundColor(.secondary)
            Button(action: handler) {
                HStack { Text(action); Image(systemName: "arrow.right") }
                    .font(AppTheme.Typography.caption)
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.Colors.skyBlue)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium).fill(Color.white.opacity(0.6)))
    }
}

struct AchievementBadge: View {
    let icon: String
    let title: String
    let isUnlocked: Bool
    let color: Color
    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle().fill(color.opacity(isUnlocked ? 0.2 : 0.08))
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(isUnlocked ? color : .gray)
            }
            .frame(width: 56, height: 56)
            Text(title)
                .font(.system(size: 11, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundColor(isUnlocked ? color : .gray)
        }
        .padding(6)
    }
}

#Preview {
    ProgressView()
        .environment(AppViewModel())
}
