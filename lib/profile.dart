import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Removed BottomNavigationBar
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.teal.shade200,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                "John Doe",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 5),
            Center(
              child: Column(
                children: [
                  Text("Email : dhruvvyas@domain.tld"),
                  Text("Phone No. : +91 9876543210"),
                  Text("Last Login : 30/01/2025 12:26 PM"),
                ],
              ),
            ),
            SizedBox(height: 15),
            Divider(),
            sectionTitle("Account Status"),
            profileDetail("Role", "Security"),
            profileDetail("Status", "Active"),
            profileDetail("Pending Actions", "None"),
            profileDetail("Member Since", "January 15, 2023"),
            SizedBox(height: 10),
            sectionTitle("Security & Access"),
            profileDetail("Password Last Updated", "3 months ago"),
            profileDetail("Login Attempts", "1 (Today)"),
            profileDetail("IP Address", "192.168.1.1"),
            profileDetail("Device", "Chrome on Windows 11"),
            SizedBox(height: 10),
            sectionTitle("Settings & Preferences"),
            profileDetail("Language", "English (UK)"),
            profileDetail("Theme Preference", "Dark Mode"),
            profileDetail("Notifications", "Enabled"),
            profileDetail("Two-Factor Authentication", "Enabled"),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 5),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget profileDetail(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Text("$label: $value"),
    );
  }
}
