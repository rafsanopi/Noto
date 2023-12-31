import 'package:chatnote/Colors/colors.dart';
import 'package:chatnote/root%20methods/back_button.dart';
import 'package:chatnote/root%20methods/user_info.dart';
import 'package:chatnote/screens/note/controller/add_note_controller.dart';
import 'package:chatnote/screens/note/widgets/add_note_wi/below_buttom_sheet.dart';
import 'package:chatnote/screens/note/widgets/add_note_wi/image_view.dart';
import 'package:chatnote/screens/note/widgets/add_note_wi/top_buttom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AddNoteScreen extends StatelessWidget {
  final bool isupdate;
  final String? docId;
  final String? title;
  final String? description;
  final String? time;
  final List<dynamic> serverimg;

  const AddNoteScreen({
    super.key,
    this.docId,
    this.title,
    this.description,
    this.isupdate = false,
    this.time,
    this.serverimg = const [],
  });
  @override
  Widget build(BuildContext context) {
    var addnoteController = Get.put(AddNoteController());

    return Scaffold(
      extendBody: false,
      body: GetBuilder<AddNoteController>(builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.onPageImageIndex.value = 1;
            controller.images.value = [];
            controller.descriptionTexteditingController.value.clear();
            addnoteController.titleTexteditingController.value.clear();

            return true;
          },
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: homeBackground,
            child: SafeArea(
                child: Padding(
              padding: EdgeInsets.all(6.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //
                      //back button
                      //
                      const CustomBackButton(),
                      //
                      //Reminder button
                      //
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: 35.h,
                          width: 120.w,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.w),
                              border:
                                  Border.all(color: primaryColor, width: 3)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SvgPicture.asset(
                                height: 15.h,
                                "asset/other_img/clock.svg",
                                colorFilter: const ColorFilter.mode(
                                  primaryColor, // Adjust the colors as needed
                                  BlendMode.srcIn,
                                ),
                              ),
                              Text(
                                "Jun 3 2023",
                                style:
                                    TextStyle(fontSize: 8.sp, color: txtColor),
                              )
                            ],
                          ),
                        ),
                      ),
                      //
                      //Save button
                      //
                      GestureDetector(
                        onTap: () {
                          controller.saveOrUpdateNote(isUpdate: isupdate);
                          controller.clearNote();
                        },
                        child: Container(
                          height: 35.h,
                          width: 80.w,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.w),
                              border:
                                  Border.all(color: primaryColor, width: 3)),
                          child: Text(
                            isupdate ? "Update" : "Save",
                            style: TextStyle(fontSize: 14.sp, color: txtColor),
                          ),
                        ),
                      ),
                      //
                      //Top Add button
                      //
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (builder) {
                                return TopButtonBottomSheet(
                                  docId: docId,
                                );
                              });
                        },
                        child: Container(
                          height: 40.h,
                          width: 40.w,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor,
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                    color: Colors.black.withOpacity(0.25)),
                              ]),
                          child: SvgPicture.asset(
                            "asset/other_img/add_plus.svg",
                            colorFilter: const ColorFilter.mode(
                              homeBackground, // Adjust the colors as needed
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  //
                  //Text input fields
                  //
                  Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        Obx(() {
                          return Column(
                            children: [
                              if (serverimg.isNotEmpty)
                                SizedBox(
                                  height: 200,
                                  width: double.infinity,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: serverimg.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.all(6.w),
                                        child: InkWell(
                                            onTap: () {
                                              Get.to(() => ImageView(
                                                    isServerImage: true,
                                                    docId: docId,
                                                  ));
                                            },
                                            child: Image.network(
                                                serverimg[index])),
                                      );
                                    },
                                  ),
                                ),
                              //
                              //
                              //
                              if (addnoteController.images.isNotEmpty)
                                SizedBox(
                                  height: 200,
                                  width: double.infinity,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: addnoteController.images.length,
                                    itemBuilder: (context, index) {
                                      var images =
                                          addnoteController.images[index];

                                      return Padding(
                                        padding: EdgeInsets.all(6.w),
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(() => ImageView(
                                                  isServerImage: false,
                                                  docId: docId,
                                                ));
                                          },
                                          child: Image.file(images),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          );
                        }),
                        TextFormField(
                          controller: isupdate
                              ? addnoteController.titleTexteditingController
                                  .value = TextEditingController(text: title)
                              : addnoteController
                                  .titleTexteditingController.value,
                          style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: txtColor),
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  fontSize: 24.sp, fontWeight: FontWeight.bold),
                              hintText: "Title",
                              border: InputBorder.none),
                        ),
                        TextFormField(
                          controller: isupdate
                              ? addnoteController
                                      .descriptionTexteditingController.value =
                                  TextEditingController(
                                      text: "$description \n\n\n$time")
                              : addnoteController
                                  .descriptionTexteditingController.value,
                          minLines: null,
                          maxLines: null,
                          style: TextStyle(
                              fontSize: 18.sp,
                              color: txtColor.withOpacity(.95)),
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 18.sp,
                              ),
                              hintText: "Descriptions",
                              border: InputBorder.none),
                        ),
                      ],
                    )),
                  ),
                  //
                  //More Settings
                  //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //
                      //users
                      //
                      Container(
                          height: 40.h,
                          width: 40.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor,
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                    color: Colors.black.withOpacity(0.25)),
                              ]),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(Uf.proPic))),
                      //
                      //More Button
                      //
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (builder) {
                                return const BelowButtonBottomSheet();
                              });
                        },
                        child: Container(
                          height: 40.h,
                          width: 40.w,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5.w),
                          child: SvgPicture.asset(
                            "asset/other_img/more.svg",
                            colorFilter: const ColorFilter.mode(
                              primaryColor, // Adjust the colors as needed
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )),
          ),
        );
      }),
    );
  }
}
