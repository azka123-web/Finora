import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../data/models/user_model.dart';
import '../../../app/routes/app_routes.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  bool isValidEmail(String email) {
    return RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email);
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

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
        'Please enter your password.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Get Hive users box
      final box = Hive.box<UserModel>('usersBox');

      // Find matching user
      UserModel? loggedInUser;

      for (final user in box.values) {
        if (user.email.toLowerCase() == email.toLowerCase() &&
            user.password == password) {
          loggedInUser = user;
          break;
        }
      }

      // Login successful
      if (loggedInUser != null) {
        final sessionBox = Hive.box('sessionBox');

        await sessionBox.put('isLoggedIn', true);
        await sessionBox.put('userEmail', loggedInUser.email);

        isLoading.value = false;

        Get.snackbar(
          'Login Successful',
          'Welcome back, ${loggedInUser.name}!',
          snackPosition: SnackPosition.BOTTOM,
        );

        // Go to Home
        Get.offNamed(AppRoutes.home);

        return;
      }

      isLoading.value = false;

      // Invalid credentials
      Get.snackbar(
        'Login Failed',
        'Incorrect email or password.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      isLoading.value = false;

      Get.snackbar(
        'Error',
        'Something went wrong while logging in.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();

    super.onClose();
  }
}