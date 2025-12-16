# ExcelCCAT - App Store Launch Guide 🍁

A comprehensive guide to launching ExcelCCAT on the Apple App Store.

---

## Table of Contents

1. [Pre-Launch Checklist](#pre-launch-checklist)
2. [App Store Connect Setup](#app-store-connect-setup)
3. [App Information](#app-information)
4. [Screenshots Requirements](#screenshots-requirements)
5. [App Icon Requirements](#app-icon-requirements)
6. [Build & Archive](#build--archive)
7. [Privacy Policy](#privacy-policy)
8. [App Review Guidelines](#app-review-guidelines)
9. [Post-Launch](#post-launch)

---

## Pre-Launch Checklist

### ✅ Development Complete
- [x] All core features implemented
- [x] Gamification system (XP, levels, achievements)
- [x] Smart learning with weak area detection
- [x] 100+ questions across all categories
- [x] Canadian-themed UI with maple leaf design
- [x] Dark mode support
- [x] Progress analytics and time tracking

### ✅ Code Quality
- [ ] Run `flutter analyze` - fix all errors
- [ ] Run `flutter test` - all tests pass
- [ ] Remove all debug prints
- [ ] Verify no hardcoded test data

### ✅ iOS Specific
- [ ] Valid Apple Developer Account ($99/year)
- [ ] App ID created in Apple Developer Portal
- [ ] Provisioning profiles configured
- [ ] App icon set (all required sizes)
- [ ] Launch screen configured
- [ ] Bundle identifier set: `com.yourcompany.excelccat`

---

## App Store Connect Setup

### Step 1: Create App Record

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click **My Apps** → **+** → **New App**
3. Fill in:
   - **Platform**: iOS
   - **Name**: ExcelCCAT - CCAT Test Prep
   - **Primary Language**: English (Canada)
   - **Bundle ID**: com.yourcompany.excelccat
   - **SKU**: EXCELCCAT001

### Step 2: Configure App Information

Navigate to **App Information** section:

| Field | Value |
|-------|-------|
| Name | ExcelCCAT - CCAT Test Prep |
| Subtitle | Master Canadian Cognitive Test |
| Category | Education |
| Secondary Category | Kids (if applicable) |
| Content Rights | Does not contain third-party content |
| Age Rating | 4+ |

---

## App Information

### App Name
```
ExcelCCAT - CCAT Test Prep
```

### Subtitle (30 characters max)
```
Master Canadian Cognitive Test
```

### Promotional Text (170 characters)
```
🍁 Prepare for the CCAT with our smart learning system! Track progress, earn achievements, and master verbal, quantitative & non-verbal reasoning skills.
```

### Description (4000 characters max)
```
ExcelCCAT is the premier test preparation app for the Canadian Cognitive Abilities Test (CCAT). Designed specifically for Canadian students and parents, our app helps you master the three key cognitive areas: Verbal, Quantitative, and Non-Verbal reasoning.

🎯 COMPREHENSIVE QUESTION BANK
• 100+ carefully crafted questions
• Covers all CCAT levels: K, 10, 11, and 12
• Verbal: Analogies, Synonyms, Antonyms, Sentence Completion, Classification
• Quantitative: Number Analogies, Number Series, Quantitative Relations
• Non-Verbal: Figure Matrices, Figure Classification, Figure Series

🧠 SMART LEARNING SYSTEM
• Automatic weak area detection
• Spaced repetition for better retention
• Bookmark difficult questions for review
• Performance tracking by question subtype
• Personalized practice recommendations

🏆 GAMIFICATION & ENGAGEMENT
• Earn XP and level up as you practice
• Unlock 22 achievement badges
• Track daily streaks to build consistency
• Complete daily challenges for bonus rewards
• Watch your progress grow with visual stats

📊 DETAILED ANALYTICS
• Performance breakdown by category
• Time per question tracking
• Weekly accuracy trends
• Test history with detailed scores
• Identify and focus on weak areas

📝 FLEXIBLE PRACTICE MODES
• Quick Assessment: 20 questions in 10 minutes
• Standard Practice: 50 questions in 30 minutes
• Full Mock Test: 176 questions in 90 minutes
• Smart Practice: Focus on weak areas automatically

📖 COMPREHENSIVE STUDY GUIDE
• Test-taking strategies for each question type
• Tips and tricks for verbal reasoning
• Number pattern recognition techniques
• Figure analysis strategies

🎨 BEAUTIFUL CANADIAN DESIGN
• Elegant Canadian red and maple leaf theme
• Dark mode for comfortable studying
• Clean, distraction-free interface
• Optimized for iPhone and iPad

Download ExcelCCAT today and take the first step toward CCAT success! 🍁
```

### Keywords (100 characters)
```
CCAT,cognitive,test,prep,Canada,gifted,education,practice,verbal,quantitative,reasoning,IQ,smart
```

### Support URL
```
https://github.com/rajkumar-natarajan/ExcelCCAT/issues
```

### Marketing URL (optional)
```
https://github.com/rajkumar-natarajan/ExcelCCAT
```

---

## Screenshots Requirements

### Required Sizes

| Device | Size (pixels) | Required |
|--------|---------------|----------|
| iPhone 6.7" (15 Pro Max) | 1290 x 2796 | ✅ Yes |
| iPhone 6.5" (14 Plus) | 1284 x 2778 | ✅ Yes |
| iPhone 5.5" (8 Plus) | 1242 x 2208 | Optional |
| iPad Pro 12.9" | 2048 x 2732 | If supporting iPad |

### Screenshot Content (6-10 screenshots)

1. **Home Screen** - Dashboard with gamification stats
2. **Practice Selection** - Test mode options
3. **Question Screen** - Active test question
4. **Achievements** - Badge collection screen
5. **Progress Analytics** - Charts and stats
6. **Study Guide** - Tips and strategies
7. **Results Screen** - Test completion with rewards
8. **Dark Mode** - Same screens in dark theme

### Taking Screenshots

```bash
# Run on iPhone 15 Pro Max simulator
xcrun simctl boot "iPhone 15 Pro Max"
flutter run -d "iPhone 15 Pro Max"

# Take screenshot
xcrun simctl io booted screenshot screenshot_name.png
```

### Screenshot Tips
- Use real content, not placeholder data
- Show actual questions and progress
- Highlight gamification features (XP, achievements)
- Include both light and dark mode
- No status bar time showing "9:41" is Apple's preference

---

## App Icon Requirements

### Required Sizes

Create a 1024x1024 PNG icon and export to these sizes:

| Size | Filename | Usage |
|------|----------|-------|
| 1024x1024 | iTunesArtwork@2x.png | App Store |
| 180x180 | Icon-App-60x60@3x.png | iPhone |
| 167x167 | Icon-App-83.5x83.5@2x.png | iPad Pro |
| 152x152 | Icon-App-76x76@2x.png | iPad |
| 120x120 | Icon-App-60x60@2x.png | iPhone |
| 87x87 | Icon-App-29x29@3x.png | Settings |
| 80x80 | Icon-App-40x40@2x.png | Spotlight |
| 76x76 | Icon-App-76x76@1x.png | iPad |
| 60x60 | Icon-App-60x60@1x.png | iPhone |
| 58x58 | Icon-App-29x29@2x.png | Settings |
| 40x40 | Icon-App-40x40@1x.png | Spotlight |
| 29x29 | Icon-App-29x29@1x.png | Settings |
| 20x20 | Icon-App-20x20@1x.png | Notification |

### Icon Design Recommendations

For ExcelCCAT, the app icon should include:
- **Canadian Red** (#C8102E) as primary color
- **Maple Leaf** symbol (🍁) stylized
- **Clean, minimal design** - works at small sizes
- **No text** - icons should be recognizable without words
- **Rounded corners** - iOS automatically applies

### Icon Location
```
excel_ccat_flutter/ios/Runner/Assets.xcassets/AppIcon.appiconset/
```

---

## Build & Archive

### Step 1: Update Version

Edit `pubspec.yaml`:
```yaml
version: 1.5.0+1  # version+build_number
```

### Step 2: Build Release

```bash
cd excel_ccat_flutter

# Clean previous builds
flutter clean
flutter pub get

# Build iOS release
flutter build ios --release

# Or build IPA directly
flutter build ipa --release
```

### Step 3: Archive in Xcode

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select **Any iOS Device (arm64)** as target
3. Go to **Product** → **Archive**
4. Wait for archive to complete
5. Click **Distribute App** in Organizer

### Step 4: Upload to App Store Connect

Choose **App Store Connect** → **Upload**

Or use command line:
```bash
xcrun altool --upload-app -f build/ios/ipa/ExcelCCAT.ipa \
  -t ios \
  -u your@email.com \
  -p @keychain:AC_PASSWORD
```

---

## Privacy Policy

### Required Privacy Policy

Create a privacy policy page and host it. Sample content:

```
ExcelCCAT Privacy Policy

Last Updated: December 2025

ExcelCCAT ("we", "our", or "us") respects your privacy. This policy explains how we handle your information.

DATA WE COLLECT
• Practice Progress: Question scores, time spent, and achievements are stored locally on your device only.
• No Personal Information: We do not collect names, emails, or any personally identifiable information.
• No Account Required: The app works completely offline without any registration.

DATA STORAGE
All data is stored locally on your device using standard iOS storage mechanisms. We do not transmit any data to external servers.

THIRD-PARTY SERVICES
ExcelCCAT does not use any third-party analytics, advertising, or tracking services.

CHILDREN'S PRIVACY
ExcelCCAT is designed for educational use by children. We comply with COPPA and do not collect any personal information from users of any age.

CONTACT
For questions about this privacy policy, please contact us at:
[Your Email]

CHANGES
We may update this policy periodically. Check this page for the latest version.
```

Host this at a URL like: `https://yoursite.com/excelccat/privacy`

---

## App Review Guidelines

### Common Rejection Reasons & Solutions

| Reason | Solution |
|--------|----------|
| **Crashes on launch** | Test on multiple iOS versions (12+) |
| **Incomplete metadata** | Fill all required App Store fields |
| **Placeholder content** | Use real questions, not "Lorem ipsum" |
| **Broken links** | Verify Support URL works |
| **Missing privacy policy** | Host policy and add URL to App Store Connect |
| **Misleading description** | Ensure features match what's described |

### Tips for Approval

1. **Test thoroughly** on real devices, not just simulators
2. **Provide demo account** if needed (not required for ExcelCCAT)
3. **Explain app purpose** in Review Notes if educational
4. **Respond quickly** to reviewer questions
5. **Be patient** - first review may take 24-48 hours

### Review Notes (for Apple reviewer)
```
ExcelCCAT is an educational app for students preparing for the Canadian Cognitive Abilities Test (CCAT). 

The app includes:
- 100+ practice questions across verbal, quantitative, and non-verbal categories
- Progress tracking and analytics
- Achievement system to encourage continued practice
- Study guide with test-taking strategies

No login or internet connection is required. All data is stored locally on the device.
```

---

## Post-Launch

### Monitor Performance

1. **App Analytics** - Check downloads, engagement in App Store Connect
2. **Crash Reports** - Monitor Xcode Organizer for crashes
3. **Reviews** - Respond to user reviews professionally
4. **Updates** - Plan regular updates with new content

### Version Update Checklist

For each update:
1. Increment version in `pubspec.yaml`
2. Update CHANGELOG.md
3. Build and archive
4. Submit with "What's New" text

### Marketing Ideas

- Share on education forums and parent groups
- Contact schools about CCAT preparation resources
- Create YouTube videos demonstrating the app
- Social media with #CCAT #GiftedEducation hashtags

---

## Quick Reference Commands

```bash
# Clean build
flutter clean && flutter pub get

# Analyze code
flutter analyze

# Run tests
flutter test

# Build iOS release
flutter build ios --release

# Build IPA
flutter build ipa --release

# Open in Xcode
open ios/Runner.xcworkspace

# Run on simulator
flutter run -d "iPhone 15 Pro"
```

---

## Support

For questions or issues:
- **GitHub Issues**: https://github.com/rajkumar-natarajan/ExcelCCAT/issues
- **Email**: [Your Email]

---

<p align="center">🍁 Good luck with your App Store launch! 🍁</p>
