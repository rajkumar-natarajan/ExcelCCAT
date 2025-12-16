# Changelog

All notable changes to the ExcelCCAT project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Flutter Migration] - 2025-10-02 🍁 **UI & SETTINGS UPDATE**

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
