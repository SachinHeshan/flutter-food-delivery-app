# 🔧 Troubleshooting Guide - E-Mart App

## 🚨 Common Issues & Solutions

### 🔥 Firebase Authentication Issues

#### Issue: Google Sign-In Not Working
**Symptoms:**
- "Sign in failed" error
- Google sign-in popup doesn't appear
- App crashes during Google sign-in

**Solutions:**
1. **Check OAuth Configuration**
   ```bash
   # Verify google-services.json is in android/app/
   ls android/app/google-services.json
   ```

2. **Enable Google Sign-In in Firebase Console**
   - Go to Authentication → Sign-in method
   - Enable Google provider
   - Add OAuth 2.0 client ID

3. **Update SHA-1 Fingerprint**
   ```bash
   # Get debug SHA-1
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```

#### Issue: "User Not Found" Error
**Symptoms:**
- Valid email shows "user not found"
- Cannot sign in with existing account

**Solutions:**
1. **Check Firebase Console Users**
   - Verify user exists in Authentication tab
   - Check if account is disabled

2. **Email Format Validation**
   ```dart
   bool isValidEmail(String email) {
     return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
   }
   ```

### 🖼️ Image Display Problems

#### Issue: Images Not Loading
**Symptoms:**
- Blank spaces instead of images
- "Failed to load image" errors
- App crashes when loading images

**Solutions:**
1. **Check Asset Paths**
   ```yaml
   # Verify in pubspec.yaml
   flutter:
     assets:
       - assets/images/
   ```

2. **Verify Image Files Exist**
   ```bash
   ls assets/images/
   # Should show all referenced images
   ```

3. **Use Error Handling**
   ```dart
   Image.asset(
     'assets/images/product.jpg',
     errorBuilder: (context, error, stackTrace) {
       return Icon(Icons.error);
     },
   )
   ```

#### Issue: Profile Images Not Updating
**Symptoms:**
- New profile image doesn't appear
- Old image persists after change

**Solutions:**
1. **Clear Image Cache**
   ```dart
   await DefaultCacheManager().emptyCache();
   ```

2. **Force Widget Rebuild**
   ```dart
   setState(() {
     // Trigger rebuild
   });
   ```

### 🛍️ Cart & Shopping Issues

#### Issue: Cart Count Not Updating
**Symptoms:**
- Cart badge shows wrong number
- Items added but count stays same

**Solutions:**
1. **Check Provider Integration**
   ```dart
   // Ensure CartStore is properly provided
   ChangeNotifierProvider(create: (_) => CartStore())
   ```

2. **Verify notifyListeners() Calls**
   ```dart
   void addItem(CartItem item) {
     _items.add(item);
     notifyListeners(); // Essential!
   }
   ```

#### Issue: Cart Items Disappearing
**Symptoms:**
- Items vanish after app restart
- Cart resets unexpectedly

**Solutions:**
1. **Implement Persistent Storage**
   ```dart
   // Save cart to SharedPreferences
   await prefs.setString('cart_items', jsonEncode(cartItems));
   ```

### 🎨 Theme & UI Issues

#### Issue: Dark Mode Not Persisting
**Symptoms:**
- Theme resets to light mode on restart
- Toggle doesn't save preference

**Solutions:**
1. **Check SafeThemeProvider Implementation**
   ```dart
   // Verify SharedPreferences usage
   await _prefs?.setBool(_themeKey, _isDarkMode);
   ```

2. **Initialize Theme Properly**
   ```dart
   SafeThemeProvider() {
     _initializeTheme(); // Must be called
   }
   ```

#### Issue: UI Overflow Errors
**Symptoms:**
- "BOTTOM OVERFLOWED BY X PIXELS"
- "RIGHT OVERFLOWED BY X PIXELS"

**Solutions:**
1. **Use Flexible Widgets**
   ```dart
   Row(
     children: [
       Expanded(child: Text('Long text here')),
       Icon(Icons.icon),
     ],
   )
   ```

2. **Add Scrollable Containers**
   ```dart
   SingleChildScrollView(
     child: Column(children: [...]),
   )
   ```

### 🔄 State Management Problems

#### Issue: Provider Not Found
**Symptoms:**
- "Could not find the correct Provider<T>"
- App crashes when accessing provider

**Solutions:**
1. **Verify Provider Hierarchy**
   ```dart
   MultiProvider(
     providers: [
       ChangeNotifierProvider(create: (_) => SafeThemeProvider()),
     ],
     child: MaterialApp(...),
   )
   ```

2. **Use Proper Provider Access**
   ```dart
   // Correct way
   final provider = Provider.of<SafeThemeProvider>(context);
   
   // Or with Consumer
   Consumer<SafeThemeProvider>(
     builder: (context, provider, child) => Widget(),
   )
   ```

### 📱 Platform-Specific Issues

#### Android Build Issues
**Symptoms:**
- Build fails with Gradle errors
- "Execution failed for task"

**Solutions:**
1. **Clean and Rebuild**
   ```bash
   flutter clean
   flutter pub get
   flutter build apk
   ```

2. **Update Gradle Wrapper**
   ```bash
   # In android/gradle/wrapper/gradle-wrapper.properties
   distributionUrl=https\://services.gradle.org/distributions/gradle-7.5-all.zip
   ```

#### iOS Build Issues
**Symptoms:**
- Xcode build failures
- CocoaPods errors

**Solutions:**
1. **Update CocoaPods**
   ```bash
   cd ios
   pod repo update
   pod install
   ```

2. **Clean Xcode Build**
   ```bash
   flutter clean
   cd ios
   xcodebuild clean
   ```

## 🛠️ Performance Issues

### App Running Slowly
**Symptoms:**
- Laggy animations
- Slow page transitions
- High memory usage

**Solutions:**
1. **Optimize Images**
   ```dart
   // Use appropriate image sizes
   Image.asset(
     'image.jpg',
     width: 200,
     height: 200,
     fit: BoxFit.cover,
   )
   ```

2. **Implement Lazy Loading**
   ```dart
   ListView.builder(
     itemCount: items.length,
     itemBuilder: (context, index) => ItemWidget(items[index]),
   )
   ```

### Memory Leaks
**Symptoms:**
- App crashes after extended use
- Memory usage keeps increasing

**Solutions:**
1. **Dispose Controllers**
   ```dart
   @override
   void dispose() {
     _controller.dispose();
     _animationController.dispose();
     super.dispose();
   }
   ```

2. **Remove Listeners**
   ```dart
   @override
   void dispose() {
     _textController.removeListener(_onTextChanged);
     super.dispose();
   }
   ```

## 🔍 Debugging Tools

### Enable Debug Mode
```dart
// In safe_theme_provider.dart
static const bool _debugMode = true;
```

### Logging
```dart
// Development logging
assert(() {
  debugPrint('Debug information here');
  return true;
}());
```

### Flutter Inspector
```bash
# Open Flutter Inspector
flutter run --debug
# Then open DevTools in browser
```

## 📞 Getting Help

### Log Collection
```bash
# Get comprehensive logs
flutter logs > app_logs.txt
```

### System Information
```bash
# Flutter system info
flutter doctor -v

# Dependency info
flutter pub deps
```

### Common Commands
```bash
# Reset everything
flutter clean && flutter pub get

# Restart with fresh state
flutter run --hot-restart

# Build for debugging
flutter run --debug --verbose
```

## 🚀 Performance Optimization

### Build Optimization
```bash
# Release build
flutter build apk --release --shrink

# Profile mode for performance testing
flutter run --profile
```

### Code Optimization
```dart
// Use const constructors
const Widget(
  child: const Text('Static text'),
)

// Optimize rebuilds
const SizedBox(height: 16), // Instead of Container
```

---

**Need More Help?**
- Check [Firebase Documentation](https://firebase.google.com/docs)
- Review [Flutter Documentation](https://docs.flutter.dev)
- Post on [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- Join [Flutter Community](https://flutter.dev/community)