import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Pages/search_page.dart';
import '../Pages/profile_page.dart';

class SimpleBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final User? user;

  const SimpleBottomNavBar({super.key, required this.selectedIndex, this.user});

  @override
  Widget build(BuildContext context) {
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
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFFFF7A00),
          unselectedItemColor: Colors.black45,
          selectedFontSize: 10,
          unselectedFontSize: 9,
          iconSize: 20,
          onTap: (index) => _handleNavTap(context, index),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_rounded),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: _buildProfileIcon(),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileIcon() {
    if (user?.photoURL != null && user!.photoURL!.isNotEmpty) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border:
              selectedIndex == 3
                  ? Border.all(color: const Color(0xFFFF7A00), width: 1)
                  : null,
        ),
        child: ClipOval(
          child: Image.network(
            user!.photoURL!,
            width: 20,
            height: 20,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) =>
                    const Icon(Icons.person_outline, size: 18),
          ),
        ),
      );
    }

    // Fallback to default profile image
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border:
            selectedIndex == 3
                ? Border.all(color: const Color(0xFFFF7A00), width: 1)
                : null,
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/profile.jpeg',
          width: 20,
          height: 20,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) =>
                  const Icon(Icons.person_outline, size: 18),
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
      case 3:
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
        break;
    }
  }
}
