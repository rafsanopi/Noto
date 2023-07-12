import 'package:chatnote/Colors/colors.dart';
import 'package:chatnote/screens/note/controller/note_controller.dart';
import 'package:chatnote/screens/note/widgets/note_screen_wi/note_grid_view.dart';

import 'package:chatnote/screens/note/widgets/note_screen_wi/notebooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../root methods/global.dart';

class Note extends GetView<NoteController> {
  const Note({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        backgroundColor: homeBackground,
        body: Padding(
            padding: EdgeInsets.only(top: 35.h, left: 10, right: 10),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                              color: Colors.black.withOpacity(0.25))
                        ]),
                    height: 60.w,
                    width: 60.w,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(Global.proPic)),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 40.h,
                      width: 120.w,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                                color: Colors.black.withOpacity(0.25)),
                          ],
                          borderRadius: BorderRadius.circular(30),
                          color: primaryColor),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white, width: 2)),
                        child: const Icon(
                          FontAwesomeIcons.magnifyingGlass,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Good\n${controller.timeOfDay}",
                      style: TextStyle(
                          fontSize: 40.sp,
                          color: txtColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Today's ${controller.dayOfWeek}",
                      style: TextStyle(
                          fontSize: 15.sp,
                          color: txtColor,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "${controller.todaysDate}",
                      style: TextStyle(
                          fontSize: 15.sp,
                          color: txtColor,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                );
              }),
              SizedBox(
                height: 10.h,
              ),
              //
              //Problem bello 2 screen
              //
              const MyNoteBooks(),
              //
              //const NoteGridView()
            ])));
  }
}
