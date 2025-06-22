import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manuscan/home_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/scheduler.dart';
import 'package:manuscan/controllers/pallet_return_controller.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/services.dart'; // Added for FilteringTextInputFormatter
import 'package:manuscan/services/defect_detection_service.dart'; // Added for defect detection

// Updated showChallanIdPopup:
void showChallanIdPopup(BuildContext context) {
  TextEditingController challanIdController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();

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
              // Vehicle Number Field
              TextField(
                controller: vehicleNumberController,
                decoration: InputDecoration(
                  labelText: 'Vehicle Number',
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
              // Number of Pallets Field
              TextField(
                controller: challanIdController,
                decoration: InputDecoration(
                  labelText: 'Number of Pallets',
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
                  if (challanIdController.text.trim().isEmpty ||
                      vehicleNumberController.text.trim().isEmpty) {
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
                    controller.setTotalPallets(
                        int.parse(challanIdController.text.trim()));
                    controller
                        .setVehicleNumber(vehicleNumberController.text.trim());

                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddPalletsSection(
                          returnId: returnId,
                          challanId: challanIdController.text
                              .trim(), // Use challanId directly
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
  final ImagePicker _imagePicker = ImagePicker();

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
    TextEditingController modelPalletController = TextEditingController();
    TextEditingController palletSrController = TextEditingController();
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
                    const Text("Enter Pallet Details",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    // MODEL PALLET field - characters only
                    TextField(
                      controller: modelPalletController,
                      decoration: InputDecoration(
                          labelText: 'MODEL PALLET',
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
                    // PALLET SR field - numbers only
                    TextField(
                      controller: palletSrController,
                      decoration: InputDecoration(
                          labelText: 'PALLET SR',
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    // Return Status dropdown
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Return Status:',
                            style: TextStyle(fontSize: 16)),
                        DropdownButton<String>(
                          value: selectedReturnStatus,
                          items: ['Returned', 'Not Returned']
                              .map((item) => DropdownMenuItem(
                                  value: item, child: Text(item)))
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
                    // Condition Status dropdown
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Condition:',
                            style: TextStyle(fontSize: 16)),
                        DropdownButton<String>(
                          value: selectedConditionStatus,
                          items: ['OK', 'Scrap', 'Repair']
                              .map((item) => DropdownMenuItem(
                                  value: item, child: Text(item)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedConditionStatus = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (modelPalletController.text.trim().isEmpty ||
                            palletSrController.text.trim().isEmpty) {
                          Flushbar(
                            message:
                                'Please enter both MODEL PALLET and PALLET SR',
                            backgroundColor: Colors.red,
                            margin: const EdgeInsets.all(10),
                            borderRadius: BorderRadius.circular(8),
                            duration: const Duration(seconds: 3),
                            flushbarPosition: FlushbarPosition.TOP,
                          ).show(context);
                          return;
                        }

                        String combinedCode =
                            '${modelPalletController.text.trim()} - ${palletSrController.text.trim()}';

                        // Add pallet to controller
                        palletReturnController.addScannedPallet({
                          'code': combinedCode,
                          'returnStatus': selectedReturnStatus,
                          'conditionStatus': selectedConditionStatus,
                        });

                        Navigator.pop(context); // Close dialog
                        // Navigate to PalletReturnScreen instead of going back
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PalletReturnScreen(
                              returnId: widget.returnId,
                              challanId: widget.challanId,
                              scannedPallets:
                                  palletReturnController.scannedPallets,
                              returnStatus: selectedReturnStatus,
                              conditionStatus: selectedConditionStatus,
                              lastScannedResult: {
                                'code': combinedCode,
                                'returnStatus': selectedReturnStatus,
                                'conditionStatus': selectedConditionStatus,
                              },
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12)),
                      child: const Text("CONFIRM",
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
    return WillPopScope(
      onWillPop: () async {
        // Navigate back to the previous screen instead of home
        Navigator.pop(context);
        return false; // Prevent default back behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Scan Pallet QR'),
          backgroundColor: Colors.teal,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPalletsSection(
                    challanId: widget.challanId,
                    returnId: widget.returnId,
                    scannedPallets: widget.scannedPallets,
                  ),
                ),
              );
            },
          ),
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
                        // Navigate to PalletReturnScreen instead of just going back
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PalletReturnScreen(
                              returnId: widget.returnId,
                              challanId: widget.challanId,
                              scannedPallets:
                                  palletReturnController.scannedPallets,
                              returnStatus: result['returnStatus']!,
                              conditionStatus: result['conditionStatus']!,
                              lastScannedResult: result,
                            ),
                          ),
                        );
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
                    final XFile? image = await _imagePicker.pickImage(
                        source: ImageSource.gallery);
                    if (image != null) {
                      try {
                        final BarcodeCapture? capture =
                            await controller.analyzeImage(image.path);
                        if (capture != null &&
                            capture.barcodes.isNotEmpty &&
                            capture.barcodes[0].rawValue != null) {
                          final code = capture.barcodes[0].rawValue!;
                          if (palletReturnController.isNavigating.value) return;
                          palletReturnController.isNavigating.value = true;

                          await controller.stop();
                          final Map<String, String>? result =
                              await _showCombinedStatusDialog(code);
                          if (result != null) {
                            palletReturnController.addScannedPallet(result);
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              log('Pallet added.');
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PalletReturnScreen(
                                    returnId: widget.returnId,
                                    challanId: widget.challanId,
                                    scannedPallets:
                                        palletReturnController.scannedPallets,
                                    returnStatus: result['returnStatus']!,
                                    conditionStatus: result['conditionStatus']!,
                                    lastScannedResult: result,
                                  ),
                                ),
                              );
                              palletReturnController.isNavigating.value = false;
                            });
                          } else {
                            await controller.start();
                            palletReturnController.isNavigating.value = false;
                          }
                        } else {
                          // Show error if no QR code found in image
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'No QR code found in the selected image'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      } catch (e) {
                        // Show error if image analysis fails
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Error analyzing image: ${e.toString()}'),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    }
                  }),
                  // Add defect detection camera button
                  _buildIconButton(Icons.camera_alt, Colors.white, () async {
                    await _runDefectDetectionScript();
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildActionButton('Back', Colors.teal, () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddPalletsSection(
                              challanId: widget.challanId,
                              returnId: widget.returnId,
                              scannedPallets: widget.scannedPallets,
                            ),
                          ),
                        );
                      }),
                      _buildActionButton(
                        'View Pallets',
                        Colors.teal,
                        () => Get.to(() => PalletReturnScreen(
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
                  const SizedBox(height: 10),
                  // Manual entry button removed - functionality moved to AddPalletsSection
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Add method to run defect detection script
  Future<void> _runDefectDetectionScript() async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Defect Detection'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Running defect detection script...'),
                SizedBox(height: 8),
                Text('This may take a few moments.',
                    style: TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      );

      // Check if service is available
      bool isAvailable = await DefectDetectionService.isServiceAvailable();
      if (!isAvailable) {
        Navigator.pop(context); // Close loading dialog
        _showServiceUnavailableDialog();
        return;
      }

      // Run the defect detection script
      DefectScriptResult result =
          await DefectDetectionService.runDefectDetectionScript();

      // Close loading dialog
      Navigator.pop(context);

      // Show results
      _showDefectDetectionScriptResults(result);
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);

      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Error running defect detection script: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Add method to show service unavailable dialog
  void _showServiceUnavailableDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Service Unavailable'),
          content: const Text(
            'The defect detection service is currently unavailable. '
            'Please ensure the FastAPI server is running on localhost:8000.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Add method to show defect detection results
  void _showDefectDetectionScriptResults(DefectScriptResult result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            result.success
                ? 'Defect Detection Complete'
                : 'Defect Detection Failed',
            style: TextStyle(
              color: result.success ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Status indicator
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: result.success
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: result.success ? Colors.green : Colors.red,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        result.success ? Icons.check_circle : Icons.error,
                        color: result.success ? Colors.green : Colors.red,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          result.success
                              ? 'SCRIPT EXECUTION SUCCESSFUL'
                              : 'SCRIPT EXECUTION FAILED',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: result.success ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Script output
                const Text(
                  'Script Output:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    result.output,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Timestamp
                Text(
                  'Executed at: ${DateTime.fromMillisecondsSinceEpoch((result.timestamp * 1000).toInt()).toString()}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
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

  // Function to parse QR string and extract MODEL PALLET and PALLET SR
  Map<String, String> parseQRString(String qrString) {
    String modelPallet = '';
    String palletSr = '';

    // Split the string by lines
    List<String> lines = qrString.split('\n');

    for (String line in lines) {
      line = line.trim();

      // Extract MODEL PALLET
      if (line.startsWith('MODEL PALLET -')) {
        modelPallet = line.replaceFirst('MODEL PALLET -', '').trim();
      }

      // Extract PALLET SR NO
      if (line.startsWith('PALLET SR NO.-')) {
        palletSr = line.replaceFirst('PALLET SR NO.-', '').trim();
      }
    }

    return {
      'modelPallet': modelPallet,
      'palletSr': palletSr,
      'originalCode': qrString,
    };
  }

  Future<Map<String, String>?> _showCombinedStatusDialog(String code) async {
    String selectedReturnStatus = 'Returned';
    String selectedConditionStatus = 'OK';

    // Parse the QR string to extract fields
    Map<String, String> parsedData = parseQRString(code);

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MODEL PALLET: ${parsedData['modelPallet']}'),
                const SizedBox(height: 8),
                Text('PALLET SR: ${parsedData['palletSr']}'),
                const SizedBox(height: 12),
                const Text('Original QR Code:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(parsedData['originalCode']!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
                  'code': parsedData['modelPallet']!.isNotEmpty &&
                          parsedData['palletSr']!.isNotEmpty
                      ? '${parsedData['modelPallet']} - ${parsedData['palletSr']}'
                      : code, // Use original if parsing failed
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

class PalletRScreen extends StatelessWidget {
  final String returnId;
  final String challanId;
  final List<Map<String, String>> scannedPallets;

  const PalletRScreen({
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
    return PalletReturnScreen(
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
class PalletReturnScreen extends StatefulWidget {
  final String returnId;
  final String challanId;
  final List<Map<String, String>> scannedPallets;
  final String returnStatus;
  final String conditionStatus;
  final Map<String, String>? lastScannedResult; // New field for the latest scan

  const PalletReturnScreen({
    super.key,
    required this.returnId,
    required this.challanId,
    required this.scannedPallets,
    required this.returnStatus,
    required this.conditionStatus,
    this.lastScannedResult,
  });

  @override
  __PalletReturnScreenState createState() => __PalletReturnScreenState();
}

class __PalletReturnScreenState extends State<PalletReturnScreen> {
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AddPalletsSection(
              challanId: widget.challanId,
              returnId: widget.returnId,
              scannedPallets: palletReturnController.scannedPallets,
            ),
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pallet Return'),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPalletsSection(
                    challanId: widget.challanId,
                    returnId: widget.returnId,
                    scannedPallets: palletReturnController.scannedPallets,
                  ),
                ),
              );
            },
          ),
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
                        // Last Scanned info removed - no longer showing
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
                                        pallet['returnStatus'] ??
                                            'Not Returned';
                                    final conditionStatus =
                                        pallet['conditionStatus'] ?? 'OK';
                                    final isReturned =
                                        returnStatus == 'Returned';

                                    // Parse the code to extract MODEL PALLET and PALLET SR
                                    String modelPallet = '';
                                    String palletSr = '';
                                    if (code.contains(' - ')) {
                                      final parts = code.split(' - ');
                                      modelPallet = parts[0];
                                      palletSr =
                                          parts.length > 1 ? parts[1] : 'N/A';
                                    } else {
                                      modelPallet = code;
                                      palletSr = 'N/A';
                                    }

                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade300),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "MODEL PALLET:",
                                                  style: TextStyle(
                                                    fontFamily: "DMSans",
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                Text(
                                                  modelPallet,
                                                  style: const TextStyle(
                                                    fontFamily: "DMSans",
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                const Text(
                                                  "PALLET SR:",
                                                  style: TextStyle(
                                                    fontFamily: "DMSans",
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                Text(
                                                  palletSr,
                                                  style: const TextStyle(
                                                    fontFamily: "DMSans",
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
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
                                                          : conditionStatus ==
                                                                  'Repair'
                                                              ? Colors.orange
                                                              : Colors.green,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () =>
                                                    showDeletePalletPopup(
                                                  context,
                                                  () => palletReturnController
                                                      .removePallet(index),
                                                ),
                                                child: const Icon(Icons.delete,
                                                    color: Colors.black54),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Obx(() => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Expected: ${palletReturnController.totalPallets}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'Returned: ${palletReturnController.returnedCount}',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.blue),
                                  ),
                                  Text(
                                    'Not Returned: ${palletReturnController.notReturnedCount}',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.red),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Obx(() => Center(
                    child: Text(
                        "Total : ${palletReturnController.scannedPallets.length}",
                        style: const TextStyle(
                            fontFamily: "DMSans",
                            fontSize: 18,
                            fontWeight: FontWeight.bold)))),
                const SizedBox(height: 10),
                // Replace the existing buttons section with this new Row
                Row(
                  children: [
                    Expanded(
                      child: Obx(() {
                        bool isDisabled =
                            palletReturnController.scannedPallets.length >=
                                palletReturnController.totalPallets.value;
                        return ElevatedButton.icon(
                          onPressed: isDisabled
                              ? null
                              : () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddPalletsSection(
                                        challanId: widget.challanId,
                                        returnId: widget.returnId,
                                        scannedPallets: widget.scannedPallets,
                                      ),
                                    ),
                                  );
                                },
                          icon: Icon(Icons.add_circle,
                              color: isDisabled ? Colors.grey : Colors.white),
                          label: Text(
                            "ADD PALLET",
                            style: TextStyle(
                                color: isDisabled ? Colors.grey : Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isDisabled ? Colors.grey.shade300 : Colors.teal,
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
                          backgroundColor:
                              const Color.fromRGBO(216, 219, 226, 1),
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
                    Get.offAll(() => HomeScreen());
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
                  child: const Text("SAVE & EXIT"),
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
}

class AddPalletsSection extends StatefulWidget {
  final String challanId;
  final String returnId;
  final List<Map<String, String>> scannedPallets;

  const AddPalletsSection({
    Key? key,
    required this.challanId,
    required this.returnId,
    required this.scannedPallets,
  }) : super(key: key);

  @override
  _AddPalletsSectionState createState() => _AddPalletsSectionState();
}

class _AddPalletsSectionState extends State<AddPalletsSection> {
  late final PalletReturnController palletReturnController;
  final TextEditingController modelPalletController = TextEditingController();
  final TextEditingController palletSrController = TextEditingController();
  String selectedReturnStatus = 'Returned';
  String selectedConditionStatus = 'OK';
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    palletReturnController =
        Get.find<PalletReturnController>(tag: widget.returnId);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate back to the previous screen instead of home
        Navigator.pop(context);
        return false; // Prevent default back behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Pallets'), // Updated title
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // MODEL PALLET field - characters only
              TextField(
                controller: modelPalletController,
                decoration: InputDecoration(
                  labelText: 'MODEL PALLET',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // PALLET SR field - numbers only
              TextField(
                controller: palletSrController,
                decoration: InputDecoration(
                  labelText: 'PALLET SR',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        String? scannedCode = await Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomReturnScannerScreen(
                              challanId: widget.challanId,
                              returnId: widget.returnId,
                              scannedPallets: widget.scannedPallets,
                            ),
                          ),
                        );
                        if (scannedCode != null) {
                          // Handle the scanned code if needed
                          // The scanner will handle adding to controller
                        }
                      },
                      icon: const Icon(Icons.qr_code_scanner,
                          color: Colors.white),
                      label: const Text(
                        "SCAN PALLET",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await _runDefectDetectionScript();
                      },
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      label: const Text(
                        "DEFECT DETECTION",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
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
                            .map((item) => DropdownMenuItem(
                                value: item, child: Text(item)))
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
                        decoration: const InputDecoration(
                            labelText: 'Condition Status'),
                        items: ['OK', 'Repair', 'Scrap']
                            .map((item) => DropdownMenuItem(
                                value: item, child: Text(item)))
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
                  if (modelPalletController.text.trim().isEmpty ||
                      palletSrController.text.trim().isEmpty) {
                    Flushbar(
                      message: 'Please enter both MODEL PALLET and PALLET SR',
                      backgroundColor: Colors.red,
                      margin: const EdgeInsets.all(10),
                      borderRadius: BorderRadius.circular(8),
                      duration: const Duration(seconds: 3),
                      flushbarPosition: FlushbarPosition.TOP,
                    ).show(context);
                    return;
                  }

                  String combinedCode =
                      '${modelPalletController.text.trim()} - ${palletSrController.text.trim()}';

                  // Add pallet to controller
                  palletReturnController.addScannedPallet({
                    'code': combinedCode,
                    'returnStatus': selectedReturnStatus,
                    'conditionStatus': selectedConditionStatus,
                  });

                  // Navigate to PalletReturnScreen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PalletReturnScreen(
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
      ),
    );
  }

  // Add method to run defect detection script
  Future<void> _runDefectDetectionScript() async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Defect Detection'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Running defect detection script...'),
                SizedBox(height: 8),
                Text('This may take a few moments.',
                    style: TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      );

      // Check if service is available
      bool isAvailable = await DefectDetectionService.isServiceAvailable();
      if (!isAvailable) {
        Navigator.pop(context); // Close loading dialog
        _showServiceUnavailableDialog();
        return;
      }

      // Run the defect detection script
      DefectScriptResult result =
          await DefectDetectionService.runDefectDetectionScript();

      // Close loading dialog
      Navigator.pop(context);

      // Show results
      _showDefectDetectionScriptResults(result);
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);

      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Error running defect detection script: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Add method to show service unavailable dialog
  void _showServiceUnavailableDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Service Unavailable'),
          content: const Text(
            'The defect detection service is currently unavailable. '
            'Please ensure the FastAPI server is running on localhost:8000.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Add method to show defect detection results
  void _showDefectDetectionScriptResults(DefectScriptResult result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            result.success
                ? 'Defect Detection Complete'
                : 'Defect Detection Failed',
            style: TextStyle(
              color: result.success ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Status indicator
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: result.success
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: result.success ? Colors.green : Colors.red,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        result.success ? Icons.check_circle : Icons.error,
                        color: result.success ? Colors.green : Colors.red,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          result.success
                              ? 'SCRIPT EXECUTION SUCCESSFUL'
                              : 'SCRIPT EXECUTION FAILED',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: result.success ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Script output
                const Text(
                  'Script Output:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    result.output,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Timestamp
                Text(
                  'Executed at: ${DateTime.fromMillisecondsSinceEpoch((result.timestamp * 1000).toInt()).toString()}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    modelPalletController.dispose();
    palletSrController.dispose();
    super.dispose();
  }
}
