import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum SocialAuthType { google, apple }

class SocialAuth {
  String? email;
  String? name;
  String? userName;
  String? socialId;
  SocialAuthType? socialFlag;
  String? image;

  SocialAuth({this.email, this.name, this.userName, this.socialId});

  Future<bool> doGoogleLogin({bool isLogout = false}) async {
    socialFlag = SocialAuthType.google;
    bool isLogin = false;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    if (isLogout) {
      if (await _googleSignIn.isSignedIn()) isLogin = false;
      return isLogin;
    }
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final User? user =
          (await _auth.signInWithCredential(credential)).user;
      this.email = user?.email!;
      this.name = user?.displayName!;
      this.socialId = user?.uid;
      return isLogin = true;
    }

    return isLogin;
  }

  Future<void> googleSignOut() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();
  }

  Future<bool> doAppleLogin({bool isLogout = false}) async {
    bool isLogin = false;

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: "nonce",
      );
      print('credentail ${credential.userIdentifier}');
      print('credentail ${credential.userIdentifier.toString()}');

      name = credential.givenName;
      email = credential.email;
      socialId = credential.userIdentifier.toString();
      isLogin = true;
    } catch (e) {
      print(e);
    }
    return isLogin;
  }
}
