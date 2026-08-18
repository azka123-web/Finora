import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/signup_service.dart';
import '../../../core/validators/auth_validator.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;

  late SignupService signupService;

  @override
  void onInit() {
    super.onInit();

    signupService = Get.find<SignupService>();
  }

  // ================================================================
  // PASSWORD VISIBILITY
  // ================================================================

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value =
    !isConfirmPasswordHidden.value;
  }

  // ================================================================
  // SIGNUP
  // ================================================================

  Future<void> signup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // ============================================================
    // NAME VALIDATION
    // ============================================================

    final nameError = AuthValidator.validateName(name);

    if (nameError != null) {
      _showError(
        AppStrings.nameRequired,
        nameError,
      );
      return;
    }

    // ============================================================
    // EMAIL VALIDATION
    // ============================================================

    final emailError = AuthValidator.validateEmail(email);

    if (emailError != null) {
      _showError(
        AppStrings.emailError,
        emailError,
      );
      return;
    }

    // ============================================================
    // PASSWORD VALIDATION
    // ============================================================

    final passwordError =
    AuthValidator.validatePassword(password);

    if (passwordError != null) {
      _showError(
        AppStrings.passwordError,
        passwordError,
      );
      return;
    }

    // ============================================================
    // CONFIRM PASSWORD VALIDATION
    // ============================================================

    final confirmPasswordError =
    AuthValidator.validateConfirmPassword(
      password,
      confirmPassword,
    );

    if (confirmPasswordError != null) {
      _showError(
        AppStrings.passwordMismatch,
        confirmPasswordError,
      );
      return;
    }

    // ============================================================
    // CREATE ACCOUNT
    // ============================================================

    try {
      isLoading.value = true;

      // ----------------------------------------------------------
      // CHECK EXISTING EMAIL
      // ----------------------------------------------------------

      final emailAlreadyExists =
      signupService.emailExists(email);

      if (emailAlreadyExists) {
        _showError(
          AppStrings.accountExists,
          AppStrings.accountAlreadyExists,
        );
        return;
      }

      // ----------------------------------------------------------
      // CREATE USER
      // ----------------------------------------------------------

      await signupService.createUser(
        name: name,
        email: email,
        password: password,
      );

      // ----------------------------------------------------------
      // SUCCESS
      // ----------------------------------------------------------

      Get.snackbar(
        AppStrings.success,
        AppStrings.accountCreatedSuccessfully,
        snackPosition: SnackPosition.BOTTOM,
      );

      await Future.delayed(
        const Duration(milliseconds: 800),
      );

      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      // ----------------------------------------------------------
      // USER-FRIENDLY ERROR
      // ----------------------------------------------------------

      _showError(
        AppStrings.error,
        AppStrings.accountCreationError,
      );
    } finally {
      // ----------------------------------------------------------
      // ALWAYS STOP LOADING
      // ----------------------------------------------------------

      isLoading.value = false;
    }
  }

  // ================================================================
  // ERROR SNACKBAR
  // ================================================================

  void _showError(
      String title,
      String message,
      ) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // ================================================================
  // DISPOSE
  // ================================================================

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}