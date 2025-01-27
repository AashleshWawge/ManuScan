import 'package:flutter/material.dart';
import 'create_account.dart';
import 'login_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;
  bool _disposed = false;
  final List<Map<String, dynamic>> _onboardingData = [
    {
      'image': 'assets/images/image1.png',
      'texts': [
        'Manage Inventory',
        'Track & organize your inventory with ease',
      ],
    },
    {
      'image': 'assets/images/image2.png',
      'texts': [
        'Image to Text Converter',
        'Upload your images and convert to text',
      ],
    },
    // Add more images and texts if needed
  ];

  @override
  void initState() {
    super.initState();
    _startOnboarding();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  _startOnboarding() async {
    while (!_disposed) {
      await Future.delayed(const Duration(seconds: 3), () {
        if (!_disposed) {
          setState(() {
            _currentIndex = (_currentIndex + 1) % _onboardingData.length;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Add white background
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 50,
              left: 20,
              child: Text(
                'WELCOME TO',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            Positioned(
              top: 70,
              left: 20,
              child: Text(
                'ManuScan',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Midnights on the Shore',
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  key: ValueKey<int>(_currentIndex),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          _onboardingData[_currentIndex]['image']!,
                          key: ValueKey<String>(
                              _onboardingData[_currentIndex]['image']!),
                        ),
                        const SizedBox(height: 20),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: Column(
                            key: ValueKey<int>(_currentIndex),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _onboardingData[_currentIndex]['texts'][0],
                                style: const TextStyle(
                                  color: Color.fromRGBO(27, 27, 30, 1),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'DMSans-VariableFont_opsz,wght',
                                ),
                              ),
                              Text(
                                _onboardingData[_currentIndex]['texts'][1],
                                style: const TextStyle(
                                  color: Color.fromRGBO(27, 27, 30, 1),
                                  fontSize: 18,
                                  fontFamily: 'Roboto-Regular',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 200),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Createaccount()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Color.fromRGBO(55, 63, 81, 1)),
                    child: const Text(
                      'CREATE ACCOUNT',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => login_account()),
                      );
                    },
                    style: TextButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Color.fromRGBO(216, 219, 226, 1),
                    ),
                    child: const Text(
                      'LOG IN',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
