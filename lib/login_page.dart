import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manuscan/home_screen.dart';
import 'package:manuscan/security/securityscreen.dart';
// import 'unused/forgot_password.dart';
// import 'unused/create_account.dart';
import 'controllers/auth_controller.dart';

class login_account extends StatefulWidget {
  const login_account({super.key});

  @override
  _login_account createState() => _login_account();
}

class _login_account extends State<login_account> {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;

  Future<void> _login() async {
    // Added validation for email format and wrong password error message
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter both email and password.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(20),
      );
      return;
    }

    // Validate email format
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(_emailController.text)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(20),
      );
      return;
    }

    // Simulate wrong password error for demonstration
    if (_emailController.text == 'test@example.com' &&
        _passwordController.text != 'password123') {
      Get.snackbar(
        'Error',
        'Wrong password for the entered email ID.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(20),
      );
      return;
    }

    if (_emailError != null || _passwordError != null) {
      return;
    }

    await authController.login(
      _emailController.text,
      _passwordController.text,
    );

    if (authController.isLoggedIn) {
      Get.snackbar(
        'Success',
        'Login Successful!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text("Log In"),
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(
                  color: Color.fromRGBO(88, 164, 176, 1),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/dana.png',
                      height: 40,
                    ),
                  ),
                ],
              ),
              body: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSubtitle(),
                      SizedBox(height: 100),
                      buildFormFields(),
                      // Commented out the 'Forgot Password' functionality
                      /*
                      buildForgotPassword(context),
                      */
                      buildFooter(),
                    ],
                  ),
                ),
              ),
            ),
            if (authController.isLoading)
              Container(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ));
  }

  Widget buildFormFields() {
    return Column(
      children: [
        buildFormField(
            'Email Address', false, Icons.email, _emailController, _emailError),
        buildFormField(
            'Password', true, Icons.lock, _passwordController, _passwordError),
      ],
    );
  }

  Widget buildFormField(String label, bool isPassword, IconData icon,
      TextEditingController controller, String? errorText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter your $label',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.white),
          ),
          filled: true,
          fillColor: Color(0xFFD8DBE2),
          prefixIcon: Icon(icon, color: const Color.fromRGBO(88, 164, 176, 1)),
          suffixIcon: isPassword ? null : null,
          errorText: errorText,
        ),
        onChanged: (value) {
          setState(() {
            if (label == 'Email Address') {
              _emailError = value.isEmpty ? 'Please enter your Email' : null;
            } else if (label == 'Password') {
              _passwordError =
                  value.length < 6 ? 'Require at least 6 characters' : null;
            }
          });
        },
      ),
    );
  }

  // Widget buildForgotPassword(BuildContext context) {
  //   return Align(
  //     alignment: Alignment.centerRight,
  //     child: Padding(
  //       padding: const EdgeInsets.only(top: 15.0),
  //       child: Text.rich(
  //         TextSpan(
  //           text: 'Forgot Password ?',
  //           style: TextStyle(
  //             color: Color(0xFF58A4B0),
  //             fontSize: 16,
  //             fontFamily: 'DM Sans',
  //             fontWeight: FontWeight.bold,
  //             decoration: TextDecoration.underline,
  //             decorationColor: Color(0xFF58A4B0),
  //           ),
  //           recognizer: TapGestureRecognizer()
  //             ..onTap = () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => ForgotPassword()),
  //               );
  //             },
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                // TextSpan(
                //   text: 'Dont have an account yet ?\n',
                //   style: TextStyle(
                //     color: Colors.black,
                //     fontSize: 18,
                //     fontFamily: 'DM Sans',
                //     height: 1.22,
                //   ),
                // ),
                // Commented out the 'Create an account' functionality
                /*
                TextSpan(
                  text: 'Create an account here',
                  style: TextStyle(
                    color: Color(0xFF58A4B0),
                    fontSize: 18,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF58A4B0),
                    height: 1.22,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Get.to(() =>
                        Createaccount()), // Updated to use GetX navigation
                ),
                */
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 220.0),
            child: GestureDetector(
              onTap: _login, // Changed to use _login method
              // onTap: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => SecurityScreen()),
              //   );
              // },
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(55, 63, 81, 1),
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0F323247),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Color(0x14323247),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'LOG IN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.bold,
                      height: 1.22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildSubtitle() {
  return Padding(
    padding: const EdgeInsets.only(top: 30.0),
    child: Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Welcome back !\n',
            style: TextStyle(
              color: Color(0xFF1B1B1E),
              fontSize: 18,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
              height: 1.22,
            ),
          ),
          TextSpan(
            text: 'Please login with your credentials',
            style: TextStyle(
              color: Color(0xFF1B1B1E),
              fontSize: 18,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w300,
              height: 1.22,
            ),
          ),
        ],
      ),
    ),
  );
}
