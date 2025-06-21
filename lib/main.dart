import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bindings/app_bindings.dart';
import 'onboarding_screen.dart';
import 'security/securityscreen.dart'; // Import your home screen
import 'package:manuscan/controllers/auth_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Getx bindings
  AppBindings().dependencies();

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
        GetPage(name: '/', page: () => const OnboardingScreen()),
        GetPage(
            name: '/home', page: () => const SecurityScreen()), // <-- Add this
      ],
    );
  }
}
