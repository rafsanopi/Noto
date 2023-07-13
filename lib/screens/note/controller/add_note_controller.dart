import 'dart:io';
import 'package:chatnote/root%20methods/snakbar_msg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../root methods/global.dart';

class AddNoteController extends GetxController {
  var titleTexteditingController = TextEditingController().obs;
  var descriptionTexteditingController = TextEditingController().obs;
  RxString notebookName = "All notes".obs;
  Rx<XFile?> pickedImage = Rx<XFile?>(null);
  RxList images = [].obs;
  RxInt onPageImageIndex = 0.obs;
  var userController = Get.find<UserController>();

  int getImageIndex(int index) {
    return onPageImageIndex.value = index;
  }

  pickImageAndUpload(XFile? photo) async {
    pickedImage.value = photo;

    images.add(File(pickedImage.value!.path));
    navigator!.pop();
  }

  saveOrUpdateNote(
      {required bool isUpdate,
      String? docID,
      bool? pin,
      bool? hasImage}) async {
    late String docId;
    final storageRef = FirebaseStorage.instance
        .ref(); // saving the image to firebasestorage then getting the download url and image name then again save those information to cloud firebase
    List<String> downloadUrls = [];
    List<String> imageNames = [];
    if (isUpdate == false) {
      try {
        await userController.doc.value.collection("userNotes").add({
          // Save Data to cloud firebase if its not updating
          "deleted": false,
          "notebook_name": ["All notes", notebookName.value],
          "pin": false,
          "share": false,
          "share_member_gmail": [],
          "reminder": "None",
          "img": false,
          "title": titleTexteditingController.value.text == ""
              ? "No title"
              : titleTexteditingController.value.text,
          "description": descriptionTexteditingController.value.text,
          "createdTime":
              DateFormat('hh:mm aaa yyyy MMMM dd').format(DateTime.now()),
        }).then((docRef) {
          docId = docRef.id;
        });

        for (var imageFile in images) {
          final imageName = DateTime.now().millisecondsSinceEpoch.toString();
          imageNames.add(imageName);
          final imagesRef = storageRef
              .child("noteImg")
              .child(userController.email.value)
              .child(docId)
              .child("$imageName.jpg");
          await imagesRef.putFile(imageFile);
          final downloadUrl = await imagesRef.getDownloadURL();
          downloadUrls.add(downloadUrl);
        }

        for (var i = 0; i < downloadUrls.length; i++) {
          var url = downloadUrls[i];
          var imageName = imageNames[
              i]; // Assuming the imageNames list contains the corresponding image names

          await userController.doc.value
              .collection("userNotes")
              .doc(docId)
              .collection("image")
              .add({
            "url": url,
            "imageName": "$imageName.jpg",
          });
          await userController.doc.value
              .collection("userNotes")
              .doc(docId)
              .update({
            "img": true,
          });
        }
        navigator!.pop();
      } on FirebaseException catch (msg) {
        GetSnakbarMsg.somethingWentWrong(msg: msg.message.toString());
      }
    } else if (isUpdate == true) {
      try {
        await userController.doc.value
            .collection("userNotes")
            .doc(docID)
            .update({
          // Save Data to cloud firebase if its not updating
          // "deleted": false,
          "pin": pin,
          //"share": false,
          //"share_member_gmail": [],
          // "reminder": "None",
          "img": hasImage,
          "title": titleTexteditingController.value.text == ""
              ? "No title"
              : titleTexteditingController.value.text,
          "description": descriptionTexteditingController.value.text,
          "createdTime":
              "edited ${DateFormat('hh:mm aaa yyyy MMMM dd').format(DateTime.now())}",
        });

        //Update Image's now
        if (images.isNotEmpty) {
          for (var imageFile in images) {
            final imageName = DateTime.now().millisecondsSinceEpoch.toString();
            imageNames.add(imageName);
            final imagesRef = storageRef
                .child("noteImg")
                .child(userController.email.value)
                .child(docID!)
                .child("$imageName.jpg");
            await imagesRef.putFile(imageFile);
            final downloadUrl = await imagesRef.getDownloadURL();
            downloadUrls.add(downloadUrl);
          }

          for (var i = 0; i < downloadUrls.length; i++) {
            var url = downloadUrls[i];
            var imageName = imageNames[
                i]; // Assuming the imageNames list contains the corresponding image names

            await userController.doc.value
                .collection("userNotes")
                .doc(docID!)
                .collection("image")
                .add({
              "url": url,
              "imageName": "$imageName.jpg",
            });
            await userController.doc.value
                .collection("userNotes")
                .doc(docID)
                .update({
              "img": true,
            });
          }
        }

        navigator!.pop();
      } on FirebaseException catch (msg) {
        GetSnakbarMsg.somethingWentWrong(msg: msg.message.toString());
      }
    }

    images.value = [];
    //
  }

  clearNote() {
    titleTexteditingController.value.clear();
    descriptionTexteditingController.value.clear();
  }
}
