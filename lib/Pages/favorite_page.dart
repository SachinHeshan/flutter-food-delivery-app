import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/favorites_store.dart';
import 'product_details.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  List<FavoriteProduct> _filteredFavorites = [];

  final List<String> _categories = [
    'All',
    'seafood',
    'desserts',
    'fast food',
    'beverages',
    'vegan foods',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterFavorites);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterFavorites);
    _searchController.dispose();
    super.dispose();
  }

  void _filterFavorites() {
    final favoritesStore = Provider.of<FavoritesStore>(context, listen: false);
    final String query = _searchController.text.toLowerCase();
    
    setState(() {
      List<FavoriteProduct> favorites = favoritesStore.favorites;
      
      // Filter by category
      if (_selectedCategory != 'All') {
        favorites = favorites.where((product) => 
          product.category.toLowerCase() == _selectedCategory.toLowerCase()
        ).toList();
      }
      
      // Filter by search query
      if (query.isNotEmpty) {
        favorites = favorites.where((product) =>
          product.title.toLowerCase().contains(query) ||
          product.subtitle.toLowerCase().contains(query)
        ).toList();
      }
      
      _filteredFavorites = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text(
          'My Favorites',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          Consumer<FavoritesStore>(
            builder: (context, favoritesStore, child) {
              return favoritesStore.favoriteCount > 0
                  ? IconButton(
                      icon: const Icon(Icons.clear_all),
                      onPressed: () => _showClearAllDialog(context),
                      tooltip: 'Clear all favorites',
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<FavoritesStore>(
        builder: (context, favoritesStore, child) {
          if (!favoritesStore.isInitialized) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF7A00),
              ),
            );
          }

          if (favoritesStore.favorites.isEmpty) {
            return _buildEmptyState();
          }

          // Initialize filtered list if empty
          if (_filteredFavorites.isEmpty && _searchController.text.isEmpty && _selectedCategory == 'All') {
            _filteredFavorites = favoritesStore.favorites;
          }

          return Column(
            children: [
              _buildSearchAndFilter(),
              Expanded(
                child: _filteredFavorites.isEmpty
                    ? _buildNoResultsState()
                    : _buildFavoritesList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search favorites...',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.black38),
                suffixIcon: Icon(Icons.tune_rounded, color: Colors.black38),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Category Filter
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      category == 'All' ? category : category.split(' ').map((word) => 
                        word[0].toUpperCase() + word.substring(1)
                      ).join(' '),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                      _filterFavorites();
                    },
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xFFFF7A00),
                    checkmarkColor: Colors.white,
                    elevation: 2,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.76,
        ),
        itemCount: _filteredFavorites.length,
        itemBuilder: (context, index) {
          return _FavoriteProductCard(product: _filteredFavorites[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFFF7A00).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border,
              size: 60,
              color: Color(0xFFFF7A00),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Favorites Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start adding products to your favorites\nby tapping the heart icon',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF7A00),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Browse Products',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.black.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Results Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filter',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear All Favorites'),
          content: const Text('Are you sure you want to remove all products from your favorites?'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<FavoritesStore>(context, listen: false).clearFavorites();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All favorites cleared'),
                    backgroundColor: Color(0xFFFF7A00),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }
}

class _FavoriteProductCard extends StatelessWidget {
  const _FavoriteProductCard({required this.product});

  final FavoriteProduct product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsPage(
              images: [product.image, product.image, product.image],
              name: product.title,
              description: product.subtitle,
              price: product.price,
              rating: product.rating,
              category: product.category,
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
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Consumer<FavoritesStore>(
                    builder: (context, favoritesStore, child) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () {
                            favoritesStore.removeFromFavorites(product.title);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.title} removed from favorites'),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.subtitle,
                    style: const TextStyle(color: Colors.black54),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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