import 'dart:ui';
import 'dart:math';
import 'package:chatnote/Auth/login_controller.dart';
import 'package:chatnote/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

double left = 30.w;
//double top = 0.0;

class _LogInScreenState extends State<LogInScreen> {
  // var logIncontroller = Get.find<LogInController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: loginBackground,
      body: Stack(children: [
//
//
//blur shapes
        Positioned(
          top: 100.h,
          left: 130.w,
          child: Image.asset(
            "asset/log_screen_img/shapes/img1.png",
            scale: 0.6.h,
          ),
        ),
        Positioned(
          top: 270.h,
          child: Image.asset(
            "asset/log_screen_img/shapes/img2.png",
            scale: 0.65.h,
          ),
        ),
        Positioned(
          bottom: 110.h,
          right: 30.w,
          child: Image.asset(
            "asset/log_screen_img/shapes/img3.png",
            scale: 0.7.h,
          ),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white.withOpacity(0.7),
        ),
        Positioned.fill(
            child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: const SizedBox(),
        )),
        //
        //
// //blur shapes end
        Positioned(
          top: 20.h,
          left: 23.w,
          child: Image.asset(
            "asset/log_screen_img/images/img2.png",
            scale: 20.h,
          ),
        ),
        Positioned(
            top: 290.h,
            left: 30.w,
            child: const CustomContainer(
              angle: -pi / 25,
              text: "Plan",
            )),
        Positioned(
            top: 340.h,
            left: 120.w,
            child: const CustomContainer(
              angle: 0,
              text: "Track",
            )),
        Positioned(
            top: 290.h,
            right: 30.w,
            child: const CustomContainer(
              angle: pi / 25,
              text: "Manage",
            )),
        Positioned(
            bottom: 140.h,
            left: 5.w,
            child: SizedBox(
              // alignment: Alignment.center,
              width: 350.w,
              child: Text(
                "Take control of your day",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: primaryColor.withOpacity(0.8),
                  fontSize: 60.sp,
                  shadows: const [
                    Shadow(
                      color: Color(0xff777777),
                      blurRadius: 4,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
            )),
        //
//button
//
        GetBuilder<LogInController>(builder: (controller) {
          return GestureDetector(
            onTap: () {},
            onPanUpdate: (details) async {
              left = max(0, left + details.delta.dx);

              if (left >= 250.w) {
                left = 30.w;
                await controller.signInWithGoogle();
                if (controller.login.value == true) {
                  controller.saveUserInfoOnLogIn();
                }
              }
              if (left < 30.w) {
                left = 30.w;
              }
              setState(() {});
            },
            child: Stack(
              children: [
                Positioned(
                    bottom: 30.h,
                    left: left,
                    child: Container(
                      height: 70.h,
                      width: 75.w,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.w),
                        child: Image.asset(
                            "asset/log_screen_img/images/google.png"),
                      ),
                    )),
                Positioned(
                  bottom: 30.h,
                  left: 30.w,
                  child: Container(
                      padding: EdgeInsets.only(right: 25.w),
                      alignment: Alignment.centerRight,
                      height: 70.h,
                      width: 300.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: primaryColor, width: 4)),
                      child: left <= 70
                          ? Text(
                              "Swipe to continue",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: secondaryColor,
                                fontSize: 20.sp,
                                shadows: [
                                  Shadow(
                                    color: const Color(0xff000000)
                                        .withOpacity(0.25),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2.0),
                                  ),
                                ],
                              ),
                            )
                          : null),
                )
              ],
            ),
          );
        })
      ]),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final double angle;
  final String text;
  const CustomContainer({
    super.key,
    this.angle = 0,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        alignment: Alignment.center,
        height: 50.h,
        width: 120.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: primaryColor, width: 4)),
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: primaryColor.withOpacity(0.8),
              fontSize: 26.sp),
        ),
      ),
    );
  }
}
