import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'onboarding_screen.dart';
import 'controllers/auth_controller.dart';

void main() {
  initializeControllers();
  runApp(MyApp());
}

void initializeControllers() {
  Get.put(AuthController()); // Initialize AuthController globally
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Changed from MaterialApp to GetMaterialApp
      debugShowCheckedModeBanner: false,
      title: 'ManuScan',
      home: OnboardingScreen(),
    );
  }
}
