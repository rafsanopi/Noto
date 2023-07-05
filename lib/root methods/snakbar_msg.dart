import 'package:chatnote/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class GetSnakbarMsg {
  static successfullyDone() {
    Get.snackbar(
      "Done",
      "Successfully done",
      icon: const Icon(FontAwesomeIcons.checkDouble, color: Colors.white),
      backgroundColor: islamicGreen,
      borderRadius: 20,
      margin: const EdgeInsets.all(15),
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
      isDismissible: true,
      forwardAnimationCurve: Curves.fastOutSlowIn,
    );
  }

  static somethingWentWrong({required String msg}) {
    Get.snackbar(
      "Error",
      msg,
      icon: const Icon(FontAwesomeIcons.xmark, color: Colors.white),
      backgroundColor: ruddyPink,
      borderRadius: 20,
      margin: const EdgeInsets.all(15),
      colorText: secondaryColor,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      forwardAnimationCurve: Curves.fastOutSlowIn,
    );
  }
}
