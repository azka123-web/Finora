import 'package:bcrypt/bcrypt.dart';

import '../../data/models/user_model.dart';
import 'local_storage_service.dart';

class SignupService {
  final LocalStorageService localStorage;

  SignupService(this.localStorage);

  // ================================================================
  // CHECK EMAIL
  // ================================================================

  bool emailExists(String email) {
    try {
      return localStorage.emailExists(email);
    } catch (e) {
      throw Exception(
        'Unable to check whether this email is already registered.',
      );
    }
  }

  // ================================================================
  // CREATE USER
  // ================================================================

  Future<void> createUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // ============================================================
      // HASH PASSWORD
      // ============================================================

      final hashedPassword = BCrypt.hashpw(
        password,
        BCrypt.gensalt(),
      );

      // ============================================================
      // CREATE USER
      // ============================================================

      final user = UserModel(
        name: name,
        email: email,
        password: hashedPassword,
      );

      // ============================================================
      // SAVE USER
      // ============================================================

      await localStorage.saveUser(user);

      // ============================================================
      // CREATE LOGIN SESSION
      // ============================================================

      await localStorage.saveSession(user.email);
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception(
        'Unable to create your account. Please try again.',
      );
    }
  }
}