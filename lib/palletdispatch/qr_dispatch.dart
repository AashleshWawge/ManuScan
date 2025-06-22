import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:manuscan/home_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/pallet_dispatch_controller.dart';
import 'package:get/get.dart';

class PalletDispatchScreen2 extends StatefulWidget {
  final String challanId;
  final List<String> scannedPallets;
  final Map<String, dynamic> challanDetails;

  const PalletDispatchScreen2({
    Key? key,
    required this.challanId,
    required this.scannedPallets,
    required this.challanDetails,
  }) : super(key: key);

  @override
  _PalletDispatchScreen2State createState() => _PalletDispatchScreen2State();
}

class _PalletDispatchScreen2State extends State<PalletDispatchScreen2> {
  final PalletDispatchController controller =
      Get.find<PalletDispatchController>(tag: 'palletDispatch');
  bool isLoading = false;
  String error = '';

  @override
  void initState() {
    super.initState();
    controller.setChallanId(widget.challanId);
    if (controller.scannedPallets.isEmpty ||
        controller.scannedPallets.length < widget.scannedPallets.length) {
      controller.scannedPallets.assignAll(widget.scannedPallets);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Pallet Dispatch",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(27, 27, 30, 1),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: const Color.fromRGBO(27, 27, 30, 1),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          color: Colors.white,
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                  ),
                )
              : error.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            error,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Add retry logic if needed
                              setState(() {
                                error = '';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Challan Details",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.teal,
                                          ),
                                        ),
                                        const Divider(height: 24),
                                        _buildDetailRow(
                                            "Vendor Code",
                                            widget.challanDetails['vendor']
                                                ['code']),
                                        _buildDetailRow(
                                            "Vendor Name",
                                            widget.challanDetails['vendor']
                                                ['name']),
                                        _buildDetailRow(
                                            "GSTIN",
                                            widget.challanDetails['vendor']
                                                ['gstin']),
                                        _buildDetailRow(
                                            "PAN",
                                            widget.challanDetails['vendor']
                                                ['pan']),
                                        const Divider(height: 24),
                                        _buildDetailRow(
                                            "Challan No",
                                            widget
                                                .challanDetails['challan_no']),
                                        _buildDetailRow(
                                            "Date",
                                            widget.challanDetails[
                                                'challan_info']['date']),
                                        _buildDetailRow(
                                            "Vehicle",
                                            widget.challanDetails[
                                                'challan_info']['vehicle_no']),
                                        _buildDetailRow(
                                            "Transporter",
                                            widget.challanDetails[
                                                'challan_info']['transporter']),
                                        const Divider(height: 24),
                                        _buildDetailRow(
                                            "Employee Code",
                                            widget.challanDetails['employee']
                                                ['code']),
                                        _buildDetailRow(
                                            "Employee Name",
                                            widget.challanDetails['employee']
                                                ['name']),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Material Details",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.teal,
                                          ),
                                        ),
                                        const Divider(height: 24),
                                        _buildDetailRow(
                                            "Material Code",
                                            widget.challanDetails['material']
                                                ['code']),
                                        _buildDetailRow(
                                            "Description",
                                            widget.challanDetails['material']
                                                ['description']),
                                        _buildDetailRow(
                                            "HSN Code",
                                            widget.challanDetails['material']
                                                ['hsn_code']),
                                        _buildDetailRow(
                                            "Unit",
                                            widget.challanDetails['material']
                                                ['unit']),
                                        _buildDetailRow(
                                            "Pallet Quantity",
                                            widget.challanDetails['material']
                                                ['pallet_count']),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    String? scannedCode =
                                        await Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CustomScannerScreen(
                                          challanId: widget.challanId,
                                          scannedPallets:
                                              controller.scannedPallets,
                                        ),
                                      ),
                                    );
                                    if (scannedCode != null) {
                                      controller.onScanned(scannedCode);
                                    }
                                  },
                                  icon: const Icon(Icons.qr_code_scanner,
                                      color: Colors.white),
                                  label: const Text(
                                    "SCAN PALLET",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
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
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      showManualPalletIdPopup(context),
                                  icon: const Icon(Icons.edit,
                                      color: Colors.white),
                                  label: const Text(
                                    "MANUAL ENTRY\nOF PALLETS",
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
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  void showManualPalletIdPopup(BuildContext context) {
    TextEditingController modelPalletController = TextEditingController();
    TextEditingController palletSrController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Enter Pallet Details",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                    print("Manual entry: $combinedCode");
                    controller.addPallet(combinedCode);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PalletDispatchScreen(
                                challanId: widget.challanId,
                                scannedPallets: controller.scannedPallets)));
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
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? 'N/A',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomScannerScreen extends StatefulWidget {
  final String challanId;
  final List<String> scannedPallets;

  const CustomScannerScreen(
      {super.key, required this.challanId, required this.scannedPallets});

  @override
  _CustomScannerScreenState createState() => _CustomScannerScreenState();
}

class _CustomScannerScreenState extends State<CustomScannerScreen> {
  final PalletDispatchController controller =
      Get.find<PalletDispatchController>(tag: 'palletDispatch');

  @override
  void initState() {
    super.initState();
    controller.setChallanId(widget.challanId);
    // Use Future.microtask to avoid triggering rebuilds during build
    Future.microtask(() {
      if (controller.scannedPallets.isEmpty ||
          controller.scannedPallets.length < widget.scannedPallets.length) {
        controller.scannedPallets.assignAll(widget.scannedPallets);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Always navigate back to PalletDispatchScreen2 instead of stacking
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PalletDispatchScreen2(
              challanId: widget.challanId,
              scannedPallets: controller.scannedPallets,
              challanDetails: {
                'vendor': {
                  'code': 'VENDOR001',
                  'name': 'Default Vendor',
                  'gstin': 'GSTIN123456789',
                  'pan': 'PAN123456789',
                },
                'challan_no': widget.challanId,
                'challan_info': {
                  'date': '2024-01-01',
                  'vehicle_no': 'DL01AB1234',
                  'transporter': 'Default Transporter',
                },
                'employee': {
                  'code': 'EMP001',
                  'name': 'Default Employee',
                },
                'material': {
                  'code': 'MAT001',
                  'description': 'Default Material',
                  'hsn_code': 'HSN001',
                  'pallet_count': '10',
                  'unit': 'PCS',
                  'axle_qty': '5',
                  'expected_return_date': '2024-02-01',
                },
              },
            ),
          ),
        );
        return false; // Prevent default back behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Scan Pallet QR'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Custom back navigation to PalletDispatchScreen2
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PalletDispatchScreen2(
                    challanId: widget.challanId,
                    scannedPallets: controller.scannedPallets,
                    challanDetails: {
                      'vendor': {
                        'code': 'VENDOR001',
                        'name': 'Default Vendor',
                        'gstin': 'GSTIN123456789',
                        'pan': 'PAN123456789',
                      },
                      'challan_no': widget.challanId,
                      'challan_info': {
                        'date': '2024-01-01',
                        'vehicle_no': 'DL01AB1234',
                        'transporter': 'Default Transporter',
                      },
                      'employee': {
                        'code': 'EMP001',
                        'name': 'Default Employee',
                      },
                      'material': {
                        'code': 'MAT001',
                        'description': 'Default Material',
                        'hsn_code': 'HSN001',
                        'pallet_count': '10',
                        'unit': 'PCS',
                        'axle_qty': '5',
                        'expected_return_date': '2024-02-01',
                      },
                    },
                  ),
                ),
              );
            },
          ),
        ),
        body: Stack(
          children: [
            MobileScanner(
              controller: controller.scannerController,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty && barcodes[0].rawValue != null) {
                  final code = barcodes[0].rawValue!;
                  controller.scannerController.stop();
                  if (!controller.scannedPallets.contains(code)) {
                    _showScannedCodeDialog(context, code);
                  } else {
                    _showDuplicateCodeDialog(context);
                  }
                }
              },
            ),
            Positioned(
              top: 30,
              left: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.image, color: Colors.white),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        try {
                          final BarcodeCapture? capture = await controller
                              .scannerController
                              .analyzeImage(image.path);
                          if (capture != null &&
                              capture.barcodes.isNotEmpty &&
                              capture.barcodes[0].rawValue != null) {
                            final code = capture.barcodes[0].rawValue!;
                            if (!controller.scannedPallets.contains(code)) {
                              _showScannedCodeDialog(context, code);
                            } else {
                              _showDuplicateCodeDialog(context);
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
                              content: Text(
                                  'Error analyzing image: ${e.toString()}'),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  IconButton(
                      icon: const Icon(Icons.flash_on, color: Colors.white),
                      onPressed: () =>
                          controller.scannerController.toggleTorch()),
                  IconButton(
                      icon: const Icon(Icons.flip_camera_android,
                          color: Colors.white),
                      onPressed: () =>
                          controller.scannerController.switchCamera()),
                ],
              ),
            ),
            Center(
                child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.cyan, width: 4),
                        borderRadius: BorderRadius.circular(10)))),
            Positioned(
                bottom: 140,
                left: 30,
                right: 30,
                child: Row(children: [
                  Expanded(
                      child: Obx(() => Slider(
                          value: controller.zoom.value,
                          min: 0.1,
                          max: 1.0,
                          onChanged: controller.setZoom)))
                ])),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white),
                      onPressed: () {
                        // Navigate back to PalletDispatchScreen2
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PalletDispatchScreen2(
                              challanId: widget.challanId,
                              scannedPallets: controller.scannedPallets,
                              challanDetails: {
                                'vendor': {
                                  'code': 'VENDOR001',
                                  'name': 'Default Vendor',
                                  'gstin': 'GSTIN123456789',
                                  'pan': 'PAN123456789',
                                },
                                'challan_no': widget.challanId,
                                'challan_info': {
                                  'date': '2024-01-01',
                                  'vehicle_no': 'DL01AB1234',
                                  'transporter': 'Default Transporter',
                                },
                                'employee': {
                                  'code': 'EMP001',
                                  'name': 'Default Employee',
                                },
                                'material': {
                                  'code': 'MAT001',
                                  'description': 'Default Material',
                                  'hsn_code': 'HSN001',
                                  'pallet_count': '10',
                                  'unit': 'PCS',
                                  'axle_qty': '5',
                                  'expected_return_date': '2024-02-01',
                                },
                              },
                            ),
                          ),
                        );
                      },
                      child: const Text('BACK')),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white),
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PalletDispatchScreen(
                                challanId: widget.challanId,
                                scannedPallets: controller.scannedPallets))),
                    child: const Text('VIEW'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

  void _showScannedCodeDialog(BuildContext context, String code) {
    // Parse the QR string to extract fields
    Map<String, String> parsedData = parseQRString(code);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pallet scanned successfully!'),
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
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                // Store the parsed data instead of raw code
                String displayCode =
                    '${parsedData['modelPallet']} - ${parsedData['palletSr']}';
                controller.addPallet(displayCode);
                Navigator.of(context).pop(); // Close dialog
                // Navigate to PalletDispatchScreen (list view) instead of going back
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PalletDispatchScreen(
                      challanId: widget.challanId,
                      scannedPallets: controller.scannedPallets,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showDuplicateCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Duplicate Pallet'),
          content: const Text('This pallet has already been scanned.'),
          actions: [
            TextButton(
                child: const Text('Back'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  // Navigate to PalletDispatchScreen (list view) instead of going back
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PalletDispatchScreen(
                        challanId: widget.challanId,
                        scannedPallets: controller.scannedPallets,
                      ),
                    ),
                  );
                })
          ],
        );
      },
    );
  }
}

class PalletDispatchScreen extends StatefulWidget {
  final String challanId;
  final List<String> scannedPallets;

  const PalletDispatchScreen(
      {super.key, required this.challanId, required this.scannedPallets});

  @override
  _PalletDispatchScreenState createState() => _PalletDispatchScreenState();
}

class _PalletDispatchScreenState extends State<PalletDispatchScreen> {
  final PalletDispatchController controller =
      Get.find<PalletDispatchController>(tag: 'palletDispatch');

  @override
  void initState() {
    super.initState();
    controller.setChallanId(widget.challanId);
    // Use Future.microtask to avoid triggering rebuilds during build
    Future.microtask(() {
      if (controller.scannedPallets.isEmpty ||
          controller.scannedPallets.length < widget.scannedPallets.length) {
        controller.scannedPallets.assignAll(widget.scannedPallets);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Always navigate back to PalletDispatchScreen2 instead of stacking
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PalletDispatchScreen2(
              challanId: widget.challanId,
              scannedPallets: controller.scannedPallets,
              challanDetails: {
                'vendor': {
                  'code': 'VENDOR001',
                  'name': 'Default Vendor',
                  'gstin': 'GSTIN123456789',
                  'pan': 'PAN123456789',
                },
                'challan_no': widget.challanId,
                'challan_info': {
                  'date': '2024-01-01',
                  'vehicle_no': 'DL01AB1234',
                  'transporter': 'Default Transporter',
                },
                'employee': {
                  'code': 'EMP001',
                  'name': 'Default Employee',
                },
                'material': {
                  'code': 'MAT001',
                  'description': 'Default Material',
                  'hsn_code': 'HSN001',
                  'pallet_count': '10',
                  'unit': 'PCS',
                  'axle_qty': '5',
                  'expected_return_date': '2024-02-01',
                },
              },
            ),
          ),
        );
        return false; // Prevent default back behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Pallet Dispatch"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Custom back navigation to PalletDispatchScreen2
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PalletDispatchScreen2(
                    challanId: widget.challanId,
                    scannedPallets: controller.scannedPallets,
                    challanDetails: {
                      'vendor': {
                        'code': 'VENDOR001',
                        'name': 'Default Vendor',
                        'gstin': 'GSTIN123456789',
                        'pan': 'PAN123456789',
                      },
                      'challan_no': widget.challanId,
                      'challan_info': {
                        'date': '2024-01-01',
                        'vehicle_no': 'DL01AB1234',
                        'transporter': 'Default Transporter',
                      },
                      'employee': {
                        'code': 'EMP001',
                        'name': 'Default Employee',
                      },
                      'material': {
                        'code': 'MAT001',
                        'description': 'Default Material',
                        'hsn_code': 'HSN001',
                        'pallet_count': '10',
                        'unit': 'PCS',
                        'axle_qty': '5',
                        'expected_return_date': '2024-02-01',
                      },
                    },
                  ),
                ),
              );
            },
          ),
        ),
        body: PalletDispatch3(context: context),
      ),
    );
  }
}

class PalletDispatch3 extends StatelessWidget {
  const PalletDispatch3({Key? key, required this.context}) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final PalletDispatchController controller =
        Get.find<PalletDispatchController>(tag: 'palletDispatch');
    print(
        "PalletDispatch3 build, scannedPallets length: ${controller.scannedPallets.length}");
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Text("Challan No : ${controller.challanId.value ?? ''}",
                  style: const TextStyle(
                      fontFamily: "DMSans",
                      fontSize: 16,
                      fontWeight: FontWeight.w600))),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: const Offset(0, 2))
                      ]),
                  child: Obx(() => ListView.builder(
                        itemCount: controller.scannedPallets.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: Colors
                                        .grey.shade300), // Bottom border only
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        controller.scannedPallets[index]
                                            .split(' - ')[0],
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
                                        controller.scannedPallets[index]
                                                    .split(' - ')
                                                    .length >
                                                1
                                            ? controller.scannedPallets[index]
                                                .split(' - ')[1]
                                            : 'N/A',
                                        style: const TextStyle(
                                          fontFamily: "DMSans",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: Colors.blue, size: 15),
                                    const SizedBox(width: 5),
                                    const Text(
                                      "Scanned & Assigned",
                                      style: TextStyle(
                                        fontFamily: "DMSans",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () => showDeletePalletPopup(
                                          context,
                                          () => controller.removePallet(index)),
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
              ),
              const SizedBox(height: 15),
              Obx(() => Center(
                  child: Text("Total : ${controller.scannedPallets.length}",
                      style: const TextStyle(
                          fontFamily: "DMSans",
                          fontSize: 18,
                          fontWeight: FontWeight.bold)))),
              const SizedBox(
                  height: 10), // Adjusted spacing to move buttons upwards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        String? scannedCode = await Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomScannerScreen(
                                    challanId: controller.challanId.value ?? '',
                                    scannedPallets:
                                        controller.scannedPallets)));
                        controller.onScanned(scannedCode);
                      },
                      icon: const Icon(Icons.qr_code_scanner,
                          color: Colors.white),
                      label: const Text("SCAN PALLET",
                          style: TextStyle(fontFamily: "DMSans", fontSize: 14)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => showPalletsAssignedPopup(
                          context, controller.scannedPallets.length),
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(216, 219, 226, 1),
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: const Text("CONFIRM",
                          style: TextStyle(
                              fontFamily: "DMSans",
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(27, 27, 30, 1))),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

void showPalletsAssignedPopup(BuildContext context, int palletCount) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("PALLETS ASSIGNED",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7FA2AB),
                    letterSpacing: 1.2)),
            const SizedBox(height: 10),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                    fontSize: 14, fontFamily: "DMSans", color: Colors.black),
                children: [
                  TextSpan(
                      text: "$palletCount pallet(s) ",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(
                      text: "have been assigned to the selected Challan")
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.find<PalletDispatchController>(tag: 'palletDispatch')
                    .resetPallets();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D4252),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              child: const Text("SAVE & EXIT"),
            ),
          ],
        ),
      );
    },
  );
}

void showDeletePalletPopup(BuildContext context, VoidCallback onConfirm) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("DELETE PALLET ?",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    letterSpacing: 1.2)),
            const SizedBox(height: 10),
            const Text("Are you sure you want to delete this pallet ?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14, fontFamily: "DMSans", color: Colors.black54)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3D4252),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: const Text("YES"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black54,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: const Text("NO"),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
