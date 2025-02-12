import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'forgot_password.dart';
import 'create_account.dart';

class login_account extends StatefulWidget {
  const login_account({super.key});

  @override
  _login_account createState() => _login_account();
}

class _login_account extends State<login_account> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log In"),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        iconTheme: IconThemeData(
          color: Color.fromRGBO(
              88, 164, 176, 1), // Change back navigation button color here
        ),
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
              buildForgotPassword(),
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

  Widget buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Text.rich(
          TextSpan(
            text: 'Forgot Password ?',
            style: TextStyle(
              color: Color(0xFF58A4B0),
              fontSize: 16,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: Color(0xFF58A4B0),
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotPassword()),
                );
              },
          ),
        ),
      ),
    );
  }

  Widget buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Don’t have an account yet ?\n',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'DM Sans',
                    height: 1.22,
                  ),
                ),
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
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Createaccount()),
                      );
                    },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 130.0),
            child: GestureDetector(
              onTap: () {},
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
                      fontWeight: FontWeight.bold, // Bold the text
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
