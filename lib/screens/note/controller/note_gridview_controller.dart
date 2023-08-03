import 'package:chatnote/root%20methods/snakbar_msg.dart';
import 'package:chatnote/root%20methods/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoteGridViewController extends GetxController {
  RxBool onLongPress = false.obs;
  RxInt selectedItemIndex = 0.obs;
  var userController = Get.find<UserController>();

  longPressUpdate(bool value) {
    onLongPress.value = value;
    update();
  }

// Function to delete a subcollection
  Future<void> deleteImageCollection(String id) async {
    try {
      final DocumentReference userNoteDocRef =
          userController.noteDoc.value.collection("userNotes").doc(id);
      final CollectionReference imageRef = userNoteDocRef.collection("image");

      // Step 1: Get all documents in the "image" subcollection
      final QuerySnapshot imageSnapshot = await imageRef.get();

      // Step 2: Create a batch operation to delete documents
      final WriteBatch batch = FirebaseFirestore.instance.batch();

      // Step 3: Add the delete operation for each document in the batch
      for (var doc in imageSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Step 4: Commit the batch to delete all documents in the subcollection
      await batch.commit();

      // Step 5: Now you can delete the subcollection reference itself (optional)
      await userNoteDocRef.collection("userNotes").doc("image").delete();

      //Delete Image from cloud storage

      var parentRef = FirebaseStorage.instance
          .ref()
          .child("noteImg")
          .child(userController.userEmail.value)
          .child(id);

      // List all items (files and subdirectories) within the parent location
      var result = await parentRef.listAll();

      // Delete each item (file or subdirectory) found within the parent location
      for (var item in result.items) {
        await item.delete();
      }
    } on FirebaseException catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
    }
  }

  deleteNote({required String id}) async {
    try {
      userController.noteDoc.value.collection("userNotes").doc(id).delete();
      deleteImageCollection(id);
    } on FirebaseException catch (error) {
      GetSnakbarMsg.somethingWentWrong(msg: error.message.toString());
    }
  }

  updatePin({required String id}) async {
    var qn = await userController.noteDoc.value
        .collection("userNotes")
        .doc(id)
        .get();
    bool output = qn["pin"];

    try {
      userController.noteDoc.value.collection("userNotes").doc(id).update({
        "pin": output = !output,
      });
    } on FirebaseException catch (error) {
      GetSnakbarMsg.somethingWentWrong(msg: error.message.toString());
    }
  }
}
