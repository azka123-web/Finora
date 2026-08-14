import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/signup_controller.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  static const Color navy = Color(0xFF0F172A);
  static const Color green = Color(0xFF10B981);
  static const Color background = Color(0xFFF8FAFC);
  static const Color textGrey = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: background,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 28),

                  // Logo
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: navy,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet_outlined,
                            color: green,
                            size: 34,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'FINORA',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.5,
                            color: navy,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Start managing your money smarter',
                          style: TextStyle(
                            fontSize: 14,
                            color: textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 38),

                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: navy,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Create your account to get started.',
                    style: TextStyle(
                      fontSize: 16,
                      color: textGrey,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Name
                  const Text(
                    'Full Name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: navy,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: controller.nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: _inputDecoration(
                      hint: 'Enter your full name',
                      icon: Icons.person_outline,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Email
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: navy,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration(
                      hint: 'Enter your email',
                      icon: Icons.email_outlined,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Password
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: navy,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Obx(
                        () => TextField(
                      controller: controller.passwordController,
                      obscureText: controller.isPasswordHidden.value,
                      decoration: _inputDecoration(
                        hint: 'Create a strong password',
                        icon: Icons.lock_outline,
                        suffix: IconButton(
                          onPressed:
                          controller.togglePasswordVisibility,
                          icon: Icon(
                            controller.isPasswordHidden.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: textGrey,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Confirm Password
                  const Text(
                    'Confirm Password',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: navy,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Obx(
                        () => TextField(
                      controller:
                      controller.confirmPasswordController,
                      obscureText:
                      controller.isConfirmPasswordHidden.value,
                      decoration: _inputDecoration(
                        hint: 'Confirm your password',
                        icon: Icons.lock_outline,
                        suffix: IconButton(
                          onPressed: controller
                              .toggleConfirmPasswordVisibility,
                          icon: Icon(
                            controller.isConfirmPasswordHidden.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: textGrey,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Create Account Button
                  Obx(
                        () => SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.signup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: navy,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                          navy.withOpacity(0.6),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                            : const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Login
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text.rich(
                        TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            color: textGrey,
                          ),
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                color: green,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: textGrey,
      ),
      prefixIcon: Icon(
        icon,
        color: textGrey,
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: borderColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: green,
          width: 1.5,
        ),
      ),
    );
  }
}