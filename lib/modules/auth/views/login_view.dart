import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  // ============================================================
  // FINORA COLORS
  // ============================================================

  static const Color navy = Color(0xFF0F172A);
  static const Color green = Color(0xFF10B981);
  static const Color background = Color(0xFFF8FAFC);
  static const Color textGrey = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    // GetX se LoginController lena
    final controller = Get.find<LoginController>();

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

                  // ==================================================
                  // FINORA LOGO
                  // ==================================================

                  const SizedBox(height: 28),

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
                          'Smart money management',
                          style: TextStyle(
                            fontSize: 14,
                            color: textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ==================================================
                  // WELCOME
                  // ==================================================

                  const SizedBox(height: 50),

                  const Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: navy,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Manage your finances smarter.',
                    style: TextStyle(
                      fontSize: 16,
                      color: textGrey,
                    ),
                  ),

                  // ==================================================
                  // EMAIL
                  // ==================================================

                  const SizedBox(height: 36),

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
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      hintStyle: const TextStyle(
                        color: textGrey,
                      ),
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: textGrey,
                      ),
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
                    ),
                  ),

                  // ==================================================
                  // PASSWORD
                  // ==================================================

                  const SizedBox(height: 20),

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
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: const TextStyle(
                          color: textGrey,
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: textGrey,
                        ),
                        suffixIcon: IconButton(
                          onPressed:
                          controller.togglePasswordVisibility,
                          icon: Icon(
                            controller.isPasswordHidden.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: textGrey,
                          ),
                        ),
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
                      ),
                    ),
                  ),

                  // ==================================================
                  // FORGOT PASSWORD
                  // ==================================================

                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: green,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  // ==================================================
                  // LOGIN BUTTON
                  // ==================================================

                  const SizedBox(height: 12),

                  Obx(
                        () => SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: navy,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                          navy.withOpacity(0.6),
                          elevation: 2,
                          shadowColor: navy.withOpacity(0.20),
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
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ==================================================
                  // OR DIVIDER
                  // ==================================================

                  const SizedBox(height: 25),

                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: borderColor,
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                        ),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: textGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const Expanded(
                        child: Divider(
                          color: borderColor,
                        ),
                      ),
                    ],
                  ),

                  // ==================================================
                  // GOOGLE LOGIN
                  // ==================================================

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          color: borderColor,
                        ),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google_logo.png',
                            width: 22,
                            height: 22,
                          ),

                          const SizedBox(width: 12),

                          const Text(
                            'Continue with Google',
                            style: TextStyle(
                              color: navy,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ==================================================
                  // CREATE ACCOUNT
                  // ==================================================

                  const SizedBox(height: 25),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.signup);
                      },
                      child: const Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                            color: textGrey,
                          ),
                          children: [
                            TextSpan(
                              text: 'Create Account',
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
}