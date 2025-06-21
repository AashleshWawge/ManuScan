import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manuscan/security/securityscreen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/scheduler.dart';
//import 'package:manuscan/controllers/pallet_return_controller.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:manuscan/controllers/auth_controller.dart'; // Add this import

// Updated showChallanIdPopup:
void showSecurityChallanIdPopup(BuildContext context) {
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController numberOfPalletsController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Enter Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "DMSans",
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: vehicleNumberController,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  labelText: "Vehicle Number",
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: numberOfPalletsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Number of Pallets",
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  if (vehicleNumberController.text.trim().isEmpty ||
                      numberOfPalletsController.text.trim().isEmpty) {
                    Flushbar(
                      message: 'Please fill in all fields',
                      backgroundColor: Colors.red,
                      margin: const EdgeInsets.all(10),
                      borderRadius: BorderRadius.circular(8),
                      duration: const Duration(seconds: 3),
                      flushbarPosition: FlushbarPosition.TOP,
                    ).show(context);
                  } else {
                    final String returnId =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    final controller =
                        Get.put(PalletReturnController(), tag: returnId);
                    controller.initialize([]);
                    controller
                        .setVehicleNumber(vehicleNumberController.text.trim());
                    controller.setTotalPallets(
                        int.parse(numberOfPalletsController.text.trim()));

                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SecurityAddPalletsSection(
                          returnId: returnId,
                          challanId: returnId,
                          scannedPallets: [],
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text(
                  "CONFIRM",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "DMSans",
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class SecurityReturnScannerScreen extends StatefulWidget {
  final String challanId;
  final String returnId;
  final List<Map<String, String>> scannedPallets;

  const SecurityReturnScannerScreen({
    super.key,
    required this.returnId,
    required this.challanId,
    required this.scannedPallets,
  });

  @override
  _SecurityReturnScannerScreenState createState() =>
      _SecurityReturnScannerScreenState();
}

class _SecurityReturnScannerScreenState
    extends State<SecurityReturnScannerScreen> {
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

  void showManualPalletIdPopup(BuildContext context) {
    TextEditingController palletIdController = TextEditingController();
    String selectedReturnStatus = 'Returned';
    String selectedConditionStatus = 'OK';
    final picker = ImagePicker();
    String? capturedImagePath;
    Map<String, dynamic>? predictionResult;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Enter Pallet ID",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    TextField(
                      controller: palletIdController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (palletIdController.text.trim().isEmpty) {
                          Flushbar(
                            message: 'Please enter a Pallet ID',
                            backgroundColor: Colors.red,
                            margin: const EdgeInsets.all(10),
                            borderRadius: BorderRadius.circular(8),
                            duration: const Duration(seconds: 3),
                            flushbarPosition: FlushbarPosition.TOP,
                          ).show(context);
                          return;
                        }
                        setState(() {
                          palletReturnController.addScannedPallet({
                            'code': palletIdController.text.trim(),
                            'returnStatus': selectedReturnStatus,
                            'conditionStatus': selectedConditionStatus,
                          });
                        });
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SecurityPalletReturnScreen(
                              challanId: widget.challanId,
                              scannedPallets:
                                  palletReturnController.scannedPallets,
                              returnStatus: selectedReturnStatus,
                              conditionStatus: selectedConditionStatus,
                              returnId: widget.returnId,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12)),
                      label: const Text("CONFIRM",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
                  () => Get.to(() => SecurityPalletReturnScreen(
                        returnId: widget.returnId,
                        challanId: widget.challanId,
                        lastScannedResult: null,
                        returnStatus: '',
                        scannedPallets: [], // No new scan when viewing
                        conditionStatus: '', // No new scan when viewing
                      )),
                ),
              ],
            ),
          ),
          Obx(() {
            // Wrap only the widget that depends on reactive variables
            if (palletReturnController.needsUpdate.value) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                palletReturnController.updateState();
              });
            }
            return const SizedBox(); // Default widget if no updates are needed
          }),
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
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text('Pallet Scanned',
                style: TextStyle(color: Colors.teal)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(code, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Return Status:',
                        style: TextStyle(fontSize: 16)),
                    DropdownButton<String>(
                      value: selectedReturnStatus,
                      items: ['Returned', 'Not Returned']
                          .map((item) =>
                              DropdownMenuItem(value: item, child: Text(item)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedReturnStatus = value!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Condition:', style: TextStyle(fontSize: 16)),
                    DropdownButton<String>(
                      value: selectedConditionStatus,
                      items: ['OK', 'Scrap', 'Repair']
                          .map((item) =>
                              DropdownMenuItem(value: item, child: Text(item)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedConditionStatus = value!;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () => Get.back(result: {
                  'code': code,
                  'returnStatus': selectedReturnStatus,
                  'conditionStatus': selectedConditionStatus,
                }),
                child: const Text('OK', style: TextStyle(color: Colors.teal)),
              ),
            ],
          );
        },
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

class SecurityPalletRScreen extends StatelessWidget {
  final String returnId;
  final String challanId;
  final List<Map<String, String>> scannedPallets;

  const SecurityPalletRScreen({
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
    return SecurityPalletReturnScreen(
      returnId: returnId,
      challanId: challanId,
      lastScannedResult: null,
      scannedPallets: [],
      conditionStatus: '',
      returnStatus: '', // No new scan initially
    );
  }
}

// Converted PalletReturn3 to StatefulWidget
class SecurityPalletReturnScreen extends StatefulWidget {
  final String returnId;
  final String challanId;
  final List<Map<String, String>> scannedPallets;
  final String returnStatus;
  final String conditionStatus;
  final Map<String, String>? lastScannedResult; // New field for the latest scan

  const SecurityPalletReturnScreen({
    super.key,
    required this.returnId,
    required this.challanId,
    required this.scannedPallets,
    required this.returnStatus,
    required this.conditionStatus,
    this.lastScannedResult,
  });

  @override
  __SecurityPalletReturnScreenState createState() =>
      __SecurityPalletReturnScreenState();
}

class __SecurityPalletReturnScreenState
    extends State<SecurityPalletReturnScreen> {
  late final PalletReturnController palletReturnController;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<PalletReturnController>(tag: widget.returnId)) {
      palletReturnController =
          Get.put(PalletReturnController(), tag: widget.returnId);
    } else {
      palletReturnController =
          Get.find<PalletReturnController>(tag: widget.returnId);
    }

    // Initialize with any passed scanned pallets
    if (widget.scannedPallets.isNotEmpty) {
      palletReturnController.addScannedPallet(widget.scannedPallets.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pallet Return'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        child: Obx(() {
                          // Access reactive variables inside Obx
                          final scannedPallets =
                              palletReturnController.scannedPallets;
                          return scannedPallets.isEmpty
                              ? const Center(
                                  child: Text('No pallets scanned yet'))
                              : ListView.builder(
                                  itemCount: scannedPallets.length,
                                  itemBuilder: (context, index) {
                                    final pallet = scannedPallets[index];
                                    final code = pallet['code'] ?? 'Unknown';
                                    final returnStatus =
                                        pallet['returnStatus'] ??
                                            'Not Returned';
                                    final conditionStatus =
                                        pallet['conditionStatus'] ?? 'OK';
                                    final isReturned =
                                        returnStatus == 'Returned';

                                    return ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                                            isReturned
                                                ? Colors.blue
                                                : Colors.red,
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
                                );
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Obx(() {
                          // Access reactive variables inside Obx
                          final totalPallets =
                              palletReturnController.totalPallets.value;
                          final returnedCount =
                              palletReturnController.returnedCount;
                          final notReturnedCount =
                              palletReturnController.notReturnedCount;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Expected: $totalPallets',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Returned: $returnedCount',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.blue),
                              ),
                              Text(
                                'Not Returned: $notReturnedCount',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.red),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      // Access reactive variables inside Obx
                      final scannedPallets =
                          palletReturnController.scannedPallets.length;
                      final totalPallets =
                          palletReturnController.totalPallets.value;

                      return ElevatedButton.icon(
                        onPressed: scannedPallets >= totalPallets
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SecurityAddPalletsSection(
                                      challanId: widget.challanId,
                                      returnId: widget.returnId,
                                      scannedPallets: widget.scannedPallets,
                                    ),
                                  ),
                                ).then((result) {
                                  if (result != null &&
                                      result is Map<String, String>) {
                                    setState(() {
                                      palletReturnController
                                          .addScannedPallet(result);
                                    });
                                  }
                                });
                              },
                        icon: const Icon(Icons.add_circle, color: Colors.white),
                        label: Text(
                          scannedPallets >= totalPallets
                              ? "MAX PALLETS REACHED"
                              : "ADD PALLET",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          disabledBackgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 12),
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
                          borderRadius: BorderRadius.circular(8),
                        ),
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
              const SizedBox(height: 20),
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
              "PALLETS SUMMARY",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7FA2AB),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Pallets:",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "${palletReturnController.scannedPallets.length}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Returned:",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        "${palletReturnController.returnedCount}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Not Returned:",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        "${palletReturnController.notReturnedCount}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Are you sure you want to save and exit?",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    "CANCEL",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showReceiptDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3D4252),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("GENERATE RECEIPT"),
                ),
              ],
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

  void showReceiptDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Receipt'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(palletReturnController.generateReceiptData()),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.offAll(() => SecurityScreen()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("DONE"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecurityAddPalletsSection extends StatefulWidget {
  final String challanId;
  final String returnId;
  final List<Map<String, String>> scannedPallets;

  const SecurityAddPalletsSection({
    Key? key,
    required this.challanId,
    required this.returnId,
    required this.scannedPallets,
  }) : super(key: key);

  @override
  _SecurityAddPalletsSectionState createState() =>
      _SecurityAddPalletsSectionState();
}

class _SecurityAddPalletsSectionState extends State<SecurityAddPalletsSection> {
  late final PalletReturnController palletReturnController;
  final TextEditingController palletIdController = TextEditingController();
  String selectedReturnStatus = 'Returned';
  String selectedConditionStatus = 'OK';

  @override
  void initState() {
    super.initState();
    palletReturnController =
        Get.find<PalletReturnController>(tag: widget.returnId);
  }

  @override
  Widget build(BuildContext context) {
    // Add check at the start of build
    if (palletReturnController.scannedPallets.length >=
        palletReturnController.totalPallets.value) {
      // Return to previous screen if max pallets reached
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
        Get.snackbar(
          'Maximum Pallets Reached',
          'Cannot add more pallets than specified limit',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Pallets'), // Updated title
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: palletIdController,
              decoration: InputDecoration(
                labelText: 'Enter Pallet ID',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: Text(
                  "OR",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            // Add a Scan Pallet button above the text field:
            ElevatedButton.icon(
              onPressed: () async {
                String? scannedCode = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecurityReturnScannerScreen(
                      challanId: widget.challanId,
                      returnId: widget.returnId,
                      scannedPallets: widget.scannedPallets,
                    ),
                  ),
                );
                if (scannedCode != null) {
                  setState(() {
                    palletIdController.text = scannedCode;
                  });
                }
              },
              icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
              label: const Text(
                "SCAN PALLET",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 20),
            // Existing options for return and condition
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedReturnStatus,
                      decoration:
                          const InputDecoration(labelText: 'Return Status'),
                      items: ['Returned', 'Not Returned']
                          .map((item) =>
                              DropdownMenuItem(value: item, child: Text(item)))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedReturnStatus = value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedConditionStatus,
                      decoration:
                          const InputDecoration(labelText: 'Condition Status'),
                      items: ['OK', 'Repair', 'Scrap']
                          .map((item) =>
                              DropdownMenuItem(value: item, child: Text(item)))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedConditionStatus = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (palletIdController.text.trim().isEmpty) {
                  Flushbar(
                    message: 'Please enter a Pallet ID',
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                    flushbarPosition: FlushbarPosition.TOP,
                  ).show(context);
                  return;
                }

                // Add pallet directly to controller
                palletReturnController.addScannedPallet({
                  'code': palletIdController.text.trim(),
                  'returnStatus': selectedReturnStatus,
                  'conditionStatus': selectedConditionStatus,
                });

                // Navigate to PalletReturnScreen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecurityPalletReturnScreen(
                      returnId: widget.returnId,
                      challanId: widget.challanId,
                      scannedPallets: palletReturnController.scannedPallets,
                      returnStatus: selectedReturnStatus,
                      conditionStatus: selectedConditionStatus,
                      lastScannedResult: null,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                "CONFIRM ENTRY",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    palletIdController.dispose();
    super.dispose();
  }
}

class PalletReturnController extends GetxController {
  final RxList<Map<String, String>> scannedPallets =
      <Map<String, String>>[].obs;
  final RxInt totalPallets = 0.obs;
  final RxString vehicleNumber = ''.obs;
  final RxBool isNavigating = false.obs;
  final RxBool needsUpdate = false.obs; // Add this field for tracking updates

  int get returnedCount =>
      scannedPallets.where((p) => p['returnStatus'] == 'Returned').length;

  int get notReturnedCount =>
      scannedPallets.where((p) => p['returnStatus'] == 'Not Returned').length;

  void initialize(List<Map<String, String>> initialPallets) {
    scannedPallets.value = List.from(initialPallets);
  }

  void setTotalPallets(int count) {
    totalPallets.value = count;
  }

  void setVehicleNumber(String number) {
    vehicleNumber.value = number;
  }

  void addScannedPallet(Map<String, String> pallet) {
    // Check for duplicate pallet ID
    if (scannedPallets.any((p) => p['code'] == pallet['code'])) {
      Get.snackbar(
        'Duplicate Entry',
        'Pallet ID ${pallet['code']} already exists.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    scannedPallets.add(pallet);
    needsUpdate.value = true; // Mark as needing an update
  }

  void removePallet(int index) {
    scannedPallets.removeAt(index);
    needsUpdate.value = true; // Mark as needing an update
  }

  void updateState() {
    needsUpdate.value = false; // Reset the update flag
    scannedPallets.refresh(); // Refresh the list to trigger UI updates
  }

  String generateReceiptData() {
    final DateTime now = DateTime.now();
    final String timestamp =
        "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    final authController = Get.find<AuthController>();
    final guardName = authController.firstName.isNotEmpty
        ? authController.firstName
        : 'Not Specified';

    return """
PALLET RETURN RECEIPT
-------------------
Date & Time: $timestamp
Vehicle Number: ${vehicleNumber.value}
Security Guard: $guardName

PALLET SUMMARY
-------------
Total Pallets: ${totalPallets.value}
Returned: $returnedCount
Not Returned: $notReturnedCount

Signature: _____________
""";
  }
}
