import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileImageWidget extends StatelessWidget {
  final User? user;
  final double size;
  final bool showEditIcon;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;

  const ProfileImageWidget({
    super.key,
    this.user,
    this.size = 50,
    this.showEditIcon = false,
    this.onTap,
    this.padding,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        child: Stack(
          children: [
            Container(
              decoration:
                  showBorder
                      ? BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: borderColor ?? const Color(0xFFFF7A00),
                          width: borderWidth,
                        ),
                      )
                      : null,
              child: CircleAvatar(
                radius: size,
                backgroundColor: Colors.grey[200],
                child: _buildProfileImage(),
              ),
            ),
            if (showEditIcon)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7A00),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: size * 0.3,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    // Try to load user profile image
    if (user?.photoURL != null && user!.photoURL!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          user!.photoURL!,
          width: size * 2,
          height: size * 2,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildFallbackAvatar(),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: const Color(0xFFFF7A00),
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
              ),
            );
          },
        ),
      );
    }

    // Show default profile image assets or icon
    return _buildFallbackAvatar();
  }

  Widget _buildFallbackAvatar() {
    // Try to show default avatar image from assets
    return ClipOval(
      child: Image.asset(
        'assets/images/profile.jpeg',
        width: size * 2,
        height: size * 2,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Final fallback to icon
          return Icon(Icons.person, size: size * 1.2, color: Colors.grey[600]);
        },
      ),
    );
  }
}

class ProfileImageButton extends StatelessWidget {
  final User? user;
  final double size;
  final VoidCallback? onTap;
  final bool isCircular;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;

  const ProfileImageButton({
    super.key,
    this.user,
    this.size = 42,
    this.onTap,
    this.isCircular = false,
    this.backgroundColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius:
            isCircular
                ? BorderRadius.circular(size / 2)
                : BorderRadius.circular(12),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius:
            isCircular
                ? BorderRadius.circular(size / 2)
                : BorderRadius.circular(12),
        child: ClipRRect(
          borderRadius:
              isCircular
                  ? BorderRadius.circular(size / 2)
                  : BorderRadius.circular(12),
          child: _buildImage(),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (user?.photoURL != null && user!.photoURL!.isNotEmpty) {
      return Image.network(
        user!.photoURL!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(),
      );
    }

    // Try default avatar asset
    return Image.asset(
      'assets/images/profile.jpeg',
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(),
    );
  }

  Widget _buildFallbackIcon() {
    return Icon(Icons.person_outline, color: Colors.black87, size: size * 0.6);
  }
}
