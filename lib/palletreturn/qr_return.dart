import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manuscan/home_screen.dart';
import 'package:manuscan/palletreturn/pallet_return.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/scheduler.dart';
import 'package:manuscan/controllers/pallet_return_controller1.dart'; // Add this import
// Remove the PalletReturnController class from here as it's now in its own file

class CustomReturnScannerScreen extends StatefulWidget {
  final String challanId;
  final String returnId;
  final List<Map<String, String>> scannedPallets;

  const CustomReturnScannerScreen({
    super.key,
    required this.returnId,
    required this.challanId,
    required this.scannedPallets,
  });

  @override
  _CustomReturnScannerScreenState createState() =>
      _CustomReturnScannerScreenState();
}

class _CustomReturnScannerScreenState extends State<CustomReturnScannerScreen> {
  double zoom = 0.5;
  late MobileScannerController controller;
  late final PalletReturnController palletReturnController;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController();
    if (!Get.isRegistered<PalletReturnController>(tag: widget.returnId)) {
      palletReturnController =
          Get.put(PalletReturnController(), tag: widget.returnId);
      palletReturnController.initialize(widget.scannedPallets);
    } else {
      palletReturnController =
          Get.find<PalletReturnController>(tag: widget.returnId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Pallet QR'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) async {
              if (palletReturnController.isNavigating.value) return;
              palletReturnController.isNavigating.value = true;

              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final barcode = barcodes.first;
                if (barcode.rawValue != null) {
                  await controller.stop();
                  final Map<String, String>? result =
                      await _showCombinedStatusDialog(barcode.rawValue!);
                  if (result != null) {
                    palletReturnController.addScannedPallet(result);
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      log('Pallet added.');
                      Get.back(); // simply go back after adding pallet
                      palletReturnController.isNavigating.value = false;
                    });
                  } else {
                    await controller.start();
                    palletReturnController.isNavigating.value = false;
                  }
                }
              }
              ;
            },
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconButton(Icons.image, Colors.white, () async {
                  final picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) controller.analyzeImage(image.path);
                }),
                _buildIconButton(
                    Icons.flash_on, Colors.white, controller.toggleTorch),
                _buildIconButton(Icons.flip_camera_android, Colors.white,
                    controller.switchCamera),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Slider(
              value: zoom,
              min: 0.1,
              max: 1.0,
              activeColor: Colors.teal,
              onChanged: (value) {
                setState(() {
                  zoom = value;
                  controller.setZoomScale(value);
                });
              },
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton('Back', Colors.teal, () => Get.back()),
                _buildActionButton(
                  'View Pallets',
                  Colors.teal,
                  () => Get.to(() => PalletReturn3Screen(
                        returnId: widget.returnId,
                        challanId: widget.challanId,
                        lastScannedResult: null, // No new scan when viewing
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconButton _buildIconButton(
      IconData icon, Color color, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: color, size: 30),
      onPressed: onPressed,
    );
  }

  ElevatedButton _buildActionButton(
      String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontSize: 16)),
    );
  }

  Future<Map<String, String>?> _showCombinedStatusDialog(String code) async {
    String selectedReturnStatus = 'Returned';
    String selectedConditionStatus = 'OK';

    return await Get.dialog<Map<String, String>>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title:
            const Text('Pallet Scanned', style: TextStyle(color: Colors.teal)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(code, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            _buildDropdownRow(
              'Return Status:',
              selectedReturnStatus,
              ['Returned', 'Not Returned'],
              (value) => selectedReturnStatus = value!,
            ),
            const SizedBox(height: 12),
            _buildDropdownRow(
              'Condition:',
              selectedConditionStatus,
              ['OK', 'Scrap', 'Repair'],
              (value) => selectedConditionStatus = value!,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: {
              'code': code,
              'returnStatus': selectedReturnStatus,
              'conditionStatus': selectedConditionStatus,
            }),
            child: const Text('OK', style: TextStyle(color: Colors.teal)),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownRow(String label, String value, List<String> items,
      void Function(String?) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        DropdownButton<String>(
          value: value,
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class PalletReturnScreen extends StatelessWidget {
  final String returnId;
  final String challanId;
  final List<Map<String, String>> scannedPallets;

  const PalletReturnScreen({
    super.key,
    required this.returnId,
    required this.challanId,
    required this.scannedPallets,
  });

  @override
  Widget build(BuildContext context) {
    Get.find<PalletReturnController>(tag: returnId);
    // Do not re-initialize here; rely on the existing controller state
    // palletReturnController.initialize(scannedPallets);

    return PalletReturn3Screen(
      returnId: returnId,
      challanId: challanId,
      lastScannedResult: null, // No new scan initially
    );
  }
}

// Converted PalletReturn3 to StatefulWidget
class PalletReturn3Screen extends StatefulWidget {
  final String returnId;
  final String challanId;
  final Map<String, String>? lastScannedResult; // New field for the latest scan

  const PalletReturn3Screen({
    super.key,
    required this.returnId,
    required this.challanId,
    this.lastScannedResult,
  });

  @override
  _PalletReturn3ScreenState createState() => _PalletReturn3ScreenState();
}

class _PalletReturn3ScreenState extends State<PalletReturn3Screen> {
  late final PalletReturnController palletReturnController;

  @override
  void initState() {
    super.initState();
    palletReturnController =
        Get.find<PalletReturnController>(tag: widget.returnId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pallet Return'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Challan ID: ${widget.challanId}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      if (widget.lastScannedResult != null) ...[
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                              'Last Scanned: ${widget.lastScannedResult!['code']} '
                              'Status: ${widget.lastScannedResult!['returnStatus']} '
                              'Condition: ${widget.lastScannedResult!['conditionStatus']}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.grey)),
                        ),
                        const Divider(height: 1, color: Colors.grey),
                      ],
                      Expanded(
                        child: Obx(() => palletReturnController
                                .scannedPallets.isEmpty
                            ? const Center(
                                child: Text('No pallets scanned yet'))
                            : ListView.builder(
                                itemCount: palletReturnController
                                    .scannedPallets.length,
                                itemBuilder: (context, index) {
                                  final pallet = palletReturnController
                                      .scannedPallets[index];
                                  final code = pallet['code'] ?? 'Unknown';
                                  final returnStatus =
                                      pallet['returnStatus'] ?? 'Not Returned';
                                  final conditionStatus =
                                      pallet['conditionStatus'] ?? 'OK';
                                  final isReturned = returnStatus == 'Returned';

                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    title: Text('Pallet ID: $code',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500)),
                                    subtitle: Row(
                                      children: [
                                        _buildStatusChip(
                                          isReturned
                                              ? 'Returned'
                                              : 'Not Returned',
                                          isReturned ? Colors.blue : Colors.red,
                                        ),
                                        const SizedBox(width: 8),
                                        _buildStatusChip(
                                          conditionStatus,
                                          conditionStatus == 'Scrap'
                                              ? Colors.red
                                              : conditionStatus == 'Repair'
                                                  ? Colors.orange
                                                  : Colors.green,
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.grey),
                                      onPressed: () => showDeletePalletPopup(
                                        context,
                                        () => palletReturnController
                                            .removePallet(index),
                                      ),
                                    ),
                                  );
                                },
                              )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Obx(() => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    'Total: ${palletReturnController.scannedPallets.length}',
                                    style: const TextStyle(fontSize: 16)),
                                Text(
                                  'Returned: ${palletReturnController.returnedCount}',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.blue),
                                ),
                                Text(
                                  'Not Returned: ${palletReturnController.notReturnedCount}',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.red),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.to(() => CustomReturnScannerScreen(
                              challanId: widget.challanId,
                              returnId: widget.returnId,
                              scannedPallets: List<Map<String, String>>.from(
                                  palletReturnController.scannedPallets),
                            ));
                      },
                      icon: const Icon(Icons.qr_code_scanner,
                          color: Colors.white),
                      label: const Text("SCAN PALLET",
                          style: TextStyle(fontFamily: "DMSans", fontSize: 14)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showPalletsNotReturnedPopup(
                            context, palletReturnController.returnedCount);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(216, 219, 226, 1),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        "CONFIRM",
                        style: TextStyle(
                          fontFamily: "DMSans",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(27, 27, 30, 1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Chip _buildStatusChip(String label, Color color) {
    return Chip(
      label: Text(label,
          style: const TextStyle(color: Colors.white, fontSize: 12)),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  void showPalletsNotReturnedPopup(BuildContext context, int palletCount) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "PALLETS ASSIGNED",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7FA2AB),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: "DMSans",
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "$palletCount pallet(s) ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text: "have been assigned to the selected Challan",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.offAll(() => HomeScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3D4252),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("SAVE & EXIT"),
            ),
          ],
        ),
      ),
    );
  }

  void showDeletePalletPopup(BuildContext context, VoidCallback onConfirm) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(20),
        title: const Text('Delete Pallet?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to delete this pallet?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('No', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: const Text('Yes', style: TextStyle(color: Colors.teal)),
          ),
        ],
      ),
    );
  }
}
