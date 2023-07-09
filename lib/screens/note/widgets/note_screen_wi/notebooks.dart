import 'dart:math';

import 'package:chatnote/screens/note/controller/note_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../Colors/colors.dart';
import '../../controller/add_note_controller.dart';
import 'note_bottom_sheet.dart';

class MyNoteBooks extends StatefulWidget {
  const MyNoteBooks({super.key});

  @override
  State<MyNoteBooks> createState() => _MyNoteBooksState();
}

class _MyNoteBooksState extends State<MyNoteBooks>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  var addNoteController = Get.put(AddNoteController());
  var noteController = Get.put(NoteController());

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 50.h,
        child: Obx(() {
          return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: noteController.noteBookItems.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) {
                var data = noteController.noteBookItems;

                return Column(
                  children: [
                    //
                    //Every containers
                    //
                    GestureDetector(
                      onTap: () {
                        noteController.updateIndex(index);
                        addNoteController.notebookName.value =
                            data[index] = noteController.noteBookItems[index];
                      },
                      child: AnimatedContainer(
                        padding: EdgeInsets.all(index != 0 ? 8.w : 0),
                        alignment: Alignment.center,
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.all(5),
                        width: index == 0 ? 140.w : 100.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: noteController.currentIndex.value == index
                              ? primaryColor
                              : null,
                          borderRadius: BorderRadius.circular(20),
                          border: noteController.currentIndex.value != index
                              ? Border.all(color: primaryColor, width: 2)
                              : null,
                        ),
                        child: index != 0
                            ? Text(
                                data[index],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: noteController.currentIndex.value ==
                                            index
                                        ? Colors.white
                                        : primaryColor),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 15.w),
                                    child: Text(
                                      "All notes",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: noteController
                                                      .currentIndex.value ==
                                                  index
                                              ? Colors.white
                                              : primaryColor),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (noteController.isRotated.value ==
                                          false) {
                                        showModalBottomSheet(
                                                context: context,
                                                builder: (builder) {
                                                  return const NoteBottomSheet();
                                                })
                                            .whenComplete(() =>
                                                noteController.toggleRotation(
                                                    _animationController));
                                      }
                                      noteController
                                          .toggleRotation(_animationController);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 50.w,
                                      height: 40.h,
                                      decoration: BoxDecoration(
                                          color: noteController
                                                      .currentIndex.value ==
                                                  index
                                              ? homeBackground
                                              : primaryColor,
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(18),
                                              bottomRight: Radius.circular(18)),
                                          border: noteController
                                                      .currentIndex.value ==
                                                  index
                                              ? Border.all(
                                                  color: primaryColor, width: 2)
                                              : null),
                                      child: AnimatedBuilder(
                                        animation: _animationController,
                                        builder: (context, child) {
                                          return Transform.rotate(
                                            angle:
                                                _animationController.value * pi,
                                            child: child,
                                          );
                                        },
                                        child: SvgPicture.asset(
                                          "asset/other_img/arrow_up_down.svg",
                                          height: 5,
                                          colorFilter: ColorFilter.mode(
                                            noteController.currentIndex.value ==
                                                    index
                                                ? primaryColor
                                                : homeBackground, // Adjust the colors as needed
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                );
              });
        }));
  }
}
