import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../data/models/user_model.dart';
import '../../../app/routes/app_routes.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value =
    !isConfirmPasswordHidden.value;
  }

  bool isValidEmail(String email) {
    return RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email);
  }

  bool isStrongPassword(String password) {
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password) &&
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
  }

  Future<void> signup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Name validation
    if (name.isEmpty) {
      Get.snackbar(
        'Name Required',
        'Please enter your name.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Email validation
    if (email.isEmpty) {
      Get.snackbar(
        'Email Required',
        'Please enter your email.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!isValidEmail(email)) {
      Get.snackbar(
        'Invalid Email',
        'Please enter a valid email address.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Password validation
    if (password.isEmpty) {
      Get.snackbar(
        'Password Required',
        'Please enter a password.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!isStrongPassword(password)) {
      Get.snackbar(
        'Weak Password',
        'Use 8+ characters with uppercase, lowercase, number and special character.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
      return;
    }

    // Confirm password validation
    if (confirmPassword.isEmpty) {
      Get.snackbar(
        'Confirm Password',
        'Please confirm your password.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'Password Mismatch',
        'Passwords do not match.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Get Hive users box
      final box = Hive.box<UserModel>('usersBox');

      // Check if email already exists
      final emailExists = box.values.any(
            (user) =>
        user.email.toLowerCase() == email.toLowerCase(),
      );

      if (emailExists) {
        isLoading.value = false;

        Get.snackbar(
          'Account Exists',
          'An account with this email already exists.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Create user
      final user = UserModel(
        name: name,
        email: email,
        password: password,
      );

      // Save user in Hive
      await box.add(user);

      // Create login session
      final sessionBox = Hive.box('sessionBox');

      await sessionBox.put('isLoggedIn', true);
      await sessionBox.put('userEmail', user.email);

      isLoading.value = false;

      Get.snackbar(
        'Success',
        'Account created successfully.',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Go directly to Home
      await Future.delayed(
        const Duration(milliseconds: 800),
      );

      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      isLoading.value = false;

      Get.snackbar(
        'Error',
        'Something went wrong while creating your account.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}