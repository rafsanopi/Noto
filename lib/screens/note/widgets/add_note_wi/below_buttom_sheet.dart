import 'package:chatnote/screens/note/controller/add_note_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../Colors/colors.dart';
import 'custom_container.dart';

class BelowButtonBottomSheet extends StatelessWidget {
  const BelowButtonBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final ImagePicker picker = ImagePicker();
    // var addNoteController = Get.put(AddNoteController());
    return GetBuilder<AddNoteController>(builder: (controller) {
      return Container(
        height: height / 2,
        width: double.infinity,
        color: primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyContainerWithIconTxt(
                icon: "asset/note_below_add/camera.svg",
                ontap: () async {
                  final XFile? photo = await picker.pickImage(
                      source: ImageSource.camera, imageQuality: 20);
                  controller.pickImageAndUpload(photo);
                },
                txt: "Take a picture"),
            MyContainerWithIconTxt(
                icon: "asset/note_below_add/gallery.svg",
                ontap: () async {
                  final XFile? photo = await picker.pickImage(
                      source: ImageSource.gallery, imageQuality: 20);
                  controller.pickImageAndUpload(photo);
                },
                txt: "Add a picture"),
            MyContainerWithIconTxt(
                icon: "asset/note_below_add/recording.svg",
                ontap: () {},
                txt: "Recording"),
            MyContainerWithIconTxt(
                icon: "asset/note_below_add/drawing.svg",
                ontap: () {},
                txt: "Drawing"),
            MyContainerWithIconTxt(
                icon: "asset/note_below_add/collaborate.svg",
                ontap: () {},
                txt: "Collaborate"),
          ],
        ),
      );
    });
  }
}
