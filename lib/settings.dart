import 'package:flutter/material.dart';
import 'package:manuscan/onboarding_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isNotificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                "Notifications",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              trailing: Switch(
                value: isNotificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    isNotificationsEnabled = value;
                  });
                },
              ),
            ),
            const Divider(),

            // Settings Options
            _buildSettingsOption(Icons.star_border, "Rate App"),
            _buildSettingsOption(Icons.share, "Share App"),
            _buildSettingsOption(Icons.lock_outline, "Privacy Policy"),
            _buildSettingsOption(
                Icons.description_outlined, "Terms and Conditions"),
            _buildSettingsOption(Icons.article_outlined, "Cookies Policy"),
            _buildSettingsOption(Icons.mail_outline, "Contact"),
            _buildSettingsOption(Icons.feedback_outlined, "Feedback"),
            _buildSettingsOption(Icons.logout, "Logout", onTap: () {
              showLogoutDialog(context);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption(IconData icon, String title,
      {VoidCallback? onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.black54),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      onTap: onTap,
    );
  }
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
        title: Text(
          "Logout Confirmation",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => OnboardingScreen()),
              ); // Navigate to OnboardingScreen
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.black87,
              foregroundColor: Colors.white,
            ),
            child: Text("CONFIRM"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black,
            ),
            child: Text("CANCEL"),
          ),
        ],
      );
    },
  );
}
