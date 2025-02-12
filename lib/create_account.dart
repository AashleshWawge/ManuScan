import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
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
  String? _roleError;
  String? _selectedRole;

  Future<void> _testDbConnection() async {
    // MySQL connection settings
    final settings = ConnectionSettings(
      host: '10.0.2.220',
      user: 'root',
      password: 'root',
      port: 3306,
      db: 'danadb',
    );

    try {
      final conn = await MySqlConnection.connect(settings);
      await conn.close();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Database connection successful')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Database connection failed: $e')),
      );
    }
  }

  Future<void> _createAccount() async {
    final String displayName = _displayNameController.text;
    final String password = _passwordController.text;
    final String role = _selectedRole ?? 'user';

    // MySQL connection settings
    final settings = ConnectionSettings(
      host: '10.0.2.220',
      user: 'root',
      password: 'root',
      port: 3306,
      db: 'danadb',
    );

    try {
      final conn = await MySqlConnection.connect(settings);

      // Upsert query
      final result = await conn.query(
        '''
        INSERT INTO users (user_id, username, password, role, created_at)
        VALUES (1, ?, ?, ?, NOW())
        ON DUPLICATE KEY UPDATE
          username = VALUES(username),
          password = VALUES(password),
          role = VALUES(role),
          created_at = VALUES(created_at);
        ''',
        [displayName, password, role],
      );

      await conn.close();

      if (result.affectedRows! > 0) {
        // Handle successful account creation
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => login_account()),
        );
      } else {
        // Handle account creation failure
        setState(() {
          _emailError = 'Failed to create account';
        });
      }
    } catch (e) {
      // Handle connection or query error
      setState(() {
        _emailError = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Account"),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        iconTheme: IconThemeData(
          color: Color.fromRGBO(
              88, 164, 176, 1), // Change back navigation button color here
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.wifi),
            onPressed: _testDbConnection,
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
        buildRoleField(),
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
          prefixIcon: Icon(icon, color: const Color.fromRGBO(88, 164, 176, 1)),
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

  Widget buildRoleField() {
    return Padding(
      padding: const EdgeInsets.only(top: 27.0),
      child: DropdownButtonFormField<String>(
        value: _selectedRole,
        decoration: InputDecoration(
          labelText: 'Role',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.white),
          ),
          filled: true,
          fillColor: Color(0xFFD8DBE2),
          prefixIcon: _getRoleIconWidget(_selectedRole),
          errorText: _roleError,
        ),
        items: <String>['Admin/Manager Team', 'Security Team', 'Warehouse Team']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedRole = newValue;
            _roleError = null;
          });
        },
        onSaved: (String? newValue) {
          _selectedRole = newValue;
        },
      ),
    );
  }

  Widget _getRoleIconWidget(String? role) {
    switch (role) {
      case 'Admin/Manager Team':
        return Icon(Icons.admin_panel_settings,
            color: const Color.fromRGBO(88, 164, 176, 1));
      case 'Security Team':
        return Icon(Icons.security,
            color: const Color.fromRGBO(88, 164, 176, 1));
      case 'Warehouse Team':
        return Image.asset('assets/images/warehouse.png',
            color: const Color.fromRGBO(88, 164, 176, 1),
            width: 24,
            height: 24);
      default:
        return Icon(Icons.person_outline,
            color: const Color.fromRGBO(88, 164, 176, 1));
    }
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
            padding: const EdgeInsets.only(top: 10.0),
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
              onTap: _createAccount,
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
                    'CREATE ACCOUNT',
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
