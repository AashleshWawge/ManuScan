import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'onboarding_screen.dart';
import 'controllers/auth_controller.dart';
import 'controllers/pallet_dispatch_controller.dart';
import 'controllers/pallet_return_controller1.dart';

void main() {
  initializeControllers();
  runApp(MyApp());
}

void initializeControllers() {
  Get.put(AuthController());
  Get.put(PalletReturnController()); // Initialize AuthController globally
  final palletDispatchController = Get.put(PalletDispatchController(),
      tag: 'palletDispatch', permanent: true);
  print(
      "Main.dart: PalletDispatchController initialized with hashCode: ${palletDispatchController.hashCode}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(context) {
    return GetMaterialApp(
      // Changed from MaterialApp to GetMaterialApp
      debugShowCheckedModeBanner: false,
      title: 'ManuScan',
      home: OnboardingScreen(),
    );
  }
}
