import 'package:chatnote/root%20methods/snakbar_msg.dart';
import 'package:chatnote/root%20methods/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class NoteGridViewController extends GetxController {
  RxBool onLongPress = false.obs;
  RxInt selectedItemIndex = 0.obs;

  longPressUpdate(bool value) {
    onLongPress.value = value;
    update();
  }

  deleteNote({required String id}) {
    try {
      Uf.doc.collection("userNotes").doc(id).delete();
    } on FirebaseException catch (error) {
      GetSnakbarMsg.somethingWentWrong(msg: error.message.toString());
    }
  }

  updatePin({required String id}) async {
    var qn = await Uf.doc.collection("userNotes").doc(id).get();
    bool output = qn["pin"];

    try {
      Uf.doc.collection("userNotes").doc(id).update({
        "pin": output = !output,
      });
    } on FirebaseException catch (error) {
      GetSnakbarMsg.somethingWentWrong(msg: error.message.toString());
    }
  }
}
