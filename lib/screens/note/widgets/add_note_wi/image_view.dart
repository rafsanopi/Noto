import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnote/Colors/colors.dart';
import 'package:chatnote/root%20methods/back_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../root methods/user_info.dart';
import '../../controller/add_note_controller.dart';

class ImageView extends StatefulWidget {
  final String docId;

  final bool isServerImage;
  const ImageView({
    super.key,
    this.docId = "",
    required this.isServerImage,
  });

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  var addnoteController = Get.put(AddNoteController());

  @override
  Widget build(BuildContext context) {
    int newIndex;
    var imageCollection = FirebaseFirestore.instance
        .collection("user")
        .doc(Uf.email)
        .collection("userNotes")
        .doc(widget.docId)
        .collection("image");

    //
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
                child: widget.isServerImage
                    ? StreamBuilder(
                        stream: imageCollection.snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError || snapshot.data == null) {
                            return const Center(
                              child: Text("Something went wrong"),
                            );
                          }

                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          var data = snapshot.data!.docs;
                          return Center(
                            child: PageView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.all(6.w),
                                  child: GestureDetector(
                                      onTap: () {
                                        //
                                        //
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: data[index]["url"],
                                            placeholder: (context, url) =>
                                                const FlutterLogo(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Obx(() {
                                                  return Text(
                                                    "${addnoteController.onPageImageIndex}/${data.length}",
                                                    style: TextStyle(
                                                        color: whiteWithOpacity,
                                                        fontSize: 14.sp),
                                                  );
                                                }),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.all(20.w),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  if (data.length == 1) {
                                                    //if index get 0 img input from main doc will be false to hide image
                                                    FirebaseFirestore.instance
                                                        .collection("user")
                                                        .doc(Uf.email)
                                                        .collection("userNotes")
                                                        .doc(widget.docId)
                                                        .update({"img": false});
                                                    navigator!.pop();
                                                  }

                                                  if (index >= 0 &&
                                                      index < data.length) {
                                                    //
                                                    String documentId =
                                                        data[index].id;
                                                    //
                                                    await imageCollection
                                                        .doc(documentId)
                                                        .delete();

                                                    var ref = FirebaseStorage
                                                        .instance
                                                        .ref();
                                                    ref
                                                        .child("noteImg")
                                                        .child(Uf.email)
                                                        .child(widget.docId)
                                                        .child(data[index]
                                                            ["imageName"])
                                                        .delete();
                                                  }
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                          color:
                                                              whiteWithOpacity,
                                                          fontSize: 26.sp),
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    SvgPicture.asset(
                                                      height: 15.h,
                                                      "asset/other_img/trash.svg",
                                                      colorFilter:
                                                          const ColorFilter
                                                              .mode(
                                                        Colors
                                                            .red, // Adjust the colors as needed
                                                        BlendMode.srcIn,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ],
                                      )),
                                );
                              },
                              onPageChanged: (index) {
                                newIndex = index + 1;
                                controller.getImageIndex(newIndex);
                              },
                            ),
                          );
                        })
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() {
                            return SizedBox(
                              height: MediaQuery.sizeOf(context).width,
                              width: double.infinity,
                              child: PageView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: addnoteController.images.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.all(6.w),
                                    child: GestureDetector(
                                        onTap: () {},
                                        child: Image.file(
                                            addnoteController.images[index])),
                                  );
                                },
                                onPageChanged: (index) {
                                  newIndex = index + 1;
                                  controller.getImageIndex(newIndex);
                                },
                              ),
                            );
                          }),
                          Padding(
                            padding: EdgeInsets.all(8.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Obx(() {
                                  return Text(
                                    "${addnoteController.onPageImageIndex}/${addnoteController.images.length}",
                                    style: TextStyle(
                                        color: whiteWithOpacity,
                                        fontSize: 14.sp),
                                  );
                                }),
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.all(20.w),
                              child: GestureDetector(
                                onTap: () async {
                                  int removedIndex =
                                      addnoteController.onPageImageIndex.value -
                                          1;
                                  addnoteController.images
                                      .removeAt(removedIndex);

                                  // Update the onPageImageIndex to the current index if there are remaining images
                                  if (addnoteController.images.isNotEmpty) {
                                    addnoteController.onPageImageIndex.value =
                                        addnoteController.images.length;
                                  } else {
                                    // If no images remaining, set onPageImageIndex to 0
                                    addnoteController.onPageImageIndex.value =
                                        0;
                                    navigator!.pop();
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Remove",
                                      style: TextStyle(
                                          color: whiteWithOpacity,
                                          fontSize: 26.sp),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    SvgPicture.asset(
                                      height: 15.h,
                                      "asset/other_img/trash.svg",
                                      colorFilter: const ColorFilter.mode(
                                        Colors
                                            .red, // Adjust the colors as needed
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ));
          }),
        ));
  }
}
