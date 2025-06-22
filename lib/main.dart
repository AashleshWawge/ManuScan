import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bindings/app_bindings.dart';
import 'onboarding_screen.dart'; // Import OnboardingScreen instead of SecurityScreen
import 'login_page.dart'; // Import login_account
import 'home_screen.dart'; // Import HomeScreen
import 'security/securityscreen.dart'; // Import SecurityScreen
import 'package:manuscan/controllers/auth_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Getx bindings
  AppBindings().dependencies();

  print('App starting - initializing OnboardingScreen');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ManuScan',
      initialBinding: AppBindings(),
      initialRoute: '/',
      getPages: [
        GetPage(
            name: '/',
            page: () =>
                const OnboardingScreen()), // Changed back to OnboardingScreen
        GetPage(name: '/login', page: () => const login_account()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/security', page: () => const SecurityScreen()),
      ],
    );
  }
}
