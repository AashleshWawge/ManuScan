import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  _ForgotPassword createState() => _ForgotPassword();
}

class _ForgotPassword extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
        backgroundColor:
            Color.fromARGB(255, 255, 255, 255), // Custom color for the app bar
        iconTheme: IconThemeData(
          color: Color.fromRGBO(
              88, 164, 176, 1), // Change back navigation button color here
        ),
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
              SizedBox(
                  height: 20), // Add space between subtitle and form fields
              buildFormFields(),
              buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSubtitle() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text:
                    'Please enter your account’s email address\nand we will send you a link\nto reset your password.',
                style: TextStyle(
                  color: Color(0xFF1B1B1E),
                  fontSize: 17,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w300,
                  height: 1.22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFormFields() {
    return Column(
      children: [
        buildFormField(
            'Email', false, Icons.email, _emailController, _emailError),
      ],
    );
  }

  Widget buildFormField(String label, bool isPassword, IconData icon,
      TextEditingController controller, String? errorText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 75.0),
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
          prefixIcon: Icon(icon,
              color: const Color.fromRGBO(
                  88, 164, 176, 1)), // Change icon color here
          suffixIcon: isPassword ? null : null,
          errorText: errorText,
        ),
        onChanged: (value) {
          setState(() {
            if (label == 'Email Address') {
              _emailError = value.isEmpty ? 'Please enter your Email' : null;
            }
          });
        },
      ),
    );
  }

  Widget buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(top: 170.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 130.0),
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
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'SUBMIT',
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
