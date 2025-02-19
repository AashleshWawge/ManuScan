import 'package:flutter/material.dart';
import 'qr_dispatch.dart';

class PalletDispatchScreen1 extends StatefulWidget {
  const PalletDispatchScreen1({super.key});

  @override
  _PalletDispatchScreen1State createState() => _PalletDispatchScreen1State();
}

class _PalletDispatchScreen1State extends State<PalletDispatchScreen1> {
  int _currentPage = 0;
  final int _itemsPerPage = 10;
  final List<Map<String, String>> _sampleData = List.generate(100, (index) {
    return {
      'sr_no': '${index + 1}',
      'client': ["John Deere", "Force Motors", "Ashok Leyland"][index % 3],
      'challan_id': index == 0 ? "ABCD434840277" : "ABCD123456789",
      'unit': "10",
    };
  });

  List<String> scannedPallets = [];
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
          "Pallet Dispatch",
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
            const SizedBox(height: 25),
            Center(
              child: Text(
                "OR",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
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
                        builder: (context) => PalletDispatchScreen12(
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

class PalletDispatchScreen12 extends StatefulWidget {
  final String challanId;
  final List<String> scannedPallets;

  const PalletDispatchScreen12(
      {super.key, required this.challanId, required this.scannedPallets});

  @override
  _PalletDispatchScreen12State createState() => _PalletDispatchScreen12State();
}

class _PalletDispatchScreen12State extends State<PalletDispatchScreen12> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Pallet Dispatch",
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
                      builder: (context) => CustomScannerScreen(
                        challanId: widget.challanId,
                        scannedPallets: widget.scannedPallets,
                      ),
                    ),
                  );
                  if (scannedCode != null &&
                      !widget.scannedPallets.contains(scannedCode)) {
                    setState(() {
                      widget.scannedPallets.add(scannedCode);
                    });
                  }
                },
                icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                label: const Text("SCAN PALLET",
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

//Pallet Dispatch after Scanning QR Code

// class PalletDispatch3 extends StatefulWidget {
//   final List<String> pallets;
//   final Function(int) onDelete;
//   final String challanId;

//   const PalletDispatch3({
//     required this.pallets,
//     required this.onDelete,
//     required this.challanId,
//     super.key,
//   });

//   @override
//   _PalletDispatch3State createState() => _PalletDispatch3State();
// }

// class _PalletDispatch3State extends State<PalletDispatch3> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Challan ID : ${widget.challanId}",
//           style: const TextStyle(
//               fontFamily: "DMSans", fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//         const SizedBox(height: 15),
//         Expanded(
//           child: Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 5,
//                   spreadRadius: 2,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: ListView.builder(
//               itemCount: widget.pallets.length,
//               itemBuilder: (context, index) {
//                 return Container(
//                   margin: const EdgeInsets.symmetric(vertical: 5),
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                   decoration: BoxDecoration(
//                     border:
//                         Border(bottom: BorderSide(color: Colors.grey.shade300)),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "PALLET ID : ${widget.pallets[index]}",
//                         style: const TextStyle(
//                             fontFamily: "DMSans",
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500),
//                       ),
//                       Row(
//                         children: [
//                           const Icon(Icons.check_circle,
//                               color: Colors.blue, size: 15),
//                           const Text(
//                             "Scanned & Assigned",
//                             style: TextStyle(
//                                 fontFamily: "DMSans",
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.blue),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               showDeletePalletPopup(context, () {
//                                 setState(() {
//                                   widget.onDelete(index);
//                                 });
//                               });
//                             },
//                             child:
//                                 const Icon(Icons.delete, color: Colors.black54),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//         const SizedBox(height: 30),
//         Center(
//           child: Text(
//             "Total : ${widget.pallets.length}",
//             style: const TextStyle(
//                 fontFamily: "DMSans",
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold),
//           ),
//         ),
//         const SizedBox(height: 30),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: ElevatedButton.icon(
//                 onPressed: () async {
//                   String? scannedCode = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => CustomScannerScreen(
//                               scannedPallets: [],
//                               challanId: '',
//                             )),
//                   );
//                   if (scannedCode != null &&
//                       !widget.pallets.contains(scannedCode)) {
//                     setState(() {
//                       widget.pallets
//                           .add(scannedCode); // ✅ Updates UI with new scan
//                     });
//                   }
//                 },
//                 icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
//                 label: const Text("SCAN PALLET",
//                     style: TextStyle(fontFamily: "DMSans", fontSize: 14)),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.black87,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8)),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 15),
//             Expanded(
//               child: ElevatedButton(
//                 onPressed: () {
//                   showPalletsAssignedPopup(context, widget.pallets.length);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.grey.shade300,
//                   foregroundColor: Colors.black,
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8)),
//                 ),
//                 child: const Text("CONFIRM",
//                     style: TextStyle(
//                         fontFamily: "DMSans",
//                         fontSize: 14,
//                         color: Colors.black54)),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// Show Pallets Assigned Popup

// void showPalletsAssignedPopup(BuildContext context, int palletCount) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         contentPadding: const EdgeInsets.all(20),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               "PALLETS ASSIGNED",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF7FA2AB), // Adjust color to match design
//                 letterSpacing: 1.2,
//               ),
//             ),
//             const SizedBox(height: 10),
//             RichText(
//               textAlign: TextAlign.center,
//               text: TextSpan(
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontFamily: "DMSans",
//                   color: Colors.black,
//                 ),
//                 children: [
//                   TextSpan(
//                     text: "$palletCount pallet(s) ",
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   const TextSpan(
//                     text: "have been assigned to the selected Challan",
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.pop(context); // Return to PalletDispatchScreen1
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF3D4252), // Dark button color
//                 foregroundColor: Colors.white,
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: const Text("SAVE & EXIT"),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }

// // Delete Pallet Function

// void showDeletePalletPopup(BuildContext context, VoidCallback onConfirm) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         contentPadding: const EdgeInsets.all(20),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               "DELETE PALLET ?",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black,
//                 letterSpacing: 1.2,
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "Are you sure you want to delete this pallet ?",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontFamily: "DMSans",
//                 color: Colors.black54,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       onConfirm(); // Calls the function to delete
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor:
//                           const Color(0xFF3D4252), // Dark button color
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text("YES"),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => Navigator.pop(context),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.grey.shade300,
//                       foregroundColor: Colors.black54,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text("NO"),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
