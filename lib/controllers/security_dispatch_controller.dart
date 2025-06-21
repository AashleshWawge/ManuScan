import 'dart:async';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SecurityDispatchController extends GetxController {
  SecurityDispatchController() {
    print(
        "SecurityDispatchController constructor called, hashCode: ${hashCode}");
  }
  final scannedPallets = <String>[].obs;
  final challanId = ''.obs;
  final zoom = 0.5.obs;
  final MobileScannerController scannerController = MobileScannerController();
  final Rx<bool> isLoading = false.obs;
  final Rx<String> errorMessage = ''.obs;
  final Rx<Map<String, dynamic>?> challanDetails =
      Rx<Map<String, dynamic>?>(null);
  final RxList<Map<String, dynamic>> activeChallans =
      <Map<String, dynamic>>[].obs;
  final Rx<bool> isLoadingChallans = false.obs;
  final Rx<bool> isSubmitting = false.obs;

  void addPallet(String code) {
    if (!scannedPallets.contains(code)) {
      scannedPallets.add(code);
      print("Added pallet: $code, Total: ${scannedPallets.length}");
    }
  }

  void removePallet(int index) {
    scannedPallets.removeAt(index);
    print("Removed pallet at index $index, Total: ${scannedPallets.length}");
  }

  void setChallanId(String id) {
    challanId.value = id;
    print("Challan ID set to: $id");
  }

  void setZoom(double value) {
    zoom.value = value;
    scannerController.setZoomScale(value);
  }

  void onScanned(String? scannedCode) {
    if (scannedCode != null && !scannedPallets.contains(scannedCode)) {
      scannedPallets.add(scannedCode);
      print("Scanned pallet: $scannedCode, Total: ${scannedPallets.length}");
    }
  }

  void resetPallets() {
    scannedPallets.clear();
    print("Scanned pallets reset to 0, Total: ${scannedPallets.length}");
  }

  Future<bool> fetchChallanDetails(String challanNo) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('🔍 Fetching challan details for No: $challanNo');
      final response = await http.get(
        Uri.parse('http://localhost:8800/api/getopenChallanDetails/$challanNo'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('❌ Request timed out');
          throw TimeoutException('Request timed out');
        },
      );

      print('📡 API Response Status Code: ${response.statusCode}');
      print('📝 API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Map flat API response to nested structure, using "null" string for missing fields
        final material = {
          'code': jsonResponse['material_code']?.toString() ?? 'null',
          'description':
              jsonResponse['material_description']?.toString() ?? 'null',
          'hsn_code': jsonResponse['hsn_code']?.toString() ?? 'null',
          'pallet_count': jsonResponse['pallet_count']?.toString() ?? 'null',
          'unit': jsonResponse['unit']?.toString() ?? 'null',
          'axle_qty': jsonResponse['axle_qty']?.toString() ?? 'null',
          'expected_return_date':
              jsonResponse['expected_return_date']?.toString() ?? 'null',
        };

        final vendor = {
          'name': jsonResponse['vendor_name']?.toString() ?? 'null',
          'address': jsonResponse['vendor_address']?.toString() ?? 'null',
          'code': jsonResponse['vendor_code']?.toString() ?? 'null',
          'gstin': jsonResponse['gstin_no']?.toString() ?? 'null',
          'pan': jsonResponse['pan_no']?.toString() ?? 'null',
        };

        final challanInfo = {
          'date': jsonResponse['challan_date']?.toString() ?? 'null',
          'vehicle_no': jsonResponse['vehicle_no']?.toString() ?? 'null',
          'transporter': jsonResponse['transporter']?.toString() ?? 'null',
        };

        final employee = {
          'code': jsonResponse['emp_code']?.toString() ?? 'null',
          'name': jsonResponse['emp_name']?.toString() ?? 'null',
        };

        challanDetails.value = {
          'challan_no': jsonResponse['challan_no']?.toString() ?? 'null',
          'vendor': vendor,
          'challan_info': challanInfo,
          'employee': employee,
          'material': material,
          'expected_return_date':
              jsonResponse['expected_return_date']?.toString() ?? 'null',
        };

        print('✅ Challan Details Successfully Parsed:');
        print('   📦 Vendor: ${challanDetails.value!['vendor']}');
        print('   📄 Challan Info: ${challanDetails.value!['challan_info']}');
        print('   🏭 Material: ${challanDetails.value!['material']}');
        return true;
      } else if (response.statusCode == 404) {
        print('❌ Error: Challan not found');
        errorMessage.value = 'Challan not found';
        return false;
      } else {
        print('❌ Error: Failed to load challan details');
        print('   Status code: ${response.statusCode}');
        print('   Response: ${response.body}');
        errorMessage.value = 'Failed to load challan details';
        return false;
      }
    } catch (e) {
      print('❌ Network Error Details: $e');
      if (e is TimeoutException) {
        errorMessage.value = 'Request timed out. Please check your connection.';
      } else if (e.toString().contains('XMLHttpRequest')) {
        errorMessage.value =
            'Cannot connect to server. Please check server URL and network.';
      } else {
        errorMessage.value = 'Network error: ${e.toString()}';
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchActiveChallans() async {
    isLoadingChallans.value = true;
    try {
      print('🔍 Fetching active challans');
      final response = await http.get(
        Uri.parse('http://localhost:8800/api/challans-dispatch'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('📡 Active Challans Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        activeChallans.value = data
            .map((item) => {
                  'vendor_name': item['vendor_name'] ?? 'N/A',
                  'challan_no': item['challan_no'] ?? 'N/A',
                  'pallet_count': item['pallet_count']?.toString() ?? '0',
                })
            .toList();
        print('✅ Fetched ${activeChallans.length} active challans');
      } else {
        print('❌ Failed to fetch active challans');
        errorMessage.value = 'Failed to load active challans';
      }
    } catch (e) {
      print('❌ Error fetching active challans: $e');
      errorMessage.value = 'Network error occurred';
    } finally {
      isLoadingChallans.value = false;
    }
  }

  Future<bool> approveChallan() async {
    try {
      isSubmitting.value = true;
      final response = await http.post(
        Uri.parse('http://localhost:8800/api/security/approve-challan'),
        body: {'challanId': challanId.value},
      );
      final data = json.decode(response.body);
      return data['status'] ?? false;
    } catch (e) {
      errorMessage.value = 'Failed to approve challan';
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> rejectChallan() async {
    try {
      isSubmitting.value = true;
      final response = await http.post(
        Uri.parse('http://localhost:8800/api/security/reject-challan'),
        body: {'challanId': challanId.value},
      );
      final data = json.decode(response.body);
      return data['status'] ?? false;
    } catch (e) {
      errorMessage.value = 'Failed to reject challan';
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }
}
