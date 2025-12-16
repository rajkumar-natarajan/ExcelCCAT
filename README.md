# ExcelCCAT - CCAT Test Preparation App 🍁

<p align="center">
  <img src="screenshots/app_icon.png" width="120" alt="ExcelCCAT Icon" />
</p>

<p align="center">
  <strong>Master the Canadian Cognitive Abilities Test</strong><br>
  Smart Learning • Gamification • Comprehensive Analytics
</p>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#screenshots">Screenshots</a> •
  <a href="#installation">Installation</a> •
  <a href="#app-store">App Store</a>
</p>

---

## ✨ Features

### 📚 Comprehensive Question Bank (100+ Questions)

| Category | Subtypes | Questions per Level |
|----------|----------|---------------------|
| **Verbal** | Analogies, Synonyms, Antonyms, Sentence Completion, Classification | 40+ |
| **Quantitative** | Number Analogies, Number Series, Quantitative Relations | 30+ |
| **Non-Verbal** | Figure Matrices, Figure Classification, Figure Series | 30+ |

- Supports all CCAT levels: **K, 10, 11, 12**
- Carefully crafted questions matching real CCAT difficulty
- Bilingual ready (English/French structure)

### 🎮 Gamification & Engagement

| Feature | Description |
|---------|-------------|
| **XP & Levels** | Earn experience points, level up from Beginner to Champion |
| **22 Achievements** | Unlock badges for milestones, streaks, perfect scores |
| **Daily Streaks** | Track consecutive practice days (3, 7, 30-day achievements) |
| **Daily Challenges** | Complete 5 questions, 3-streak, full test for bonus XP |
| **Points System** | Base points + streak multipliers (up to 2x) |

### 🧠 Smart Learning System

- **Weak Area Detection** - Automatically identifies struggling subtypes
- **Spaced Repetition** - Re-shows missed questions at optimal intervals  
- **Bookmarks** - Save difficult questions for focused review
- **Performance Tracking** - Track accuracy by question subtype
- **Adaptive Practice** - Prioritizes review questions and weak areas

### 📊 Detailed Analytics

| Tab | Insights |
|-----|----------|
| **Overview** | Category accuracy, weak areas, mastery count |
| **Trends** | Weekly accuracy charts, daily practice activity |
| **Time Stats** | Average time per category, fastest/slowest times |
| **History** | Last 10 test sessions with scores and duration |

### 📝 Practice Modes

| Mode | Questions | Time | Best For |
|------|-----------|------|----------|
| Quick Assessment | 20 | 10 min | Daily warmup |
| Standard Practice | 50 | 30 min | Regular study |
| Full Mock Test | 176 | 90 min | Real test simulation |
| Smart Practice | 15 | 30 min | Weak area focus |

### 📖 Study Guide

- Verbal reasoning strategies (analogies, synonyms, antonyms)
- Quantitative pattern recognition techniques
- Non-verbal figure analysis tips
- Time management and test-taking strategies

### 🎨 Canadian-Themed Design

- **Canadian Red** (#C8102E) primary color
- **Maple Leaf** accent patterns
- **Dark Mode** support with system detection
- **Clean, distraction-free** interface
- Optimized for iPhone and iPad

---

## 📱 Screenshots

| Home Dashboard | Achievements | Practice |
|----------------|--------------|----------|
| Level, XP, streaks, daily challenges | 22 unlockable badges | Question types selection |

| Test Session | Results | Progress Analytics |
|--------------|---------|-------------------|
| Timer, bookmark, clean UI | XP earned, level up | Charts and trends |

> 📸 *Screenshots coming soon - run the app to see the beautiful Canadian-themed UI!*

---

## 🚀 Installation

### Prerequisites
- macOS with Xcode 15+
- iOS 12.0+ device or simulator

### Quick Start

```bash
# Clone the repository
git clone https://github.com/rajkumar-natarajan/ExcelCCAT.git
cd ExcelCCAT/excel_ccat_flutter

# Install dependencies
flutter pub get

# Run on iOS Simulator
flutter run -d ios

# Run on connected iPhone
flutter run -d <device_id>
```

### Build for Release

```bash
# Build iOS release
flutter build ios --release

# Build IPA for App Store
flutter build ipa --release
```

---

## 🏪 App Store

See **[APP_STORE_GUIDE.md](APP_STORE_GUIDE.md)** for complete App Store submission instructions including:

- App Store Connect setup
- App description and keywords
- Screenshot requirements
- Icon specifications
- Privacy policy template
- Review guidelines

---

## 📁 Project Structure

```
excel_ccat_flutter/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── controllers/
│   │   ├── gamification_controller.dart   # XP, levels, achievements
│   │   ├── settings_controller.dart       # Theme, language settings
│   │   └── smart_learning_controller.dart # Weak areas, spaced repetition
│   ├── data/
│   │   └── question_data_manager.dart     # Question bank
│   ├── models/
│   │   └── question.dart                  # Data models
│   ├── screens/
│   │   ├── achievements_screen.dart       # Badges and stats
│   │   ├── dashboard_screen.dart          # Home with gamification
│   │   ├── practice_screen.dart           # Test configuration
│   │   ├── progress_screen.dart           # Analytics tabs
│   │   ├── results_screen.dart            # Test results + rewards
│   │   ├── review_screen.dart             # Answer review
│   │   ├── settings_screen.dart           # App settings
│   │   ├── study_guide_screen.dart        # Tips and strategies
│   │   └── test_session_screen.dart       # Active test
│   └── widgets/
│       └── canadian_theme.dart            # Theme components
├── ios/                              # iOS platform files
├── test/                             # Unit tests
└── pubspec.yaml                      # Dependencies
```

---

## 🎨 Design System

### Colors

| Name | Hex | Usage |
|------|-----|-------|
| Canadian Red | `#C8102E` | Primary, buttons, accents |
| Red Light | `#E8536A` | Hover states, gradients |
| Red Dark | `#A00D24` | Pressed states |
| Cream | `#FFF8F0` | Light mode background |
| Navy | `#1A2456` | Dark mode background |

### Typography

- **Headings**: Bold, Canadian Red
- **Body**: Regular, high contrast
- **Labels**: Medium weight

---

## 🛠️ Tech Stack

| Component | Technology |
|-----------|------------|
| Framework | Dart / Cross-platform SDK |
| State Management | ChangeNotifier (Provider pattern) |
| Data Persistence | SharedPreferences |
| Platforms | iOS, Android, Web, macOS |
| Min iOS Version | 12.0 |

---

## 📄 Version History

See [CHANGELOG.md](CHANGELOG.md) for detailed version history.

### Latest: v1.5.0 (December 2025)
- ✅ Gamification system (XP, levels, 22 achievements)
- ✅ Daily streaks and challenges
- ✅ Canadian-themed UI throughout
- ✅ App Store ready

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

## 📝 License

This project is for educational purposes.

---

## 👨‍💻 Author

**Raj Kumar Natarajan**

- GitHub: [@rajkumar-natarajan](https://github.com/rajkumar-natarajan)

---

<p align="center">
  Made with ❤️ for Canadian students 🍁
</p>
