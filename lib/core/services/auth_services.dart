import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<UserCredential> signInWithGoogle() async {
    // Start Google Sign-In
    final GoogleSignInAccount googleUser =
    await GoogleSignIn.instance.authenticate();

    // Get Google authentication token
    final GoogleSignInAuthentication googleAuth =
        googleUser.authentication;

    final String? idToken = googleAuth.idToken;

    // Make sure ID token exists
    if (idToken == null) {
      throw Exception('Google ID token is null.');
    }

    // Create Firebase credential
    final credential = GoogleAuthProvider.credential(
      idToken: idToken,
    );

    // Sign in with Firebase
    return await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
  }
}