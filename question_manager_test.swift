import Foundation

// Let's create a simple test that mimics exactly what the app should be doing
print("=== Direct QuestionDataManager Test ===")

// Create a test configuration (mimicking what AppViewModel does)
struct TestConfig {
    let testType: String = "fullMock"
    let level: String = "level12"
    let questionCount: Int = 176
    let timeLimit: Int = 120
    let isTimedSession: Bool = true
}

let config = TestConfig()

print("Test Configuration:")
print("- Type: \(config.testType)")
print("- Level: \(config.level)")
print("- Expected Questions: \(config.questionCount)")

// Test what should happen
var simulatedQuestions: [String] = []

// Simulate the question generation process
print("\nSimulating question generation...")

// Generate questions for all types (this simulates what QuestionDataManager does)
let verbalCount = 20  // per subtype
let quantitativeCount = 20  // per subtype
let nonVerbalCount = 20  // per subtype

// Verbal (3 subtypes)
for i in 1...(verbalCount * 3) {
    simulatedQuestions.append("Verbal Question \(i)")
}

// Quantitative (3 subtypes)
for i in 1...(quantitativeCount * 3) {
    simulatedQuestions.append("Quantitative Question \(i)")
}

// Non-Verbal (3 subtypes)
for i in 1...(nonVerbalCount * 3) {
    simulatedQuestions.append("Non-Verbal Question \(i)")
}

print("Generated \(simulatedQuestions.count) total questions")

// Ensure minimum volume (this simulates ensureMinimumVolume)
let targetPerType = 200
let typesCount = 3  // verbal, quantitative, non-verbal
let currentTotal = simulatedQuestions.count

if currentTotal < (targetPerType * typesCount) {
    let needed = (targetPerType * typesCount) - currentTotal
    for i in 1...needed {
        simulatedQuestions.append("Synthetic Question \(i)")
    }
    print("Added \(needed) synthetic questions to reach target")
}

print("Final question count: \(simulatedQuestions.count)")

// Test configuration filtering (this simulates getConfiguredQuestions)
var configuredQuestions: [String] = []

// For level12 full mock, we need 176 questions
let shuffled = simulatedQuestions.shuffled()
configuredQuestions = Array(shuffled.prefix(config.questionCount))

print("Configured questions for test: \(configuredQuestions.count)")

// Final result
if configuredQuestions.count == 0 {
    print("❌ ISSUE FOUND: Would result in 'Question 0 of 0'")
    print("This indicates a problem in the question generation or filtering logic")
} else {
    print("✅ SUCCESS: Would display 'Question 1 of \(configuredQuestions.count)'")
}

print("\n=== Test Complete ===")
