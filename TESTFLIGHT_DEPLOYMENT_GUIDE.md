# TestFlight Deployment Guide for ExcelCCAT

This comprehensive guide documents all the steps required to deploy the ExcelCCAT Flutter app to TestFlight for beta testing.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Apple Developer Account Setup](#apple-developer-account-setup)
3. [Certificate Creation](#certificate-creation)
4. [App ID Registration](#app-id-registration)
5. [Provisioning Profile Creation](#provisioning-profile-creation)
6. [Xcode Project Configuration](#xcode-project-configuration)
7. [Building the IPA](#building-the-ipa)
8. [Uploading to TestFlight](#uploading-to-testflight)
9. [Managing TestFlight Testers](#managing-testflight-testers)
10. [Troubleshooting](#troubleshooting)

---

## Prerequisites

Before starting, ensure you have:

- ✅ **Apple Developer Account** ($99/year) - [developer.apple.com](https://developer.apple.com)
- ✅ **Xcode** installed (latest version recommended)
- ✅ **Flutter SDK** installed and configured
- ✅ **macOS** (required for iOS builds)
- ✅ **App Store Connect** access - [appstoreconnect.apple.com](https://appstoreconnect.apple.com)

### Verify Flutter Setup

```bash
flutter doctor
```

Ensure iOS development is properly configured with no errors.

---

## Apple Developer Account Setup

### Step 1: Sign in to Apple Developer Portal

1. Go to [developer.apple.com/account](https://developer.apple.com/account)
2. Sign in with your Apple ID
3. Accept any pending agreements

### Key Information for ExcelCCAT

| Field | Value |
|-------|-------|
| Team ID | `Y62BAT7CF4` |
| Bundle Identifier | `com.curiousdev.excelCcatFlutter` |
| App Name | ExcelCCAT |

---

## Certificate Creation

### Step 1: Generate Certificate Signing Request (CSR)

Open Terminal and run:

```bash
cd ~/Desktop
openssl req -new -newkey rsa:2048 -nodes \
  -keyout distribution.key \
  -out CertificateSigningRequest.certSigningRequest \
  -subj "/emailAddress=your_email@example.com/CN=ExcelCCAT Distribution/C=CA"
```

This creates two files on your Desktop:
- `distribution.key` - Private key (keep this safe!)
- `CertificateSigningRequest.certSigningRequest` - CSR file to upload

### Step 2: Create Apple Distribution Certificate

1. Go to [Certificates, Identifiers & Profiles](https://developer.apple.com/account/resources/certificates/add)
2. Under **Software**, select **"Apple Distribution"**
3. Click **Continue**
4. Click **"Choose File"** and select the CSR file from your Desktop
5. Click **Continue**
6. Click **Download** to get the `.cer` file
7. **Double-click** the downloaded `.cer` file to install it in Keychain

### Step 3: Verify Certificate Installation

```bash
security find-identity -v -p codesigning
```

You should see an entry like:
```
"Apple Distribution: Your Name (TEAM_ID)"
```

---

## App ID Registration

### Step 1: Create App ID

1. Go to [Identifiers](https://developer.apple.com/account/resources/identifiers/list)
2. Click the **"+"** button
3. Select **"App IDs"** → Continue
4. Select **"App"** → Continue
5. Fill in the details:
   - **Description**: `ExcelCCAT Flutter`
   - **Bundle ID**: Select "Explicit" and enter `com.curiousdev.excelCcatFlutter`
6. Scroll down and enable any capabilities you need (optional)
7. Click **Continue** → **Register**

---

## Provisioning Profile Creation

### Step 1: Create App Store Distribution Profile

1. Go to [Profiles](https://developer.apple.com/account/resources/profiles/add)
2. Under **Distribution**, select **"App Store Connect"**
3. Click **Continue**
4. Select your App ID: `com.curiousdev.excelCcatFlutter`
5. Click **Continue**
6. Select your **Apple Distribution** certificate
7. Click **Continue**
8. Enter Profile Name: `ExcelCCAT App Store`
9. Click **Generate**
10. Click **Download**

### Step 2: Install Provisioning Profile

**Option A: Double-click the file**
- Double-click the downloaded `.mobileprovision` file

**Option B: Manual installation**
```bash
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp ~/Downloads/ExcelCCAT_App_Store.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/
```

### Step 3: Verify Profile Installation

```bash
# Get profile name
security cms -D -i ~/Downloads/ExcelCCAT_App_Store.mobileprovision 2>/dev/null | grep -A1 "Name"
```

---

## Xcode Project Configuration

### Update Signing Settings

The iOS project needs to be configured for distribution signing. The key settings in `ios/Runner.xcodeproj/project.pbxproj`:

**For Release and Profile configurations:**

```
CODE_SIGN_IDENTITY = "Apple Distribution";
CODE_SIGN_STYLE = Manual;
DEVELOPMENT_TEAM = Y62BAT7CF4;
PROVISIONING_PROFILE_SPECIFIER = "ExcelCCAT App Store";
```

### Export Options Plist

Create `ios/ExportOptions.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store-connect</string>
    <key>teamID</key>
    <string>Y62BAT7CF4</string>
    <key>uploadSymbols</key>
    <true/>
    <key>destination</key>
    <string>upload</string>
</dict>
</plist>
```

---

## Building the IPA

### Step 1: Clean and Get Dependencies

```bash
cd excel_ccat_flutter
flutter clean
flutter pub get
```

### Step 2: Build the Archive

```bash
flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
```

**Expected Output:**
```
✓ Built build/ios/archive/Runner.xcarchive
```

### Alternative: Build Archive Only

If the export fails, build just the archive:

```bash
flutter build ipa --release
```

Then use Xcode to export and upload.

---

## Uploading to TestFlight

### Method 1: Using Xcode Organizer (Recommended)

1. **Open the archive in Xcode:**
   ```bash
   open build/ios/archive/Runner.xcarchive
   ```

2. **In Xcode Organizer:**
   - Select your archive
   - Click **"Distribute App"**

3. **Choose distribution method:**
   - Select **"App Store Connect"**
   - Click **Next**

4. **Choose destination:**
   - Select **"Upload"**
   - Click **Next**

5. **Distribution options:**
   - ✅ Upload your app's symbols
   - ✅ Manage Version and Build Number
   - Click **Next**

6. **Signing:**
   - Select **"Manually manage signing"**
   - Distribution Certificate: **"Apple Distribution: Rajkumar Natarajan (Y62BAT7CF4)"**
   - Provisioning Profile: **"ExcelCCAT App Store"**
   - Click **Next**

7. **Review and Upload:**
   - Review the summary
   - Click **"Upload"**

8. **Wait for upload to complete** (may take 5-15 minutes)

### Method 2: Using Command Line (xcrun)

```bash
xcrun altool --upload-app \
  --type ios \
  --file "build/ios/ipa/excel_ccat_flutter.ipa" \
  --username "your_apple_id@example.com" \
  --password "@keychain:AC_PASSWORD"
```

**Note:** You need to create an app-specific password at [appleid.apple.com](https://appleid.apple.com)

---

## Managing TestFlight Testers

### Step 1: Access App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click **"My Apps"**
3. Select **ExcelCCAT**
4. Click **"TestFlight"** tab

### Step 2: Wait for Processing

After upload, Apple processes the build (usually 10-30 minutes). You'll receive an email when it's ready.

### Step 3: Add Testers

**Internal Testers (up to 100):**
1. Go to **TestFlight** → **Internal Testing**
2. Click **"+"** to create a new group or add to existing
3. Add testers by email (must be App Store Connect users)

**External Testers (up to 10,000):**
1. Go to **TestFlight** → **External Testing**
2. Click **"+"** to create a new group
3. Add tester emails
4. Submit for Beta App Review (required for first external build)

### Step 4: Testers Install the App

1. Testers receive email invitation
2. They install **TestFlight** app from App Store
3. They redeem the invitation code
4. App appears in TestFlight for download

---

## Troubleshooting

### Common Errors and Solutions

#### Error: "No profiles for 'com.curiousdev.excelCcatFlutter' were found"

**Solution:**
1. Verify the provisioning profile is installed:
   ```bash
   ls ~/Library/MobileDevice/Provisioning\ Profiles/
   ```
2. Re-download and install the profile from Apple Developer Portal
3. Ensure the profile name matches exactly in Xcode project settings

#### Error: "Communication with Apple failed: Your team has no devices"

**Solution:**
- This occurs when trying to use Development signing
- Use **Distribution** signing instead (not Development)
- Set `CODE_SIGN_IDENTITY = "Apple Distribution"` in project settings

#### Error: "Requires a provisioning profile"

**Solution:**
1. Open the archive in Xcode Organizer
2. Use "Distribute App" with manual signing
3. Select the correct certificate and profile

#### Error: "The certificate has an invalid issuer"

**Solution:**
1. Download Apple's intermediate certificates:
   ```bash
   curl -O https://www.apple.com/certificateauthority/AppleWWDRCAG3.cer
   ```
2. Double-click to install in Keychain

#### Error: "Code Sign error: No identity found"

**Solution:**
1. Import the private key that was used to create the CSR:
   ```bash
   security import ~/Desktop/distribution.key -k ~/Library/Keychains/login.keychain-db
   ```
2. Re-download and install the certificate

### Verify Everything is Set Up

```bash
# Check certificates
security find-identity -v -p codesigning

# Check provisioning profiles
ls ~/Library/MobileDevice/Provisioning\ Profiles/

# Check profile details
security cms -D -i ~/Library/MobileDevice/Provisioning\ Profiles/*.mobileprovision 2>/dev/null | grep -A1 "Name"
```

---

## Quick Reference Commands

```bash
# Clean build
flutter clean && flutter pub get

# Build IPA for TestFlight
flutter build ipa --release --export-options-plist=ios/ExportOptions.plist

# Open archive in Xcode
open build/ios/archive/Runner.xcarchive

# Check signing identities
security find-identity -v -p codesigning

# List provisioning profiles
ls ~/Library/MobileDevice/Provisioning\ Profiles/
```

---

## Version History

| Version | Date | Notes |
|---------|------|-------|
| 1.5.1 | 2025-12-24 | Fixed quick actions navigation, TestFlight deployment |
| 1.5.0 | 2025-12-16 | Gamification system, App Store preparation |

---

## Additional Resources

- [Flutter iOS Deployment Guide](https://docs.flutter.dev/deployment/ios)
- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- [TestFlight Documentation](https://developer.apple.com/testflight/)

---

*Last updated: December 24, 2025*
