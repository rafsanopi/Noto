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
  void onReady() {
    userInfo();

    super.onReady();
  }

  @override
  void onInit() {
    userInfo();
    super.onInit();
  }
}

class Global {
  static init() {
    //Note screen controller's
    Get.lazyPut(() => NoteController(), fenix: true);
    Get.lazyPut(() => AddNoteController(), fenix: true);
    Get.lazyPut(() => NoteGridViewController(), fenix: true);
    //login Screen
    Get.lazyPut(() => LogInController(), fenix: false);
    //
    Get.lazyPut(() => UserController(), fenix: true);
  }
}
