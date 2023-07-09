import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Uf {
  static DocumentReference<Map<String, dynamic>> doc =
      FirebaseFirestore.instance.collection("user").doc(Uf.email);

  static String username = "";
  static String email = "";
  static String proPic = "";

  static currentUserInfo() {
    var user = FirebaseAuth.instance.currentUser;

    username = user!.displayName!;
    email = user.email!;
    proPic = user.photoURL!;
  }
}
