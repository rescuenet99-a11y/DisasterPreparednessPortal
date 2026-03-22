import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/user_state.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _villageController = TextEditingController();

  bool _isGoogleLoading = false;

  void _login() {
    if (_formKey.currentState!.validate()) {
      UserState.name = _nameController.text;
      UserState.mobileNumber = _mobileController.text;
      UserState.villageName = _villageController.text;
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  Future<void> _loginWithGoogle() async {
      setState(() {
        _isGoogleLoading = true;
      });
      
      // Simulate network request for Google Sign-In
      await Future.delayed(const Duration(seconds: 2));

      UserState.name = 'John Doe (Google)';
      UserState.mobileNumber = '+91 9876543210';
      UserState.villageName = 'Google Account Linked';

      if (!mounted) return;
      
      setState(() {
        _isGoogleLoading = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.shield, size: 80, color: AppColors.primaryRed),
                  const SizedBox(height: 16),
                  const Text(
                    'Disaster Portal Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enter your details to continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Mobile Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter your mobile number' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _villageController,
                    decoration: const InputDecoration(
                      labelText: 'Village/City Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter your village/city name' : null,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Continue', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _isGoogleLoading ? null : _loginWithGoogle,
                    icon: _isGoogleLoading 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.email, color: Colors.red),
                    label: Text(_isGoogleLoading ? 'Signing in...' : 'Continue with Google', style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.black26),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
