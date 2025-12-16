# ExcelCCAT Screenshots

This folder contains screenshots of the ExcelCCAT app for documentation and App Store submission.

## Current Screenshots

| Screenshot | Description |
|------------|-------------|
| `dashboard.png` | Main dashboard with gamification stats and quick actions |

## Required App Store Screenshots

For App Store submission, you need screenshots in these sizes:

### iPhone
- 6.7" (iPhone 15 Pro Max, 14 Pro Max): 1290 x 2796 pixels
- 6.5" (iPhone 14 Plus, 13 Pro Max): 1284 x 2778 pixels
- 5.5" (iPhone 8 Plus): 1242 x 2208 pixels

### iPad
- 12.9" iPad Pro: 2048 x 2732 pixels
- 11" iPad Pro: 1668 x 2388 pixels

## How to Capture Screenshots

### Using Simulator
```bash
# Capture from specific simulator
xcrun simctl io <device-id> screenshot filename.png

# Example for iPhone 17 Pro
xcrun simctl io FA6A3D7F-1B58-436A-AEFF-1F05FB0BF1CD screenshot screenshot.png
```

### Screenshot Guidelines

1. **Dashboard** - Show XP, level, streak, and daily challenge
2. **Practice Setup** - Display test configuration options
3. **Test Session** - Active question with timer
4. **Results** - Score breakdown and statistics
5. **Achievements** - Badges and progress
6. **Progress** - Analytics charts and trends
7. **Settings** - Customization options

## App Icon

The app icon features:
- Canadian red gradient background (#D52B1E)
- White maple leaf symbol
- Clean, professional design

Located in: `excel_ccat_flutter/ios/Runner/Assets.xcassets/AppIcon.appiconset/`
