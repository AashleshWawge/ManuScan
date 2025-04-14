import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manuscan/home_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/scheduler.dart';
import 'package:manuscan/controllers/pallet_return_controller1.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class PalletReturn2 extends StatefulWidget {
  final String challanId;
  final List<Map<String, String>> scannedPallets;

  const PalletReturn2(
      {super.key, required this.challanId, required this.scannedPallets});

  @override
  _PalletReturn2State createState() => _PalletReturn2State();
}

class _PalletReturn2State extends State<PalletReturn2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Pallet Return",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Challan ID
            Text(
              "Challan ID : ${widget.challanId}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Vendor Information Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  // Vendor Details
                  Text("Vendor 202758",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(
                      "John Deere India Pvt Ltd\nGat no. 166-167 and 271-291 Sanaswadi\nPune-412208"),
                  Text("GSTIN No. : "),
                  Text("PAN No. : AAACJ4233B"),
                  Divider(),

                  // Challan Details
                  Text("Challan No. : 4348402774"),
                  Text("Challan Date : 03/01/2025"),
                  Text("Vehicle No. : "),
                  Text("Transporter : "),
                  Text("EMP Code : 1253822"),
                  Text("Name : Mr. KADAM MAYUR ASHOK"),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Material Details Container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Material Code: ABCD123456789",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Material Description: PALLET 5E/5B/5R AXLE"),
                  Text("HSN Code: 12345678"),
                  Text("Unit: EA"),
                  Text("Pallet Qty: 10.00"),
                  Text("Axle Qty: 2"),
                  Text("Expected Return Date: 02/07/2025"),
                ],
              ),
            ),

            const Spacer(),

            // Scan Pallet Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PalletReturn3(
                        challanId: widget.challanId,
                        scannedPallets: widget.scannedPallets,
                        returnId: '',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.list, color: Colors.white),
                label: const Text("VIEW PALLET LIST",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class PalletReturn3 extends StatefulWidget {
  final String challanId;
  final List<Map<String, String>> scannedPallets;
  final String returnId;

  const PalletReturn3({
    super.key,
    required this.challanId,
    required this.scannedPallets,
    required this.returnId,
  });

  @override
  _PalletReturn3 createState() => _PalletReturn3();
}

class _PalletReturn3 extends State<PalletReturn3> {
  late final PalletReturnController palletReturnController;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<PalletReturnController>(tag: widget.returnId)) {
      palletReturnController =
          Get.put(PalletReturnController(), tag: widget.returnId);
      palletReturnController.initialize(widget.scannedPallets);
    } else {
      palletReturnController =
          Get.find<PalletReturnController>(tag: widget.returnId);
    }
  }

  String selectedReturnStatus = 'Returned';
  String selectedConditionStatus = 'OK';
  int _currentPage = 0;
  final int _itemsPerPage = 5;
  List<Map<String, String>> pallets = List.generate(
    10,
    (index) => {
      "srNo": "${index + 1}",
      "palletId": "PALLET ID : 1234567",
      "axleQty": "2",
    },
  );

  void showManualPalletIdPopup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManualEntryPage(
          challanId: widget.challanId,
          returnId: widget.returnId,
          scannedPallets: widget.scannedPallets,
        ),
      ),
    ).then((result) {
      if (result != null) {
        setState(() {
          palletReturnController.addScannedPallet(result);
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PalletReturn4Screen(
              challanId: widget.challanId,
              scannedPallets: palletReturnController.scannedPallets,
              returnStatus: result['returnStatus'],
              conditionStatus: result['conditionStatus'],
              returnId: widget.returnId,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (pallets.length / _itemsPerPage).ceil();
    List<Map<String, String>> paginatedPallets =
        pallets.skip(_currentPage * _itemsPerPage).take(_itemsPerPage).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pallet Return",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pallet List",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text("Sr. No.",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          Text("Pallet ID",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          Text("Axle Qty.",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: paginatedPallets.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(paginatedPallets[index]["srNo"]!),
                                Text(paginatedPallets[index]["palletId"]!),
                                Text(paginatedPallets[index]["axleQty"]!),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentPage = (_currentPage - 1 + totalPages) %
                                    totalPages;
                              });
                            },
                            child: const Icon(Icons.arrow_back),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentPage = 0;
                              });
                            },
                            child: Text(
                                "Page  ${_currentPage + 1} of $totalPages "),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentPage = (_currentPage + 1) % totalPages;
                              });
                            },
                            child: const Icon(Icons.arrow_forward),
                          ),
                          Text(
                            "Showing ${paginatedPallets.length} of ${pallets.length}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Buttons in a row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    String? scannedCode = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomReturnScannerScreen(
                          challanId: widget.challanId,
                          scannedPallets: widget.scannedPallets,
                          returnId: '',
                        ),
                      ),
                    );
                    if (scannedCode != null &&
                        !widget.scannedPallets
                            .contains({"palletId": scannedCode})) {
                      setState(() {
                        widget.scannedPallets.add({"palletId": scannedCode});
                      });
                    }
                  },
                  icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                  label: const Text(
                    "SCAN PALLET",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showManualPalletIdPopup(context);
                  },
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text(
                    "MANUAL ENTRY\nOF PALLET ID",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
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
    final mlModel = MLModel();
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
                    if (capturedImagePath != null) ...[
                      const SizedBox(height: 15),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(capturedImagePath!),
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (predictionResult != null) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Prediction: ${predictionResult!['label']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Confidence: ${(predictionResult!['confidence'] * 100).toStringAsFixed(1)}%",
                              ),
                              Text(
                                "Status: ${predictionResult!['status']}",
                                style: TextStyle(
                                  color: predictionResult!['status'] == 'OK'
                                      ? Colors.green
                                      : predictionResult!['status'] == 'Repair'
                                          ? Colors.orange
                                          : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          final prediction =
                              await mlModel.predictCondition(image.path);
                          setState(() {
                            capturedImagePath = image.path;
                            predictionResult = prediction;
                            selectedConditionStatus =
                                prediction['status'] as String;
                          });
                        }
                      },
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      label: const Text("CAPTURE IMAGE"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Return Status:"),
                        DropdownButton<String>(
                          value: selectedReturnStatus,
                          items: ['Returned', 'Not Returned']
                              .map((item) => DropdownMenuItem(
                                  value: item, child: Text(item)))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedReturnStatus = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Condition:"),
                        DropdownButton<String>(
                          value: selectedConditionStatus,
                          items: ['OK', 'Scrap', 'Repair']
                              .map((item) => DropdownMenuItem(
                                  value: item, child: Text(item)))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedConditionStatus = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
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
                            builder: (context) => PalletReturn4Screen(
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
                  () => Get.to(() => PalletReturn4Screen(
                        returnId: widget.returnId,
                        challanId: widget.challanId,
                        lastScannedResult: null,
                        returnStatus: '',
                        scannedPallets: [],
                        conditionStatus: '', // No new scan when viewing
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
    return PalletReturn4Screen(
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
class PalletReturn4Screen extends StatefulWidget {
  final String returnId;
  final String challanId;
  final List<Map<String, String>> scannedPallets;
  final String returnStatus;
  final String conditionStatus;
  final Map<String, String>? lastScannedResult; // New field for the latest scan

  const PalletReturn4Screen({
    super.key,
    required this.returnId,
    required this.challanId,
    required this.scannedPallets,
    required this.returnStatus,
    required this.conditionStatus,
    this.lastScannedResult,
  });

  @override
  __PalletReturn4ScreenState createState() => __PalletReturn4ScreenState();
}

class __PalletReturn4ScreenState extends State<PalletReturn4Screen> {
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
                    style: TextStyle(color: Colors.grey),
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

class MLModel {
  Interpreter? _interpreter;
  List<String> _labels = [];
  final int inputSize = 640;
  final int numChannels = 3;
  bool _isInitialized = false;

  MLModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _loadModel();
      await _loadLabels();
      _isInitialized = true;
    } catch (e) {
      debugPrint('Failed to initialize ML model: $e');
      _isInitialized = false;
    }
  }

  Future<void> _loadModel() async {
    try {
      debugPrint('Loading model...');
      final options = InterpreterOptions()..threads = 2;
      _interpreter = await Interpreter.fromAsset(
        'assets/models/model.tflite',
        options: options,
      );
      debugPrint('Model loaded successfully.');
    } catch (e) {
      debugPrint('Error loading model: $e');
      rethrow;
    }
  }

  Future<void> _loadLabels() async {
    try {
      final labelsData =
          await rootBundle.loadString('assets/models/labels.txt');
      _labels = labelsData
          .split('\n')
          .map((label) => label.trim())
          .where((label) => label.isNotEmpty)
          .toList();
      debugPrint('Labels loaded: $_labels');
    } catch (e) {
      debugPrint('Error loading labels: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> predictCondition(String imagePath) async {
    if (!_isInitialized || _interpreter == null) {
      debugPrint('Model not initialized, initializing now...');
      await _initialize();
      if (!_isInitialized || _interpreter == null) {
        return {'label': 'Error', 'confidence': 0.0, 'status': 'OK'};
      }
    }

    try {
      final imageData = File(imagePath).readAsBytesSync();
      final image = img.decodeImage(imageData);
      if (image == null) throw Exception('Failed to decode image');

      // Process image
      final processedImage = _preprocessImage(image);

      // Prepare input tensor with shape [1, 640, 640, 3]
      final input = Float32List(1 * inputSize * inputSize * numChannels);
      input.setAll(0, processedImage);

      // Prepare output tensor with shape [1, 84, 8400]
      final outputBuffer = Float32List(1 * 84 * 8400);

      try {
        // Run inference
        _interpreter!.run(input.reshape([1, inputSize, inputSize, numChannels]),
            outputBuffer.reshape([1, 84, 8400]));

        // Process results
        final results = _processResults(outputBuffer);
        debugPrint('Prediction results: $results');
        return results;
      } catch (e) {
        debugPrint('Inference error: $e');
        return {'label': 'Error', 'confidence': 0.0, 'status': 'OK'};
      }
    } catch (e) {
      debugPrint('Error during prediction: $e');
      return {'label': 'Error', 'confidence': 0.0, 'status': 'OK'};
    }
  }

  // Preprocess the image to resize and normalize pixel values
  List<double> _preprocessImage(img.Image image) {
    final resizedImage =
        img.copyResize(image, width: inputSize, height: inputSize);
    final normalizedImage = resizedImage.data
        .map((pixel) {
          final r = (pixel >> 16) & 0xFF;
          final g = (pixel >> 8) & 0xFF;
          final b = pixel & 0xFF;
          return [r / 255.0, g / 255.0, b / 255.0];
        })
        .expand((rgb) => rgb)
        .toList();
    return normalizedImage;
  }

  // Process the output buffer to extract meaningful results
  Map<String, dynamic> _processResults(Float32List outputBuffer) {
    try {
      // Process YOLO output with shape [1, 84, 8400]
      var maxConfidence = 0.0;
      var bestClass = 0;

      // For each detection (8400)
      for (var i = 0; i < 8400; i++) {
        // Skip box coordinates (first 4 values)
        final startIdx = i * 84 + 4;
        // Process class probabilities (remaining 80 values)
        for (var j = 0; j < 80; j++) {
          final confidence = outputBuffer[startIdx + j];
          if (confidence > maxConfidence) {
            maxConfidence = confidence;
            bestClass = j;
          }
        }
      }

      final label = bestClass < _labels.length ? _labels[bestClass] : 'Unknown';

      // Map the label to a status
      String status;
      if (maxConfidence < 0.5) {
        status = 'OK'; // Default if confidence is low
      } else {
        status = _mapLabelToStatus(label);
      }

      return {'label': label, 'confidence': maxConfidence, 'status': status};
    } catch (e) {
      debugPrint('Error processing results: $e');
      return {'label': 'Unknown', 'confidence': 0.0, 'status': 'OK'};
    }
  }

  String _mapLabelToStatus(String label) {
    switch (label) {
      case 'OK':
        return 'OK';
      case 'Repair':
        return 'Repair';
      case 'Scrap':
        return 'Scrap';
      default:
        return 'Unknown';
    }
  }
}

void showChallanIdPopup(BuildContext context) {
  TextEditingController challanIdController = TextEditingController();
  final picker = ImagePicker();
  final mlModel = MLModel();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Enter Challan ID",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "DMSans",
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: challanIdController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: () async {
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    final result = await mlModel.predictCondition(image.path);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Prediction Result"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Label: ${result['label']}",
                                  style: const TextStyle(fontSize: 16)),
                              Text(
                                  "Confidence: ${(result['confidence'] * 100).toStringAsFixed(2)}%",
                                  style: const TextStyle(fontSize: 16)),
                              Text("Status: ${result['status']}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                label: const Text("CAPTURE IMAGE"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  if (challanIdController.text.trim().isEmpty) {
                    Flushbar(
                      message: 'Please enter a Challan ID',
                      backgroundColor: Colors.red,
                      margin: const EdgeInsets.all(10),
                      borderRadius: BorderRadius.circular(8),
                      duration: const Duration(seconds: 3),
                      flushbarPosition: FlushbarPosition.TOP,
                    ).show(context);
                  } else {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PalletReturn2(
                          challanId: challanIdController.text.trim(),
                          scannedPallets: [],
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
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

class ManualEntryPage extends StatefulWidget {
  final String challanId;
  final String returnId;
  final List<Map<String, String>> scannedPallets;

  const ManualEntryPage({
    Key? key,
    required this.challanId,
    required this.returnId,
    required this.scannedPallets,
  }) : super(key: key);

  @override
  State<ManualEntryPage> createState() => _ManualEntryPageState();
}

class _ManualEntryPageState extends State<ManualEntryPage> {
  final TextEditingController palletIdController = TextEditingController();
  String selectedReturnStatus = 'Returned';
  String selectedConditionStatus = 'OK';
  final picker = ImagePicker();
  final mlModel = MLModel();
  String? capturedImagePath;
  Map<String, dynamic>? predictionResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual Pallet Entry'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            const SizedBox(height: 20),
            if (capturedImagePath != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(capturedImagePath!),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (predictionResult != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      "Prediction: ${predictionResult!['label']}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Confidence: ${(predictionResult!['confidence'] * 100).toStringAsFixed(1)}%",
                    ),
                    Text(
                      "Status: ${predictionResult!['status']}",
                      style: TextStyle(
                        color: predictionResult!['status'] == 'OK'
                            ? Colors.green
                            : predictionResult!['status'] == 'Repair'
                                ? Colors.orange
                                : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: captureAndPredict,
              icon: const Icon(Icons.camera_alt),
              label: const Text("CAPTURE IMAGE"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
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

                Navigator.pop(context, {
                  'code': palletIdController.text.trim(),
                  'returnStatus': selectedReturnStatus,
                  'conditionStatus': selectedConditionStatus,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("CONFIRM ENTRY"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> captureAndPredict() async {
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          capturedImagePath = image.path;
          predictionResult = null; // Clear previous result while processing
        });

        final prediction = await mlModel.predictCondition(image.path);
        setState(() {
          predictionResult = prediction;
          if (prediction['status'] != 'Error') {
            selectedConditionStatus = prediction['status'] as String;
          }
        });
      }
    } catch (e) {
      debugPrint('Error capturing image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to process image')));
      }
    }
  }

  @override
  void dispose() {
    palletIdController.dispose();
    super.dispose();
  }
}
