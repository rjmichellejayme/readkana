import 'package:flutter/material.dart';
import 'package:readkana/screens/home_screen.dart';
import 'package:readkana/screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _fullNameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _termsAccepted = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _nicknameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2F0),
      body: SafeArea(
        child: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                const SizedBox(height: 50),
                // Get Started image and text
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/get_started.png',
                        width: 250,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Full name field
                _buildTextField(
                  controller: _fullNameController,
                  hintText: 'Full name',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                // Nickname field
                _buildTextField(
                  controller: _nicknameController,
                  hintText: 'Nickname',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                // Password field
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'Strong Password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 24),
                // Terms and conditions checkbox
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _termsAccepted,
                        onChanged: (value) {
                          setState(() {
                            _termsAccepted = value ?? false;
                          });
                        },
                        activeColor: const Color(0xFFDA6D8F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: const BorderSide(
                          color: Colors.grey,
                          width: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'By checking the box you agree to our ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Handle terms navigation
                      },
                      child: const Text(
                        'Terms',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFDA6D8F),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const Text(
                      ' and ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Handle conditions navigation
                      },
                      child: const Text(
                        'Conditions',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFDA6D8F),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const Text(
                      '.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Sign Up button
                ElevatedButton(
                  onPressed: _termsAccepted ? _handleSignUp : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDA6D8F),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        const Color(0xFFDA6D8F).withOpacity(0.5),
                    disabledForegroundColor: Colors.white60,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        size: 18,
                      ),
                    ],
                      ),
                    ),
                    const SizedBox(height: 16),
                // Continue as Guest button
                    OutlinedButton(
                  onPressed: _handleContinueAsGuest,
                      style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: const BorderSide(color: Colors.black26),
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                        ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Continue as Guest',
                        style: TextStyle(
                          fontSize: 16,
                      fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                // Already a member text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                    const Text(
                      'Already a member? ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    InkWell(
                      onTap: _navigateToLogin,
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFDA6D8F),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          suffixIcon: Icon(
            icon,
            color: Colors.grey,
            size: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  void _handleSignUp() {
    // Check if all fields are filled
    if (_fullNameController.text.isEmpty ||
        _nicknameController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Simulate account creation
    print('Signing up with:');
    print('Full Name: ${_fullNameController.text}');
    print('Nickname: ${_nicknameController.text}');
    print('Password: ${_passwordController.text}');

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Account created successfully! Please enter your details.'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate to login screen after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  void _handleContinueAsGuest() {
    // Navigate to your app's main screen as a guest
    print('Continuing as guest');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  void _navigateToLogin() {
    // Navigate to login screen
    print('Navigating to login screen');
    Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }
}
