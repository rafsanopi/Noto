import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Colors/colors.dart';
import '../../../../root methods/user_info.dart';
import 'nb_name_popup.dart';

class NoteBottomSheet extends StatelessWidget {
  const NoteBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: const BoxDecoration(color: primaryColor),
      height: 350.h,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "My notebooks",
                style: TextStyle(color: whiteWithOpacity, fontSize: 25.sp),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            margin: EdgeInsets.symmetric(vertical: 20.h),
            height: 45.h,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black, width: 2),
                color: secondaryColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      "asset/other_img/trash.svg",
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
                      "Recently Deleted",
                      style:
                          TextStyle(color: whiteWithOpacity, fontSize: 16.sp),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "0",
                      style:
                          TextStyle(color: whiteWithOpacity, fontSize: 16.sp),
                    ),
                    SvgPicture.asset(
                      "asset/other_img/arrow.svg",
                      height: 25.w,
                      colorFilter: const ColorFilter.mode(
                        whiteWithOpacity, // Adjust the colors as needed
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          //
          //Add button and all notes
          //
          Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: Row(
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return const NoteBookName();
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(20.w),
                        height: 70.h,
                        width: 70.w,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            color: whiteWithOpacity),
                        child: SvgPicture.asset(
                          "asset/other_img/add_plus.svg",
                          colorFilter: const ColorFilter.mode(
                            secondaryColor, // Adjust the colors as needed
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    const Text(
                      "Add notebook",
                      style: TextStyle(color: whiteWithOpacity),
                    )
                  ],
                ),
                SizedBox(
                  width: 20.w,
                ),
                const NoteBook(text: "All notes")
              ],
            ),
          ),
          //
          //user created notebooks
          //
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("user")
                .doc(Uf.email)
                .collection("notebooks")
                .orderBy("name", descending: true)
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
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              var data = snapshot.data!.docs;

              return GridView.builder(
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: .7,
                ),
                itemBuilder: (context, index) {
                  var name = data[index]["name"];
                  return GestureDetector(
                      onTap: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return NoteBookName(
                              id: data[index].id,
                              isupdate: true,
                              notebookName: name,
                            );
                          },
                        );
                      },
                      child: NoteBook(text: name));
                },
              );
            },
          )),
        ],
      ),
    );
  }
}

class NoteBook extends StatelessWidget {
  final String text;
  const NoteBook({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 70.h,
          width: 70.w,
          child: SvgPicture.asset(
            "asset/other_img/notebook.svg",
            colorFilter: const ColorFilter.mode(
              whiteWithOpacity, // Adjust the colors as needed
              BlendMode.srcIn,
            ),
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: whiteWithOpacity,
          ),
        )
      ],
    );
  }
}
