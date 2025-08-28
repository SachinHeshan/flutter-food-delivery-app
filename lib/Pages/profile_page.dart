import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../services/safe_theme_provider.dart';
import '../widgets/profile_image_widget.dart';
import 'signin.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Info Section
            _buildUserInfoSection(),
            const SizedBox(height: 24),

            // Account Settings Section
            _buildSectionTitle('Account Settings'),
            _buildSettingsCard([
              _buildSettingsTile(
                icon: Icons.person_outline,
                title: 'Edit Personal Details',
                subtitle: 'Name, phone, address',
                onTap: () => _showEditProfileDialog(),
              ),
              _buildSettingsTile(
                icon: Icons.location_on_outlined,
                title: 'Delivery Addresses',
                subtitle: 'Manage your addresses',
                onTap: () => _showAddressesDialog(),
              ),
              _buildSettingsTile(
                icon: Icons.payment_outlined,
                title: 'Payment Methods',
                subtitle: 'Cards, PayPal, Cash on delivery',
                onTap: () => _showPaymentMethodsDialog(),
              ),
              _buildSettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Notification Settings',
                subtitle: 'Push, SMS, Email',
                onTap: () => _showNotificationSettings(),
              ),
            ]),

            const SizedBox(height: 16),

            // Support & Info Section
            _buildSectionTitle('Support & Info'),
            _buildSettingsCard([
              _buildSettingsTile(
                icon: Icons.headset_mic_outlined,
                title: 'Contact Us',
                subtitle: 'Chat, call, or email support',
                onTap: () => _showContactOptions(),
              ),
              _buildSettingsTile(
                icon: Icons.info_outline,
                title: 'About App',
                subtitle: 'Version 1.0.0',
                onTap: () => _showAboutDialog(),
              ),
            ]),

            const SizedBox(height: 16),

            // Other Features Section
            _buildSectionTitle('Other Features'),
            _buildSettingsCard([
              _buildDarkModeToggle(),
              _buildSettingsTile(
                icon: Icons.logout,
                title: 'Logout',
                subtitle: 'Sign out of your account',
                onTap: () => _showLogoutDialog(),
                textColor: Colors.red,
              ),
            ]),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          ProfileImageWidget(
            user: user,
            size: 50,
            showEditIcon: true,
            onTap: () => _showImagePickerDialog(),
            showBorder: true,
            borderColor: const Color(0xFFFF7A00),
            borderWidth: 2,
          ),
          const SizedBox(height: 16),
          Text(
            user?.displayName ?? 'Guest User',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user?.email ?? 'guest@example.com',
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _navigateToEditProfile(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF7A00),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Edit Profile',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.black87),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor ?? Colors.black87,
        ),
      ),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.black54)),
      trailing: const Icon(Icons.chevron_right, color: Colors.black45),
      onTap: onTap,
    );
  }

  Widget _buildDarkModeToggle() {
    return Consumer<SafeThemeProvider>(
      builder: (context, themeProvider, child) {
        return ListTile(
          leading: Icon(
            themeProvider.isDarkMode
                ? Icons.dark_mode
                : Icons.light_mode_outlined,
          ),
          title: const Text(
            'Dark Mode',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            themeProvider.isDarkMode
                ? 'Switch to light theme${!themeProvider.prefsAvailable ? ' (session only)' : ''}'
                : 'Switch to dark theme${!themeProvider.prefsAvailable ? ' (session only)' : ''}',
          ),
          trailing: Switch(
            value: themeProvider.isDarkMode,
            onChanged: (value) async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              await themeProvider.toggleTheme();
              if (mounted) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      '${themeProvider.isDarkMode ? 'Dark mode enabled' : 'Light mode enabled'}${!themeProvider.prefsAvailable ? ' (for this session)' : ''}',
                    ),
                    duration: Duration(
                      seconds: themeProvider.prefsAvailable ? 2 : 3,
                    ),
                  ),
                );
              }
            },
            activeColor: const Color(0xFFFF7A00),
          ),
        );
      },
    );
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Change Profile Picture'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Camera feature coming soon'),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Gallery feature coming soon'),
                      ),
                    );
                  },
                ),
                if (user?.photoURL != null)
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Remove Photo'),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Photo removed')),
                      );
                    },
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  void _navigateToEditProfile() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => EditProfilePage(user: user)));
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: user?.displayName ?? '');
    final phoneController = TextEditingController();
    final addressController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Profile'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Save profile changes to Firebase or local storage
                  final name = nameController.text.trim();
                  final phone = phoneController.text.trim();
                  final address = addressController.text.trim();

                  // Validate inputs
                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Name cannot be empty')),
                    );
                    return;
                  }

                  // In a real app, save all profile data to Firebase
                  // await user?.updateDisplayName(name);
                  // await saveUserProfile(phone: phone, address: address);

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Profile updated: $name${phone.isNotEmpty ? ', $phone' : ''}${address.isNotEmpty ? ', $address' : ''}',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7A00),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void _showAddressesDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delivery Addresses'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAddressTile('Home', '123 Main St, City, State 12345'),
                _buildAddressTile('Work', '456 Office Blvd, City, State 67890'),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _showAddAddressDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Address'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7A00),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  Widget _buildAddressTile(String title, String address) {
    return ListTile(
      leading: const Icon(Icons.location_on),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(address),
      trailing: PopupMenuButton(
        itemBuilder:
            (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
      ),
    );
  }

  void _showAddAddressDialog() {
    final titleController = TextEditingController();
    final addressController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Address'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Address Title (e.g., Home, Work)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Full Address',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Address added successfully')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7A00),
                ),
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  void _showPaymentMethodsDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Payment Methods'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPaymentMethodTile(
                  'Credit Card',
                  '**** **** **** 1234',
                  Icons.credit_card,
                ),
                _buildPaymentMethodTile(
                  'PayPal',
                  'user@example.com',
                  Icons.account_balance_wallet,
                ),
                _buildPaymentMethodTile(
                  'Cash on Delivery',
                  'Pay when you receive',
                  Icons.money,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Add Payment Method'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7A00),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  Widget _buildPaymentMethodTile(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: PopupMenuButton(
        itemBuilder:
            (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
      ),
    );
  }

  void _showNotificationSettings() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Notification Settings'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Push Notifications'),
                  subtitle: const Text('Receive app notifications'),
                  value: true,
                  onChanged: (value) {},
                  activeColor: const Color(0xFFFF7A00),
                ),
                SwitchListTile(
                  title: const Text('SMS Notifications'),
                  subtitle: const Text('Receive text messages'),
                  value: false,
                  onChanged: (value) {},
                  activeColor: const Color(0xFFFF7A00),
                ),
                SwitchListTile(
                  title: const Text('Email Notifications'),
                  subtitle: const Text('Receive email updates'),
                  value: true,
                  onChanged: (value) {},
                  activeColor: const Color(0xFFFF7A00),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings saved')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7A00),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void _showContactOptions() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Contact Us'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.chat),
                  title: const Text('Live Chat'),
                  subtitle: const Text('Chat with our support team'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening chat...')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text('Call Us'),
                  subtitle: const Text('+1 (555) 123-4567'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Calling support...')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Email Support'),
                  subtitle: const Text('support@emart.com'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening email app...')),
                    );
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'E-Mart',
      applicationVersion: '1.0.0',
      applicationIcon: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/images/logo.jpeg',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) => Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7A00),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.store, size: 30, color: Colors.white),
              ),
        ),
      ),
      children: [
        const Text(
          'E-Mart is your one-stop shop for all your grocery and food delivery needs. We provide fresh, quality products delivered right to your doorstep.',
        ),
        const SizedBox(height: 16),
        const Text('Features:', style: TextStyle(fontWeight: FontWeight.bold)),
        const Text('• Fast delivery'),
        const Text('• Fresh products'),
        const Text('• Secure payments'),
        const Text('• 24/7 customer support'),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const SignIn()),
                      (route) => false,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Logout'),
              ),
            ],
          ),
    );
  }
}
