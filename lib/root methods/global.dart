import 'package:chatnote/Auth/login_controller.dart';
import 'package:chatnote/screens/note/controller/add_note_controller.dart';
import 'package:chatnote/screens/note/controller/collaborate_controller.dart';
import 'package:chatnote/screens/note/controller/note_controller.dart';
import 'package:chatnote/screens/note/controller/note_gridview_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  RxString userName = "".obs;
  RxString userEmail = "".obs;
  RxString userProPic = "".obs;
  RxString userUid = "".obs;

  Rx<DocumentReference<Map<String, dynamic>>> noteDoc =
      Rx<DocumentReference<Map<String, dynamic>>>(
          FirebaseFirestore.instance.collection("user").doc());

  userInfo() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userProPic.value = user.photoURL!;
        userEmail.value = user.email!;
        userName.value = user.displayName!;
        userUid.value = user.uid;

        noteDoc.value =
            FirebaseFirestore.instance.collection("user").doc("notes");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  onInit() {
    userInfo();
    super.onInit();
  }
}

class Global {
  static init() {
    Get.lazyPut(() => UserController(), fenix: true);
    Get.lazyPut(() => NoteController(), fenix: true);
    Get.lazyPut(() => AddNoteController(), fenix: true);
    Get.lazyPut(() => NoteGridViewController(), fenix: true);
    Get.lazyPut(() => CollaborateController(), fenix: true);
    Get.lazyPut(() => LogInController(), fenix: true);
  }
}
