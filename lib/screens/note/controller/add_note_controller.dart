import 'dart:io';
import 'package:chatnote/root%20methods/snakbar_msg.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../root methods/user_info.dart';

class AddNoteController extends GetxController {
  var titleTexteditingController = TextEditingController().obs;
  var descriptionTexteditingController = TextEditingController().obs;
  RxString notebookName = "All notes".obs;
  Rx<XFile?> pickedImage = Rx<XFile?>(null);
  RxList images = [].obs;
  RxList serverImage = [].obs;

  RxInt onPageImageIndex = 1.obs;
  RxString currentImageUrl = "".obs;
  RxInt currentImageIndex = 0.obs;

  getImageFilesFromNetwork(List<dynamic> imageUrls) async {
    for (var i = 0; i < imageUrls.length; i++) {
      var imageUrl = imageUrls[i];
      var response = await http.get(Uri.parse(imageUrl));
      var dir = await getTemporaryDirectory();
      var file = File('${dir.path}/temp_$i.jpg');
      await file.writeAsBytes(response.bodyBytes);
      images.add(file);
      print(images);
    }
  }

  int getImageIndex(int index) {
    return onPageImageIndex.value = index;
  }

  pickImageAndUpload(XFile? photo) async {
    pickedImage.value = photo;

    images.add(File(pickedImage.value!.path));
    navigator!.pop();
  }

  saveOrUpdateNote({required bool isUpdate}) async {
    late String docId;

    if (isUpdate == false) {
      try {
        await Uf.doc.collection("userNotes").add({
          "deleted": false,
          "notebook_name": ["All notes", notebookName.value],
          "pin": false,
          "share": false,
          "share_member_gmail": [],
          "reminder": "None",
          "img": [],
          "title": titleTexteditingController.value.text == ""
              ? "No title"
              : titleTexteditingController.value.text,
          "description": descriptionTexteditingController.value.text,
          "createdTime":
              DateFormat('hh:mm aaa yyyy MMMM dd').format(DateTime.now()),
        }).then((docRef) {
          docId = docRef.id;
        });

        final storageRef = FirebaseStorage.instance.ref();
        List<String> downloadUrls = [];

        for (var imageFile in images) {
          final imageName = DateTime.now().millisecondsSinceEpoch.toString();
          final imagesRef = storageRef
              .child("noteImg")
              .child(Uf.email)
              .child(docId)
              .child("$imageName.jpg");
          await imagesRef.putFile(imageFile);
          final downloadUrl = await imagesRef.getDownloadURL();
          downloadUrls.add(downloadUrl);
        }

        await Uf.doc.collection("userNotes").doc(docId).update({
          "img": downloadUrls,
        });
      } on FirebaseException catch (msg) {
        GetSnakbarMsg.somethingWentWrong(msg: msg.message.toString());
      }
    } else {}

    images.value = [];
    navigator!.pop();
  }

  clearNote() {
    titleTexteditingController.value.clear();
    descriptionTexteditingController.value.clear();
  }
}
