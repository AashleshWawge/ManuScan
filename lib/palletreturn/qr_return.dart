import 'package:flutter/material.dart';
import 'package:manuscan/palletreturn/pallet_return.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';

class CustomReturnScannerScreen extends StatefulWidget {
  final String challanId;
  final String returnId;
  final List<String> scannedPallets;

  const CustomReturnScannerScreen(
      {super.key,
      required this.returnId,
      required this.challanId,
      required this.scannedPallets});

  @override
  _CustomReturnScannerScreenState createState() =>
      _CustomReturnScannerScreenState();
}

class _CustomReturnScannerScreenState extends State<CustomReturnScannerScreen> {
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
    if (!widget.scannedPallets.contains(code)) {
      setState(() {
        widget.scannedPallets.add(code);
      });
      print("Updated Scanned Pallet List: ${widget.scannedPallets}");
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedReturnStatus = 'Returned';
        return AlertDialog(
          title: const Text('Pallet scanned successfully!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(code),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: selectedReturnStatus,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedReturnStatus = newValue!;
                  });
                },
                items: <String>['Returned', 'Not Returned']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('NEXT'),
              onPressed: () {
                Navigator.of(context).pop();
                _showConditionStatusDialog(code, selectedReturnStatus);
              },
            ),
          ],
        );
      },
    );
  }

  void _showConditionStatusDialog(String code, String returnStatus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedConditionStatus = 'OK';
        return AlertDialog(
          title: const Text('Select Condition Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: selectedConditionStatus,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedConditionStatus = newValue!;
                  });
                },
                items: <String>['OK', 'Scrap', 'Repair']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context, {
                  'code': code,
                  'returnStatus': returnStatus,
                  'conditionStatus': selectedConditionStatus
                });
              },
            ),
          ],
        );
      },
    );
  }
}

class PalletReturnScreen extends StatefulWidget {
  final String returnId;
  final String challanId;
  final List<String> scannedPallets;

  const PalletReturnScreen(
      {super.key,
      required this.returnId,
      required this.challanId,
      required this.scannedPallets});

  @override
  _PalletReturnScreenState createState() => _PalletReturnScreenState();
}

class _PalletReturnScreenState extends State<PalletReturnScreen> {
  List<bool> returnedStatus = [];
  List<String> palletStatus = [];

  @override
  void initState() {
    super.initState();
    returnedStatus = List<bool>.from(widget.scannedPallets.map((_) => false));
    palletStatus = List<String>.from(widget.scannedPallets.map((_) => 'OK'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pallet Return"),
      ),
      body: PalletReturn3(
        context,
        widget.scannedPallets,
        returnedStatus,
        palletStatus,
        (index) {
          setState(() {
            widget.scannedPallets.removeAt(index);
            returnedStatus.removeAt(index);
            palletStatus.removeAt(index);
          });
        },
        widget.returnId,
        widget.challanId,
        (result) {
          if (result != null && result is Map) {
            String scannedCode = result['code']!;
            String returnStatus = result['returnStatus']!;
            String conditionStatus = result['conditionStatus']!;
            if (!widget.scannedPallets.contains(scannedCode)) {
              setState(() {
                widget.scannedPallets.add(scannedCode);
                returnedStatus.add(returnStatus == 'Returned');
                palletStatus.add(conditionStatus);
              });
            }
          }
        },
      ),
    );
  }
}

// Pallet Return after Scanning QR Code
Widget PalletReturn3(
    BuildContext context,
    List<String> pallets,
    List<bool> returnedStatus,
    List<String> palletStatus,
    Function(int) onDelete,
    String returnId,
    String challanId,
    Function(dynamic) onScanned) {
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
                      bool isReturned = returnedStatus[index];
                      String status = palletStatus[index];
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
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      isReturned
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color:
                                          isReturned ? Colors.blue : Colors.red,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      isReturned ? "Returned" : "Not Returned",
                                      style: TextStyle(
                                        color: isReturned
                                            ? Colors.blue
                                            : Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      status == 'Scrap'
                                          ? Icons.cancel
                                          : status == 'Repair'
                                              ? Icons.build
                                              : Icons.check_circle,
                                      color: status == 'Scrap'
                                          ? Colors.red
                                          : status == 'Repair'
                                              ? Colors.yellow
                                              : Colors.blue,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      status,
                                      style: TextStyle(
                                        color: status == 'Scrap'
                                            ? Colors.red
                                            : status == 'Repair'
                                                ? Colors.yellow
                                                : Colors.blue,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
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
                        "Returned : ${returnedStatus.where((status) => status).length}",
                        style: const TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Not Returned : ${returnedStatus.where((status) => !status).length}",
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
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomReturnScannerScreen(
                            challanId: challanId,
                            scannedPallets: pallets,
                            returnId: returnId,
                          )),
                );
                onScanned(result);
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
                showPalletsNotReturnedPopup(
                    context, returnedStatus.where((status) => !status).length);
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

void showPalletsNotReturnedPopup(BuildContext context, int notReturnedCount) {
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
              "PALLETS NOT RETURNED",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 10),
            Text(
              "$notReturnedCount pallet(s) from the selected Challan have not been returned by the customer.",
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
                    builder: (context) => PalletReturnScreen1(),
                  ),
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
