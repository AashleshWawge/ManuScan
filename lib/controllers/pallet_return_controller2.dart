import 'package:get/get.dart';

class PalletReturnController extends GetxController {
  // Make scannedPallets reactive
  RxList<Map<String, String>> scannedPallets = <Map<String, String>>[].obs;
  RxList<bool> returnedStatus = <bool>[].obs;
  RxList<String> palletStatus = <String>[].obs;
  RxBool isNavigating = false.obs;

  void initialize(List<Map<String, String>> pallets) {
    scannedPallets.assignAll(pallets);
    // Update related lists based on incoming data
    returnedStatus.assignAll(pallets.map((p) => p['returnStatus'] == 'Returned').toList());
    palletStatus.assignAll(pallets.map((p) => p['conditionStatus'] ?? '').toList());
  }

  void addScannedPallet(Map<String, String> newPallet) {
    scannedPallets.add(newPallet);
    returnedStatus.add(newPallet['returnStatus'] == 'Returned');
    palletStatus.add(newPallet['conditionStatus'] ?? '');
  }

  void removePallet(int index) {
    scannedPallets.removeAt(index);
    returnedStatus.removeAt(index);
    palletStatus.removeAt(index);
  }
}
