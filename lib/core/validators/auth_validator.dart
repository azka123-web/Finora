import '../constants/app_strings.dart';

class AuthValidator {
  // ================================================================
  // NAME VALIDATION
  // ================================================================

  static String? validateName(String name) {
    if (name.trim().isEmpty) {
      return AppStrings.enterName;
    }

    return null;
  }

  // ================================================================
  // EMAIL VALIDATION
  // ================================================================

  static String? validateEmail(String email) {
    if (email.trim().isEmpty) {
      return AppStrings.enterEmail;
    }

    if (!isValidEmail(email)) {
      return AppStrings.validEmail;
    }

    return null;
  }

  // ================================================================
  // PASSWORD VALIDATION
  // ================================================================

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return AppStrings.enterPassword;
    }

    if (!isStrongPassword(password)) {
      return AppStrings.strongPassword;
    }

    return null;
  }

  // ================================================================
  // CONFIRM PASSWORD VALIDATION
  // ================================================================

  static String? validateConfirmPassword(
      String password,
      String confirmPassword,
      ) {
    if (confirmPassword.isEmpty) {
      return AppStrings.confirmPassword;
    }

    if (password != confirmPassword) {
      return AppStrings.passwordsDoNotMatch;
    }

    return null;
  }

  // ================================================================
  // EMAIL FORMAT CHECK
  // ================================================================

  static bool isValidEmail(String email) {
    return RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email);
  }

  // ================================================================
  // PASSWORD STRENGTH CHECK
  // ================================================================

  static bool isStrongPassword(String password) {
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password) &&
        RegExp(
          r'[!@#$%^&*(),.?":{}|<>]',
        ).hasMatch(password);
  }
}