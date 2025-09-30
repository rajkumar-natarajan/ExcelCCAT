//
//  ExcelCCATApp.swift
//  ExcelCCAT
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

@main
struct ExcelCCATApp: App {
    @State private var appViewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appViewModel)
                .preferredColorScheme(appViewModel.appSettings.isDarkMode ? .dark : .light)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                    appViewModel.saveUserData()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
                    appViewModel.saveUserData()
                }
        }
    }
}
