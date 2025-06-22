import 'package:flutter/material.dart';
import 'package:manuscan/notification.dart';
import 'package:manuscan/settings.dart';
import 'package:manuscan/profile.dart';
import 'package:manuscan/widgets/custom_bottom_navigation_bar.dart';
import 'package:manuscan/controllers/auth_controller.dart'; // Change this import
import 'palletdispatch/pallet_dispatch.dart';
import 'package:get/get.dart';
import 'palletreturn/qr_return.dart'; // Ensure this import exposes showChallanIdPopup
import 'palletdispatch/qr_dispatch.dart'; // Added import for PalletDispatchScreen2

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final authController = Get.find<AuthController>(); // Use find instead of put

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    print('HomeScreen initState called');
    print('AuthController firstName: ${authController.firstName}');
    print('AuthController role: ${authController.role}');
    print('AuthController isLoggedIn: ${authController.isLoggedIn}');
    _screens = [
      HomeScreenContent(authController: authController),
      const NotificationsScreen(),
      const SettingsScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    print('HomeScreen build method called');
    print('Current index: $_currentIndex');
    print('AuthController isLoading: ${authController.isLoading}');
    print('AuthController isLoggedIn: ${authController.isLoggedIn}');

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          print('Bottom nav tapped: $index');
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: SafeArea(
        child: Obx(() {
          print('HomeScreen Obx rebuild triggered');
          if (authController.isLoading) {
            print('Showing loading indicator');
            return const Center(child: CircularProgressIndicator());
          }
          if (_currentIndex == 0) {
            print('Showing HomeScreenContent');
            return HomeScreenContent(authController: authController);
          }
          print('Showing screen at index: $_currentIndex');
          return _screens[_currentIndex];
        }),
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  final AuthController authController;

  const HomeScreenContent({Key? key, required this.authController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('HomeScreenContent build method called');
    print('AuthController firstName: ${authController.firstName}');
    print('AuthController role: ${authController.role}');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => _buildHeader(userName: authController.firstName)),
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
              print(
                  'Pallet Dispatch tapped - navigating directly to QR dispatch');
              // Navigate directly to PalletDispatchScreen2 (qr_dispatch.dart) with default values
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PalletDispatchScreen2(
                    challanId: 'DEFAULT_CHALLAN',
                    scannedPallets: [],
                    challanDetails: {
                      'vendor': {
                        'code': 'VENDOR001',
                        'name': 'Default Vendor',
                        'gstin': 'GSTIN123456789',
                        'pan': 'PAN123456789',
                      },
                      'challan_no': 'DEFAULT_CHALLAN',
                      'challan_info': {
                        'date': '2024-01-01',
                        'vehicle_no': 'DL01AB1234',
                        'transporter': 'Default Transporter',
                      },
                      'employee': {
                        'code': 'EMP001',
                        'name': 'Default Employee',
                      },
                      'material': {
                        'code': 'MAT001',
                        'description': 'Default Material',
                        'hsn_code': 'HSN001',
                        'pallet_count': '10',
                        'unit': 'PCS',
                        'axle_qty': '5',
                        'expected_return_date': '2024-02-01',
                      },
                    },
                  ),
                ),
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
              print('Pallet Return tapped');
              // Call showChallanIdPopup to start the return process.
              showChallanIdPopup(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader({required String userName}) {
    print('_buildHeader called with userName: $userName');
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
