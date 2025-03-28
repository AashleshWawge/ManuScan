import 'package:flutter/material.dart';
import 'package:manuscan/notification.dart';
import 'package:manuscan/settings.dart';
import 'package:manuscan/profile.dart';
import 'package:manuscan/widgets/custom_bottom_navigation_bar.dart';
// import 'defectdetection/defect_detection.dart';
import 'palletreturn/pallet_return.dart';
import 'palletdispatch/pallet_dispatch.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreenContent(),
    const NotificationsScreen(),
    const SettingsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: SafeArea(
        child: _screens[_currentIndex],
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          const Text(
            "What would you like to do ?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildActionCard(
            context: context,
            imagePath: 'assets/images/pd.png', // Add your image path here
            title: "Pallet Dispatch",
            description:
                "Manage the outbound movement of pallets by tracking dispatch details and ensuring accurate inventory updates.",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PalletDispatchScreen1()),
              );
            },
          ),
          _buildActionCard(
            context: context,
            imagePath: 'assets/images/pr.png', // Add your image path here
            title: "Pallet Return",
            description:
                "Handle the return of pallets efficiently by recording inbound shipments, verifying conditions, and updating stock levels.",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PalletReturnScreen1()),
              );
            },
          ),
          // _buildActionCard(
          //   context: context,
          //   imagePath: 'assets/images/dd.png', // Add your image path here
          //   title: "Defect Detection",
          //   description:
          //       "Identify and track defective pallets through inspection, categorize issues, and take necessary actions for repairs or replacements.",
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => const DefectDetectionScreen()),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final String userName = "John"; // Replace with dynamic user name

    return Container(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Image.asset('assets/images/textbg.png'), // Add your image here
          Positioned(
            left: 16,
            top: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome, $userName",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Manage your inventory seamlessly. Navigate through dispatch, returns, and defect detection with ease",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String imagePath,
    required String title,
    required String description,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(imagePath, width: 40, height: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
