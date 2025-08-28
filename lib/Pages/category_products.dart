import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_details.dart';
import '../services/favorites_store.dart';

class CategoryProductsPage extends StatelessWidget {
  const CategoryProductsPage({super.key, required this.category});

  final String category;

  // Private map to avoid exposing _Product in public API
  static final Map<String, List<_Product>> _categoryToProducts = {
    'seafood': [
      _Product(
        title: 'Grilled Salmon',
        subtitle: 'Ocean Bites',
        image: 'assets/images/Grilled Salmon.peg.jpeg',
        rating: 4.9,
        price: 14.99,
      ),
      _Product(
        title: 'Fried Tilapia',
        subtitle: 'Sea Chef',
        image: 'assets/images/Fried Tilapia.jpeg',
        rating: 4.8,
        price: 12.49,
      ),
    ],
    'desserts': [
      _Product(
        title: 'Lava Cake',
        subtitle: 'Warm chocolate cake',
        image: 'assets/images/Chocolate Lava Cake.jpeg',
        rating: 4.9,
        price: 8.99,
      ),
      _Product(
        title: 'Strawberry cake',
        subtitle: 'Creamy cheesecake',
        image: 'assets/images/Strawberry Cheesecake.jpeg',
        rating: 4.8,
        price: 7.49,
      ),
    ],
    'fast food': [
      _Product(
        title: 'Cheese Burger',
        subtitle: 'Juicy beef',
        image: 'assets/images/Cheese Burger.jpeg',
        rating: 4.8,
        price: 5.99,
      ),
      _Product(
        title: 'French Fries',
        subtitle: 'Crispy fries',
        image: 'assets/images/French Fries.jpeg',
        rating: 4.7,
        price: 4.49,
      ),
    ],
    'beverages': [
      _Product(
        title: 'Iced Coffee',
        subtitle: 'Fresh Bar',
        image: 'assets/images/Iced Coffee.jpeg',
        rating: 4.7,
        price: 3.99,
      ),
      _Product(
        title: 'Iced Latte',
        subtitle: 'Coffee Co',
        image: 'assets/images/Fresh Orange Juice.jpeg',
        rating: 4.8,
        price: 4.99,
      ),
    ],
    'vegan foods': [
      _Product(
        title: 'Vegan Salad Bowl',
        subtitle: 'Fresh Greens',
        image: 'assets/images/Vegan Foods.jpeg',
        rating: 4.6,
        price: 9.49,
      ),
    ],
  };

  // Public accessor to fetch all products across categories for search
  static List<ProductItem> allProducts() {
    final List<ProductItem> items = [];
    _categoryToProducts.forEach((key, products) {
      for (final p in products) {
        items.add(
          ProductItem(
            title: p.title,
            subtitle: p.subtitle,
            image: p.image,
            rating: p.rating,
            price: p.price,
            category: key,
          ),
        );
      }
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final products =
        _categoryToProducts[_normalize(category)] ?? const <_Product>[];
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF6F7FB),
      body:
          products.isEmpty
              ? const Center(child: Text('No products in this category'))
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.76,
                            ),
                        itemCount: products.length,
                        itemBuilder:
                            (_, i) => _ProductTile(
                              product: products[i],
                              category: _normalize(category),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  String _normalize(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product, required this.category});
  final _Product product;
  final String category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (_) => ProductDetailsPage(
                  images: [product.image, product.image, product.image],
                  name: product.title,
                  description: product.subtitle,
                  price: product.price,
                  rating: product.rating,
                  category: category,
                  offers: const [
                    '10% off on first order',
                    'Free delivery over \$20',
                  ],
                ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                  child: Image.asset(
                    product.image,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Consumer<FavoritesStore>(
                    builder: (context, favoritesStore, child) {
                      final bool isFavorite = favoritesStore.isFavorite(product.title);
                      return InkWell(
                        onTap: () {
                          final favoriteProduct = FavoriteProduct(
                            title: product.title,
                            subtitle: product.subtitle,
                            image: product.image,
                            price: product.price,
                            rating: product.rating,
                            category: category,
                          );
                          favoritesStore.toggleFavorite(favoriteProduct);
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isFavorite 
                                    ? '${product.title} removed from favorites'
                                    : '${product.title} added to favorites',
                              ),
                              backgroundColor: isFavorite 
                                  ? Colors.red 
                                  : const Color(0xFFFF7A00),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            isFavorite 
                                ? Icons.favorite 
                                : Icons.favorite_border_rounded,
                            color: isFavorite 
                                ? Colors.red 
                                : Colors.black54,
                            size: 18,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.subtitle,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 18,
                            color: Color(0xFFFFB800),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFFF7A00),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Product {
  const _Product({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.rating,
    required this.price,
  });

  final String title;
  final String subtitle;
  final String image;
  final double rating;
  final double price;
}

class ProductItem {
  const ProductItem({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.rating,
    required this.price,
    required this.category,
  });

  final String title;
  final String subtitle;
  final String image;
  final double rating;
  final double price;
  final String category;
}
