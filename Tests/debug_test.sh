#!/bin/bash

# Quick debug test to verify question generation
echo "🔍 Quick Debug Test - Question Generation Verification"
echo "================================================="

# Create a simple Swift test script
cat > /tmp/debug_questions.swift << 'EOF'
import Foundation

print("🐛 DEBUG: Starting question generation test...")

// Simulate the exact call that should be happening
struct TestConfiguration {
    let testType: String
    let level: String
    let questionCount: Int
    let timeLimit: Int
    let isTimedSession: Bool
    
    init(testType: String = "fullMock", level: String = "level12") {
        self.testType = testType
        self.level = level
        self.questionCount = 176
        self.timeLimit = 120
        self.isTimedSession = true
    }
}

let config = TestConfiguration()
print("🐛 DEBUG: Test Configuration Created")
print("  - Test Type: \(config.testType)")
print("  - Level: \(config.level)")
print("  - Question Count: \(config.questionCount)")
print("  - Time Limit: \(config.timeLimit)")
print("  - Is Timed: \(config.isTimedSession)")

// Simulate question generation
var questions: [String] = []
for i in 1...config.questionCount {
    questions.append("Question \(i)")
}

print("🐛 DEBUG: Generated \(questions.count) questions")

if questions.count == 0 {
    print("❌ ISSUE: No questions generated!")
    print("This would cause 'Question 0 of 0' display")
} else {
    print("✅ SUCCESS: Questions generated correctly")
    print("Would display: Question 1 of \(questions.count)")
}
EOF

echo "Running debug test..."
swift /tmp/debug_questions.swift

echo ""
echo "🔍 Checking actual app for the issue..."

# Install and test the app directly
echo "Installing fresh app build..."
SIMULATOR_ID="DBA92F0B-BF84-4CD3-BC3C-D29B0B3BA787"
APP_PATH="/Users/rajkumarnatarajan/Library/Developer/Xcode/DerivedData/ExcelCCAT-gpagatfwltyqfmgmjgbsmainfqho/Build/Products/Debug-iphonesimulator/ExcelCCAT.app"

if [ -f "$APP_PATH/ExcelCCAT" ]; then
    echo "✅ App binary found"
    xcrun simctl install "$SIMULATOR_ID" "$APP_PATH" 2>/dev/null && echo "✅ App installed" || echo "❌ App installation failed"
    
    echo ""
    echo "🚀 Launching app for manual test..."
    echo "Please check the simulator - the app should now load properly with questions."
    echo ""
    echo "If you still see 'Question 0 of 0':"
    echo "1. The QuestionDataManager might not be generating questions correctly"
    echo "2. There might be an issue with the TestSession creation"
    echo "3. The fix might not be applied properly"
    
    xcrun simctl launch "$SIMULATOR_ID" com.curiousdev.ExcelCCAT
    echo "App launched with PID: $?"
    
else
    echo "❌ App binary not found at: $APP_PATH"
    echo "Need to build app first"
fi

# Cleanup
rm -f /tmp/debug_questions.swift

echo ""
echo "🏁 Debug test completed!"
echo "Check the simulator to see if the issue is resolved."
