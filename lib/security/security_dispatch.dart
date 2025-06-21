import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/security_dispatch_controller.dart';
import '../models/challan_details.dart';
import 'package:another_flushbar/flushbar.dart';

class SecurityDispatchScreen1 extends StatefulWidget {
  const SecurityDispatchScreen1({super.key});

  @override
  _SecurityDispatchScreen1State createState() =>
      _SecurityDispatchScreen1State();
}

class _SecurityDispatchScreen1State extends State<SecurityDispatchScreen1> {
  late final SecurityDispatchController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SecurityDispatchController>(tag: 'securityDispatch');
    controller.fetchActiveChallans();
  }

  int _currentPage = 0;
  final int _itemsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    // Ensure the controller is initialized
    Get.lazyPut(() => SecurityDispatchController(), tag: 'securityDispatch');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Security Dispatch",
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
                if (controller.isLoadingChallans.value &&
                    controller.activeChallans.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (paginatedData.isEmpty) {
                  return const Center(child: Text('No active challans found'));
                } else {
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
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              Text("Client",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              Text("Challan No",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              Text("Pallets",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: paginatedData.length,
                            itemBuilder: (context, index) {
                              final item = paginatedData[index];
                              return GestureDetector(
                                onTap: () => handleChallanFetch(
                                    item["challan_no"]!, context),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
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
                                      Text(item["vendor_name"] ?? ''),
                                      Text(item["challan_no"] ?? ''),
                                      Text(item["pallet_count"]?.toString() ??
                                          ''),
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
                }
              }),
            ),
            const SizedBox(height: 25),
            const Center(
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

      if (!mounted) return;

      if (success) {
        controller.setChallanId(challanId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SecurityDispatchScreen2(
              challanId: challanId,
              scannedPallets: controller.scannedPallets,
              challanDetails: controller.challanDetails.value!,
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
        ),
      );
    }
  }

  void showChallanIdPopup(BuildContext context) {
    TextEditingController challanIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
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
                    Navigator.pop(dialogContext);
                    await handleChallanFetch(challanId, context);
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

// Import the ChallanDetails model from the correct file

class SecurityDispatchScreen2 extends StatefulWidget {
  final String challanId;
  final List<String> scannedPallets;
  final Map<String, dynamic> challanDetails;

  const SecurityDispatchScreen2({
    super.key,
    required this.challanId,
    required this.scannedPallets,
    required this.challanDetails,
  });

  @override
  _SecurityDispatchScreen2State createState() =>
      _SecurityDispatchScreen2State();
}

class _SecurityDispatchScreen2State extends State<SecurityDispatchScreen2> {
  final SecurityDispatchController controller =
      Get.find<SecurityDispatchController>(tag: 'securityDispatch');
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
            "Security Dispatch",
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
                                  onPressed: () {
                                    showSecurityConfirmDialog(context);
                                  },
                                  icon: const Icon(Icons.check,
                                      color: Colors.white),
                                  label: const Text(
                                    "APPROVE",
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
                                  onPressed: () {
                                    showSecurityRejectDialog(context);
                                  },
                                  icon: const Icon(Icons.close,
                                      color: Colors.white),
                                  label: const Text(
                                    "REJECT",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 25, horizontal: 20),
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

void showSecurityConfirmDialog(BuildContext context) {
  final controller =
      Get.isRegistered<SecurityDispatchController>(tag: 'securityDispatch')
          ? Get.find<SecurityDispatchController>(tag: 'securityDispatch')
          : Get.put(SecurityDispatchController(),
              tag: 'securityDispatch', permanent: true);

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
              "CONFIRM DISPATCH",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3D4252), // Adjust color to match design
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "DMSans",
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "Are you sure you want to approve dispatch ?",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final success = await controller.approveChallan();
                    if (success) {
                      Get.offAllNamed('/home'); // Go to home screen
                    } else {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(controller.errorMessage.value),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF3D4252), // Dark button color
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Obx(() => controller.isSubmitting.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white))
                      : const Text("SAVE & EXIT")),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(216, 219, 226, 1),
                    foregroundColor: Colors.black54,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("NO"),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

// Delete Pallet Function
void showSecurityRejectDialog(BuildContext context) {
  final controller =
      Get.isRegistered<SecurityDispatchController>(tag: 'securityDispatch')
          ? Get.find<SecurityDispatchController>(tag: 'securityDispatch')
          : Get.put(SecurityDispatchController(),
              tag: 'securityDispatch', permanent: true);

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
              "REJECT DISPATCH",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red, // Adjust color to match design
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "DMSans",
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "Are you sure you want to reject dispatch ?",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed('/home'); // Go to home screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF3D4252), // Dark button color
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("SAVE & EXIT"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(216, 219, 226, 1),
                    foregroundColor: Colors.black54,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("NO"),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
