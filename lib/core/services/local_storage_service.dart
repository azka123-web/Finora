import 'package:bcrypt/bcrypt.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/models/user_model.dart';

class LocalStorageService {
  // ============================================================
  // USERS
  // ============================================================

  Box<UserModel> get usersBox =>
      Hive.box<UserModel>('usersBox');

  // ============================================================
  // SESSION
  // ============================================================

  Box get sessionBox =>
      Hive.box('sessionBox');

  // ============================================================
  // FIND USER BY EMAIL
  // ============================================================

  UserModel? findUserByEmail(String email) {
    try {
      final normalizedEmail =
      email.trim().toLowerCase();

      for (final user in usersBox.values) {
        if (user.email.toLowerCase() ==
            normalizedEmail) {
          return user;
        }
      }

      return null;
    } catch (e) {
      throw Exception(
        'Your saved account data could not be accessed. '
            'Please restart the app and try again.',
      );
    }
  }

  // ============================================================
  // CHECK EMAIL EXISTS
  // ============================================================

  bool emailExists(String email) {
    try {
      return findUserByEmail(email) != null;
    } catch (e) {
      throw Exception(
        'We could not check whether this email is already registered. '
            'Please try again.',
      );
    }
  }

  // ============================================================
  // CHECK LOGIN CREDENTIALS
  // ============================================================

  UserModel? findUserByCredentials(
      String email,
      String password,
      ) {
    try {
      final normalizedEmail =
      email.trim().toLowerCase();

      for (final user in usersBox.values) {
        if (user.email.toLowerCase() !=
            normalizedEmail) {
          continue;
        }

        // Verify the entered password against
        // the securely stored password hash.
        if (BCrypt.checkpw(
          password,
          user.password,
        )) {
          return user;
        }

        // Email exists, but password is incorrect.
        throw Exception(
          'The password you entered is incorrect. '
              'Please check your password and try again.',
        );
      }

      // No account was found with this email.
      return null;
    } catch (e) {
      if (e is Exception &&
          e.toString().contains(
            'The password you entered is incorrect.',
          )) {
        rethrow;
      }

      throw Exception(
        'We could not verify your login details. '
            'Please try again.',
      );
    }
  }

  // ============================================================
  // SAVE USER
  // ============================================================

  Future<void> saveUser(UserModel user) async {
    try {
      await usersBox.add(user);
    } catch (e) {
      throw Exception(
        'Your account could not be saved. '
            'Please try signing up again.',
      );
    }
  }

  // ============================================================
  // SAVE SESSION
  // ============================================================

  Future<void> saveSession(String email) async {
    try {
      await sessionBox.put(
        'isLoggedIn',
        true,
      );

      await sessionBox.put(
        'userEmail',
        email,
      );
    } catch (e) {
      throw Exception(
        'Your login was successful, but your session '
            'could not be saved. Please log in again.',
      );
    }
  }

  // ============================================================
  // CLEAR SESSION
  // ============================================================

  Future<void> clearSession() async {
    try {
      await sessionBox.put(
        'isLoggedIn',
        false,
      );

      await sessionBox.delete(
        'userEmail',
      );
    } catch (e) {
      throw Exception(
        'Your account could not be logged out properly. '
            'Please try again.',
      );
    }
  }

  // ============================================================
  // CURRENT USER EMAIL
  // ============================================================

  String? get currentUserEmail {
    try {
      final email =
      sessionBox.get('userEmail');

      if (email == null) {
        return null;
      }

      final value =
      email.toString().trim();

      return value.isEmpty ? null : value;
    } catch (e) {
      throw Exception(
        'Your current login session could not be read. '
            'Please log in again.',
      );
    }
  }
}