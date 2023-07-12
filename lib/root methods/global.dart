import 'package:chatnote/Auth/login_controller.dart';
import 'package:chatnote/screens/note/controller/add_note_controller.dart';
import 'package:chatnote/screens/note/controller/note_controller.dart';
import 'package:chatnote/screens/note/controller/note_gridview_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  RxString username = "".obs;
  RxString email = "".obs;
  RxString proPic = "".obs;
  Rx<DocumentReference<Map<String, dynamic>>> doc =
      Rx<DocumentReference<Map<String, dynamic>>>(
          FirebaseFirestore.instance.collection("user").doc());

  userInfo() {
    var user = FirebaseAuth.instance.currentUser;

    try {
      username.value = user!.displayName!;
      email.value = user.email!;
      proPic.value = user.photoURL!;
      doc.value =
          FirebaseFirestore.instance.collection("user").doc(email.value);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void onInit() {
    userInfo();
    super.onInit();
  }
}

class Global {
  static String username = "";
  static String email = "";
  static String proPic = "";

  static void userInfo() async {
    var user = FirebaseAuth.instance.currentUser;

    try {
      username = user!.displayName!;
      email = user.email!;
      proPic = user.photoURL!;
      // // print("email is: $email");
      // var firebase = await FirebaseFirestore.instance
      //     .collection("user")
      //     .doc(user.email)
      //     .collection("userInfo")
      //     .doc(user.email)
      //     .get();
      // email = firebase.data()?["email"];
    } on Exception catch (e) {
      print("Error is: $e");
    }

    //  print("Email is: $proPic");
  }

  static init() {
    //Note screen controller's
    Get.lazyPut(() => NoteController(), fenix: true);
    Get.lazyPut(() => AddNoteController(), fenix: true);
    Get.lazyPut(() => NoteGridViewController(), fenix: true);
    //login Screen
    Get.lazyPut(
      () => LogInController(),
    );
    //
    Get.lazyPut(() => UserController(), fenix: true);
  }

  static DocumentReference<Map<String, dynamic>> doc =
      FirebaseFirestore.instance.collection("user").doc(email);
}
