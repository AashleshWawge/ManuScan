import 'package:get/get.dart';
import 'package:manuscan/controllers/auth_controller.dart';

class PalletReturnController extends GetxController {
  static PalletReturnController get to =>
      Get.find<PalletReturnController>(tag: 'palletReturn');

  // Essential properties for pallet return
  final RxList<Map<String, String>> scannedPallets =
      <Map<String, String>>[].obs;
  final isNavigating = false.obs;
  final totalPallets = 0.obs;

  // Add new properties for vehicle tracking
  final RxString vehicleNumber = ''.obs;
  final RxString vehicleId = ''.obs;

  // Computed properties
  int get returnedCount =>
      scannedPallets.where((p) => p['returnStatus'] == 'Returned').length;
  int get notReturnedCount => totalPallets.value - returnedCount;

  void initialize(List<Map<String, String>> initialPallets) {
    scannedPallets.clear();
    scannedPallets.addAll(initialPallets);
  }

  void addScannedPallet(Map<String, String> pallet) {
    if (!scannedPallets.any((p) => p['code'] == pallet['code'])) {
      scannedPallets.add(pallet);
    }
  }

  void removePallet(int index) {
    if (index >= 0 && index < scannedPallets.length) {
      scannedPallets.removeAt(index);
    }
  }

  void setTotalPallets(int count) {
    totalPallets.value = count;
  }

  // Add method to set vehicle number
  void setVehicleNumber(String number) {
    vehicleNumber.value = number.toUpperCase();
  }

  String getVehicleNumber() {
    return vehicleNumber.value;
  }

  String generateReceiptData() {
    final DateTime now = DateTime.now();
    final String timestamp =
        "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    final authController = Get.find<AuthController>();

    return """
PALLET RETURN RECEIPT
-------------------
Date & Time: $timestamp
Vehicle Number: ${vehicleNumber.value}
Security Guard: ${authController.userFirstName}

PALLET SUMMARY
-------------
Total Pallets: ${totalPallets.value}
Returned: $returnedCount
Not Returned: $notReturnedCount

Signature: _____________
""";
  }
}
