import 'package:get/get.dart';

class PalletReturnController extends GetxController {
  var scannedPallets = <Map<String, String>>[].obs;
  var isNavigating = false.obs;

  void initialize(List<Map<String, String>> initialPallets) {
    if (scannedPallets.isEmpty) {
      scannedPallets.assignAll(initialPallets);
    }
  }

  void addScannedPallet(Map<String, String> result) {
    final String scannedCode = result['code'] ?? '';
    int existingIndex =
        scannedPallets.indexWhere((pallet) => pallet['code'] == scannedCode);
    if (existingIndex >= 0) {
      scannedPallets[existingIndex] = result;
    } else {
      scannedPallets.add(result);
    }
  }

  void removePallet(int index) {
    if (index >= 0 && index < scannedPallets.length) {
      scannedPallets.removeAt(index);
    }
  }

  int get returnedCount =>
      scannedPallets.where((p) => p['returnStatus'] == 'Returned').length;

  int get notReturnedCount =>
      scannedPallets.where((p) => p['returnStatus'] != 'Returned').length;
}
