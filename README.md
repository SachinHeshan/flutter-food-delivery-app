# 🛒 E-Mart - Food Delivery App

A modern Flutter-based e-commerce food delivery application with Firebase integration, featuring user authentication, product catalog, shopping cart, and profile management.

## 📱 Features

### 🔐 Authentication
- Email/Password sign-in and registration
- Google Sign-In integration
- User profile management with image upload
- Secure logout functionality

### 🏪 E-Commerce Features
- Browse products by categories (Seafood, Desserts, Fast Food, Beverages, Vegan)
- Product details with images and ratings
- Shopping cart with quantity management
- Search functionality across all products
- Product recommendations and offers

### 🎨 UI/UX Features
- Material Design 3 with modern aesthetics
- Light/Dark theme switching with persistent preferences
- Responsive design with custom components
- Smooth animations and transitions
- Custom bottom navigation with profile integration
- Splash screen with branded logo

### 📱 Profile Management
- User profile with editable information
- Profile image upload (camera/gallery options)
- Account settings and preferences
- Support and help sections
- Theme customization

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.7.2+)
- Dart SDK
- Firebase account
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd e-mart/e_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Follow the guide in [FIREBASE_SETUP.md](./FIREBASE_SETUP.md)
   - Ensure `google-services.json` is in `android/app/`
   - Configure authentication providers

4. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── Pages/
│   ├── signin.dart           # Authentication pages
│   ├── signup.dart
│   ├── home.dart             # Main home page
│   ├── profile_page.dart     # User profile
│   ├── edit_profile_page.dart
│   ├── cart_page.dart        # Shopping cart
│   ├── product_details.dart  # Product information
│   ├── category_products.dart# Category listings
│   └── search_page.dart      # Search functionality
├── widgets/
│   ├── profile_image_widget.dart     # Reusable profile components
│   └── custom_bottom_nav_bar.dart    # Custom navigation
├── services/
│   ├── auth_service.dart     # Authentication logic
│   ├── cart_store.dart       # Cart state management
│   └── safe_theme_provider.dart      # Theme management
└── main.dart                 # App entry point
```

## 🛠 Technology Stack

- **Framework:** Flutter 3.7.2+
- **Language:** Dart
- **Backend:** Firebase (Auth, Firestore, Storage)
- **State Management:** Provider pattern
- **Storage:** SharedPreferences
- **Authentication:** Firebase Auth + Google Sign-In
- **UI:** Material Design 3

## 📦 Dependencies

```yaml
dependencies:
  flutter: sdk
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.3
  cloud_firestore: ^5.4.3
  firebase_storage: ^12.2.3
  google_sign_in: ^6.2.1
  provider: ^6.1.1
  shared_preferences: ^2.2.2
  cupertino_icons: ^1.0.8
```

## 🎯 Key Features Implementation

### Theme Management
- **SafeThemeProvider**: Error-resilient theme switching
- **Persistent Storage**: User preferences saved locally
- **Graceful Degradation**: Works without SharedPreferences

### Profile System
- **ProfileImageWidget**: Reusable avatar component
- **Image Upload**: Camera and gallery integration
- **Fallback System**: Firebase → Asset → Icon hierarchy

### Cart Management
- **CartStore**: Global cart state management
- **Quantity Control**: Add, remove, and modify items
- **Real-time Updates**: Live cart count and totals

## 🚀 Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 🧪 Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 Support

For support and questions, please refer to:
- [Firebase Setup Guide](./FIREBASE_SETUP.md)
- [API Documentation](./API_DOCUMENTATION.md)
- [Troubleshooting Guide](./TROUBLESHOOTING.md)
