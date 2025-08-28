# 🚀 Deployment Guide - E-Mart App

## 📋 Pre-Deployment Checklist

### ✅ Code Quality
- [ ] All lint warnings resolved
- [ ] No unused imports or variables
- [ ] Proper error handling implemented
- [ ] Debug prints removed/commented
- [ ] Performance optimizations applied

### ✅ Firebase Configuration
- [ ] Production Firebase project created
- [ ] Authentication providers enabled
- [ ] Firestore security rules configured
- [ ] Storage rules configured
- [ ] API keys secured

### ✅ Asset Optimization
- [ ] Images optimized for size
- [ ] All assets properly referenced
- [ ] App icons generated for all platforms
- [ ] Splash screens configured

## 🤖 Android Deployment

### 1. Configure App Signing

#### Generate Release Key
```bash
keytool -genkey -v -keystore ~/release-key.keystore -alias release -keyalg RSA -keysize 2048 -validity 10000
```

#### Configure Gradle
Create `android/key.properties`:
```properties
storePassword=<store_password>
keyPassword=<key_password>
keyAlias=release
storeFile=<path_to_keystore>
```

Update `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    compileSdkVersion 34
    defaultConfig {
        applicationId "com.emart.food_delivery"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

### 2. Configure App Manifest

Update `android/app/src/main/AndroidManifest.xml`:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.emart.food_delivery">
    
    <!-- Permissions -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    
    <application
        android:name="io.flutter.app.FlutterApplication"
        android:label="E-Mart"
        android:icon="@mipmap/ic_launcher"
        android:requestLegacyExternalStorage="true">
        
        <activity
            android:name=".MainActivity"
            android:theme="@style/LaunchTheme"
            android:exported="true"
            android:launchMode="singleTop"
            android:screenOrientation="portrait">
            
            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        
        <!-- Firebase Messaging -->
        <service
            android:name=".MyFirebaseMessagingService"
            android:exported="false">
            <intent-filter>
                <action android:name="com.google.firebase.MESSAGING_EVENT" />
            </intent-filter>
        </service>
    </application>
</manifest>
```

### 3. Build Release APK

```bash
# Clean project
flutter clean && flutter pub get

# Build release APK
flutter build apk --release --shrink

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

### 4. Google Play Store Deployment

#### Prepare Store Listing
- **App Name:** E-Mart - Food Delivery
- **Description:** Modern food delivery app with Firebase integration
- **Screenshots:** Take screenshots from multiple devices
- **Privacy Policy:** Create and host privacy policy
- **App Category:** Food & Drink

#### Upload to Play Console
1. Create new app in [Google Play Console](https://play.google.com/console)
2. Upload AAB file (`build/app/outputs/bundle/release/app-release.aab`)
3. Fill in store listing details
4. Set pricing and distribution
5. Submit for review

## 🍎 iOS Deployment

### 1. Configure Xcode Project

#### Update iOS Bundle ID
In `ios/Runner.xcodeproj`, set:
- Bundle Identifier: `com.emart.food-delivery`
- Display Name: `E-Mart`
- Version: `1.0.0`
- Build: `1`

#### Configure Info.plist
Update `ios/Runner/Info.plist`:
```xml
<dict>
    <key>CFBundleDisplayName</key>
    <string>E-Mart</string>
    <key>CFBundleIdentifier</key>
    <string>com.emart.food-delivery</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    
    <!-- Camera permission -->
    <key>NSCameraUsageDescription</key>
    <string>This app needs camera access to take profile photos</string>
    
    <!-- Photo library permission -->
    <key>NSPhotoLibraryUsageDescription</key>
    <string>This app needs photo library access to select profile images</string>
</dict>
```

### 2. Apple Developer Account Setup

#### Certificates and Provisioning
1. Create App ID in Apple Developer Portal
2. Generate Distribution Certificate
3. Create Provisioning Profile for App Store distribution
4. Download and install certificates

#### App Store Connect
1. Create new app in [App Store Connect](https://appstoreconnect.apple.com)
2. Set app information and pricing
3. Upload app icon and screenshots

### 3. Build and Archive

```bash
# Clean and get dependencies
flutter clean && flutter pub get

# Build iOS release
flutter build ios --release --no-codesign

# Open Xcode for archiving
open ios/Runner.xcworkspace
```

#### In Xcode:
1. Select "Any iOS Device" or connected device
2. Product → Archive
3. Upload to App Store Connect
4. Submit for review

## 🌐 Web Deployment

### 1. Build Web Version

```bash
# Build for web
flutter build web --release --web-renderer html

# Preview build
flutter run -d web-server --web-port 8080
```

### 2. Firebase Hosting

#### Initialize Firebase Hosting
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login and initialize
firebase login
firebase init hosting
```

#### Configure `firebase.json`
```json
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

#### Deploy
```bash
# Deploy to Firebase Hosting
firebase deploy --only hosting

# Deploy with custom domain
firebase hosting:channel:deploy live
```

### 3. Alternative Web Hosting

#### GitHub Pages
```bash
# Build and commit to gh-pages branch
flutter build web --base-href "/e-mart/"
git checkout -b gh-pages
cp -r build/web/* .
git add . && git commit -m "Deploy web app"
git push origin gh-pages
```

#### Netlify
1. Build web version: `flutter build web`
2. Drag `build/web` folder to Netlify deploy area
3. Configure custom domain if needed

## 🐧 Linux Distribution

### 1. Build Linux Desktop App

```bash
# Enable Linux desktop
flutter config --enable-linux-desktop

# Build Linux app
flutter build linux --release
```

### 2. Create AppImage

#### Install Required Tools
```bash
# Install AppImage tools
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage
```

#### Create AppDir Structure
```bash
mkdir -p e-mart.AppDir/usr/bin
cp -r build/linux/x64/release/bundle/* e-mart.AppDir/usr/bin/
```

#### Create Desktop Entry
Create `e-mart.AppDir/e-mart.desktop`:
```ini
[Desktop Entry]
Name=E-Mart
Exec=e-mart
Icon=e-mart
Type=Application
Categories=Shopping;
```

#### Build AppImage
```bash
./appimagetool-x86_64.AppImage e-mart.AppDir
```

## 🔒 Security Configuration

### Environment Variables
Create `.env` files for different environments:

#### `.env.production`
```env
FIREBASE_API_KEY=your_production_api_key
FIREBASE_PROJECT_ID=your_production_project_id
FIREBASE_MESSAGING_SENDER_ID=your_sender_id
```

### Firebase Security Rules

#### Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Products are read-only for authenticated users
    match /products/{productId} {
      allow read: if request.auth != null;
      allow write: if false; // Only admin can write
    }
  }
}
```

#### Storage Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /profile_images/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 📊 Monitoring and Analytics

### Firebase Analytics
```dart
// Add to main.dart
import 'package:firebase_analytics/firebase_analytics.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;

// Track events
await analytics.logEvent(
  name: 'add_to_cart',
  parameters: {
    'item_id': productId,
    'item_name': productName,
    'value': price,
  },
);
```

### Crashlytics
```dart
// Add to main.dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// Initialize Crashlytics
FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

// Log custom errors
FirebaseCrashlytics.instance.recordError(
  exception,
  stackTrace,
  reason: 'Custom error description',
);
```

## 🔄 CI/CD Pipeline

### GitHub Actions

Create `.github/workflows/deploy.yml`:
```yaml
name: Deploy E-Mart App

on:
  push:
    branches: [ main ]

jobs:
  build-android:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: actions/setup-java@v3
      with:
        java-version: '11'
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.7.2'
    
    - name: Get dependencies
      run: flutter pub get
      
    - name: Build APK
      run: flutter build apk --release
      
    - name: Upload artifact
      uses: actions/upload-artifact@v3
      with:
        name: release-apk
        path: build/app/outputs/flutter-apk/app-release.apk

  deploy-web:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: subosito/flutter-action@v2
    
    - name: Build web
      run: flutter build web --release
      
    - name: Deploy to Firebase
      uses: FirebaseExtended/action-hosting-deploy@v0
      with:
        repoToken: '${{ secrets.GITHUB_TOKEN }}'
        firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
        projectId: your-firebase-project-id
```

## 📈 Post-Deployment

### Performance Monitoring
- Monitor app performance in Firebase Console
- Track user engagement and retention
- Monitor crash reports and fix issues
- Gather user feedback and iterate

### Update Strategy
```bash
# Version bump
flutter pub version

# Build and test
flutter build apk --release
flutter test

# Deploy update
# (Follow platform-specific deployment steps)
```

---

**Deployment Complete! 🎉**

Your E-Mart food delivery app is now ready for production deployment across multiple platforms. Monitor performance and user feedback to continuously improve the app experience.