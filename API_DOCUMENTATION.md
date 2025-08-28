# 📡 API Documentation - E-Mart App

## 🔥 Firebase Integration

### Authentication Service

#### User Registration
```dart
// Email/Password Registration
Future<User?> signUpWithEmailPassword(String email, String password, String displayName)

// Google Sign-In Registration  
Future<User?> signInWithGoogle()
```

#### User Authentication
```dart
// Email/Password Sign-In
Future<User?> signInWithEmailPassword(String email, String password)

// Sign Out
Future<void> signOut()

// Current User
User? getCurrentUser()
```

### Data Models

#### User Profile
```dart
class UserProfile {
  String uid;
  String email;
  String? displayName;
  String? photoURL;
  String? phoneNumber;
  String? address;
  String? city;
  String? zipCode;
  DateTime createdAt;
  DateTime lastLoginAt;
}
```

#### Product
```dart
class Product {
  String id;
  String title;
  String subtitle;
  String description;
  String image;
  double price;
  double rating;
  String category;
  List<String> offers;
  bool isAvailable;
  DateTime createdAt;
}
```

#### Cart Item
```dart
class CartItem {
  String name;
  double price;
  String image;
  int quantity;
  
  // Methods
  void increment();
  void decrement();
  double getTotalPrice();
}
```

## 🛍️ E-Commerce Services

### Cart Management
```dart
class CartStore extends ChangeNotifier {
  // Properties
  List<CartItem> get items;
  int get itemCount;
  double get totalPrice;
  
  // Methods
  void addItem(CartItem item);
  void removeItem(String name);
  void increment(String name);
  void decrement(String name);
  void clear();
}
```

### Product Categories
```dart
enum ProductCategory {
  seafood,
  desserts,
  fastFood,
  beverages,
  veganFoods
}

// Category Products Access
Map<String, List<Product>> getCategoryProducts(String category);
List<ProductItem> getAllProducts();
```

## 🎨 Theme Management

### SafeThemeProvider
```dart
class SafeThemeProvider extends ChangeNotifier {
  // Properties
  bool get isDarkMode;
  bool get isInitialized;
  bool get prefsAvailable;
  ThemeData get lightTheme;
  ThemeData get darkTheme;
  
  // Methods
  Future<void> toggleTheme();
  Future<void> _initializeTheme();
}
```

### Theme Configuration
```dart
// Light Theme
ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.orange,
  brightness: Brightness.light,
  scaffoldBackgroundColor: Color(0xFFF6F7FB),
  fontFamily: 'Poppins',
);

// Dark Theme  
ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.orange,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF121212),
  fontFamily: 'Poppins',
);
```

## 📱 UI Components

### ProfileImageWidget
```dart
class ProfileImageWidget extends StatelessWidget {
  final User? user;
  final double size;
  final VoidCallback? onTap;
  
  // Fallback System:
  // 1. Firebase photoURL
  // 2. Default asset image
  // 3. Icon fallback
}
```

### CustomBottomNavBar
```dart
class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final User? user;
  
  // Navigation Items:
  // 0: Home
  // 1: Search  
  // 2: Cart
  // 3: Profile
}
```

## 🔄 State Management

### Provider Pattern Implementation
```dart
// Main App Provider Setup
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => SafeThemeProvider()),
    ChangeNotifierProvider(create: (_) => CartStore()),
  ],
  child: MyApp(),
)
```

### Global State Access
```dart
// Theme Provider
final themeProvider = Provider.of<SafeThemeProvider>(context);

// Cart Store  
final cartStore = Provider.of<CartStore>(context);

// Or using Consumer
Consumer<SafeThemeProvider>(
  builder: (context, themeProvider, child) {
    return Widget();
  },
)
```

## 🗃️ Local Storage

### SharedPreferences Integration
```dart
// Theme Preference Storage
static const String _themeKey = 'isDarkMode';

// Safe Storage with Fallback
try {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDarkMode = prefs.getBool(_themeKey) ?? false;
} catch (e) {
  // Use in-memory fallback
}
```

## 🚀 Navigation

### Route Management
```dart
// Main Routes
'/signin' -> SignIn()
'/signup' -> SignUp()  
'/home' -> HomePage()
'/profile' -> ProfilePage()
'/cart' -> CartPage()
'/product-details' -> ProductDetailsPage()
'/search' -> SearchPage()
'/category-products' -> CategoryProductsPage()

// Navigation Examples
Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
```

## 🔐 Security & Validation

### Form Validation
```dart
// Email Validation
bool isValidEmail(String email) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
}

// Password Validation  
bool isValidPassword(String password) {
  return password.length >= 6;
}

// Phone Validation
bool isValidPhone(String phone) {
  return RegExp(r'^\+?[\d\s-()]+$').hasMatch(phone);
}
```

### Error Handling
```dart
// Authentication Errors
try {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
} on FirebaseAuthException catch (e) {
  switch (e.code) {
    case 'user-not-found':
      return 'No user found for that email.';
    case 'wrong-password':
      return 'Wrong password provided.';
    default:
      return 'Authentication failed: ${e.message}';
  }
}
```

## 📊 Performance Optimization

### Image Loading
```dart
// Optimized Image Loading with Caching
Image.asset(
  imagePath,
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) {
    return Container(/* fallback UI */);
  },
)
```

### State Updates
```dart
// Efficient State Updates
void updateCart() {
  // Batch updates
  WidgetsBinding.instance.addPostFrameCallback((_) {
    notifyListeners();
  });
}
```

## 🧪 Testing Support

### Mock Services
```dart
// Mock Authentication
class MockAuthService implements AuthService {
  @override
  Future<User?> signIn(String email, String password) async {
    // Mock implementation
  }
}

// Mock Cart Store
class MockCartStore extends CartStore {
  // Test-specific implementations
}
```

This API documentation provides comprehensive coverage of all services, data models, and integration points in the E-Mart application.