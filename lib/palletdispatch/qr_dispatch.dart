import 'package:flutter/material.dart';
import 'package:manuscan/palletdispatch/pallet_dispatch.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';

class CustomScannerScreen extends StatefulWidget {
  final String challanId;
  final List<String> scannedPallets;

  const CustomScannerScreen(
      {super.key, required this.challanId, required this.scannedPallets});

  @override
  _CustomScannerScreenState createState() => _CustomScannerScreenState();
}

class _CustomScannerScreenState extends State<CustomScannerScreen> {
  double zoom = 0.5; // Default zoom level
  MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  controller.stop();
                  _showScannedCodeDialog(barcode.rawValue!);
                }
              }
            },
          ),

          // **Top Icons**
          Positioned(
            top: 30,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.image, color: Colors.white),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      controller.analyzeImage(image.path);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.flash_on, color: Colors.white),
                  onPressed: () => controller.toggleTorch(),
                ),
                IconButton(
                  icon: Icon(Icons.flip_camera_android, color: Colors.white),
                  onPressed: () => controller.switchCamera(),
                ),
              ],
            ),
          ),

          // **Scan Area Borders**
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.cyan, width: 4),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // **Zoom Slider**
          Positioned(
            bottom: 140,
            left: 30,
            right: 30,
            child: Row(
              children: [
                Expanded(
                  child: Slider(
                    value: zoom,
                    min: 0.1,
                    max: 1.0,
                    onChanged: (value) {
                      setState(() {
                        zoom = value;
                        controller.setZoomScale(value);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // **Back & View Buttons**
          Positioned(
            bottom: 30,
            left: 30,
            right: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                  child: Text('BACK'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PalletDispatchScreen(
                          challanId: widget.challanId,
                          scannedPallets: widget.scannedPallets,
                        ),
                      ),
                    );
                  },
                  child: Text('VIEW'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Pallet Scanned Successfully
  void _showScannedCodeDialog(String code) {
    if (!widget.scannedPallets.contains(code)) {
      setState(() {
        widget.scannedPallets.add(code);
      });
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pallet scanned successfully!'),
          content: Text(code),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context, code);
              },
            ),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pallet Dispatch"),
      ),
      body: PalletDispatch3(
        context,
        widget.scannedPallets,
        (index) {
          setState(() {
            widget.scannedPallets.removeAt(index);
          });
        },
        widget.challanId,
        (scannedCode) {
          if (scannedCode != null &&
              !widget.scannedPallets.contains(scannedCode)) {
            setState(() {
              widget.scannedPallets.add(scannedCode);
            });
          }
        },
      ),
    );
  }
}

// Pallet Dispatch after Scanning QR Code
Widget PalletDispatch3(BuildContext context, List<String> pallets,
    Function(int) onDelete, String challanId, Function(String?) onScanned) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Challan ID : $challanId",
          style: const TextStyle(
              fontFamily: "DMSans", fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 15),
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
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              itemCount: pallets.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.grey.shade300)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "PALLET ID :",
                            style: const TextStyle(
                                fontFamily: "DMSans",
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            pallets[index],
                            style: const TextStyle(
                                fontFamily: "DMSans",
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
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
                                color: Colors.blue),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () => showDeletePalletPopup(
                                context, () => onDelete(index)),
                            child:
                                const Icon(Icons.delete, color: Colors.black54),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 30),
        Center(
          child: Text(
            "Total : ${pallets.length}",
            style: const TextStyle(
                fontFamily: "DMSans",
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  String? scannedCode = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomScannerScreen(
                        challanId: challanId,
                        scannedPallets: pallets,
                      ),
                    ),
                  );
                  onScanned(scannedCode);
                },
                icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
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
                  showPalletsAssignedPopup(context, pallets.length);
                  // Add your confirm action here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(216, 219, 226, 1),
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
  );
}

void showPalletsAssignedPopup(BuildContext context, int palletCount) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
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
                color: Color(0xFF7FA2AB), // Adjust color to match design
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PalletDispatchScreen1(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3D4252), // Dark button color
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
      );
    },
  );
}

// Delete Pallet Function

void showDeletePalletPopup(BuildContext context, VoidCallback onConfirm) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "DELETE PALLET ?",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Are you sure you want to delete this pallet ?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontFamily: "DMSans",
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirm(); // Calls the function to delete
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF3D4252), // Dark button color
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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
