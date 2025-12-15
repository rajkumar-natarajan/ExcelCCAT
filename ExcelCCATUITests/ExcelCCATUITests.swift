//
//  ExcelCCATUITests.swift
//  ExcelCCATUITests
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import XCTest

final class ExcelCCATUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    @MainActor
    func testAppLaunchesSuccessfully() throws {
        // Verify app launches and main tab view is visible
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 10), "App should be running")
        
        // Look for either onboarding or main tab view
        let tabBar = app.tabBars.firstMatch
        let continueButton = app.buttons["Continue"]
        let getStartedButton = app.buttons["Get Started"]
        
        // If onboarding, skip it
        if continueButton.waitForExistence(timeout: 3) {
            continueButton.tap()
        }
        if getStartedButton.waitForExistence(timeout: 2) {
            getStartedButton.tap()
        }
        
        // Verify main content is visible
        let mainContentExists = tabBar.waitForExistence(timeout: 5) ||
                                app.staticTexts["Home"].waitForExistence(timeout: 5) ||
                                app.staticTexts["Practice"].waitForExistence(timeout: 5)
        
        XCTAssertTrue(mainContentExists, "Main app content should be visible")
    }

    @MainActor
    func testStartFullMockTest() throws {
        // Skip onboarding if present
        skipOnboardingIfPresent()
        
        // Look for Full Mock Test button or Start button
        let possibleButtons = [
            "Full Mock Test",
            "Start Test",
            "Start Mock Test",
            "Take Test",
            "Begin Test"
        ]
        
        var testButtonFound = false
        for buttonName in possibleButtons {
            let button = app.buttons[buttonName]
            if button.waitForExistence(timeout: 2) {
                button.tap()
                testButtonFound = true
                break
            }
        }
        
        // Also try static texts that might be tappable
        if !testButtonFound {
            let fullMockText = app.staticTexts["Full Mock Test"]
            if fullMockText.waitForExistence(timeout: 2) {
                fullMockText.tap()
                testButtonFound = true
            }
        }
        
        // Wait for test to start or loading
        sleep(3)
        
        // Check if we see question content or loading
        let questionVisible = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Question'")).firstMatch.exists
        let loadingVisible = app.staticTexts["Loading..."].exists
        let progressExists = app.progressIndicators.firstMatch.exists
        
        // At this point we should see either questions, loading, or the test screen
        print("Question visible: \(questionVisible)")
        print("Loading visible: \(loadingVisible)")
        print("Progress exists: \(progressExists)")
        
        // Verify we're not stuck on "Question 0 of 0"
        let badLabel = app.staticTexts["Question 0 of 0"]
        if badLabel.exists {
            XCTFail("Found 'Question 0 of 0' - questions not loading properly")
        }
    }
    
    @MainActor
    func testNavigationTabs() throws {
        skipOnboardingIfPresent()
        
        // Check if tab bar exists
        let tabBar = app.tabBars.firstMatch
        if tabBar.waitForExistence(timeout: 5) {
            // Try tapping different tabs
            let tabs = ["Home", "Practice", "Progress", "Settings"]
            for tab in tabs {
                let tabButton = tabBar.buttons[tab]
                if tabButton.exists {
                    tabButton.tap()
                    sleep(1)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func skipOnboardingIfPresent() {
        let continueButton = app.buttons["Continue"]
        let getStartedButton = app.buttons["Get Started"]
        let skipButton = app.buttons["Skip"]
        
        for _ in 0..<3 {
            if continueButton.waitForExistence(timeout: 1) {
                continueButton.tap()
            }
            if skipButton.waitForExistence(timeout: 1) {
                skipButton.tap()
            }
        }
        
        if getStartedButton.waitForExistence(timeout: 1) {
            getStartedButton.tap()
        }
        
        // Give time for main view to appear
        sleep(1)
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
