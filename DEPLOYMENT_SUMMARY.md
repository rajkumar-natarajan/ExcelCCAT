# Deployment Summary - Version 1.6.0

## 🚀 Updates Overview
**Date:** December 31, 2025
**Version:** 1.6.0

### New Features
- **Visual Questions for Levels 10-12**: Implemented programmatic visual questions for Non-Verbal reasoning.
  - **Matrix Patterns**: 3x3 grid completion.
  - **Odd One Out**: Visual classification.
  - **Sequence Patterns**: Visual series.
- **UI Enhancements**: Updated `TestSessionScreen` to render shapes directly.

## 🛠️ Build & Deployment Instructions

### 1. Prerequisites
Ensure you have the latest code:
```bash
git pull origin main
```

### 2. Clean Build Environment
If you encounter "resource fork" or "detritus not allowed" errors, run:
```bash
cd excel_ccat_flutter
flutter clean
xattr -cr .
flutter pub get
cd ios
pod install
cd ..
```

### 3. Run on iPhone 17 Pro (Simulator)
To run the app on the iPhone 17 Pro simulator:
```bash
# List available devices to find the ID for iPhone 17 Pro
flutter devices

# Run on the specific device (replace <Device ID> with the actual ID)
flutter run -d <Device ID>
```

### 4. Deploy to TestFlight
To build and upload the IPA to TestFlight:

1. **Build the IPA:**
   ```bash
   flutter build ipa --export-options-plist=ios/ExportOptions.plist
   ```

2. **Upload to App Store Connect:**
   - Open the generated `build/ios/ipa/ExcelCCAT.ipa` in **Apple Transporter** or **Xcode**.
   - Click "Deliver" to upload.

3. **Manage Testers:**
   - Go to [App Store Connect](https://appstoreconnect.apple.com).
   - Navigate to **TestFlight**.
   - Add external testers to the "Beta Group".

## 📝 Changelog
See [CHANGELOG.md](../CHANGELOG.md) for detailed version history.
