import 'package:flutter/material.dart';
import 'package:manuscan/defectdetection/defect_detection.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';

class CustomScannerScreendefect extends StatefulWidget {
  final String challanId;
  final String returnId;
  final List<Map<String, String>> scannedPallets;

  const CustomScannerScreendefect(
      {super.key,
      required this.returnId,
      required this.challanId,
      required this.scannedPallets});

  @override
  _CustomScannerScreendefectState createState() =>
      _CustomScannerScreendefectState();
}

class _CustomScannerScreendefectState extends State<CustomScannerScreendefect> {
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
                        builder: (context) => PalletReturnScreen(
                          returnId: widget.returnId,
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
    if (!widget.scannedPallets.any((pallet) => pallet['code'] == code)) {
      setState(() {
        widget.scannedPallets.add({'code': code, 'status': 'OK'});
      });
      print("Updated Scanned Pallet List: ${widget.scannedPallets}");
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pallet scanned successfully!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(code),
              const SizedBox(height: 20),
              const Text('Select Status:'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      _updatePalletStatus(code, 'Scrap');
                      Navigator.of(context).pop();
                    },
                    child: const Text('Scrap'),
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      _updatePalletStatus(code, 'OK');
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow),
                    onPressed: () {
                      _updatePalletStatus(code, 'Repair');
                      Navigator.of(context).pop();
                    },
                    child: const Text('Repair'),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updatePalletStatus(String code, String status) {
    setState(() {
      for (var pallet in widget.scannedPallets) {
        if (pallet['code'] == code) {
          pallet['status'] = status;
          break;
        }
      }
    });
  }
}

class PalletReturnScreen extends StatefulWidget {
  final String returnId;
  final String challanId;
  final List<Map<String, String>> scannedPallets;

  const PalletReturnScreen(
      {super.key,
      required this.returnId,
      required this.challanId,
      required this.scannedPallets});

  @override
  _PalletReturnScreenState createState() => _PalletReturnScreenState();
}

class _PalletReturnScreenState extends State<PalletReturnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Defect Detection"),
      ),
      body: PalletReturn3(
        context,
        widget.scannedPallets,
        (index) {
          setState(() {
            widget.scannedPallets.removeAt(index);
          });
        },
        widget.returnId,
        widget.challanId,
        (scannedCode) {
          if (scannedCode != null &&
              !widget.scannedPallets
                  .any((pallet) => pallet['code'] == scannedCode['code'])) {
            setState(() {
              widget.scannedPallets.add(scannedCode);
            });
          }
        },
      ),
    );
  }
}

// Pallet Return after Scanning QR Code
Widget PalletReturn3(
    BuildContext context,
    List<Map<String, String>> pallets,
    Function(int) onDelete,
    String returnId,
    String challanId,
    Function(Map<String, String>?) onScanned) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Challan ID : $challanId",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: pallets.length,
                    itemBuilder: (context, index) {
                      String status = pallets[index]['status']!;
                      Color statusColor;
                      switch (status) {
                        case 'Scrap':
                          statusColor = Colors.red;
                          break;
                        case 'OK':
                          statusColor = Colors.blue;
                          break;
                        case 'Repair':
                          statusColor = Colors.yellow;
                          break;
                        default:
                          statusColor = Colors.grey;
                      }
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("PALLET ID : ${pallets[index]['code']}"),
                            Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: statusColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  status,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.black54),
                              onPressed: () {
                                showDeletePalletPopup(context, () {
                                  onDelete(index);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total : ${pallets.length}"),
                      Text(
                        "Repair : ${pallets.where((pallet) => pallet['status'] == 'Repair').length}",
                        style: const TextStyle(
                            color: Colors.yellow, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Scrap : ${pallets.where((pallet) => pallet['status'] == 'Scrap').length}",
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                Map<String, String>? scannedCode = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomScannerScreendefect(
                            challanId: challanId,
                            scannedPallets: pallets,
                            returnId: returnId,
                          )),
                );
                onScanned(scannedCode);
              },
              icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
              label: const Text("SCAN PALLET",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3D4252),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                int repairedCount = pallets
                    .where((pallet) => pallet['status'] == 'Repair')
                    .length;
                int scrapCount = pallets
                    .where((pallet) => pallet['status'] == 'Scrap')
                    .length;
                showPalletsNotReturnedPopup(context, repairedCount, scrapCount);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 216, 219, 226),
                foregroundColor: const Color.fromRGBO(27, 27, 30, 1),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("CONFIRM",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ],
    ),
  );
}

void showPalletsNotReturnedPopup(
    BuildContext context, int repairedCount, int scrapCount) {
  // Don't show if all pallets are returned

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "PALLETS DEFECT DETECTED",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 10),
            Text(
              "$repairedCount pallet(s) to be repaired and $scrapCount pallet(s) to be scrapped from the selected Challan.",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              onPressed: () {
                Navigator.pop(context); // Close popup
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DefectDetectionScreen()),
                );
              },
              child: const Text("SAVE & EXIT",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    },
  );
}

void showDeletePalletPopup(BuildContext context, VoidCallback onDelete) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "DELETE PALLET?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Are you sure you want to delete this pallet?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {
                    onDelete(); // Execute deletion
                    Navigator.pop(context); // Close popup
                  },
                  child:
                      const Text("YES", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close popup
                  },
                  child:
                      const Text("NO", style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
