import 'package:chatnote/Auth/login_controller.dart';
import 'package:chatnote/screens/note/controller/add_note_controller.dart';
import 'package:chatnote/screens/note/controller/note_controller.dart';
import 'package:chatnote/screens/note/controller/note_gridview_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  RxString email = "".obs;
  RxString proPic = "".obs;
  Rx<DocumentReference<Map<String, dynamic>>> doc =
      Rx<DocumentReference<Map<String, dynamic>>>(
          FirebaseFirestore.instance.collection("user").doc());

  userInfo() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        proPic.value = user.photoURL!;
        email.value = user.email!;

        doc.value =
            FirebaseFirestore.instance.collection("user").doc(email.value);

        print(email.value);
        print(doc.value);
      }
    } catch (e) {
      print("Error: $e");
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
    Get.lazyPut(() => LogInController(), fenix: true);
  }
}
