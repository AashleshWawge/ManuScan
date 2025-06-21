import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pallet_dispatch_controller.dart';
import 'qr_dispatch.dart';
import 'package:another_flushbar/flushbar.dart';

class PalletDispatchScreen1 extends StatefulWidget {
  const PalletDispatchScreen1({super.key});

  @override
  _PalletDispatchScreen1State createState() => _PalletDispatchScreen1State();
}

class _PalletDispatchScreen1State extends State<PalletDispatchScreen1> {
  int _currentPage = 0;
  final int _itemsPerPage = 10;
  final PalletDispatchController controller =
      Get.find<PalletDispatchController>(tag: 'palletDispatch');

  @override
  void initState() {
    super.initState();
    controller.fetchActiveChallans();
  }

  @override
  Widget build(BuildContext context) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Active Challan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Obx(() => controller.isLoadingChallans.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () => controller.fetchActiveChallans(),
                      )),
              ],
            ),
            const SizedBox(height: 25),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingChallans.value &&
                    controller.activeChallans.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final totalPages =
                    (controller.activeChallans.length / _itemsPerPage).ceil();
                final paginatedData = controller.activeChallans
                    .skip(_currentPage * _itemsPerPage)
                    .take(_itemsPerPage)
                    .toList();

                return Container(
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
                            Text("Challan No",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            Text("Pallets",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: paginatedData.isEmpty
                            ? const Center(
                                child: Text('No active challans found'))
                            : ListView.builder(
                                itemCount: paginatedData.length,
                                itemBuilder: (context, index) {
                                  final item = paginatedData[index];
                                  return GestureDetector(
                                    onTap: () => handleChallanFetch(
                                        item["challan_no"]!, context),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade300),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                              '${index + 1 + (_currentPage * _itemsPerPage)}'),
                                          Text(item["vendor_name"]!),
                                          Text(item["challan_no"]!),
                                          Text(item["pallet_count"]!),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      if (paginatedData.isNotEmpty)
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
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: _currentPage > 0
                                    ? () => setState(() => _currentPage--)
                                    : null,
                              ),
                              Text("Page ${_currentPage + 1} of $totalPages"),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: _currentPage < totalPages - 1
                                    ? () => setState(() => _currentPage++)
                                    : null,
                              ),
                              Text(
                                "Showing ${paginatedData.length} of ${controller.activeChallans.length}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 25),
            Center(
                child: Text("OR",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => showChallanIdPopup(context),
                label: const Text("ENTER CHALLAN No",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future<void> handleChallanFetch(
      String challanId, BuildContext context) async {
    try {
      bool success = await controller.fetchChallanDetails(challanId);

      if (!mounted) return; // Check if widget is still mounted

      if (success) {
        controller.setChallanId(challanId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PalletDispatchScreen2(
              challanId: challanId,
              scannedPallets: controller.scannedPallets,
              challanDetails: controller
                  .challanDetails.value!, // <-- FIXED: remove .toMap()
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.errorMessage.value),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An unexpected error occurred'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void showChallanIdPopup(BuildContext context) {
    TextEditingController challanIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Use separate context for dialog
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Enter Challan No",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                TextField(
                  controller: challanIdController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    final challanId = challanIdController.text.trim();
                    if (challanId.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a Challan No'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    Navigator.pop(dialogContext); // Close dialog first
                    await handleChallanFetch(challanId, context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
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
