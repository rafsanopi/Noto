import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../root methods/snakbar_msg.dart';
import '../../../root methods/global.dart';

class NoteController extends GetxController {
  var userController = Get.find<UserController>();

  RxInt currentIndex = 0.obs;

  RxBool isRotated = false.obs;

  Rx<TextEditingController> noteBookNameController =
      TextEditingController().obs;

  RxList<String> noteBookItems = ["All notes"].obs;
  RxString timeOfDay = "".obs;
  RxString dayOfWeek = DateFormat('EEEE').format(DateTime.now()).obs;
  RxString todaysDate = DateFormat.yMMMMd().format(DateTime.now()).obs;

  RxBool isLoading = true.obs;

  timeStatus() {
    dayOfWeek;
    todaysDate;
    DateTime now = DateTime.now();
    TimeOfDay currentTime = TimeOfDay.fromDateTime(now);

    if (currentTime.hour >= 5 && currentTime.hour < 12) {
      timeOfDay.value = 'Morning';
    } else if (currentTime.hour >= 12 && currentTime.hour < 17) {
      timeOfDay.value = 'Afternoon';
    } else if (currentTime.hour >= 17 && currentTime.hour < 21) {
      timeOfDay.value = 'Evening';
    } else {
      timeOfDay.value = 'Night';
    }
  }

  getNoteBooks() async {
    // try {
    //   QuerySnapshot qn =
    //       await userController.doc.value.collection("notebooks").get();
    //   for (int i = 0; i < qn.docs.length; i++) {
    //     noteBookItems.add(qn.docs[i]["name"]);
    //   }

    //   isLoading.value = false;
    // } on Exception catch (e) {
    //   isLoading.value = true;
    // }
    print(userController.doc.value.id);
  }

  saveNotebooksName() async {
    try {
      await Global.doc
          .collection("notebooks")
          .doc(noteBookNameController.value.text)
          .set({
        "name": noteBookNameController.value.text.trim(),
        "time": todaysDate.value
      });
    } on FirebaseException catch (error) {
      GetSnakbarMsg.somethingWentWrong(msg: error.message!);
    } finally {
      navigator!.pop();
      noteBookNameController.value.clear();
    }
  }

  updateIndex(int index) {
    currentIndex.value = index;
    update();
  }

  void toggleRotation(AnimationController animationController) {
    isRotated.value = !isRotated.value;
    if (isRotated.value) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }

  Future<void> deleteDocumentWithValue(String value) async {
    // Get a reference to the Firestore collection

    // Query documents where the field array contains the specified value
    final QuerySnapshot snapshot = await Global.doc
        .collection("userNotes")
        .where('notebook_name', arrayContainsAny: [value]).get();

    // Iterate through the documents and delete each one
    for (final DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  @override
  void onReady() {
    getNoteBooks();

    super.onReady();
  }

  @override
  void onInit() {
    timeStatus();
    Global.userInfo();
    // getNoteBooks();
    super.onInit();
  }
}
