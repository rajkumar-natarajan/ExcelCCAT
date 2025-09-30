//
//  WeakAreaAnalyzer.swift
//  ExcelCCAT
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import Foundation

// MARK: - WeakArea Model

struct WeakArea: Identifiable {
    let id = UUID()
    let questionType: QuestionType
    let subType: String?
    let difficulty: Difficulty?
    let title: String
    let description: String
    let averageScore: Double
    let totalAttempts: Int
    let severity: Severity
    
    enum Severity {
        case critical  // < 50%
        case moderate  // 50-70%
        case minor     // 70-80%
    }
}

// MARK: - Recommendation Model

struct Recommendation: Identifiable {
    let id: UUID
    let title: String
    let subtitle: String
    let actionText: String
    let action: () -> Void
}

// MARK: - WeakAreaAnalyzer

class WeakAreaAnalyzer {
    
    /// Analyzes test and practice results to identify weak areas
    static func analyzePerformance(
        testResults: [TestResult],
        practiceResults: [PracticeResult]
    ) -> [WeakArea] {
        
        var weakAreas: [WeakArea] = []
        
        // Analyze by question type
        for questionType in QuestionType.allCases {
            if let weakArea = analyzeQuestionType(
                questionType,
                testResults: testResults,
                practiceResults: practiceResults
            ) {
                weakAreas.append(weakArea)
            }
        }
        
        // Analyze by sub-type for detailed insights
        weakAreas.append(contentsOf: analyzeSubTypes(
            testResults: testResults,
            practiceResults: practiceResults
        ))
        
        // Analyze by difficulty level
        weakAreas.append(contentsOf: analyzeDifficultyLevels(
            testResults: testResults,
            practiceResults: practiceResults
        ))
        
        // Sort by severity (critical first) then by score (lowest first)
        return weakAreas.sorted { first, second in
            if first.severity != second.severity {
                return first.severity.rawValue < second.severity.rawValue
            }
            return first.averageScore < second.averageScore
        }
    }
    
    // MARK: - Question Type Analysis
    
    private static func analyzeQuestionType(
        _ questionType: QuestionType,
        testResults: [TestResult],
        practiceResults: [PracticeResult]
    ) -> WeakArea? {
        
        // Collect scores for this question type
        var scores: [Double] = []
        
        // From test results - extract type-specific performance
        for result in testResults {
            if let typeScore = extractTypeScore(from: result, type: questionType) {
                scores.append(typeScore)
            }
        }
        
        // From practice results
        for result in practiceResults {
            if result.questionType == questionType {
                scores.append(result.percentageScore)
            }
        }
        
        guard !scores.isEmpty else { return nil }
        
        let averageScore = scores.reduce(0, +) / Double(scores.count)
        let severity = determineSeverity(score: averageScore)
        
        // Only return if it's actually a weak area (< 80%)
        guard averageScore < 80 else { return nil }
        
        return WeakArea(
            questionType: questionType,
            subType: nil,
            difficulty: nil,
            title: questionType.displayName,
            description: generateTypeDescription(questionType, score: averageScore),
            averageScore: averageScore,
            totalAttempts: scores.count,
            severity: severity
        )
    }
    
    // MARK: - Sub-Type Analysis
    
    private static func analyzeSubTypes(
        testResults: [TestResult],
        practiceResults: [PracticeResult]
    ) -> [WeakArea] {
        
        var subTypeScores: [String: [Double]] = [:]
        
        // Collect sub-type specific scores from practice results
        for result in practiceResults {
            if let subType = result.subType {
                subTypeScores[subType, default: []].append(result.percentageScore)
            }
        }
        
        var weakSubTypes: [WeakArea] = []
        
        for (subType, scores) in subTypeScores {
            guard scores.count >= 2 else { continue } // Need at least 2 attempts
            
            let averageScore = scores.reduce(0, +) / Double(scores.count)
            guard averageScore < 75 else { continue } // Only weak sub-types
            
            let severity = determineSeverity(score: averageScore)
            let questionType = determineQuestionType(for: subType)
            
            weakSubTypes.append(WeakArea(
                questionType: questionType,
                subType: subType,
                difficulty: nil,
                title: formatSubTypeName(subType),
                description: generateSubTypeDescription(subType, score: averageScore),
                averageScore: averageScore,
                totalAttempts: scores.count,
                severity: severity
            ))
        }
        
        return weakSubTypes
    }
    
    // MARK: - Difficulty Level Analysis
    
    private static func analyzeDifficultyLevels(
        testResults: [TestResult],
        practiceResults: [PracticeResult]
    ) -> [WeakArea] {
        
        var difficultyScores: [Difficulty: [Double]] = [:]
        
        // Analyze difficulty-specific performance from practice results
        for result in practiceResults {
            if let difficulty = result.difficulty {
                difficultyScores[difficulty, default: []].append(result.percentageScore)
            }
        }
        
        var weakDifficulties: [WeakArea] = []
        
        for (difficulty, scores) in difficultyScores {
            guard scores.count >= 3 else { continue } // Need sufficient data
            
            let averageScore = scores.reduce(0, +) / Double(scores.count)
            guard averageScore < 70 else { continue } // Only weak difficulties
            
            let severity = determineSeverity(score: averageScore)
            
            weakDifficulties.append(WeakArea(
                questionType: .verbal, // Will be updated with mixed type indicator
                subType: nil,
                difficulty: difficulty,
                title: "\(difficulty.displayName) " + NSLocalizedString("difficulty_questions", comment: "Difficulty Questions"),
                description: generateDifficultyDescription(difficulty, score: averageScore),
                averageScore: averageScore,
                totalAttempts: scores.count,
                severity: severity
            ))
        }
        
        return weakDifficulties
    }
    
    // MARK: - Helper Methods
    
    private static func extractTypeScore(from result: TestResult, type: QuestionType) -> Double? {
        // This would extract type-specific performance from a full test result
        // For now, we'll estimate based on overall score and type distribution
        
        let typeWeight: Double
        switch type {
        case .verbal: typeWeight = 0.33
        case .quantitative: typeWeight = 0.34
        case .nonVerbal: typeWeight = 0.33
        }
        
        // Simulate type-specific performance with some variance
        let variance = Double.random(in: -10...10)
        return min(100, max(0, result.percentageScore + variance))
    }
    
    private static func determineSeverity(score: Double) -> WeakArea.Severity {
        switch score {
        case ..<50: return .critical
        case 50..<70: return .moderate
        default: return .minor
        }
    }
    
    private static func determineQuestionType(for subType: String) -> QuestionType {
        if VerbalSubType.allCases.map(\.rawValue).contains(subType) {
            return .verbal
        } else if QuantitativeSubType.allCases.map(\.rawValue).contains(subType) {
            return .quantitative
        } else {
            return .nonVerbal
        }
    }
    
    private static func formatSubTypeName(_ subType: String) -> String {
        return subType.replacingOccurrences(of: "_", with: " ").capitalized
    }
    
    // MARK: - Description Generators
    
    private static func generateTypeDescription(_ type: QuestionType, score: Double) -> String {
        let baseKey: String
        switch type {
        case .verbal:
            baseKey = "verbal_weakness_desc"
        case .quantitative:
            baseKey = "quantitative_weakness_desc"
        case .nonVerbal:
            baseKey = "nonverbal_weakness_desc"
        }
        
        return NSLocalizedString(baseKey, comment: "Type-specific weakness description")
    }
    
    private static func generateSubTypeDescription(_ subType: String, score: Double) -> String {
        switch subType {
        case VerbalSubType.analogies.rawValue:
            return NSLocalizedString("analogies_weakness_desc", comment: "Analogies weakness description")
        case VerbalSubType.sentenceCompletion.rawValue:
            return NSLocalizedString("sentence_completion_weakness_desc", comment: "Sentence completion weakness description")
        case VerbalSubType.classification.rawValue:
            return NSLocalizedString("classification_weakness_desc", comment: "Classification weakness description")
        case QuantitativeSubType.numberAnalogies.rawValue:
            return NSLocalizedString("number_analogies_weakness_desc", comment: "Number analogies weakness description")
        case QuantitativeSubType.quantitativeAnalogies.rawValue:
            return NSLocalizedString("quantitative_analogies_weakness_desc", comment: "Quantitative analogies weakness description")
        case QuantitativeSubType.equationBuilding.rawValue:
            return NSLocalizedString("equation_building_weakness_desc", comment: "Equation building weakness description")
        default:
            return NSLocalizedString("general_weakness_desc", comment: "General weakness description")
        }
    }
    
    private static func generateDifficultyDescription(_ difficulty: Difficulty, score: Double) -> String {
        let baseKey = "\(difficulty.rawValue)_difficulty_weakness_desc"
        return NSLocalizedString(baseKey, comment: "Difficulty-specific weakness description")
    }
}

// MARK: - Extensions

extension WeakArea.Severity {
    var rawValue: Int {
        switch self {
        case .critical: return 0
        case .moderate: return 1
        case .minor: return 2
        }
    }
}

extension Difficulty {
    var displayName: String {
        switch self {
        case .easy: return NSLocalizedString("easy", comment: "Easy")
        case .medium: return NSLocalizedString("medium", comment: "Medium")
        case .hard: return NSLocalizedString("hard", comment: "Hard")
        }
    }
}
