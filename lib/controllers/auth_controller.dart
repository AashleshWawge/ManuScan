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
  final RxString username = 'Security Guard'.obs;

  // Change from RxString to getter/setter pattern
  final _firstName = RxString('Security Guard');
  String get firstName => _firstName.value;
  set firstName(String value) => _firstName.value = value;

  final RxString _lastName = ''.obs;
  final RxString _email = ''.obs;
  final RxString _role = ''.obs;

  bool get isLoggedIn => _isLoggedIn.value;
  Map<String, dynamic>? get currentUser => _currentUser.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  String get token => _token.value;
  String get userFirstName => firstName;

  String get lastName => _lastName.value;
  String get email => _email.value;
  String get role => _role.value;

  @override
  void onInit() {
    super.onInit();
    // Remove automatic login bypass - start with no user logged in
    _firstName.value = '';
    _lastName.value = '';
    _email.value = '';
    _role.value = '';
    _isLoggedIn.value = false;
    _currentUser.value = null;
    print('AuthController initialized - no user logged in');
    checkAuth();
  }

  void checkAuth() {
    // Add your auth check logic here
    print('checkAuth called - user role: ${_role.value}');
    print(
        'checkAuth called - currentUser role: ${_currentUser.value?['role']}');
    print('checkAuth called - isLoggedIn: ${_isLoggedIn.value}');
    print('checkAuth called - firstName: ${_firstName.value}');
    // Ensure no navigation happens here
    print('checkAuth completed - no navigation triggered');
  }

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
        // Implement role-based navigation for account creation
        final userRole = role;
        if (userRole == 'Security guard') {
          Get.offNamed('/security');
          print(
              'Account created - navigating to SecurityScreen for Security guard role');
        } else {
          Get.offNamed('/home');
          print('Account created - navigating to HomeScreen for other roles');
        }
      } else {
        _errorMessage.value = 'Failed to create account';
      }
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  // Update login method to properly set firstName
  Future<void> login(String email, String password) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      print('Login request for user: $email');

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

      print('Login response: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _currentUser.value = responseData['user'];

        if (responseData['user'] != null) {
          final userData = responseData['user'] as Map<String, dynamic>;
          _firstName.value = userData['first_name'] ?? 'Security Guard';
          print('Set firstName to: ${firstName}');
        }

        _isLoggedIn.value = true;
        // Implement role-based navigation
        final userRole = responseData['user']?['role'] ?? 'user';
        if (userRole == 'Security guard') {
          Get.offNamed('/security');
          print(
              'Login successful - navigating to SecurityScreen for Security guard role');
        } else {
          Get.offNamed('/home');
          print('Login successful - navigating to HomeScreen for other roles');
        }
      } else {
        final responseData = jsonDecode(response.body);
        _errorMessage.value = responseData['error'] ?? 'Failed to login';
      }
    } catch (e) {
      print('Login error: $e');
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  void logout() {
    _isLoggedIn.value = false;
    _currentUser.value = null;
    _token.value = ''; // Clear the token on logout
    // Restore navigation functionality
    Get.offAll(() => OnboardingScreen());
    print('Logout - navigating to OnboardingScreen');
  }

  // Update setUserData method
  void setUserData({
    required String firstName,
    required String lastName,
    required String email,
    required String role,
  }) {
    _firstName.value = firstName;
    _lastName.value = lastName;
    _email.value = email;
    _role.value = role;
  }

  // Method to clear user data on logout
  void clearUserData() {
    _firstName.value = '';
    _lastName.value = '';
    _email.value = '';
    _role.value = '';
  }
}
