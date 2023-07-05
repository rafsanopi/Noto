import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Colors/colors.dart';

class MyContainerWithIconTxt extends StatelessWidget {
  final String txt;
  final String icon;
  final VoidCallback ontap;
  const MyContainerWithIconTxt({
    super.key,
    required this.txt,
    required this.icon,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: InkWell(
        onTap: ontap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          // margin: EdgeInsets.only(top: 18.h),
          height: 45.h,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.w),
              border: Border.all(color: Colors.black, width: 2),
              color: secondaryColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    icon,
                    height: 20.w,
                    colorFilter: const ColorFilter.mode(
                      whiteWithOpacity, // Adjust the colors as needed
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    txt,
                    style: TextStyle(color: whiteWithOpacity, fontSize: 16.sp),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
