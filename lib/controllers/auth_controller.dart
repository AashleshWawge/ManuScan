// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../home_screen.dart';
import '../onboarding_screen.dart';

class AuthController extends GetxController {
  final _isLoggedIn = false.obs;
  final _currentUser = Rx<Map<String, dynamic>?>(null);
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  final _token = RxString('');

  bool get isLoggedIn => _isLoggedIn.value;
  Map<String, dynamic>? get currentUser => _currentUser.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  String get token => _token.value;

  Future<void> createAccount({
    required String displayName,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final response = await http
          .post(
            Uri.parse('http://localhost:8800/Registeration'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'displayName': displayName,
              'email': email,
              'password': password,
              'role': role,
            }),
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        _currentUser.value = {
          'displayName': displayName,
          'email': email,
          'role': role,
        };
        _isLoggedIn.value = true;
        Get.offAll(() => HomeScreen());
      } else {
        _errorMessage.value = 'Failed to create account';
      }
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      print('Sending POST request to http://localhost:8800/Login');
      print('Request body: ${jsonEncode(<String, String>{
            'user_name': email,
            'password': password,
          })}');

      final response = await http
          .post(
            Uri.parse('http://localhost:8800/Login'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'user_name': email,
              'password': password,
            }),
          )
          .timeout(Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Login successful: $responseData');
        _currentUser.value = {
          'user_id': responseData['user']['user_id'] ?? '',
          'user_name': responseData['user']['user_name'] ?? '',
        };
        // Store the token
        _token.value = responseData['token'] ?? '';
        Get.offAll(() => HomeScreen());
        _isLoggedIn.value = true;
      } else {
        final responseData = jsonDecode(response.body);
        print('Login failed: $responseData');
        _errorMessage.value = responseData['error'] ?? 'Failed to login';
      }
    } catch (e) {
      print('Exception: $e');
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  void logout() {
    _isLoggedIn.value = false;
    _currentUser.value = null;
    _token.value = ''; // Clear the token on logout
    Get.offAll(() => OnboardingScreen());
  }
}
