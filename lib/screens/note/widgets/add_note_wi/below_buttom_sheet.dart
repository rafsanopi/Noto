import 'package:chatnote/root%20methods/global.dart';
import 'package:chatnote/screens/note/controller/add_note_controller.dart';
import 'package:chatnote/screens/note/controller/collaborate_controller.dart';
import 'package:chatnote/screens/note/note_screens/collaborate_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../Colors/colors.dart';
import 'custom_container.dart';

class BelowButtonBottomSheet extends StatelessWidget {
  final String docID;
  const BelowButtonBottomSheet({super.key, required this.docID});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final ImagePicker picker = ImagePicker();

    var userController = Get.find<UserController>();

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
            GetBuilder<CollaborateController>(builder: (collaborateController) {
              return MyContainerWithIconTxt(
                  icon: "asset/note_below_add/collaborate.svg",
                  ontap: () {
                    collaborateController
                        .getOwnerGmail(originalNoteId: docID)
                        .then((value) {
                      if (collaborateController.ownerGmail.value !=
                          userController.userEmail.value) {
                        Get.snackbar("Sorry", "You don't have the permission",
                            backgroundColor: orangeColor);
                        return;
                      } else {
                        collaborateController.docId.value = docID;
                        collaborateController.getShareUserGmails(docID);

                        Get.to(() => CollaborateScreen(
                              docID: docID,
                            ));
                      }
                    });
                  },
                  txt: "Collaborate");
            })
          ],
        ),
      );
    });
  }
}
