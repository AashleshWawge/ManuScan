import 'package:flutter/material.dart';
import 'package:manuscan/palletreturn/qr_return.dart';
import 'package:another_flushbar/flushbar.dart';

class PalletReturnScreen1 extends StatefulWidget {
  const PalletReturnScreen1({super.key});

  @override
  _PalletReturnScreen1State createState() => _PalletReturnScreen1State();
}

class _PalletReturnScreen1State extends State<PalletReturnScreen1> {
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
              "Active Challan",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: "DMSans",
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
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: "DMSans",
                              )),
                          Text("Client",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: "DMSans",
                              )),
                          Text("Challan Id",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: "DMSans",
                              )),
                          Text("Unit",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: "DMSans",
                              )),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: paginatedData.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                challanId = paginatedData[index]["challan_id"];
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PalletReturn2(
                                    challanId: paginatedData[index]
                                        ["challan_id"]!,
                                    scannedPallets: [],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    paginatedData[index]["sr_no"]!,
                                    style:
                                        const TextStyle(fontFamily: "DMSans"),
                                  ),
                                  Text(
                                    paginatedData[index]["client"]!,
                                    style:
                                        const TextStyle(fontFamily: "DMSans"),
                                  ),
                                  Text(
                                    paginatedData[index]["challan_id"]!,
                                    style:
                                        const TextStyle(fontFamily: "DMSans"),
                                  ),
                                  Text(
                                    paginatedData[index]["unit"]!,
                                    style:
                                        const TextStyle(fontFamily: "DMSans"),
                                  ),
                                ],
                              ),
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
                            onTap: () => setState(() => _currentPage =
                                (_currentPage - 1 + totalPages) % totalPages),
                            child: const Icon(Icons.arrow_back),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _currentPage = 0),
                            child: Text(
                              "Page ${_currentPage + 1} of $totalPages",
                              style: const TextStyle(fontFamily: "DMSans"),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() =>
                                _currentPage = (_currentPage + 1) % totalPages),
                            child: const Icon(Icons.arrow_forward),
                          ),
                          Text(
                            "Showing ${paginatedData.length} of ${_sampleData.length}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "DMSans",
                            ),
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "DMSans",
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => showChallanIdPopup(context),
                label: const Text(
                  "ENTER CHALLAN ID",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: "DMSans",
                  ),
                ),
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
                ElevatedButton(
                  onPressed: () {
                    if (challanIdController.text.trim().isEmpty) {
                      Flushbar(
                        message: 'Please enter a Challan ID',
                        backgroundColor: Colors.red,
                        margin: const EdgeInsets.all(10),
                        borderRadius: BorderRadius.circular(8),
                        duration: const Duration(seconds: 3),
                        flushbarPosition:
                            FlushbarPosition.TOP, // Display at the top
                      ).show(context);
                    } else {
                      setState(() {
                        challanId = challanIdController.text.trim();
                      });
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PalletReturn2(
                            challanId: challanId!,
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
}
