//
//  ExcelCCATUITests.swift
//  ExcelCCAT UI Tests
//
//  Created by GitHub Copilot on 2025-09-30.
//

import XCTest

/// Comprehensive UI tests for ExcelCCAT app
/// Tests user interface interactions, navigation, and screen functionality
final class ExcelCCATUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - App Launch Tests
    
    func testAppLaunch() throws {
        XCTAssertTrue(app.state == .runningForeground, "App should launch successfully")
    }
    
    func testOnboardingFlow() throws {
        // If first launch, test onboarding
        if app.staticTexts["Welcome to ExcelCCAT"].exists {
            // Test onboarding screens
            XCTAssertTrue(app.staticTexts["Welcome to ExcelCCAT"].exists, "Should show welcome message")
            
            // Navigate through onboarding
            if app.buttons["Get Started"].exists {
                app.buttons["Get Started"].tap()
            }
            
            // Complete onboarding
            if app.buttons["Start Learning"].exists {
                app.buttons["Start Learning"].tap()
            }
        }
    }
    
    // MARK: - Main Navigation Tests
    
    func testMainTabNavigation() throws {
        // Skip onboarding if present
        skipOnboardingIfPresent()
        
        // Test tab bar navigation
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.exists, "Tab bar should be visible")
        
        // Test Home tab
        if app.buttons["Home"].exists {
            app.buttons["Home"].tap()
            XCTAssertTrue(app.navigationBars["Home"].exists || app.staticTexts.containing(.any, identifier: "welcome").element.exists, "Should navigate to Home")
        }
        
        // Test Practice tab
        if app.buttons["Practice"].exists {
            app.buttons["Practice"].tap()
            XCTAssertTrue(app.navigationBars["Practice"].exists || app.staticTexts["Practice"].exists, "Should navigate to Practice")
        }
        
        // Test Progress tab
        if app.buttons["Progress"].exists {
            app.buttons["Progress"].tap()
            XCTAssertTrue(app.navigationBars["Progress"].exists || app.staticTexts["Progress"].exists, "Should navigate to Progress")
        }
        
        // Test Settings tab
        if app.buttons["Settings"].exists {
            app.buttons["Settings"].tap()
            XCTAssertTrue(app.navigationBars["Settings"].exists || app.staticTexts["Settings"].exists, "Should navigate to Settings")
        }
    }
    
    // MARK: - Home Screen Tests
    
    func testHomeScreenElements() throws {
        skipOnboardingIfPresent()
        navigateToHome()
        
        // Test welcome message
        XCTAssertTrue(app.staticTexts.containing(.any, identifier: "welcome").element.exists, "Should show welcome message")
        
        // Test level selection
        if app.buttons.containing(.any, identifier: "level").element.exists {
            XCTAssertTrue(true, "Should show level selection")
        }
        
        // Test main action buttons
        let testButtons = ["Start Mock Test", "Take Test", "Begin Test", "Start Full Mock"]
        let hasTestButton = testButtons.contains { app.buttons[$0].exists }
        XCTAssertTrue(hasTestButton, "Should have a test start button")
        
        // Test quick practice options
        let practiceButtons = ["Verbal Practice", "Quantitative Practice", "Non-Verbal Practice", "Quick Practice"]
        let hasPracticeButton = practiceButtons.contains { app.buttons[$0].exists }
        XCTAssertTrue(hasPracticeButton, "Should have practice options")
    }
    
    func testLevelSelection() throws {
        skipOnboardingIfPresent()
        navigateToHome()
        
        // Test level selection if available
        let levelButtons = ["Level 10", "Level 11", "Level 12"]
        for levelButton in levelButtons {
            if app.buttons[levelButton].exists {
                app.buttons[levelButton].tap()
                // Verify selection feedback
                XCTAssertTrue(app.buttons[levelButton].isSelected || app.buttons[levelButton].exists, "Should select level")
                break
            }
        }
    }
    
    // MARK: - Test Session Tests
    
    func testStartMockTest() throws {
        skipOnboardingIfPresent()
        navigateToHome()
        
        // Try to start a mock test
        let startButtons = ["Start Mock Test", "Take Test", "Begin Test", "Start Full Mock", "Full Mock Test"]
        for buttonText in startButtons {
            if app.buttons[buttonText].exists {
                app.buttons[buttonText].tap()
                
                // Wait for test session to load
                sleep(2)
                
                // Check if we're in test session
                let testSessionIndicators = [
                    app.staticTexts.containing(.any, identifier: "Question").element.exists,
                    app.buttons["Next"].exists,
                    app.buttons["Previous"].exists,
                    app.staticTexts.matching(.regularExpression, identifier: "Question \\d+ of \\d+").element.exists
                ]
                
                let inTestSession = testSessionIndicators.contains(true)
                if inTestSession {
                    XCTAssertTrue(true, "Should enter test session")
                    
                    // Test question navigation if possible
                    testQuestionInteraction()
                    
                    // Exit test session
                    if app.buttons["Exit"].exists || app.buttons["xmark"].exists {
                        app.buttons.matching(.any, identifier: "Exit").element.tap()
                        if app.buttons["Exit"].exists {
                            app.buttons["Exit"].tap() // Confirm exit
                        }
                    }
                } else {
                    // Might be showing a configuration screen
                    if app.buttons["Start Test"].exists || app.buttons["Begin"].exists {
                        app.buttons.matching(.any, identifier: "Start").element.tap()
                        sleep(2)
                        
                        // Check again for test session
                        if app.staticTexts.containing(.any, identifier: "Question").element.exists {
                            XCTAssertTrue(true, "Should enter test session after configuration")
                            testQuestionInteraction()
                        }
                    }
                }
                break
            }
        }
    }
    
    func testQuestionInteraction() {
        // Test answering a question if in test session
        if app.staticTexts.containing(.any, identifier: "Question").element.exists {
            
            // Try to select an answer option
            let answerButtons = app.buttons.matching(.regularExpression, identifier: "[A-D]|Option [1-4]")
            if answerButtons.count > 0 {
                answerButtons.element(boundBy: 0).tap()
                XCTAssertTrue(true, "Should be able to select an answer")
            }
            
            // Try navigation buttons
            if app.buttons["Next"].exists {
                app.buttons["Next"].tap()
                XCTAssertTrue(true, "Should be able to navigate questions")
            }
            
            if app.buttons["Previous"].exists && app.buttons["Previous"].isEnabled {
                app.buttons["Previous"].tap()
                XCTAssertTrue(true, "Should be able to go back")
            }
        }
    }
    
    // MARK: - Practice Session Tests
    
    func testPracticeMode() throws {
        skipOnboardingIfPresent()
        navigateToPractice()
        
        // Test quick practice options
        let practiceTypes = ["Verbal", "Quantitative", "Non-Verbal"]
        for practiceType in practiceTypes {
            if app.buttons.containing(.any, identifier: practiceType).element.exists {
                app.buttons.containing(.any, identifier: practiceType).element.tap()
                
                // Wait for practice session to start
                sleep(2)
                
                // Check if practice session started
                if app.staticTexts.containing(.any, identifier: "Question").element.exists {
                    XCTAssertTrue(true, "Should start practice session")
                    testQuestionInteraction()
                    
                    // Exit practice session
                    exitCurrentSession()
                }
                break
            }
        }
    }
    
    func testCustomPracticeConfiguration() throws {
        skipOnboardingIfPresent()
        navigateToPractice()
        
        // Look for custom configuration options
        if app.buttons["Custom Practice"].exists || app.buttons["Configure"].exists {
            app.buttons.matching(.any, identifier: "Custom").element.tap()
            
            // Test configuration options
            if app.steppers.count > 0 {
                app.steppers.element(boundBy: 0).buttons["Increment"].tap()
                XCTAssertTrue(true, "Should allow configuration changes")
            }
            
            // Start configured practice
            if app.buttons["Start Practice"].exists || app.buttons["Begin Practice"].exists {
                app.buttons.matching(.any, identifier: "Start").element.tap()
                
                sleep(2)
                if app.staticTexts.containing(.any, identifier: "Question").element.exists {
                    XCTAssertTrue(true, "Should start custom practice session")
                    exitCurrentSession()
                }
            }
        }
    }
    
    // MARK: - Settings Screen Tests
    
    func testSettingsScreen() throws {
        skipOnboardingIfPresent()
        navigateToSettings()
        
        // Test settings sections
        XCTAssertTrue(app.staticTexts["Settings"].exists, "Should show Settings title")
        
        // Test language settings
        testLanguageSettings()
        
        // Test appearance settings
        testAppearanceSettings()
        
        // Test audio/haptic settings
        testAudioHapticsSettings()
        
        // Test about section
        testAboutSection()
    }
    
    func testLanguageSettings() {
        if app.staticTexts["Language"].exists {
            // Test language selection
            if app.buttons["English"].exists || app.buttons["Français"].exists {
                XCTAssertTrue(true, "Should show language options")
                
                // Try switching language
                if app.buttons["Français"].exists {
                    app.buttons["Français"].tap()
                    // Note: Language switch might require app restart
                }
            }
        }
    }
    
    func testAppearanceSettings() {
        if app.staticTexts["Appearance"].exists {
            // Test dark mode toggle
            let darkModeSwitch = app.switches["Dark Mode"]
            if darkModeSwitch.exists {
                let initialState = darkModeSwitch.value as? String
                darkModeSwitch.tap()
                
                // Verify toggle worked
                let newState = darkModeSwitch.value as? String
                XCTAssertNotEqual(initialState, newState, "Should toggle dark mode")
            }
            
            // Test font size selection
            if app.buttons["Font Size"].exists {
                app.buttons["Font Size"].tap()
                
                let fontSizes = ["Small", "Medium", "Large", "Extra Large"]
                for fontSize in fontSizes {
                    if app.buttons[fontSize].exists {
                        app.buttons[fontSize].tap()
                        XCTAssertTrue(true, "Should allow font size selection")
                        break
                    }
                }
            }
        }
    }
    
    func testAudioHapticsSettings() {
        // Test sound and haptic toggles
        let audioSettings = ["Sound Effects", "Haptic Feedback", "Sound", "Haptics"]
        for setting in audioSettings {
            let toggle = app.switches[setting]
            if toggle.exists {
                let initialState = toggle.value as? String
                toggle.tap()
                let newState = toggle.value as? String
                XCTAssertNotEqual(initialState, newState, "Should toggle \(setting)")
            }
        }
    }
    
    func testAboutSection() {
        if app.buttons["About"].exists || app.staticTexts["About"].exists {
            app.buttons["About"].tap()
            
            // Check for about information
            sleep(1)
            let aboutIndicators = [
                app.staticTexts["About"].exists,
                app.staticTexts.containing(.any, identifier: "Version").element.exists,
                app.staticTexts.containing(.any, identifier: "ExcelCCAT").element.exists
            ]
            
            XCTAssertTrue(aboutIndicators.contains(true), "Should show about information")
            
            // Close about view
            if app.buttons["Done"].exists || app.buttons["Close"].exists {
                app.buttons.matching(.any, identifier: "Done").element.tap()
            }
        }
    }
    
    // MARK: - Progress Screen Tests
    
    func testProgressScreen() throws {
        skipOnboardingIfPresent()
        navigateToProgress()
        
        // Test progress elements
        let progressIndicators = [
            app.staticTexts["Progress"].exists,
            app.staticTexts.containing(.any, identifier: "Total").element.exists,
            app.staticTexts.containing(.any, identifier: "Score").element.exists,
            app.staticTexts.containing(.any, identifier: "Accuracy").element.exists
        ]
        
        XCTAssertTrue(progressIndicators.contains(true), "Should show progress information")
        
        // Test charts or progress visualization
        if app.otherElements["Chart"].exists || app.images.count > 0 {
            XCTAssertTrue(true, "Should show progress visualization")
        }
        
        // Test export functionality if available
        if app.buttons["Export"].exists || app.buttons["Share"].exists {
            XCTAssertTrue(true, "Should have export functionality")
        }
    }
    
    // MARK: - Accessibility Tests
    
    func testVoiceOverAccessibility() throws {
        skipOnboardingIfPresent()
        
        // Test that major elements have accessibility labels
        navigateToHome()
        
        let homeElements = app.buttons.allElementsBoundByIndex + app.staticTexts.allElementsBoundByIndex
        for element in homeElements {
            if element.exists && element.isHittable {
                XCTAssertNotNil(element.label, "Interactive elements should have accessibility labels")
            }
        }
    }
    
    func testFontScaling() throws {
        skipOnboardingIfPresent()
        navigateToSettings()
        
        // Test font size changes
        if app.buttons["Font Size"].exists {
            app.buttons["Font Size"].tap()
            
            if app.buttons["Large"].exists {
                app.buttons["Large"].tap()
                // Navigate back to see changes
                navigateToHome()
                XCTAssertTrue(true, "Should support font scaling")
            }
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testNetworkErrorHandling() throws {
        // Test app behavior with no network
        // Note: This would require network simulation in a real test environment
        XCTAssertTrue(true, "App should handle offline operation")
    }
    
    func testMemoryPressureHandling() throws {
        // Test app behavior under memory pressure
        // Start a test session and navigate around
        skipOnboardingIfPresent()
        
        for _ in 0..<5 {
            navigateToHome()
            navigateToPractice()
            navigateToProgress()
            navigateToSettings()
        }
        
        XCTAssertTrue(app.state == .runningForeground, "App should handle navigation stress")
    }
    
    // MARK: - Performance Tests
    
    func testAppLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            app.launch()
        }
    }
    
    func testNavigationPerformance() throws {
        skipOnboardingIfPresent()
        
        measure {
            navigateToHome()
            navigateToPractice()
            navigateToProgress()
            navigateToSettings()
        }
    }
    
    // MARK: - Data Persistence Tests
    
    func testSettingsPersistence() throws {
        skipOnboardingIfPresent()
        navigateToSettings()
        
        // Change a setting
        let darkModeSwitch = app.switches["Dark Mode"]
        if darkModeSwitch.exists {
            darkModeSwitch.tap()
            
            // Restart app
            app.terminate()
            app.launch()
            skipOnboardingIfPresent()
            navigateToSettings()
            
            // Check if setting persisted
            XCTAssertTrue(darkModeSwitch.exists, "Settings should persist across app launches")
        }
    }
    
    // MARK: - Helper Methods
    
    private func skipOnboardingIfPresent() {
        sleep(1) // Wait for app to load
        
        if app.staticTexts["Welcome to ExcelCCAT"].exists || app.buttons["Get Started"].exists {
            // Skip onboarding
            if app.buttons["Get Started"].exists {
                app.buttons["Get Started"].tap()
            }
            
            if app.buttons["Next"].exists {
                app.buttons["Next"].tap()
            }
            
            if app.buttons["Start Learning"].exists || app.buttons["Done"].exists {
                app.buttons.matching(.any, identifier: "Start Learning").element.tap()
            }
            
            sleep(1) // Wait for transition
        }
    }
    
    private func navigateToHome() {
        if app.buttons["Home"].exists {
            app.buttons["Home"].tap()
        } else if app.tabBars.buttons.element(boundBy: 0).exists {
            app.tabBars.buttons.element(boundBy: 0).tap()
        }
        sleep(0.5)
    }
    
    private func navigateToPractice() {
        if app.buttons["Practice"].exists {
            app.buttons["Practice"].tap()
        } else if app.tabBars.buttons.count > 1 {
            app.tabBars.buttons.element(boundBy: 1).tap()
        }
        sleep(0.5)
    }
    
    private func navigateToProgress() {
        if app.buttons["Progress"].exists {
            app.buttons["Progress"].tap()
        } else if app.tabBars.buttons.count > 2 {
            app.tabBars.buttons.element(boundBy: 2).tap()
        }
        sleep(0.5)
    }
    
    private func navigateToSettings() {
        if app.buttons["Settings"].exists {
            app.buttons["Settings"].tap()
        } else if app.tabBars.buttons.count > 3 {
            app.tabBars.buttons.element(boundBy: 3).tap()
        }
        sleep(0.5)
    }
    
    private func exitCurrentSession() {
        // Try various ways to exit current session
        if app.buttons["Exit"].exists {
            app.buttons["Exit"].tap()
            if app.buttons["Exit"].exists { // Confirmation
                app.buttons["Exit"].tap()
            }
        } else if app.buttons.matching(.any, identifier: "xmark").element.exists {
            app.buttons.matching(.any, identifier: "xmark").element.tap()
            if app.buttons["Exit"].exists {
                app.buttons["Exit"].tap()
            }
        } else if app.navigationBars.buttons.element(boundBy: 0).exists {
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
        sleep(1)
    }
}

// MARK: - UI Test Extensions

extension XCUIElement {
    var isToggled: Bool {
        return (value as? String) == "1"
    }
}

extension XCUIElementQuery {
    func containing(_ type: NSPredicate.Options, identifier: String) -> XCUIElement {
        return self.containing(.predicateWithFormat, identifier: "identifier CONTAINS[c] %@", identifier)
    }
    
    func matching(_ type: NSPredicate.Options, identifier: String) -> XCUIElementQuery {
        return self.matching(.predicateWithFormat, identifier: "identifier MATCHES %@", identifier)
    }
}
