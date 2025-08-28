import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'category_products.dart';
import 'product_details.dart';
import '../services/favorites_store.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  late List<ProductItem> _all;
  late List<ProductItem> _filtered;

  @override
  void initState() {
    super.initState();
    _all = CategoryProductsPage.allProducts();
    _filtered = _all;
    _controller.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onQueryChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    final q = _controller.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filtered = _all;
      } else {
        _filtered =
            _all.where((p) {
              return p.title.toLowerCase().contains(q) ||
                  p.subtitle.toLowerCase().contains(q) ||
                  p.category.toLowerCase().contains(q);
            }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search products... ',
            border: InputBorder.none,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF6F7FB),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            _filtered.isEmpty
                ? const Center(child: Text('No matching products'))
                : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.76,
                  ),
                  itemCount: _filtered.length,
                  itemBuilder: (_, i) => _SearchTile(item: _filtered[i]),
                ),
      ),
    );
  }
}

class _SearchTile extends StatelessWidget {
  const _SearchTile({required this.item});
  final ProductItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (_) => ProductDetailsPage(
                  images: [item.image, item.image, item.image],
                  name: item.title,
                  description: item.subtitle,
                  price: item.price,
                  rating: item.rating,
                  category: item.category,
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
                    item.image,
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
                      final bool isFavorite = favoritesStore.isFavorite(item.title);
                      return InkWell(
                        onTap: () {
                          final favoriteProduct = FavoriteProduct(
                            title: item.title,
                            subtitle: item.subtitle,
                            image: item.image,
                            price: item.price,
                            rating: item.rating,
                            category: item.category,
                          );
                          favoritesStore.toggleFavorite(favoriteProduct);
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isFavorite 
                                    ? '${item.title} removed from favorites'
                                    : '${item.title} added to favorites',
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
                    item.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
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
                            item.rating.toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
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
