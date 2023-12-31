import 'package:chatnote/Colors/colors.dart';
import 'package:chatnote/root%20methods/snakbar_msg.dart';
import 'package:chatnote/root%20methods/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../nav_bar.dart';

class LogInController extends GetxController {
  RxBool login = false.obs;

  //
  Future<bool> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        login.value = true;
      }
    } on FirebaseAuthException {
      Get.snackbar("error", "Something went wrong",
          backgroundColor: homeBackground, colorText: secondaryColor);
      login.value = false;
    }
    return login.value;
  }

  void saveUserInfoOnLogIn() {
    Uf.currentUserInfo();
    var doc = FirebaseFirestore.instance.collection("user").doc(Uf.email);
    try {
      doc
          .collection("userInfo")
          .doc(Uf.email)
          .set({"name": Uf.username, "piclink": Uf.proPic, "email": Uf.email});
      // ignore: empty_catches
    } on FirebaseException catch (error) {
      GetSnakbarMsg.somethingWentWrong(msg: error.message!);
    } finally {
      Get.off(() => const NavBar());
    }
  }
}
