# ExcelCCAT Flutter App

See the main [README.md](../README.md) for complete documentation.

## Quick Start

```bash
# Install dependencies
flutter pub get

# Run on macOS
flutter run -d macos

# Run on iOS
flutter run -d ios

# Run on Android
flutter run -d android

# Run on Web
flutter run -d chrome
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── controllers/              # State management
├── data/                     # Question data
├── models/                   # Data models
└── screens/                  # UI screens
```

    flutter run -d chrome
    ```

## Project Structure

*   `lib/main.dart`: App entry point with navigation and theming.
*   `lib/models/`: Data models for Questions, Test Configurations, and Results.
*   `lib/data/`: `QuestionDataManager` handles question generation and filtering logic.
*   `lib/controllers/`: State management (e.g., `SettingsController`).
*   `lib/screens/`: UI screens:
    *   `dashboard_screen.dart`: Home screen with welcome card.
    *   `practice_screen.dart`: Test configuration with question type filters.
    *   `study_guide_screen.dart`: Tips and strategies for each question type.
    *   `test_session_screen.dart`: Active test-taking interface.
    *   `results_screen.dart`: Score summary and performance breakdown.
    *   `review_screen.dart`: Per-question review with explanations.
    *   `progress_screen.dart`: Historical performance analytics.
    *   `settings_screen.dart`: App settings (theme, language, level).
*   `test/`: Integration and Unit tests.

## Note on Non-Verbal Questions
In this version, Non-Verbal questions (Figure Matrices, Classification, Series) are implemented as **text-based logic puzzles** to demonstrate the logic without requiring external image assets. Future updates will include graphical assets for these sections.

## Roadmap

### 🎮 Gamification & Engagement
- [ ] Daily Streak System - Reward consecutive days of practice with badges
- [ ] Achievement Badges - Unlock badges for milestones (100 questions, perfect scores)
- [ ] XP/Points System - Earn points for correct answers, bonus for speed
- [ ] Leaderboard - Compare scores with other students

### 🧠 Smart Learning (In Progress)
- [x] Weak Area Focus - Automatically prioritize question types you struggle with
- [x] Spaced Repetition - Re-show missed questions after intervals
- [ ] Adaptive Difficulty - Adjust question difficulty based on performance
- [x] Bookmark Questions - Save difficult questions for later review

### 📊 Enhanced Analytics
- [ ] Time Per Question Stats - Track how long each question type takes
- [ ] Trend Charts - Show improvement over time with graphs
- [ ] Weekly/Monthly Reports - Summary emails or in-app reports
- [ ] Percentile Comparison - Compare to other CCAT test-takers

### 🎨 User Experience
- [ ] Onboarding Tutorial - Guide new users through the app
- [ ] Animations - Add smooth transitions and micro-interactions
- [ ] Sound Effects - Optional audio for correct/incorrect answers
- [ ] Haptic Feedback - Vibration on mobile for answer selection

### 📱 Features
- [ ] Offline Mode - Download questions for offline practice
- [ ] Cloud Sync - Sync progress across devices (Firebase)
- [ ] Export Results as PDF - Share or print test results
- [ ] Push Notifications - Daily practice reminders
- [ ] Parent/Teacher Dashboard - Monitor student progress

### 📝 Content
- [ ] More Verbal Questions - Expand analogies, classification, sentence completion
- [ ] Image-Based Non-Verbal - Add actual figure/shape images
- [ ] Complete French Translation - Full bilingual content
- [ ] Timed Mini-Challenges - 5-question speed rounds

### ♿ Accessibility
- [ ] VoiceOver/TalkBack Support - Screen reader compatibility
- [ ] High Contrast Mode - For visually impaired users
- [ ] Larger Touch Targets - Better for motor accessibility

