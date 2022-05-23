import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  loginOrRegister() async {
    final googleSignIn = GoogleSignIn();
    var account = await googleSignIn.signIn();
    if (account != null) {
      var auth = await account.authentication;
      if (auth.accessToken != null && auth.idToken != null) {
        AuthCredential credential = GoogleAuthProvider.credential(
            idToken: auth.idToken, accessToken: auth.accessToken);
        var userCredential =
        await firebaseAuth.signInWithCredential(credential);
        return userCredential.user;
      }
    }
  }
}
