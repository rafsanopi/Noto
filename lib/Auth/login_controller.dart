import 'package:chatnote/Colors/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../nav_bar.dart';
import '../root methods/global.dart';
import '../root methods/snakbar_msg.dart';

class LogInController extends GetxController {
  var userController = Get.find<UserController>();

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
    var doc = FirebaseFirestore.instance
        .collection("userInfo")
        .doc(userController.userEmail.value);
    try {
      doc.set({
        "name": userController.userName.value,
        "piclink": userController.userProPic.value,
        "email": userController.userEmail.value,
        "uid": userController.userUid.value
      });
      // ignore: empty_catches
    } on FirebaseException catch (error) {
      GetSnakbarMsg.somethingWentWrong(msg: error.message!);
    } finally {
      Get.off(() => const NavBar());
    }
  }
}
