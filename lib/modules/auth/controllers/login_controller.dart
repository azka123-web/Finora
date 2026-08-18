import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/services/auth_services.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/validators/auth_validator.dart';
import '../../../data/models/user_model.dart';
import '../../../core/services/login_service.dart';
import '../../../core/constants/app_strings.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isLoading = false.obs;
  final isGoogleLoading = false.obs;

  late AuthService authService;
  late LocalStorageService localStorage;
  late LoginService loginService;

  @override
  void onInit() {
    super.onInit();

    authService = Get.find<AuthService>();
    localStorage = Get.find<LocalStorageService>();
    loginService = Get.find<LoginService>();
  }

  // ============================================================
  // PASSWORD VISIBILITY
  // ============================================================

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // ============================================================
  // NORMAL EMAIL / PASSWORD LOGIN
  // ============================================================

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    // ==========================================================
    // EMAIL VALIDATION
    // ==========================================================

    if (email.isEmpty) {
      Get.snackbar(
        AppStrings.emailError,
        AppStrings.enterYourEmailMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!AuthValidator.isValidEmail(email)) {
      Get.snackbar(
        AppStrings.emailError,
        AppStrings.invalidEmailMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // ==========================================================
    // PASSWORD VALIDATION
    // ==========================================================

    if (password.isEmpty) {
      Get.snackbar(
        AppStrings.passwordError,
        AppStrings.enterYourPassword,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      // ========================================================
      // FIND USER + VERIFY PASSWORD
      // ========================================================

      final UserModel? loggedInUser =
      await loginService.loginWithEmail(
        email,
        password,
      );

      // ========================================================
      // LOGIN SUCCESSFUL
      // ========================================================

      if (loggedInUser != null) {
        // Save CURRENT user's email in session
        await localStorage.saveSession(
          loggedInUser.email,
        );

        isLoading.value = false;

        Get.snackbar(
          AppStrings.loginSuccessful,
          '${AppStrings.welcomeBack}, ${loggedInUser.name}!',
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.offNamed(AppRoutes.home);

        return;
      }

      // ========================================================
      // INVALID CREDENTIALS
      // ========================================================

      isLoading.value = false;

      Get.snackbar(
        AppStrings.loginFailed,
        AppStrings.incorrectEmailOrPassword,
        snackPosition: SnackPosition.BOTTOM,
      );
    } on LoginServiceException catch (e) {
      isLoading.value = false;

      switch (e.error) {
        case LoginServiceError.storageFailure:
          Get.snackbar(
            AppStrings.error,
            AppStrings.storageError,
            snackPosition: SnackPosition.BOTTOM,
          );
          break;

        case LoginServiceError.sessionFailure:
          Get.snackbar(
            AppStrings.error,
            AppStrings.sessionError,
            snackPosition: SnackPosition.BOTTOM,
          );
          break;

        case LoginServiceError.unexpected:
          Get.snackbar(
            AppStrings.loginFailed,
            AppStrings.loginErrorMessage,
            snackPosition: SnackPosition.BOTTOM,
          );
          break;
      }
    } catch (_) {
      isLoading.value = false;

      Get.snackbar(
        AppStrings.loginFailed,
        AppStrings.loginErrorMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ============================================================
  // GOOGLE LOGIN
  // ============================================================

  Future<void> loginWithGoogle() async {
    try {
      isGoogleLoading.value = true;

      // Google + Firebase authentication
      final userCredential =
      await authService.signInWithGoogle();

      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Firebase user is null.');
      }

      // ========================================================
      // GET GOOGLE USER INFORMATION
      // ========================================================

      final String googleName =
      firebaseUser.displayName?.trim().isNotEmpty == true
          ? firebaseUser.displayName!.trim()
          : 'Google User';

      final String? googleEmail =
      firebaseUser.email?.trim();

      if (googleEmail == null || googleEmail.isEmpty) {
        throw Exception('Google email is unavailable.');
      }

      // ========================================================
      // CHECK IF USER ALREADY EXISTS
      // ========================================================

      final existingUser =
      localStorage.findUserByEmail(googleEmail);

      // ========================================================
      // CREATE LOCAL USER IF NOT EXISTS
      // ========================================================

      if (existingUser == null) {
        final newUser = UserModel(
          name: googleName,
          email: googleEmail,
          password: '',
        );

        await localStorage.saveUser(newUser);
      }

      // ========================================================
      // SAVE CURRENT GOOGLE USER SESSION
      // ========================================================

      await localStorage.saveSession(
        googleEmail,
      );

      isGoogleLoading.value = false;

      Get.snackbar(
        AppStrings.googleLoginSuccessful,
        '${AppStrings.welcome}, $googleName!',
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.offNamed(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      isGoogleLoading.value = false;

      Get.snackbar(
        AppStrings.googleLoginFailed,
        e.message ??
            AppStrings.firebaseAuthenticationFailed,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (_) {
      isGoogleLoading.value = false;

      Get.snackbar(
        AppStrings.googleLoginFailed,
        AppStrings.googleLoginErrorMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();

    super.onClose();
  }
}