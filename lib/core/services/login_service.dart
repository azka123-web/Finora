import '../../data/models/user_model.dart';
import 'local_storage_service.dart';

// ================================================================
// LOGIN SERVICE EXCEPTION
// ================================================================

enum LoginServiceError {
  storageFailure,
  sessionFailure,
  unexpected,
}

class LoginServiceException implements Exception {
  final LoginServiceError error;

  const LoginServiceException(this.error);
}

// ================================================================
// LOGIN SERVICE
// ================================================================

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
    UserModel? user;

    // --------------------------------------------------------------
    // FIND USER
    // --------------------------------------------------------------

    try {
      user = localStorage.findUserByCredentials(
        email,
        password,
      );
    } on LoginServiceException {
      rethrow;
    } catch (_) {
      throw const LoginServiceException(
        LoginServiceError.storageFailure,
      );
    }

    // --------------------------------------------------------------
    // INVALID CREDENTIALS
    // --------------------------------------------------------------

    if (user == null) {
      return null;
    }

    // --------------------------------------------------------------
    // SAVE CURRENT LOGGED-IN USER SESSION
    // --------------------------------------------------------------

    try {
      await localStorage.saveSession(user.email);
    } on LoginServiceException {
      rethrow;
    } catch (_) {
      throw const LoginServiceException(
        LoginServiceError.sessionFailure,
      );
    }

    return user;
  }
}