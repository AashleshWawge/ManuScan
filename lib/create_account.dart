import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login_page.dart';

class Createaccount extends StatefulWidget {
  const Createaccount({super.key});

  @override
  _CreateaccountState createState() => _CreateaccountState();
}

class _CreateaccountState extends State<Createaccount> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _displayNameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Account"),
        backgroundColor:
            Color.fromARGB(255, 255, 255, 255), // Custom color for the app bar
      ),
      body: Container(
        color: Colors.white, // Add white background
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          // Ensure scrolling if content overflows
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSubtitle(),
              buildFormFields(),
              buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSubtitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Let’s get to know you !\n',
              style: TextStyle(
                color: Color(0xFF1B1B1E),
                fontSize: 18,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w700,
                height: 1.22,
              ),
            ),
            TextSpan(
              text: 'Enter your details to continue',
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

  Widget buildFormFields() {
    return Column(
      children: [
        buildFormField('Display Name', false, Icons.person,
            _displayNameController, _displayNameError),
        buildFormField(
            'Email Address', false, Icons.email, _emailController, _emailError),
        buildFormField(
            'Password', true, Icons.lock, _passwordController, _passwordError),
        buildFormField('Confirm Password', true, Icons.lock,
            _confirmPasswordController, _confirmPasswordError),
      ],
    );
  }

  Widget buildFormField(String label, bool isPassword, IconData icon,
      TextEditingController controller, String? errorText) {
    return Padding(
      padding: const EdgeInsets.only(top: 27.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword &&
            (label == 'Password'
                ? !_isPasswordVisible
                : !_isConfirmPasswordVisible),
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter your $label',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.white),
          ),
          filled: true,
          fillColor: Color(0xFFD8DBE2),
          prefixIcon: Icon(icon,
              color: const Color.fromRGBO(
                  88, 164, 176, 1)), // Change icon color here
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    label == 'Password'
                        ? (_isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off)
                        : (_isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                  ),
                  onPressed: () {
                    setState(() {
                      if (label == 'Password') {
                        _isPasswordVisible = !_isPasswordVisible;
                      } else {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      }
                    });
                  },
                )
              : null,
          errorText: errorText,
        ),
        onChanged: (value) {
          setState(() {
            if (label == 'Display Name') {
              _displayNameError =
                  value.isEmpty ? 'Please enter your display name' : null;
            } else if (label == 'Email Address') {
              _emailError = value.isEmpty ? 'Please enter your email' : null;
            } else if (label == 'Password') {
              _passwordError =
                  value.length < 6 ? 'Require at least 6 characters' : null;
            } else if (label == 'Confirm Password') {
              _confirmPasswordError = value != _passwordController.text
                  ? 'Passwords do not match'
                  : null;
            }
          });
        },
      ),
    );
  }

  Widget buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Already have an account?\n',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.bold,
                    height: 1.22,
                  ),
                ),
                TextSpan(
                  text: 'Login here',
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
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => login_account()),
                      );
                    },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: SizedBox(
              width: double.infinity,
              height: 66,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'By clicking the “CREATE ACCOUNT” button, you agree to',
                      style: TextStyle(
                        color: Color(0xFF1B1B1E),
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                        height: 1.22,
                      ),
                    ),
                    TextSpan(
                      text: ' Terms of use',
                      style: TextStyle(
                        color: Color(0xFF1B1B1E),
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                        height: 1.22,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          const url = 'https://www.google.com/';
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          } else {
                            throw 'Could not load $url';
                          }
                        },
                    ),
                    TextSpan(
                      text: ' and ',
                      style: TextStyle(
                        color: Color(0xFF1B1B1E),
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                        height: 1.22,
                      ),
                    ),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: Color(0xFF1B1B1E),
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                        height: 1.22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: GestureDetector(
              onTap: () {
                // Handle the account creation action
              },
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
                    'CREATE ACCOUNT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w400,
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
