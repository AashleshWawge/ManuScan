import 'package:manuscan/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:manuscan/controllers/auth_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State variables
  bool notificationsEnabled = true;
  String selectedLanguage = 'English';
  int selectedIndex = 2; // For bottom navigation
  bool isDarkMode = false;

  // Language options
  final List<String> languages = ['English', 'Hindi', 'Marathi'];

  void _handleNotificationChange(bool value) {
    setState(() {
      notificationsEnabled = value;
    });
  }

  void _handleLanguageChange(String? newLanguage) {
    if (newLanguage != null) {
      setState(() {
        selectedLanguage = newLanguage;
      });
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
            actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
              // Call the logout function from the auth_controller
              AuthController().logout();
              // Navigate to OnboardingScreen and remove all previous routes
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                (Route<dynamic> route) => false,
              );
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((String language) {
              return RadioListTile<String>(
                title: Text(language),
                value: language,
                groupValue: selectedLanguage,
                onChanged: (String? value) {
                  _handleLanguageChange(value);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildProfileSettings(),
                  _buildNotificationSettings(),
                  _buildLanguageSettings(),
                  _buildSecuritySettings(),
                  _buildHelpAndSupport(),
                  _buildPrivacyPolicy(),
                  const Spacer(),
                  _buildLogoutButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSettings() {
    return _buildSettingItem(
      icon: Icons.person_outline,
      title: 'Profile Settings',
      onTap: () {
        // Navigate to profile settings
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Placeholder()),
        );
      },
    );
  }

  Widget _buildNotificationSettings() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading:
            const Icon(Icons.notifications_outlined, color: Colors.black87),
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Switch(
          value: notificationsEnabled,
          onChanged: _handleNotificationChange,
          activeColor: Colors.teal,
        ),
      ),
    );
  }

  Widget _buildLanguageSettings() {
    return _buildSettingItem(
      icon: Icons.language_outlined,
      title: 'Language Preferences',
      trailing: Text(
        selectedLanguage,
        style: const TextStyle(color: Colors.grey),
      ),
      onTap: _showLanguageDialog,
    );
  }

  Widget _buildSecuritySettings() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(Icons.lock_outline, color: Colors.black87),
        title: const Text(
          'Security',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildHelpAndSupport() {
    return _buildSettingItem(
      icon: Icons.help_outline,
      title: 'Help & Support',
      onTap: () {
        // Navigate to help and support
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Placeholder()),
        );
      },
    );
  }

  Widget _buildPrivacyPolicy() {
    return _buildSettingItem(
      icon: Icons.privacy_tip_outlined,
      title: 'Privacy Policy',
      onTap: () {
        // Navigate to privacy policy
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Placeholder()),
        );
      },
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black87, size: 24),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.red, size: 24),
        title: const Text(
          'Logout',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.red,
          ),
        ),
        onTap: _handleLogout,
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "Logout Confirmation",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const OnboardingScreen()),
                  (Route<dynamic> route) => false,
                ); // Navigate to OnboardingScreen and remove all previous routes
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
              ),
              child: const Text("CONFIRM"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
              ),
              child: const Text("CANCEL"),
            ),
          ],
        );
      },
    );
  }
}
