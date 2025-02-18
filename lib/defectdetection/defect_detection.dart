import 'package:flutter/material.dart';
import 'package:manuscan/defectdetection/qr_defect.dart';

class DefectDetectionScreen extends StatefulWidget {
  const DefectDetectionScreen({super.key});

  @override
  _DefectDetectionScreenState createState() => _DefectDetectionScreenState();
}

class _DefectDetectionScreenState extends State<DefectDetectionScreen> {
  int _currentPage = 0;
  final int _itemsPerPage = 10;
  final List<Map<String, String>> _sampleData = List.generate(60, (index) {
    return {
      'sr_no': '${index + 1}',
      'client': ["John Deere", "Force Motors", "Ashok Leyland"][index % 3],
      'challan_id': index == 0 ? "ABCD434840277" : "ABCD123456789",
      'unit': "10",
    };
  });

  List<Map<String, String>> scannedPallets = [];
  String? challanId;

  @override
  Widget build(BuildContext context) {
    int totalPages = (_sampleData.length / _itemsPerPage).ceil();
    List<Map<String, String>> paginatedData = _sampleData
        .skip(_currentPage * _itemsPerPage)
        .take(_itemsPerPage)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Defect Detection",
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
              "Active Challan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
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
                          Text("Client",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          Text("Challan Id",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          Text("Unit",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: paginatedData.length,
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
                                Text(paginatedData[index]["sr_no"]!),
                                Text(paginatedData[index]["client"]!),
                                Text(paginatedData[index]["challan_id"]!),
                                Text(paginatedData[index]["unit"]!),
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
                            "Showing ${paginatedData.length} of ${_sampleData.length}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 60),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  showChallanIdPopup(context);
                },
                label: const Text("ENTER CHALLAN ID",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void showChallanIdPopup(BuildContext context) {
    TextEditingController challanIdController = TextEditingController();

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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        horizontal: 20, vertical: 12),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      challanId = challanIdController.text;
                    });
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DefectDetection2(
                          challanId: challanId!,
                          scannedPallets: scannedPallets,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                  ),
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

class DefectDetection2 extends StatefulWidget {
  final String challanId;
  final List<Map<String, String>> scannedPallets;

  const DefectDetection2(
      {super.key, required this.challanId, required this.scannedPallets});

  @override
  _DefectDetection2State createState() => _DefectDetection2State();
}

class _DefectDetection2State extends State<DefectDetection2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Defect Detection",
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
                onPressed: () async {
                  String? scannedCode = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DefectDetection3(
                        challanId: widget.challanId,
                        scannedPallets: widget.scannedPallets,
                      ),
                    ),
                  );
                  if (scannedCode != null &&
                      !widget.scannedPallets.contains(scannedCode)) {
                    setState(() {
                      widget.scannedPallets
                          .add(scannedCode as Map<String, String>);
                    });
                  }
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

class DefectDetection3 extends StatefulWidget {
  final String challanId;
  final List<Map<String, String>> scannedPallets;

  DefectDetection3(
      {Key? key, required this.challanId, required this.scannedPallets})
      : super(key: key);

  @override
  _DefectDetection3 createState() => _DefectDetection3();
}

class _DefectDetection3 extends State<DefectDetection3> {
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

  @override
  Widget build(BuildContext context) {
    int totalPages = (pallets.length / _itemsPerPage).ceil();
    List<Map<String, String>> paginatedPallets =
        pallets.skip(_currentPage * _itemsPerPage).take(_itemsPerPage).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Defect Detection",
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
            const SizedBox(height: 60),
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  String? scannedCode = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomScannerScreendefect(
                        challanId: widget.challanId,
                        scannedPallets: widget.scannedPallets,
                        returnId: '',
                      ),
                    ),
                  );
                  if (scannedCode != null &&
                      !widget.scannedPallets.contains(scannedCode)) {
                    setState(() {
                      widget.scannedPallets
                          .add(scannedCode as Map<String, String>);
                    });
                  }
                },
                icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                label: const Text("SCAN PALLET",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

//Defect Detetction after Scanning QR Code

// Widget defectdetection4(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text("Defect Detection"),
//       leading: IconButton(
//         icon: Icon(Icons.arrow_back),
//         onPressed: () => Navigator.pop(context),
//       ),
//     ),
//     body: Padding(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Challan ID : 434840277",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 10),
//           Expanded(
//             child: ListView(
//               children: List.generate(5, (index) {
//                 return ListTile(
//                   leading: Text("PALLET ID : 1234567"),
//                   title: Row(
//                     children: [
//                       Icon(
//                         index == 1 || index == 4
//                             ? Icons.cancel
//                             : (index == 3 ? Icons.warning : Icons.check_circle),
//                         color: index == 1 || index == 4
//                             ? Colors.red
//                             : (index == 3 ? Colors.orange : Colors.blue),
//                       ),
//                       SizedBox(width: 8),
//                       Text(
//                         index == 1 || index == 4
//                             ? "Scrap"
//                             : (index == 3 ? "Repair" : "OK"),
//                         style: TextStyle(
//                           color: index == 1 || index == 4
//                               ? Colors.red
//                               : (index == 3 ? Colors.orange : Colors.blue),
//                         ),
//                       ),
//                     ],
//                   ),
//                   trailing: IconButton(
//                     icon: Icon(Icons.delete),
//                     onPressed: () {
//                       showDeletePalletPopup(context, () {
//                         // Implement the delete functionality here
//                         //after deletion, update the UI
//                         // For example, remove the pallet from the list
//                         // scannedPallets.removeAt(index);
//                         // Note: Ensure this logic is handled within a StatefulWidget
//                       });
//                       // TODO: Show delete confirmation pop-up
//                     },
//                   ),
//                 );
//               }),
//             ),
//           ),
//           Divider(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("Total : 5"),
//               Text(
//                 "Repair : 1",
//                 style: TextStyle(color: Colors.orange),
//               ),
//               Text(
//                 "Scrap : 2",
//                 style: TextStyle(color: Colors.red),
//               ),
//             ],
//           ),
//           SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   // TODO: Implement Scan Pallet action
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.black,
//                 ),
//                 child: Text("SCAN PALLET"),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   showDefectDetectedPopup(context);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.grey[400],
//                 ),
//                 child: Text("CONFIRM"),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }

// // Defect Detected Popup

// void showDefectDetectedPopup(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16.0),
//         ),
//         contentPadding: EdgeInsets.all(20),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               "PALLET DEFECT DETECTED",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.red,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 10),
//             RichText(
//               textAlign: TextAlign.center,
//               text: TextSpan(
//                 style: TextStyle(color: Colors.black, fontSize: 14),
//                 children: [
//                   TextSpan(text: "1 "),
//                   TextSpan(
//                     text: "pallet(s)",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   TextSpan(text: " to be repaired and "),
//                   TextSpan(
//                     text: "2 pallet(s)",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   TextSpan(text: " to be scrapped from the selected Challan"),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.black,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//               child: Text(
//                 "SAVE & EXIT",
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }

// // Delete Pallet Popup
// void showDeletePalletPopup(BuildContext context, VoidCallback onDelete) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         contentPadding:
//             const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               "DELETE PALLET?",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "Are you sure you want to delete this pallet?",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.black,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 12),
//                   ),
//                   onPressed: () {
//                     onDelete(); // Execute deletion
//                     Navigator.pop(context); // Close popup
//                   },
//                   child:
//                       const Text("YES", style: TextStyle(color: Colors.white)),
//                 ),
//                 const SizedBox(width: 15),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.grey,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 12),
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context); // Close popup
//                   },
//                   child:
//                       const Text("NO", style: TextStyle(color: Colors.black)),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
