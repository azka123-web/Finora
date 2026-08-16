import '../../data/models/user_model.dart';
import 'local_storage_service.dart';

class LoginService {
  final LocalStorageService localStorage;

  LoginService(this.localStorage);

  // ================================================================
  // EMAIL / PASSWORD LOGIN
  // ================================================================

  Future<UserModel?> loginWithEmail(
      String email,
      String password,
      ) async {
    final user = localStorage.findUserByCredentials(
      email,
      password,
    );

    if (user == null) {
      return null;
    }

    // Save CURRENT logged-in user's session
    await localStorage.saveSession(user.email);

    return user;
  }
}