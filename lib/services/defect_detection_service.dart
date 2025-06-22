import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class DefectDetectionService {
  // Use different URLs based on the platform
  static String get baseUrl {
    if (Platform.isAndroid) {
      // For Android emulator, use 10.0.2.2 to access host machine
      // For physical device, replace with your computer's IP address
      // Example: return 'http://192.168.1.100:8000';
      return 'http://192.168.1.25:8000';
    } else if (Platform.isIOS) {
      // For iOS simulator, localhost should work
      return 'http://localhost:8000';
    } else {
      // For web or other platforms
      return 'http://localhost:8000';
    }
  }

  /// Run the defect detection script and return its output
  static Future<DefectScriptResult> runDefectDetectionScript() async {
    try {
      print('Connecting to: $baseUrl/run-defect-detection');

      // Make POST request to run the script
      var response = await http.post(
        Uri.parse('$baseUrl/run-defect-detection'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      var jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        return DefectScriptResult.fromJson(jsonData);
      } else {
        throw Exception(
            'Failed to run script: ${jsonData['detail'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Error connecting to server: $e');
      throw Exception('Error running defect detection script: $e');
    }
  }

  /// Analyze a pallet image for defects
  static Future<DefectAnalysisResult> analyzePalletImage(
      XFile imageFile) async {
    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/analyze-pallet'),
      );

      // Add the image file
      var imageBytes = await imageFile.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: 'pallet_image.jpg',
        ),
      );

      // Send the request
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonData = json.decode(responseData);

      if (response.statusCode == 200) {
        return DefectAnalysisResult.fromJson(jsonData['data']);
      } else {
        throw Exception(
            'Failed to analyze image: ${jsonData['detail'] ?? 'Unknown error'}');
      }
    } catch (e) {
      throw Exception('Error analyzing image: $e');
    }
  }

  /// Check if the defect detection service is available
  static Future<bool> isServiceAvailable() async {
    try {
      print('Checking service availability at: $baseUrl/health');
      var response = await http.get(Uri.parse('$baseUrl/health'));
      print('Health check response: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('Health check failed: $e');
      return false;
    }
  }
}

class DefectScriptResult {
  final bool success;
  final String output;
  final double timestamp;

  DefectScriptResult({
    required this.success,
    required this.output,
    required this.timestamp,
  });

  factory DefectScriptResult.fromJson(Map<String, dynamic> json) {
    return DefectScriptResult(
      success: json['success'] ?? false,
      output: json['output'] ?? '',
      timestamp: json['timestamp']?.toDouble() ?? 0.0,
    );
  }
}

class DefectAnalysisResult {
  final String decision;
  final String analysis;
  final String imageUrl;

  DefectAnalysisResult({
    required this.decision,
    required this.analysis,
    required this.imageUrl,
  });

  factory DefectAnalysisResult.fromJson(Map<String, dynamic> json) {
    return DefectAnalysisResult(
      decision: json['decision'] ?? 'UNDETERMINED',
      analysis: json['analysis'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }

  bool get hasDefect => decision == 'DEFECT';
  bool get isNoDefect => decision == 'NO DEFECT';
}
