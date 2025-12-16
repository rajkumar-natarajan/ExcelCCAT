# ExcelCCAT - CCAT Test Preparation App 🍁

<p align="center">
  <img src="screenshots/home.png" width="250" alt="Home Screen" />
  <img src="screenshots/practice.png" width="250" alt="Practice Screen" />
  <img src="screenshots/progress.png" width="250" alt="Progress Screen" />
</p>

A cross-platform Flutter application for **CCAT (Canadian Cognitive Abilities Test)** preparation, supporting iOS, Android, Web, and macOS.

## ✨ Features

### 📚 Comprehensive Question Bank
- **70+ Questions** across all CCAT levels (K, 10, 11, 12)
- **Three Main Batteries**:
  - **Verbal**: Analogies, Sentence Completion, Classification
  - **Quantitative**: Number Analogies, Number Series, Quantitative Relations
  - **Non-Verbal**: Figure Matrices, Figure Classification, Figure Series

### 🧠 Smart Learning System
- **Weak Area Detection** - Automatically identifies question types you struggle with
- **Spaced Repetition** - Re-shows missed questions at optimal intervals
- **Question Bookmarks** - Save difficult questions for later review
- **Performance Tracking** - Track accuracy per question subtype

### 📝 Test Modes
| Mode | Questions | Time |
|------|-----------|------|
| Quick Assessment | 20 | 10 min |
| Standard Practice | 50 | 30 min |
| Full Mock Test | 176 | 90 min |

### 📖 Study Guide
- Comprehensive tips and strategies for each question type
- Examples for Verbal, Quantitative, and Non-Verbal batteries
- Time management and test-taking strategies

### 📊 Progress Analytics
- Performance breakdown by category (Verbal, Quantitative, Non-Verbal)
- Weak areas identification with accuracy tracking
- Mastery count and questions due for review

### ⚙️ Customization
- **Theme**: Canadian Red theme with Dark Mode support
- **Language**: English and French (structure ready)
- **Grade Level**: Adjustable from K-12

## 📱 Screenshots

| Home | Practice | Study Guide |
|------|----------|-------------|
| ![Home](screenshots/home.png) | ![Practice](screenshots/practice.png) | ![Guide](screenshots/guide.png) |

| Test Session | Results | Progress |
|--------------|---------|----------|
| ![Test](screenshots/test.png) | ![Results](screenshots/results.png) | ![Progress](screenshots/progress.png) |

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.10.0 or higher
- Dart SDK
- Xcode (for iOS/macOS)
- Android Studio (for Android)

### Installation

```bash
# Clone the repository
git clone https://github.com/rajkumar-natarajan/ExcelCCAT.git
cd ExcelCCAT/excel_ccat_flutter

# Install dependencies
flutter pub get

# Run on macOS
flutter run -d macos

# Run on iOS Simulator
flutter run -d ios

# Run on Android
flutter run -d android

# Run on Web
flutter run -d chrome
```

## 📁 Project Structure

```
excel_ccat_flutter/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── controllers/
│   │   ├── settings_controller.dart
│   │   └── smart_learning_controller.dart
│   ├── data/
│   │   └── question_data_manager.dart
│   ├── models/
│   │   └── question.dart
│   └── screens/
│       ├── dashboard_screen.dart
│       ├── practice_screen.dart
│       ├── progress_screen.dart
│       ├── results_screen.dart
│       ├── review_screen.dart
│       ├── settings_screen.dart
│       ├── study_guide_screen.dart
│       └── test_session_screen.dart
├── test/
│   └── app_test.dart
└── pubspec.yaml
```

## 🎨 Design

- **Material 3** design system
- **Canadian Red** (#C8102E) as primary color
- **Dark Mode** support with system theme detection
- **Responsive** layout for mobile and desktop

## 🛠️ Tech Stack

- **Framework**: Flutter 3.10+
- **State Management**: ChangeNotifier
- **Data Persistence**: SharedPreferences
- **Platforms**: iOS, Android, Web, macOS

## 🗺️ Roadmap

### 🎮 Gamification & Engagement
- [ ] Daily Streak System
- [ ] Achievement Badges
- [ ] XP/Points System
- [ ] Leaderboard

### 🧠 Smart Learning (Implemented ✅)
- [x] Weak Area Focus
- [x] Spaced Repetition
- [x] Bookmark Questions
- [ ] Adaptive Difficulty

### 📊 Enhanced Analytics
- [ ] Time Per Question Stats
- [ ] Trend Charts
- [ ] Weekly/Monthly Reports

### 📝 Content
- [ ] More Verbal Questions
- [ ] Image-Based Non-Verbal
- [ ] Complete French Translation

## 📄 Changelog

See [CHANGELOG.md](CHANGELOG.md) for detailed version history.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is for educational purposes.

## 👨‍💻 Author

**Raj Kumar Natarajan**

- GitHub: [@rajkumar-natarajan](https://github.com/rajkumar-natarajan)

---

<p align="center">Made with ❤️ for Canadian students 🍁</p>
