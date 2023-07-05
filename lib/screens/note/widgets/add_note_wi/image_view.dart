import 'package:chatnote/Colors/colors.dart';
import 'package:chatnote/root%20methods/back_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../root methods/user_info.dart';
import '../../controller/add_note_controller.dart';

class ImageView extends StatelessWidget {
  final String? docId;

  final bool isServerImage;
  const ImageView({
    super.key,
    this.docId,
    required this.isServerImage,
  });

  @override
  Widget build(BuildContext context) {
    var addnoteController = Get.put(AddNoteController());
    int newIndex;
    return Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.all(6.w),
            child: const CustomBackButton(),
          ),
        ),
        body: SafeArea(
          child: GetBuilder<AddNoteController>(builder: (controller) {
            return WillPopScope(
              onWillPop: () async {
                addnoteController.onPageImageIndex.value = 1;
                return true;
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 230.h,
                    // width: 400.w,
                    child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: isServerImage
                          ? addnoteController.serverImage.length
                          : addnoteController.images.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(6.w),
                          child: GestureDetector(
                              onTap: () {},
                              child: isServerImage
                                  ? Image.network(
                                      addnoteController.serverImage[index])
                                  : Image.file(
                                      addnoteController.images[index])),
                        );
                      },
                      onPageChanged: (index) {
                        addnoteController.currentImageUrl.value =
                            addnoteController.serverImage[index];
                        addnoteController.currentImageIndex.value = index;

                        newIndex = index + 1;
                        controller.getImageIndex(newIndex);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Obx(() {
                          return Text(
                            "${addnoteController.onPageImageIndex}/${isServerImage ? addnoteController.serverImage.length : addnoteController.images.length}",
                            style: TextStyle(
                                color: whiteWithOpacity, fontSize: 14.sp),
                          );
                        }),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: GestureDetector(
                      onTap: () async {
                        if (isServerImage) {
                          await FirebaseStorage.instance
                              .refFromURL(
                                  addnoteController.currentImageUrl.value)
                              .delete();
                          List<dynamic> newServerImage =
                              addnoteController.serverImage;
                          newServerImage.removeAt(
                              addnoteController.currentImageIndex.value);
                          Uf.doc
                              .collection("userNotes")
                              .doc(docId)
                              .update({"img": newServerImage});
                          // controller.update();

                          return;
                        }
                        int removedIndex =
                            addnoteController.onPageImageIndex.value - 1;
                        addnoteController.images.removeAt(removedIndex);

                        Uf.doc
                            .collection("userNotes")
                            .doc(docId)
                            .update({"img": addnoteController.serverImage});

                        // Update the onPageImageIndex to the current index if there are remaining images
                        if (addnoteController.images.isNotEmpty) {
                          addnoteController.onPageImageIndex.value =
                              addnoteController.images.length;
                        } else {
                          // If no images remaining, set onPageImageIndex to 0
                          addnoteController.onPageImageIndex.value = 0;
                          navigator!.pop();
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isServerImage ? "Delete" : "Remove",
                            style: TextStyle(
                                color: whiteWithOpacity, fontSize: 26.sp),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          SvgPicture.asset(
                            height: 15.h,
                            "asset/other_img/trash.svg",
                            colorFilter: const ColorFilter.mode(
                              Colors.red, // Adjust the colors as needed
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
        ));
  }
}
