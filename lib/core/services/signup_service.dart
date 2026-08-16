import 'package:bcrypt/bcrypt.dart';

import '../../data/models/user_model.dart';
import 'local_storage_service.dart';

class SignupService {
  final LocalStorageService localStorage;

  SignupService(this.localStorage);

  // Check whether email already exists
  bool emailExists(String email) {
    return localStorage.emailExists(email);
  }

  // Create and save new user
  Future<void> createUser({
    required String name,
    required String email,
    required String password,
  }) async {
    // Hash password before storing it
    final hashedPassword = BCrypt.hashpw(
      password,
      BCrypt.gensalt(),
    );

    final user = UserModel(
      name: name,
      email: email,
      password: hashedPassword,
    );

    await localStorage.saveUser(user);

    // Create login session
    await localStorage.saveSession(user.email);
  }
}