import 'dart:io' show Platform;
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInUtil {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email', 'profile'
    ],
    serverClientId: '848528389134-l2d7nl15upjh6ir0k2pfo2kncbjr564t.apps.googleusercontent.com',
    clientId: Platform.isIOS
      ? '848528389134-9j0l51uoitblk61sfacsb5kd525v7i47.apps.googleusercontent.com'
      : null,
  );

  Future<GoogleSignInAccount?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      return account;
    } catch (error) {
      print('Google Sign-In error: $error');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}