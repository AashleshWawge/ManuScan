import 'package:flutter/material.dart';

class PalletDispatchScreen extends StatefulWidget {
  const PalletDispatchScreen({super.key});

  @override
  _PalletDispatchScreenState createState() => _PalletDispatchScreenState();
}

class _PalletDispatchScreenState extends State<PalletDispatchScreen> {
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

  @override
  Widget build(BuildContext context) {
    int totalPages = (_sampleData.length / _itemsPerPage).ceil();
    List<Map<String, String>> paginatedData = _sampleData
        .skip(_currentPage * _itemsPerPage)
        .take(_itemsPerPage)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Pallet Dispatch",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Active Challan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  columns: const [
                    DataColumn(
                        label: Text("Sr. No.",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text("Client",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text("Challan Id",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text("Unit",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: paginatedData.map((row) {
                    return DataRow(cells: [
                      DataCell(Text(row['sr_no']!)),
                      DataCell(Text(row['client']!)),
                      DataCell(Text(row['challan_id']!)),
                      DataCell(Text(row['unit']!)),
                    ]);
                  }).toList(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Page",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: List.generate(
                    totalPages,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: _currentPage == index
                              ? Colors.teal
                              : Colors.grey.shade300,
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              color: _currentPage == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Text("Showing ${paginatedData.length} of ${_sampleData.length}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text("OR", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showChallanIdPopup(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  "ENTER CHALLAN ID",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showChallanIdPopup(BuildContext context) {
  TextEditingController challanIdController = TextEditingController();

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return Padding(
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
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                String enteredChallanId = challanIdController.text;
                Navigator.pop(context, enteredChallanId);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PalletDispatchScreen2(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child:
                  const Text("CONFIRM", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    },
  );
}


class PalletDispatchScreen2 extends StatelessWidget {
  const PalletDispatchScreen2({super.key});

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Challan ID
            const Text(
              "Challan ID : ABCD434840277",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

            // Material Details
            const Text("Material Code: ABCD123456789",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const Text("Material Description: PALLET 5E/5B/5R AXLE"),
            const Text("HSN Code: 12345678"),
            const Text("Unit: EA"),
            const Text("Pallet Qty: 10.00"),
            const Text("Axle Qty: 2"),
            const Text("Expected Return Date: 02/07/2025"),

            const Spacer(),

            // Scan Pallet Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Add scan functionality here
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
          ],
        ),
      ),
    );
  }
}

