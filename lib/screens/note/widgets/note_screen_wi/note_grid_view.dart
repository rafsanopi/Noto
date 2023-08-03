import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnote/screens/note/controller/collaborate_controller.dart';
import 'package:chatnote/screens/note/controller/note_gridview_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../Colors/colors.dart';
import '../../../../root methods/global.dart';
import '../../controller/add_note_controller.dart';
import '../../note_screens/add_note_screen.dart';

class NoteGridView extends GetView<NoteGridViewController> {
  const NoteGridView({super.key});

  // double getMinHeight(int index) {
  //   switch (index % 5) {
  //     case 0:
  //       return 250;
  //     case 1:
  //       return 290;
  //     case 2:
  //       return 310;
  //     case 3:
  //       return 360;
  //     default:
  //       return 270;
  //   }
  // }

  double measureTextHeight(String text, TextStyle style, double width) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
        text: textSpan, maxLines: 10, textDirection: TextDirection.ltr);
    textPainter.layout(maxWidth: width);
    return textPainter.height;
  }

  @override
  Widget build(BuildContext context) {
    var addNoteController = Get.find<AddNoteController>();
    var userController = Get.find<UserController>();
    var collaborationController = Get.find<CollaborateController>();

//

//
    return Obx(() {
      String selectedNotebookName = addNoteController.notebookName.value;

      Query userNotesQuery = userController.noteDoc.value
          .collection("userNotes")
          .where("share_member_gmail",
              arrayContainsAny: [userController.userEmail.value])
          .orderBy('pin', descending: true)
          .orderBy("createdTime", descending: true);

      if (selectedNotebookName == "All notes") {
        // If "All notes" is selected, fetch all notes without filtering by notebook_name
        userNotesQuery = userNotesQuery;
      } else {
        // If a specific notebook is selected, filter by the selected notebook_name
        userNotesQuery = userNotesQuery.where("notebook_name",
            isEqualTo: selectedNotebookName);
      }
      return StreamBuilder(
          stream: userNotesQuery.snapshots(),
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

            return Expanded(
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return MasonryGridView.count(
                  itemCount: data.length,
                  crossAxisCount: 2,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  itemBuilder: (context, index) {
                    // var height = getMinHeight(index);
                    String id = data[index].id;
                    bool hasImage = data[index]["img"];
                    bool pin = data[index]["pin"];

                    String title = data[index]["title"];
                    String description = data[index]["description"];
                    String time = data[index]["createdTime"];
                    List shareMemberGmail = data[index]["share_member_gmail"];

                    //
                    double availableWidth = constraints.maxWidth;

                    // Calculate the height needed for title and description texts
                    final titleTextStyle =
                        Theme.of(context).textTheme.titleLarge;
                    final descriptionTextStyle = TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color:
                          txtColor, // Replace txtColor with your desired color
                    );

                    final titleTextHeight = measureTextHeight(
                        title, titleTextStyle!, availableWidth);
                    final descriptionTextHeight = measureTextHeight(
                        description, descriptionTextStyle, availableWidth);

                    // Calculate the height for the image (if available)
                    double imageHeight = hasImage == true ? 130.h : 20.h;

                    // Calculate the total height required for the card
                    double totalHeight =
                        titleTextHeight + descriptionTextHeight + imageHeight;
                    //

                    return Obx(() {
                      print(descriptionTextHeight);
                      return Padding(
                          padding: EdgeInsets.all(8.w),
                          child: InkWell(
                            onLongPress: () {
                              controller.longPressUpdate(true);
                              controller.selectedItemIndex.value = index;
                            },
                            onTap: () {
                              Get.to(() => AddNoteScreen(
                                    // serverimg: imageList,
                                    pin: pin,
                                    hasImage: hasImage,
                                    docId: id,
                                    isupdate: true,
                                    title: title,
                                    description: description,
                                    time: time,
                                    sharedUserGmails: shareMemberGmail,
                                  ));
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.w),
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
                              child: controller.onLongPress.value == false ||
                                      controller.selectedItemIndex.value !=
                                          index
                                  ? SizedBox(
                                      height: totalHeight + 40.h,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (hasImage)
                                            SizedBox(
                                                height: 90.h,
                                                width: double.infinity,
                                                child: StreamBuilder(
                                                    stream: userController
                                                        .noteDoc.value
                                                        .collection("userNotes")
                                                        .doc(id)
                                                        .collection("image")
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      }
                                                      if (snapshot.hasError ||
                                                          snapshot.data ==
                                                              null) {
                                                        return const Center(
                                                          child: Text(
                                                              "Something went wrong"),
                                                        );
                                                      }

                                                      if (!snapshot.hasData) {
                                                        return const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      }

                                                      var data =
                                                          snapshot.data!.docs;
                                                      return ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount: data.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        6.w),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  data[index]
                                                                      ["url"],
                                                              placeholder: (context,
                                                                      url) =>
                                                                  const FlutterLogo(),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  const Icon(Icons
                                                                      .error),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    })),
                                          if (hasImage)
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  title,
                                                  style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w700,
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
                                                maxLines:
                                                    (descriptionTextHeight)
                                                        .toInt(),
                                                overflow: TextOverflow.ellipsis,
                                                description,
                                                style: descriptionTextStyle,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // show shared note user image
                                              SharedUserImage(
                                                shareMemberGmail:
                                                    shareMemberGmail,
                                              ),
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
                                      ),
                                    )
                                  : SizedBox(
                                      height: 200.h,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          LongPressItems(
                                            txt: "Delete",
                                            img: "trash",
                                            ontap: () {
                                              if (userController
                                                      .userEmail.value ==
                                                  data[index]["ownerGmail"]) {
                                                controller.deleteNote(id: id);
                                                controller
                                                    .longPressUpdate(false);
                                              } else {
                                                collaborationController
                                                    .removeSharedGmail(
                                                        id,
                                                        userController
                                                            .userEmail.value);
                                              }
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
                            ),
                          ));
                    });
                  },
                );
              }),
            );
          });
    });
  }
}

class SharedUserImage extends StatelessWidget {
  // ignore: non_constant_identifier_names
  final List shareMemberGmail;
  final double height;
  final double width;
  const SharedUserImage({
    super.key,
    required this.shareMemberGmail,
    this.height = 20,
    this.width = 70,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("userInfo")
          .where("email", whereIn: shareMemberGmail)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }

        if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("No members to display."),
          );
        }

        var data = snapshot.data!.docs;
        if (data.length == 1) {
          return Container();
        }

        return Container(
            height: height.h,
            width: width.w,
            alignment: Alignment.center,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.all(1.w),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(data[index]["piclink"])),
              ),
            ));
      },
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
