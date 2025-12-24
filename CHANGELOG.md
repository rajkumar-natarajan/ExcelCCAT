# Changelog

All notable changes to the ExcelCCAT project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.5.1] - 2025-12-24 🐛 **BUG FIX**

### 🐛 Fixed - Quick Actions Navigation
- **Quick Actions**: Fixed issue where tapping Verbal, Quantitative, or Non-Verbal quick action buttons always navigated to the Practice screen without pre-selecting the category.
- **Category Pre-selection**: Quick actions now correctly pre-select the corresponding question type (Verbal, Quantitative, or Non-Verbal) when navigating to the Practice screen.
- **Improved UX**: Users can now quickly start practicing a specific category directly from the dashboard.

## [1.5.0] - 2025-12-16 🎮 **GAMIFICATION & APP STORE READY**

### ✅ Added - Gamification System
- **GamificationController**: New controller managing XP, levels, points, streaks, and achievements.
- **XP & Level System**: Earn XP for correct answers and test completion, level up as you progress.
- **Points System**: 10 base points per correct answer with streak multipliers (up to +20 for 10+ streak).
- **Answer Streaks**: Track consecutive correct answers with bonus rewards.
- **Daily Streaks**: Track consecutive practice days with 3, 7, and 30-day achievements.

### ✅ Added - Achievement System (22 Badges)
- **Answer Milestones**: First Steps, Getting Started, Knowledge Seeker, Scholar, Master Mind (1-500 correct).
- **Answer Streaks**: On Fire, Hot Streak, Unstoppable, Legend (3-20 in a row).
- **Daily Streaks**: Consistent, Dedicated, Committed (3-30 days).
- **Tests Completed**: Test Taker, Test Pro, Test Master (1-50 tests).
- **Perfect Scores**: Perfect Score badge for 100% on any test.
- **Level Milestones**: Rising Star, Expert, Champion (levels 5, 10, 25).
- **XP Milestones**: XP Hunter, XP Master, XP Legend (1K-10K XP).
- **Rarity System**: Common, Uncommon, Rare, Epic, Legendary badges.

### ✅ Added - Achievements Screen
- **Stats Tab**: Level card with XP progress bar, points display, answer streak, daily streak.
- **Badges Tab**: All 22 achievements showing locked/unlocked status, rarity colors, and rewards.
- **Quick Summary**: Total XP, level title, achievements count.

### ✅ Added - Dashboard Gamification
- **Gamification Card**: Shows Level, Daily Streak, Points, and XP progress bar.
- **Daily Challenges**: Three daily goals (5 questions, 3-streak, full test) with progress tracking.
- **Achievements Button**: Quick access in app bar and action grid.

### ✅ Added - Reward Integration
- **Test Session Rewards**: XP/points awarded for each correct answer during tests.
- **Completion Bonus**: Extra XP for finishing tests with accuracy and speed bonuses.
- **Results Screen Rewards**: Shows points earned, XP gained, and level-up celebration.
- **Level Up Banner**: Animated celebration when reaching new level.

### ✅ Added - App Store Preparation
- **APP_STORE_GUIDE.md**: Comprehensive guide for App Store submission.
- **App Description**: Full description with keywords for App Store.
- **Privacy Policy Template**: Ready-to-use privacy policy content.
- **Screenshot Requirements**: Detailed specifications for all device sizes.
- **Icon Requirements**: All required sizes documented.

### ✅ Updated - Canadian Theme
- **CanadianColors**: Expanded color palette with Canadian Red variations.
- **CanadianBackground**: Subtle maple leaf pattern backgrounds.
- **CanadianQuestionCard**: Themed question cards with red accents.
- **MapleDivider**: Decorative divider with maple leaf.

### ✅ Updated - Branding
- **Removed "Flutter" mentions**: App no longer references Flutter framework.
- **Version**: Updated to 1.5.0 for App Store release.
- **Bundle Settings**: Prepared for com.yourcompany.excelccat bundle ID.

### ✅ Updated - Documentation
- **README.md**: Complete rewrite with all features documented.
- **CHANGELOG.md**: Comprehensive version history.
- **Project Structure**: Updated to reflect all new files.

---

## [1.4.0] - 2025-12-16 📊 **ENHANCED ANALYTICS & CONTENT**

### ✅ Added - Time Analytics
- **Time Per Question Tracking**: Records time spent on each question subtype.
- **Average Time by Category**: Shows average solving time for Verbal, Quantitative, Non-Verbal.
- **Time Stats Storage**: Persists fastest/slowest times in SharedPreferences.
- **Time Stats Tab**: New tab in Progress screen showing detailed timing analytics.

### ✅ Added - Test History & Trends
- **Test Session Recording**: Stores completed test sessions with date, score, timing.
- **Weekly Accuracy Trend**: Bar chart showing accuracy improvement over weeks.
- **Daily Practice Count**: Visual chart of practice sessions per day (last 7 days).
- **Recent Sessions List**: View last 10 test sessions with scores and duration.
- **Trend Analysis**: Calculates weekly averages for performance tracking.

### ✅ Added - Progress Screen Redesign
- **Three-Tab Layout**: Overview, Trends, Time Stats tabs for organized analytics.
- **Visual Charts**: Simple bar charts for accuracy trends and daily activity.
- **Empty States**: Helpful messages when no data is available yet.
- **Session History**: Detailed list of recent test sessions.

### ✅ Added - Expanded Verbal Content
- **Synonyms Questions**: 8 new questions per level (24 total).
- **Antonyms Questions**: 8 new questions per level (24 total).
- **Expanded Analogies**: 8 questions per level (up from 5).
- **Study Guide Updates**: Added Synonyms and Antonyms sections with tips.

### ✅ Added - New Verbal Subtypes
- **VerbalSubType.synonyms**: Find words with similar meanings.
- **VerbalSubType.antonyms**: Find words with opposite meanings.
- **Question Bank Growth**: 48 new verbal questions added.

---

## [1.3.0] - 2025-12-16 🧹 **PROJECT CLEANUP**

### ✅ Removed - Swift/Native iOS Code
- **Removed Swift App**: Deleted ExcelCCAT/, ExcelCCAT.xcodeproj/, ExcelCCATTests/, ExcelCCATUITests/.
- **Removed Swift Tests**: Deleted Tests/, TestResults/, question_manager_test.swift.
- **Removed Outdated Docs**: Deleted DEVELOPMENT.md, ISSUE_RESOLUTION_SUMMARY.md, RELEASE_NOTES.md, TECHNICAL_DOCUMENTATION.md, TESTING_PERFORMANCE_ANALYSIS.md, USER_GUIDE.md.

### ✅ Updated - Documentation
- **New README**: Complete rewrite focused on Flutter app only.
- **Project Structure**: Updated to reflect Flutter-only codebase.
- **Screenshots Folder**: Added placeholder for app screenshots.

### ✅ Simplified - Repository
- **Single Framework**: Now Flutter-only for easier maintenance.
- **Cross-Platform**: iOS, Android, Web, and macOS all from single codebase.

---

## [Flutter 1.2.0] - 2025-12-16 🧠 **SMART LEARNING FEATURES**

### ✅ Added - Smart Learning Controller
- **SmartLearningController**: New singleton controller for intelligent learning features.
- **Performance Tracking**: Records accuracy per question subtype (Synonyms, Number Analogies, etc.).
- **Weak Area Detection**: Identifies subtypes with <70% accuracy after 3+ attempts.
- **Spaced Repetition**: Tracks incorrect answers with timestamps for scheduled review.
- **Mastery Tracking**: Marks questions as mastered after consecutive correct answers.

### ✅ Added - Bookmark Feature
- **Bookmark Button**: Added to test session screen (app bar) for bookmarking questions.
- **Persistent Storage**: Bookmarks saved to SharedPreferences for persistence across sessions.
- **Bookmark Count**: Displayed in Practice screen and Progress screen.

### ✅ Added - Smart Practice Mode
- **Smart Practice Card**: New card in Practice screen with learning statistics.
- **Weak Areas Button**: Start practice focusing on subtypes you struggle with.
- **Bookmarks Button**: Practice only your bookmarked questions.
- **Question Prioritization**: Review questions and weak areas prioritized first.
- **Adaptive Session Length**: Smart practice uses 15 questions with 2 min per question.

### ✅ Enhanced - Progress Screen
- **Smart Learning Status**: New card showing weak area count and questions due for review.
- **Dynamic Accuracy**: Category progress bars now show real accuracy data from practice.
- **Weak Areas Section**: Lists specific subtypes needing improvement with practice button.
- **Mastery Count**: Shows total number of mastered questions.

### ✅ Technical
- **SharedPreferences Dependency**: Added for persistent data storage.
- **Singleton Pattern**: SmartLearningController uses factory constructor for global access.
- **JSON Serialization**: Performance stats serialized for storage.

---

## [Flutter 1.1.0] - 2025-12-16 📚 **STUDY GUIDE & QUESTION FIXES**

### ✅ Added - Study Guide
- **Comprehensive Study Guide**: New "Guide" tab in bottom navigation with test-taking strategies.
- **Verbal Battery Tips**: Strategies for Analogies, Sentence Completion, and Classification questions.
- **Quantitative Battery Tips**: Strategies for Number Analogies, Series, and Relations questions.
- **Non-Verbal Battery Tips**: Strategies for Figure Matrices, Classification, and Series questions.
- **General Test-Taking Tips**: Time management, elimination, and review strategies with examples.

### ✅ Fixed - Question Categorization
- **Question Type Filter**: Added filter chips in Practice screen to select Verbal, Quantitative, or Non-Verbal.
- **Proper Filtering**: Questions are now correctly filtered by selected types before test starts.
- **No More Mixed Types**: Fixed bug where non-verbal questions appeared in verbal-only tests.

### ✅ Added - Expanded Question Bank
- **Number Analogies**: Expanded from 3 to 8 questions per level (24 total).
- **Number Series**: Expanded from 3 to 8 questions per level (24 total).
- **Quantitative Relations**: Expanded from 3 to 8 questions per level with clearer formatting (24 total).
- **Better Question Stems**: Improved question wording for clarity (e.g., "A: 5+3, B: 4+2" format).

---

## [Flutter 1.0.0] - 2025-10-02 🍁 **UI & SETTINGS UPDATE**

### ✅ Added - UI Modernization
- **Canadian Theme**: Implemented a new `ThemeData` using Canadian Red (`#C8102E`) as the seed color.
- **Dashboard Redesign**: Added a gradient welcome card and Maple Leaf iconography.
- **Settings Module**: Created `SettingsController` to manage:
    - **Theme Mode**: System, Light, Dark.
    - **Language**: English, French.
    - **Grade Level**: K, 1-2, 3-4, 5-8, 9-12.

### ✅ Fixed - Logic & State
- **Question Logic**: Implemented text-based logic for non-verbal questions to ensure playability without assets.
- **State Management**: Centralized app state using `ChangeNotifier` for settings persistence.
- **Build Fixes**: Resolved `AppBarTheme` and `Icon` errors in `main.dart` and `dashboard_screen.dart`.
- **Answer Review**: Added per-question review screen with correctness, user choice, correct answer, and explanations.

## [1.0.1] - 2025-09-30 🎯 **MAJOR STABILITY RELEASE**

### ✅ Fixed - Compilation & Build Issues
- **RESOLVED ALL COMPILATION ERRORS** - App now builds successfully with zero errors
- Fixed 70+ compilation errors in `QuestionDataManager.swift`
- Resolved SwiftUI generic parameter inference error in `SettingsView.swift`
- Fixed enum conversion issues throughout the codebase
- Corrected parameter order and type mismatches across all files

### ✅ Added - New Features & Components
- **Font Size Customization**: Small, Medium, Large, Extra Large options in settings
- **Accessibility Enhancement**: Added `isReducedMotionEnabled` setting for motion sensitivity
- **App Icon Generator**: New utility for dynamic icon generation (`AppIconGenerator.swift`)
- **Icon Renderer**: Custom icon rendering system (`IconRenderer.swift`)
- **Multi-Level Support**: Enhanced support for Level 10, 11, and 12 CCAT tests
- **Custom Test Configuration**: Advanced test setup with TDSB standards compliance

### ✅ Enhanced - Core Systems
- **Type Safety**: All enum conversions now use proper type-safe methods
- **Codable Compliance**: All models properly conform to Codable protocol
- **Settings System**: Expanded `AppSettings` with fontSize and accessibility options
- **Localization**: Enhanced bilingual support with proper localization methods
- **Error Handling**: Comprehensive error management throughout the app

### ✅ Improved - User Interface
- **SwiftUI Compatibility**: Fixed generic parameter inference issues
- **Settings View**: Complete redesign with VStack instead of Group for better stability
- **Theme System**: Enhanced `FontSize` enum with `displayName` and Codable conformance
- **UI Responsiveness**: Better handling of different screen sizes and orientations

### ✅ Technical Improvements
- **Data Persistence**: Enhanced UserDefaults storage with proper Codable support
- **Memory Management**: Improved object lifecycle and memory usage
- **Performance**: Optimized question loading and session management
- **Build Stability**: Zero compilation errors, ready for production development

### 🔧 Infrastructure
- **iOS Compatibility**: Updated minimum requirement to iOS 18.5+
- **Xcode Support**: Enhanced compatibility with Xcode 16.0+
- **Swift Version**: Updated to Swift 5.10+ for latest features
- **Testing**: Validated on iPhone 16 and iPhone 16 Pro simulators

### 📝 Documentation
- **README.md**: Comprehensive update with latest features and fixes
- **Code Comments**: Enhanced inline documentation throughout codebase
- **Architecture**: Updated technical architecture documentation
- **Setup Instructions**: Improved build and installation guidelines

### 🗂️ File Structure Changes
```
Added:
+ ExcelCCAT/Utils/AppIconGenerator.swift
+ ExcelCCAT/Utils/IconRenderer.swift

Modified:
~ ExcelCCAT/Data/QuestionDataManager.swift (70+ fixes)
~ ExcelCCAT/Models/Question.swift (enhanced Codable, localization)
~ ExcelCCAT/Utils/Theme.swift (FontSize enhancements)
~ ExcelCCAT/Views/SettingsView.swift (SwiftUI fixes)
~ ExcelCCAT/ViewModels/AppViewModel.swift (type safety)
~ ExcelCCAT/Views/*.swift (various improvements)
```

### 🐛 Bug Fixes
- Fixed missing `gradeRange` property in `CCATLevel` enum
- Added missing extension methods for `TDSBTestType` (questionCountRange, timeRange, etc.)
- Resolved parameter type mismatches in TestConfiguration
- Fixed SwiftUI View builder issues in settings sections
- Corrected enum case conversions in question generation

### ⚡ Performance
- Improved question loading efficiency
- Enhanced memory usage in test sessions
- Optimized SwiftUI view rendering
- Better state management with @Observable pattern

### 🔒 Security & Stability
- Enhanced data validation throughout the app
- Improved error handling and recovery
- Better session state persistence
- Robust Codable implementations for all models

### 📱 Compatibility
- **iOS 18.5+**: Full compatibility with latest iOS features
- **Device Support**: iPhone and iPad optimized layouts
- **Accessibility**: Enhanced VoiceOver and accessibility support
- **Internationalization**: Improved English/French bilingual support

---

## [1.0.0] - 2025-09-29

### Added
- Initial release of ExcelCCAT app
- Bilingual CCAT-7 Level 12 test preparation
- Complete SwiftUI interface
- Offline functionality
- Progress tracking system
- Mock test capabilities
- Practice session modes

### Features
- 600+ questions across three main types
- Deterministic mock test generation
- Comprehensive progress analytics
- Battery monitoring during sessions
- Haptic feedback system
- Dark/Light mode support

---

## Legend
- ✅ **Fixed**: Bug fixes and error resolutions
- ✅ **Added**: New features and components
- ✅ **Enhanced**: Improvements to existing features
- ✅ **Improved**: Performance and UX enhancements
- 🔧 **Infrastructure**: Technical and build improvements
- 📝 **Documentation**: Documentation updates
- 🗂️ **File Structure**: File organization changes
- 🐛 **Bug Fixes**: Specific bug resolutions
- ⚡ **Performance**: Performance optimizations
- 🔒 **Security & Stability**: Security and stability improvements
- 📱 **Compatibility**: Platform and device compatibility
