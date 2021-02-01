import 'package:EasyChat/screens/home.dart';
import 'package:EasyChat/services/database.dart';
import 'package:EasyChat/services/sharedprefhelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    UserCredential result =
        await _firebaseAuth.signInWithCredential(credential);

    User userDetails = result.user;

    if (result != null) {
      SharedPrefHelper().saveUserId(userDetails.uid);
      SharedPrefHelper().saveUserName(userDetails.email.split("@")[0]);
      SharedPrefHelper().saveDisplayName(userDetails.displayName);
      SharedPrefHelper().saveUserEmail(userDetails.email);
      SharedPrefHelper().saveUserProfilePic(userDetails.photoURL);

      Map<String, dynamic> userInfoMap = {
        "userId": userDetails.uid,
        "userName": userDetails.email.split("@")[0],
        "displayName": userDetails.displayName,
        "userEmail": userDetails.email,
        "userProfilePic": userDetails.photoURL,
      };

      DatabaseMethods()
          .addUserInfoToDB(userDetails.uid, userInfoMap)
          .then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      });
    }
  }

  Future signOut() async {
    auth.signOut();
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}
