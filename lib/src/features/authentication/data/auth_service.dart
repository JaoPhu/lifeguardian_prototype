import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  // Google Sign In
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        if (kDebugMode) {
          print('--- Google Sign In Successful ---');
          print('Name: ${account.displayName}');
          print('Email: ${account.email}');
          print('ID: ${account.id}');
          print('---------------------------------');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Google Sign In Error: $error');
      }
    }
  }

  // Apple Sign In
  Future<void> signInWithApple() async {
    try {
      AuthorizationCredentialAppleID credential;

      if (defaultTargetPlatform == TargetPlatform.android) {
        // Android: Web Flow (Login via Apple ID password)
        // Note: This IS 'Web on App'. It requires Service ID & Redirect URI setup in Apple Developer Portal.
        credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
            clientId: 'com.example.lifeguardian.service', // Placeholder: Needs actual Service ID
            redirectUri: Uri.parse('https://example.com/callbacks/sign_in_with_apple'), // Placeholder
          ),
        );
      } else {
        // iOS: Native Flow (FaceID/TouchID/Device Info)
        credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );
      }

      if (kDebugMode) {
        print('--- Apple Sign In Successful ---');
        print('Name: ${credential.givenName} ${credential.familyName}');
        print('Email: ${credential.email}');
        print('User Identifier: ${credential.userIdentifier}');
        print('--------------------------------');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Apple Sign In Error: $error');
      }
    }
  }
}
