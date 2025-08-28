import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProduct {
  FavoriteProduct({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.price,
    required this.rating,
    required this.category,
  });

  final String title;
  final String subtitle;
  final String image;
  final double price;
  final double rating;
  final String category;

  // Convert to/from JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'image': image,
      'price': price,
      'rating': rating,
      'category': category,
    };
  }

  factory FavoriteProduct.fromJson(Map<String, dynamic> json) {
    return FavoriteProduct(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      category: json['category'] ?? '',
    );
  }
}

class FavoritesStore extends ChangeNotifier {
  static const String _favoritesKey = 'favorite_products';
  static const bool _debugMode = false; // Set to true for development debugging

  final List<FavoriteProduct> _favorites = <FavoriteProduct>[];
  bool _isInitialized = false;
  SharedPreferences? _prefs;

  List<FavoriteProduct> get favorites => List.unmodifiable(_favorites);
  int get favoriteCount => _favorites.length;
  bool get isInitialized => _isInitialized;

  FavoritesStore() {
    _initializeFavorites();
  }

  Future<void> _initializeFavorites() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final String? favoritesJson = _prefs?.getString(_favoritesKey);
      
      if (favoritesJson != null && favoritesJson.isNotEmpty) {
        final List<dynamic> favoritesList = jsonDecode(favoritesJson);
        _favorites.clear();
        _favorites.addAll(
          favoritesList.map((json) => FavoriteProduct.fromJson(json)).toList(),
        );
      }
    } catch (e) {
      // Handle SharedPreferences errors gracefully
      if (_debugMode) {
        assert(() {
          debugPrint('FavoritesStore: Could not load favorites from storage: $e');
          return true;
        }());
      }
    }

    _isInitialized = true;
    notifyListeners();
  }

  bool isFavorite(String productTitle) {
    return _favorites.any((favorite) => favorite.title == productTitle);
  }

  Future<void> toggleFavorite(FavoriteProduct product) async {
    final int existingIndex = _favorites.indexWhere(
      (favorite) => favorite.title == product.title,
    );

    if (existingIndex >= 0) {
      // Remove from favorites
      _favorites.removeAt(existingIndex);
    } else {
      // Add to favorites
      _favorites.add(product);
    }

    // Save to SharedPreferences
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> addToFavorites(FavoriteProduct product) async {
    if (!isFavorite(product.title)) {
      _favorites.add(product);
      await _saveFavorites();
      notifyListeners();
    }
  }

  Future<void> removeFromFavorites(String productTitle) async {
    _favorites.removeWhere((favorite) => favorite.title == productTitle);
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> clearFavorites() async {
    _favorites.clear();
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    try {
      if (_prefs != null) {
        final String favoritesJson = jsonEncode(
          _favorites.map((favorite) => favorite.toJson()).toList(),
        );
        await _prefs!.setString(_favoritesKey, favoritesJson);
      }
    } catch (e) {
      // Handle save errors gracefully
      if (_debugMode) {
        assert(() {
          debugPrint('FavoritesStore: Could not save favorites to storage: $e');
          return true;
        }());
      }
    }
  }

  // Get favorites by category
  List<FavoriteProduct> getFavoritesByCategory(String category) {
    return _favorites.where((favorite) => 
      favorite.category.toLowerCase() == category.toLowerCase()
    ).toList();
  }

  // Search favorites
  List<FavoriteProduct> searchFavorites(String query) {
    final String lowerQuery = query.toLowerCase();
    return _favorites.where((favorite) =>
      favorite.title.toLowerCase().contains(lowerQuery) ||
      favorite.subtitle.toLowerCase().contains(lowerQuery) ||
      favorite.category.toLowerCase().contains(lowerQuery)
    ).toList();
  }
}

// Global instance
final FavoritesStore favoritesStore = FavoritesStore();