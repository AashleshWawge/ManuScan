import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class PalletDispatchController extends GetxController {
  PalletDispatchController() {
    print("PalletDispatchController constructor called, hashCode: ${hashCode}");
  }
  final scannedPallets = <String>[].obs; // Reactive list for scanned pallets
  final challanId = ''.obs; // Reactive string for challan ID
  final zoom = 0.5.obs; // Reactive double for zoom level
  final MobileScannerController scannerController = MobileScannerController();

  void addPallet(String code) {
    if (!scannedPallets.contains(code)) {
      scannedPallets.add(code);
      print("Added pallet: $code, Total: ${scannedPallets.length}");
    }
  }

  void removePallet(int index) {
    scannedPallets.removeAt(index);
    print("Removed pallet at index $index, Total: ${scannedPallets.length}");
  }

  void setChallanId(String id) {
    challanId.value = id;
    print("Challan ID set to: $id");
  }

  void setZoom(double value) {
    zoom.value = value;
    scannerController.setZoomScale(value);
  }

  // Handle scanned codes (e.g., from QR scanner or manual entry)
  void onScanned(String? scannedCode) {
    if (scannedCode != null && !scannedPallets.contains(scannedCode)) {
      scannedPallets.add(scannedCode);
      print("Scanned pallet: $scannedCode, Total: ${scannedPallets.length}");
    }
  }

  void resetPallets() {
    scannedPallets.clear();
    print("Scanned pallets reset to 0, Total: ${scannedPallets.length}");
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }
}
