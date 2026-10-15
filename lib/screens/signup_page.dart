import 'package:flutter/material.dart';
import 'package:tracker1/resource/colors/app_colors.dart';
import '../services/storage_service.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback onSignupSuccess;
  final VoidCallback onNavigateToLogin;

  const SignupPage({
    super.key,
    required this.onSignupSuccess,
    required this.onNavigateToLogin,
  });

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final StorageService _storageService = StorageService();

  bool _isObscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final success = await _storageService.registerUser(name, email, password);
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully! Welcome to Expense Tracker.'),
            backgroundColor: AppColors.income,
          ),
        );
        widget.onSignupSuccess();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create account. Please try again.'),
            backgroundColor: AppColors.expense,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold: root screen container
      body: SafeArea(
        // SafeArea: keeps the content clear of status bar and notch areas
        child: Center(
          // Center: align the sign-up card in the middle of the screen
          child: SingleChildScrollView(
            // SingleChildScrollView: allows content to scroll on smaller screens
            padding: const EdgeInsets.all(24.0),
            child: Card(
            // Card: wraps the form in a modern rounded panel
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              // Padding: adds internal spacing around the form elements
              padding: const EdgeInsets.all(24.0),
              child: Form(
                // Form: groups validation and form fields together
                key: _formKey,
                child: Column(
                  // Column: stacks the widgets vertically from top to bottom
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.accent,
                      child: Icon(Icons.person_add, size: 36, color: AppColors.white),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      // Text: title heading of the sign-up screen
                      'Create Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      // Text: subtitle describing the purpose of the screen
                      'Sign up to track your finances effortlessly',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.gray500, fontSize: 13),
                    ),
                    const SizedBox(height: 20),

                    // TextFormField: full name input field
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Enter your name';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // TextFormField: email input field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Enter your email';
                        if (!val.contains('@')) return 'Enter a valid email address';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // TextFormField: password input field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _isObscure = !_isObscure),
                        ),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Enter a password';
                        if (val.length < 4) return 'Password must be at least 4 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // TextFormField: confirm password input field
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _isObscure,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock_reset),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) {
                        if (val != _passwordController.text) return 'Passwords do not match';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // ElevatedButton: submit button for creating the account
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleSignup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
                            )
                          : const Text(
                              'Create Account',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                    const SizedBox(height: 12),

                    // Row: place the login prompt and action link side by side
                    Row(
                      // Row: keeps the login prompt and action button side by side
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          // Text: asks whether the user already has an account
                          'Already have an account?',
                        ),
                        TextButton(
                          // TextButton: takes the user to the login screen
                          onPressed: widget.onNavigateToLogin,
                          child: const Text(
                            'Log In',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          ),
        ),
      ),
    );
  }
}
