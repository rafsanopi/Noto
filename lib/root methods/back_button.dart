import 'dart:math';

import 'package:chatnote/screens/note/controller/add_note_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../Colors/colors.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddNoteController>(builder: (controller) {
      return GestureDetector(
        onTap: () {
          navigator!.pop();
          controller.clearNote();
          controller.onPageImageIndex.value = 1;
          controller.images.value = [];
        },
        child: Container(
          height: 40.h,
          width: 40.w,
          alignment: Alignment.center,
          padding: EdgeInsets.all(5.w),
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
          child: Transform.rotate(
            angle: pi,
            child: SvgPicture.asset(
              "asset/other_img/arrow.svg",
              colorFilter: const ColorFilter.mode(
                homeBackground, // Adjust the colors as needed
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      );
    });
  }
}
