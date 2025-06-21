class ChallanDetails {
  final String vendorName;
  final String vendorAddress;
  final String gstinNo;
  final String panNo;
  final String challanNo;
  final String challanDate;
  final String vehicleNo;
  final String transporter;
  final String empCode;
  final String empName;
  final String materialCode;
  final String materialDescription;
  final String hsnCode;
  final String unit;
  final String palletQty;
  final String axleQty;
  final String expectedReturnDate;

  ChallanDetails({
    required this.vendorName,
    required this.vendorAddress,
    required this.gstinNo,
    required this.panNo,
    required this.challanNo,
    required this.challanDate,
    required this.vehicleNo,
    required this.transporter,
    required this.empCode,
    required this.empName,
    required this.materialCode,
    required this.materialDescription,
    required this.hsnCode,
    required this.unit,
    required this.palletQty,
    required this.axleQty,
    required this.expectedReturnDate,
  });

  factory ChallanDetails.fromJson(Map<String, dynamic> json) {
    return ChallanDetails(
      vendorName: json['vendor_name'] ?? '',
      vendorAddress: json['vendor_address'] ?? '',
      gstinNo: json['gstin_no'] ?? '',
      panNo: json['pan_no'] ?? '',
      challanNo: json['challan_no'] ?? '',
      challanDate: json['challan_date'] ?? '',
      vehicleNo: json['vehicle_no'] ?? '',
      transporter: json['transporter'] ?? '',
      empCode: json['emp_code'] ?? '',
      empName: json['emp_name'] ?? '',
      materialCode: json['material_code'] ?? '',
      materialDescription: json['material_description'] ?? '',
      hsnCode: json['hsn_code'] ?? '',
      unit: json['unit'] ?? '',
      palletQty: json['pallet_qty']?.toString() ?? '',
      axleQty: json['axle_qty']?.toString() ?? '',
      expectedReturnDate: json['expected_return_date'] ?? '',
    );
  }
}
