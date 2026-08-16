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
    final normalizedEmail = email.trim().toLowerCase();

    for (final user in usersBox.values) {
      if (user.email.toLowerCase() == normalizedEmail) {
        return user;
      }
    }

    return null;
  }

  // ============================================================
  // CHECK EMAIL EXISTS
  // ============================================================

  bool emailExists(String email) {
    return findUserByEmail(email) != null;
  }

  // ============================================================
  // CHECK LOGIN CREDENTIALS
  // ============================================================

  UserModel? findUserByCredentials(
      String email,
      String password,
      ) {
    final normalizedEmail = email.trim().toLowerCase();

    for (final user in usersBox.values) {
      if (user.email.toLowerCase() != normalizedEmail) {
        continue;
      }

      if (BCrypt.checkpw(password, user.password)) {
        return user;
      }
    }

    return null;
  }

  // ============================================================
  // SAVE USER
  // ============================================================

  Future<void> saveUser(UserModel user) async {
    await usersBox.add(user);
  }

  // ============================================================
  // SAVE SESSION
  // ============================================================

  Future<void> saveSession(String email) async {
    await sessionBox.put('isLoggedIn', true);
    await sessionBox.put('userEmail', email);
  }

  // ============================================================
  // CLEAR SESSION
  // ============================================================

  Future<void> clearSession() async {
    await sessionBox.put('isLoggedIn', false);
    await sessionBox.delete('userEmail');
  }

  // ============================================================
  // CURRENT USER EMAIL
  // ============================================================

  String? get currentUserEmail {
    final email = sessionBox.get('userEmail');

    if (email == null) {
      return null;
    }

    final value = email.toString().trim();

    return value.isEmpty ? null : value;
  }
}