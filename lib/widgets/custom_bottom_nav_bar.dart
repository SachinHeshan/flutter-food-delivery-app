import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Pages/search_page.dart';
import '../Pages/profile_page.dart';
import '../Pages/favorite_page.dart';
import 'profile_image_widget.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final User? user;

  const CustomBottomNavBar({super.key, required this.selectedIndex, this.user});

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = const Color(0xFFFF7A00);
    final Color unselectedColor = Colors.black45;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          constraints: const BoxConstraints(minHeight: 50, maxHeight: 70),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _buildNavItem(
                  context: context,
                  icon: Icons.home_filled,
                  label: 'Home',
                  index: 0,
                  selectedColor: selectedColor,
                  unselectedColor: unselectedColor,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  context: context,
                  icon: Icons.search,
                  label: 'Search',
                  index: 1,
                  selectedColor: selectedColor,
                  unselectedColor: unselectedColor,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  context: context,
                  icon: Icons.favorite_border_rounded,
                  label: 'Favorites',
                  index: 2,
                  selectedColor: selectedColor,
                  unselectedColor: unselectedColor,
                ),
              ),
              Expanded(
                child: _buildProfileNavItem(
                  context: context,
                  selectedColor: selectedColor,
                  unselectedColor: unselectedColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    final bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => _handleNavTap(context, index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? selectedColor : unselectedColor,
              size: 22,
            ),
            const SizedBox(height: 2),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? selectedColor : unselectedColor,
                  fontSize: 9,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileNavItem({
    required BuildContext context,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    final bool isSelected = selectedIndex == 3;
    return GestureDetector(
      onTap: () => _handleNavTap(context, 3),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    isSelected
                        ? Border.all(color: selectedColor, width: 1.5)
                        : null,
              ),
              child: ClipOval(
                child: ProfileImageWidget(
                  user: user,
                  size: 9,
                  showEditIcon: false,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Flexible(
              child: Text(
                'Profile',
                style: TextStyle(
                  color: isSelected ? selectedColor : unselectedColor,
                  fontSize: 9,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNavTap(BuildContext context, int index) {
    switch (index) {
      case 1:
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const SearchPage()));
        break;
      case 2:
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const FavoritePage()));
        break;
      case 3:
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
        break;
      // Add other navigation cases as needed
    }
  }
}
