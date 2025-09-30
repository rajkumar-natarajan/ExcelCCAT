# ExcelCCAT - Bilingual CCAT-7 Level 12 Prep App

## Overview
ExcelCCAT is a comprehensive iOS application designed for CCAT-7 Level 12 test preparation with full bilingual support (English/French). The app provides offline functionality, deterministic mock tests, progress analytics, and adaptive learning features.

## Features

### ✅ Core Functionality
- **Bilingual Interface**: Complete English/French localization
- **Offline Operation**: No internet required for core functionality
- **Deterministic Mock Tests**: Three consistent full mock test sets (A/B/C)
- **Practice Sessions**: Targeted practice by question type and difficulty
- **Progress Analytics**: Comprehensive performance tracking and insights
- **Battery Monitoring**: Low battery warnings during sessions
- **Haptic Feedback**: Enhanced user experience with tactile responses

### ✅ Question Management
- **600+ Questions**: Across three main types (Verbal, Quantitative, Non-Verbal)
- **Difficulty Levels**: Easy, Medium, Hard progression
- **Synthetic Generation**: Volume expansion while maintaining quality
- **Deterministic Partitioning**: Ensures consistent mock test experiences

### ✅ Test Session Features
- **Full Mock Tests**: 176 questions, 75-minute timed sessions
- **Practice Modes**: Customizable question count and timing
- **Session Persistence**: Resume interrupted sessions
- **Time Warnings**: Localized notifications for time management
- **Result Recording**: Separate tracking for practice vs test sessions

### ✅ User Interface
- **SwiftUI Architecture**: Modern, responsive design
- **@Observable State Management**: Efficient data flow
- **Dark/Light Mode Support**: Automatic theme adaptation
- **Accessibility**: VoiceOver and accessibility feature support
- **Custom Animations**: Smooth transitions and feedback

## Technical Architecture

### Models
- `Question`: Core question structure with bilingual content
- `TestSession`: Session state management
- `TestResult`/`PracticeResult`: Performance tracking
- `UserProgress`: Achievement and statistics storage

### ViewModels
- `AppViewModel`: Global app state and session management
- `TestSessionViewModel`: Active test session control

### Views
- `HomeView`: Dashboard and quick access
- `TestSessionView`: Test-taking interface
- `ProgressView`: Analytics and insights dashboard
- `SettingsView`: Configuration and data management
- `PracticeView`: Practice session setup

### Data Management
- `QuestionDataManager`: Centralized question repository
- Deterministic mock set generation
- Synthetic question expansion
- Local persistence with UserDefaults

## Question Types

### Verbal Reasoning
- **Analogies**: Word relationship patterns
- **Sentence Completion**: Context-based vocabulary
- **Classification**: Categorical thinking

### Quantitative Reasoning
- **Number Analogies**: Mathematical relationships
- **Quantitative Analogies**: Formula and equation patterns
- **Equation Building**: Problem-solving skills

### Non-Verbal Reasoning
- **Figure Matrices**: Pattern recognition in grids
- **Figure Classification**: Visual categorization
- **Figure Series**: Sequential pattern completion

## Localization

### Supported Languages
- **English**: Complete interface and content
- **French**: Full translation with cultural adaptation

### Localized Content
- Interface text and navigation
- Question stems and answer options
- Explanations and feedback
- Error messages and warnings
- Progress insights and recommendations

## Installation & Setup

### Requirements
- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

### Build Instructions
1. Clone the repository
2. Open `ExcelCCAT.xcodeproj` in Xcode
3. Select target device/simulator
4. Build and run (⌘+R)

### Dependencies
- SwiftUI (iOS 17+)
- Foundation
- UserNotifications
- UIKit (for haptics)

## Usage Guide

### Getting Started
1. Launch app and complete onboarding
2. Choose language preference (English/French)
3. Review dashboard for quick access options

### Taking Tests
1. **Full Mock Test**: Complete 176-question timed assessment
2. **Practice Sessions**: Choose question type, count, and timing
3. **Review Results**: Analyze performance and identify improvement areas

### Progress Tracking
1. View performance trends over time
2. Identify weak areas for focused practice
3. Track achievement milestones
4. Export progress reports

## Development Status

### Version 1.0 Features ✅
- [x] Core app architecture
- [x] Bilingual question database
- [x] Test session management
- [x] Progress analytics
- [x] Deterministic mock tests
- [x] Battery monitoring
- [x] Haptic feedback
- [x] Time warnings

### Upcoming Features 🚧
- [ ] Enhanced question content quality
- [ ] Weak area identification system
- [ ] Achievement unlock mechanics
- [ ] Sound effects integration
- [ ] Non-verbal image assets
- [ ] Review session functionality

## File Structure

```
ExcelCCAT/
├── Models/
│   ├── Question.swift
│   ├── TestSession.swift
│   ├── TestResult.swift
│   └── UserProgress.swift
├── ViewModels/
│   ├── AppViewModel.swift
│   └── TestSessionViewModel.swift
├── Views/
│   ├── HomeView.swift
│   ├── TestSessionView.swift
│   ├── ProgressView.swift
│   ├── SettingsView.swift
│   └── PracticeView.swift
├── Data/
│   └── QuestionDataManager.swift
├── Localization/
│   ├── Localizable.strings (en)
│   └── Localizable.strings (fr)
├── Utilities/
│   └── AppTheme.swift
└── Resources/
    └── Assets.xcassets
```

## Testing

### Unit Tests
- Question data validation
- Score calculation accuracy
- Session state management
- Localization completeness

### UI Tests
- Navigation flow verification
- Accessibility compliance
- Cross-language functionality
- Performance benchmarks

## Contributing

### Code Style
- SwiftUI best practices
- @Observable pattern usage
- Comprehensive documentation
- Localization considerations

### Pull Request Process
1. Create feature branch
2. Implement with tests
3. Update documentation
4. Submit PR with description

## License

Copyright © 2025 Rajkumar Natarajan. All rights reserved.

## Contact

For questions or support, please contact the development team.

---

*Last updated: September 30, 2025*
