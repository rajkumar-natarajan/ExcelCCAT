import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question.dart';

/// Manages smart learning features: weak areas, spaced repetition, bookmarks
class SmartLearningController extends ChangeNotifier {
  static final SmartLearningController _instance = SmartLearningController._internal();
  factory SmartLearningController() => _instance;
  SmartLearningController._internal();

  // Performance tracking by question type and subtype
  Map<String, PerformanceStats> _performanceBySubType = {};
  
  // Bookmarked question IDs
  Set<String> _bookmarkedQuestions = {};
  
  // Questions answered incorrectly with timestamp for spaced repetition
  Map<String, DateTime> _incorrectQuestions = {};
  
  // Questions answered correctly (to exclude from weak area focus)
  Set<String> _masteredQuestions = {};

  bool _isInitialized = false;

  /// Initialize and load from storage
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    final prefs = await SharedPreferences.getInstance();
    
    // Load performance stats
    final perfJson = prefs.getString('smart_learning_performance');
    if (perfJson != null) {
      final Map<String, dynamic> data = jsonDecode(perfJson);
      _performanceBySubType = data.map((key, value) => 
        MapEntry(key, PerformanceStats.fromJson(value)));
    }
    
    // Load bookmarks
    final bookmarks = prefs.getStringList('smart_learning_bookmarks');
    if (bookmarks != null) {
      _bookmarkedQuestions = bookmarks.toSet();
    }
    
    // Load incorrect questions
    final incorrectJson = prefs.getString('smart_learning_incorrect');
    if (incorrectJson != null) {
      final Map<String, dynamic> data = jsonDecode(incorrectJson);
      _incorrectQuestions = data.map((key, value) => 
        MapEntry(key, DateTime.parse(value)));
    }
    
    // Load mastered questions
    final mastered = prefs.getStringList('smart_learning_mastered');
    if (mastered != null) {
      _masteredQuestions = mastered.toSet();
    }
    
    _isInitialized = true;
    notifyListeners();
  }

  /// Save all data to storage
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save performance stats
    final perfData = _performanceBySubType.map((key, value) => 
      MapEntry(key, value.toJson()));
    await prefs.setString('smart_learning_performance', jsonEncode(perfData));
    
    // Save bookmarks
    await prefs.setStringList('smart_learning_bookmarks', _bookmarkedQuestions.toList());
    
    // Save incorrect questions
    final incorrectData = _incorrectQuestions.map((key, value) => 
      MapEntry(key, value.toIso8601String()));
    await prefs.setString('smart_learning_incorrect', jsonEncode(incorrectData));
    
    // Save mastered questions
    await prefs.setStringList('smart_learning_mastered', _masteredQuestions.toList());
  }

  // ==================== BOOKMARKS ====================

  bool isBookmarked(String questionId) => _bookmarkedQuestions.contains(questionId);

  void toggleBookmark(String questionId) {
    if (_bookmarkedQuestions.contains(questionId)) {
      _bookmarkedQuestions.remove(questionId);
    } else {
      _bookmarkedQuestions.add(questionId);
    }
    _save();
    notifyListeners();
  }

  Set<String> get bookmarkedQuestionIds => Set.from(_bookmarkedQuestions);
  
  int get bookmarkCount => _bookmarkedQuestions.length;

  // ==================== PERFORMANCE TRACKING ====================

  /// Record an answer for a question
  void recordAnswer(Question question, bool isCorrect) {
    final subType = question.subType;
    
    // Update performance stats
    if (!_performanceBySubType.containsKey(subType)) {
      _performanceBySubType[subType] = PerformanceStats(subType: subType);
    }
    _performanceBySubType[subType]!.recordAttempt(isCorrect);
    
    // Update spaced repetition tracking
    if (isCorrect) {
      // If answered correctly twice, mark as mastered
      if (_incorrectQuestions.containsKey(question.id)) {
        _incorrectQuestions.remove(question.id);
        _masteredQuestions.add(question.id);
      }
    } else {
      // Track incorrect answer with timestamp
      _incorrectQuestions[question.id] = DateTime.now();
      _masteredQuestions.remove(question.id);
    }
    
    _save();
    notifyListeners();
  }

  /// Record multiple answers from a test session
  void recordTestSession(List<Question> questions, List<UserAnswer> answers) {
    for (int i = 0; i < questions.length && i < answers.length; i++) {
      recordAnswer(questions[i], answers[i].isCorrect);
    }
  }

  /// Get performance stats for a subtype
  PerformanceStats? getStats(String subType) => _performanceBySubType[subType];

  /// Get all performance stats
  Map<String, PerformanceStats> get allStats => Map.from(_performanceBySubType);

  // ==================== WEAK AREA FOCUS ====================

  /// Get subtypes sorted by weakness (lowest accuracy first)
  List<String> getWeakAreas() {
    final sorted = _performanceBySubType.entries.toList()
      ..sort((a, b) => a.value.accuracy.compareTo(b.value.accuracy));
    return sorted.map((e) => e.key).toList();
  }

  /// Get the weakest subtypes (below 70% accuracy)
  List<String> getWeakSubTypes() {
    return _performanceBySubType.entries
        .where((e) => e.value.accuracy < 70 && e.value.totalAttempts >= 3)
        .map((e) => e.key)
        .toList();
  }

  /// Check if a subtype is a weak area
  bool isWeakArea(String subType) {
    final stats = _performanceBySubType[subType];
    if (stats == null || stats.totalAttempts < 3) return false;
    return stats.accuracy < 70;
  }

  // ==================== SPACED REPETITION ====================

  /// Get questions due for review (answered incorrectly and enough time has passed)
  List<String> getQuestionsForReview() {
    final now = DateTime.now();
    return _incorrectQuestions.entries
        .where((e) {
          final daysSinceIncorrect = now.difference(e.value).inDays;
          // Review after 1 day, then 3 days, then 7 days
          return daysSinceIncorrect >= 1;
        })
        .map((e) => e.key)
        .toList();
  }

  /// Check if a question needs review
  bool needsReview(String questionId) {
    if (!_incorrectQuestions.containsKey(questionId)) return false;
    final daysSince = DateTime.now().difference(_incorrectQuestions[questionId]!).inDays;
    return daysSince >= 1;
  }

  /// Get count of questions needing review
  int get reviewCount => getQuestionsForReview().length;

  // ==================== SMART QUESTION SELECTION ====================

  /// Prioritize questions based on smart learning
  /// - Questions needing review come first
  /// - Questions from weak areas come second
  /// - Exclude mastered questions (optional)
  List<Question> prioritizeQuestions(
    List<Question> questions, {
    bool includeReviewQuestions = true,
    bool focusWeakAreas = true,
    bool excludeMastered = false,
  }) {
    List<Question> result = List.from(questions);
    
    // Optionally exclude mastered questions
    if (excludeMastered) {
      result = result.where((q) => !_masteredQuestions.contains(q.id)).toList();
    }
    
    // Sort by priority
    result.sort((a, b) {
      // Priority 1: Questions needing review
      if (includeReviewQuestions) {
        final aReview = needsReview(a.id);
        final bReview = needsReview(b.id);
        if (aReview && !bReview) return -1;
        if (!aReview && bReview) return 1;
      }
      
      // Priority 2: Questions from weak areas
      if (focusWeakAreas) {
        final aWeak = isWeakArea(a.subType);
        final bWeak = isWeakArea(b.subType);
        if (aWeak && !bWeak) return -1;
        if (!aWeak && bWeak) return 1;
      }
      
      return 0;
    });
    
    return result;
  }

  // ==================== SUMMARY ====================

  /// Get a summary of smart learning status
  SmartLearningSummary getSummary() {
    return SmartLearningSummary(
      totalQuestionsAttempted: _performanceBySubType.values
          .fold(0, (sum, stats) => sum + stats.totalAttempts),
      weakAreaCount: getWeakSubTypes().length,
      reviewDueCount: reviewCount,
      bookmarkCount: bookmarkCount,
      masteredCount: _masteredQuestions.length,
    );
  }

  /// Clear all smart learning data
  Future<void> clearAllData() async {
    _performanceBySubType.clear();
    _bookmarkedQuestions.clear();
    _incorrectQuestions.clear();
    _masteredQuestions.clear();
    await _save();
    notifyListeners();
  }
}

/// Performance statistics for a question subtype
class PerformanceStats {
  final String subType;
  int totalAttempts;
  int correctAttempts;
  DateTime? lastAttempt;

  PerformanceStats({
    required this.subType,
    this.totalAttempts = 0,
    this.correctAttempts = 0,
    this.lastAttempt,
  });

  double get accuracy => totalAttempts > 0 ? (correctAttempts / totalAttempts) * 100 : 0;

  void recordAttempt(bool isCorrect) {
    totalAttempts++;
    if (isCorrect) correctAttempts++;
    lastAttempt = DateTime.now();
  }

  Map<String, dynamic> toJson() => {
    'subType': subType,
    'totalAttempts': totalAttempts,
    'correctAttempts': correctAttempts,
    'lastAttempt': lastAttempt?.toIso8601String(),
  };

  factory PerformanceStats.fromJson(Map<String, dynamic> json) => PerformanceStats(
    subType: json['subType'] ?? '',
    totalAttempts: json['totalAttempts'] ?? 0,
    correctAttempts: json['correctAttempts'] ?? 0,
    lastAttempt: json['lastAttempt'] != null ? DateTime.parse(json['lastAttempt']) : null,
  );
}

/// Summary of smart learning status
class SmartLearningSummary {
  final int totalQuestionsAttempted;
  final int weakAreaCount;
  final int reviewDueCount;
  final int bookmarkCount;
  final int masteredCount;

  SmartLearningSummary({
    required this.totalQuestionsAttempted,
    required this.weakAreaCount,
    required this.reviewDueCount,
    required this.bookmarkCount,
    required this.masteredCount,
  });
}
