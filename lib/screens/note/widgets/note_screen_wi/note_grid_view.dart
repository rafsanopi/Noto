import 'package:chatnote/screens/note/add_note_screen.dart';
import 'package:chatnote/screens/note/controller/note_gridview_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../Colors/colors.dart';
import '../../../../root methods/user_info.dart';
import '../../controller/add_note_controller.dart';

class NoteGridView extends StatelessWidget {
  const NoteGridView({super.key});

  double getMinHeight(int index) {
    switch (index % 5) {
      case 0:
        return 250;
      case 1:
        return 290;
      case 2:
        return 310;
      case 3:
        return 360;
      default:
        return 270;
    }
  }

  @override
  Widget build(BuildContext context) {
    var addNoteController = Get.put(AddNoteController());
    var noteGridViewController = Get.put(NoteGridViewController());

    return Expanded(
      child: Obx(() {
        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("user")
                .doc(Uf.email)
                .collection("userNotes")
                .where("notebook_name", arrayContainsAny: {
              addNoteController.notebookName.value
            }).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
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

              return MasonryGridView.count(
                itemCount: data.length,
                crossAxisCount: 2,
                itemBuilder: (context, index) {
                  var height = getMinHeight(index);
                  String id = data[index].id;
                  List<dynamic> imageList = data[index]["img"];
                  String title = data[index]["title"];
                  String description = data[index]["description"];
                  String time = data[index]["createdTime"];

                  return Padding(
                    padding: EdgeInsets.all(8.w),
                    child: GetBuilder<NoteGridViewController>(
                        builder: (controller) {
                      return InkWell(
                        onLongPress: () {
                          controller.longPressUpdate(true);
                          controller.selectedItemIndex.value = index;
                        },
                        onTap: () {
                          if (imageList.isNotEmpty) {
                            addNoteController.serverImage.value =
                                imageList; //save the image's from cloud firebase to show
                            addNoteController.currentImageUrl.value = imageList[
                                0]; // save the 0 image for deleting purpose in [ImageView]
                          }

                          Get.to(() => AddNoteScreen(
                                serverimg: imageList,
                                docId: id,
                                isupdate: true,
                                title: title,
                                description: description,
                                time: time,
                              ));
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          height: height,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: secondaryColor,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: -2,
                                    blurStyle: BlurStyle.outer,
                                    blurRadius: 10,
                                    color: primaryColor.withOpacity(.30))
                              ]),
                          child: noteGridViewController.onLongPress.value ==
                                      false ||
                                  controller.selectedItemIndex.value != index
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (imageList.isNotEmpty)
                                      SizedBox(
                                          height: 90.h,
                                          width: double.infinity,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: imageList.length,
                                            itemBuilder: (context, index) {
                                              return Image.network(
                                                imageList[index],
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          )),
                                    if (imageList.isNotEmpty)
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            title,
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w700,
                                                color: txtColor),
                                          ),
                                          if (data[index]["pin"] == true)
                                            SvgPicture.asset(
                                              "asset/other_img/pin.svg",
                                              height: 15.w,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                primaryColor, // Adjust the colors as needed
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                        ]),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        height: double.infinity,
                                        child: Text(
                                          description,
                                          maxLines: imageList.isNotEmpty
                                              ? 3
                                              : height ~/ 16.h,
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                              overflow: TextOverflow.ellipsis,
                                              color: txtColor),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            height: 20.h,
                                            width: 20.w,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: primaryColor,
                                                boxShadow: [
                                                  BoxShadow(
                                                      spreadRadius: 1,
                                                      blurRadius: 10,
                                                      offset:
                                                          const Offset(0, 4),
                                                      color: Colors.black
                                                          .withOpacity(0.25)),
                                                ]),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                child:
                                                    Image.network(Uf.proPic))),
                                        SizedBox(
                                          height: 20.h,
                                          width: 40.w,
                                          child: Text(
                                            time,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 7.sp,
                                              color: txtColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    LongPressItems(
                                      txt: "Delete",
                                      img: "trash",
                                      ontap: () {
                                        controller.deleteNote(id: id);
                                        controller.longPressUpdate(false);
                                      },
                                    ),
                                    LongPressItems(
                                      txt: "Pin",
                                      img: "pin",
                                      ontap: () {
                                        controller.updatePin(id: id);
                                        controller.longPressUpdate(false);
                                      },
                                    ),
                                    LongPressItems(
                                      txt: "Cancel",
                                      img: "close2",
                                      ontap: () {
                                        controller.longPressUpdate(false);
                                      },
                                    ),
                                  ],
                                ),
                        ),
                      );
                    }),
                  );
                },
              );
            });
      }),
    );
  }
}

class LongPressItems extends StatelessWidget {
  final VoidCallback ontap;
  final String txt;
  final String img;
  const LongPressItems(
      {super.key, required this.ontap, required this.txt, required this.img});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 6.h,
      ),
      child: InkWell(
        onTap: ontap,
        child: Container(
          width: double.infinity,
          height: 35.h,
          decoration: BoxDecoration(
              border: Border.all(color: primaryColor, width: 2),
              borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(txt),
                SvgPicture.asset(
                  "asset/other_img/$img.svg",
                  height: 20.w,
                  colorFilter: const ColorFilter.mode(
                    primaryColor, // Adjust the colors as needed
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
