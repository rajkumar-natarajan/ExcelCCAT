//
//  MainTabView.swift
//  ExcelCCAT
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

struct MainTabView: View {
    @Environment(AppViewModel.self) private var appViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == .home ? "house.fill" : "house")
                    Text(NSLocalizedString("home", comment: ""))
                }
                .tag(Tab.home)
            
            PracticeView()
                .tabItem {
                    Image(systemName: selectedTab == .practice ? "brain.head.profile.fill" : "brain.head.profile")
                    Text(NSLocalizedString("practice", comment: ""))
                }
                .tag(Tab.practice)
            
            ProgressView()
                .tabItem {
                    Image(systemName: selectedTab == .progress ? "chart.line.uptrend.xyaxis.circle.fill" : "chart.line.uptrend.xyaxis.circle")
                    Text(NSLocalizedString("progress_title", comment: ""))
                }
                .tag(Tab.progress)
            
            SettingsView()
                .tabItem {
                    Image(systemName: selectedTab == .settings ? "gearshape.fill" : "gearshape")
                    Text(NSLocalizedString("settings_title", comment: ""))
                }
                .tag(Tab.settings)
        }
        .tint(AppTheme.Colors.skyBlue)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        
        if colorScheme == .dark {
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(AppTheme.Colors.darkSurface)
        } else {
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
        }
        
        appearance.selectionIndicatorTintColor = UIColor(AppTheme.Colors.skyBlue)
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

// MARK: - Tab Enum

enum Tab: String, CaseIterable {
    case home = "home"
    case practice = "practice"
    case progress = "progress"
    case settings = "settings"
    
    var displayName: String {
        switch self {
        case .home:
            return NSLocalizedString("home", comment: "")
        case .practice:
            return NSLocalizedString("practice", comment: "")
        case .progress:
            return NSLocalizedString("progress_title", comment: "")
        case .settings:
            return NSLocalizedString("settings_title", comment: "")
        }
    }
    
    var icon: String {
        switch self {
        case .home:
            return "house"
        case .practice:
            return "brain.head.profile"
        case .progress:
            return "chart.line.uptrend.xyaxis.circle"
        case .settings:
            return "gearshape"
        }
    }
    
    var selectedIcon: String {
        return icon + ".fill"
    }
}

#Preview {
    MainTabView()
        .environment(AppViewModel())
}
