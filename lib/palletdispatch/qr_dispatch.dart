import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:manuscan/home_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:manuscan/controllers/pallet_dispatch_controller.dart';

class PalletDispatchScreen2 extends StatefulWidget {
  final String challanId;
  final List<String> scannedPallets;

  const PalletDispatchScreen2(
      {super.key, required this.challanId, required this.scannedPallets});

  @override
  _PalletDispatchScreen2State createState() => _PalletDispatchScreen2State();
}

class _PalletDispatchScreen2State extends State<PalletDispatchScreen2> {
  final PalletDispatchController controller =
      Get.find<PalletDispatchController>(tag: 'palletDispatch');

  @override
  void initState() {
    super.initState();
    print(
        "PalletDispatchScreen2: Found controller with hashCode: ${controller.hashCode}");
    controller.setChallanId(widget.challanId);
    if (controller.scannedPallets.isEmpty ||
        controller.scannedPallets.length < widget.scannedPallets.length) {
      controller.scannedPallets.assignAll(widget.scannedPallets);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white, // Ensure AppBar background is white
        elevation: 0,
        title: const Text("Pallet Dispatch",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Challan ID : ${widget.challanId}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Vendor 202758",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(
                      "John Deere India Pvt Ltd\nGat no. 166-167 and 271-291 Sanaswadi\nPune-412208"),
                  Text("GSTIN No. : "),
                  Text("PAN No. : AAACJ4233B"),
                  Divider(),
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(10)),
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
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      String? scannedCode = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomScannerScreen(
                                challanId: widget.challanId,
                                scannedPallets: controller.scannedPallets)),
                      );
                      if (scannedCode != null) {
                        controller.onScanned(scannedCode);
                        setState(() {}); // Optional refresh
                      }
                    },
                    icon:
                        const Icon(Icons.qr_code_scanner, color: Colors.white),
                    label: const Text(
                      "SCAN PALLET",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                  const SizedBox(width: 10),
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
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  void showManualPalletIdPopup(BuildContext context) {
    TextEditingController palletIdController = TextEditingController();

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
                const Text("Enter Pallet ID",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                    print("Manual entry: ${palletIdController.text.trim()}");
                    controller.addPallet(palletIdController.text.trim());
                    Navigator.pop(context);
                    Navigator.push(
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
    if (controller.scannedPallets.isEmpty ||
        controller.scannedPallets.length < widget.scannedPallets.length) {
      controller.scannedPallets.assignAll(widget.scannedPallets);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Pallet QR'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
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
                    if (image != null)
                      controller.scannerController.analyzeImage(image.path);
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
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.teal,foregroundColor: Colors.white),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('BACK')),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal,foregroundColor: Colors.white),
                  onPressed: () => Navigator.push(
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
    );
  }

  void _showScannedCodeDialog(BuildContext context, String code) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pallet scanned successfully!'),
          content: Text(code),
          actions: [
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                controller.addPallet(code);
                Navigator.of(context).pop();
                Navigator.pop(context, code);
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
                  Navigator.of(context).pop();
                  Navigator.pop(context);
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
    if (controller.scannedPallets.isEmpty ||
        controller.scannedPallets.length < widget.scannedPallets.length) {
      controller.scannedPallets.assignAll(widget.scannedPallets);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Pallet Dispatch")),
        body: PalletDispatch3(context: context));
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
              Obx(() => Text("Challan ID : ${controller.challanId.value}",
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "PALLET ID :",
                                      style: TextStyle(
                                        fontFamily: "DMSans",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      controller.scannedPallets[index],
                                      style: const TextStyle(
                                        fontFamily: "DMSans",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
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
                        String? scannedCode = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomScannerScreen(
                                    challanId: controller.challanId.value,
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
