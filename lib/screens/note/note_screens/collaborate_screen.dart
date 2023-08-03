import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnote/Colors/colors.dart';
import 'package:chatnote/root%20methods/global.dart';
import 'package:chatnote/screens/note/controller/collaborate_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../root methods/back_button.dart';

class CollaborateScreen extends GetView<CollaborateController> {
  final String docID;
  const CollaborateScreen({
    super.key,
    required this.docID,
  });

  @override
  Widget build(BuildContext context) {
    var userInfoController = Get.find<UserController>();
    TextEditingController emailTxtEditingController = TextEditingController();
    return Scaffold(
      backgroundColor: homeBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(
            children: [
              const Row(
                children: [
                  CustomBackButton(),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(6.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: emailTxtEditingController,
                          onChanged: (value) {
                            controller.getSearchValue(value);
                          },
                          decoration: InputDecoration(
                            hintText: "Enter email to share with",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color:
                                    primaryColor, // Change the focus border color here
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color:
                                    txtColor, // Change the unfocus border color here
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          "Note members",
                          style: TextStyle(
                              fontSize: 22.sp,
                              color: txtColor,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Obx(() {
                          return Column(
                            children: [
                              if (controller.search.value.isNotEmpty)
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("userInfo")
                                        .where("email",
                                            isEqualTo: controller.search.value)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      if (snapshot.hasError) {
                                        return const Center(
                                          child: Text("Something went wrong"),
                                        );
                                      }
                                      // Check if snapshot has data and its docs are not empty before proceeding
                                      var data = snapshot.data!.docs;
                                      if (controller.search.isNotEmpty &&
                                          data.isEmpty) {
                                        return const Center(
                                          child:
                                              Text("This email does not exist"),
                                        );
                                      }
                                      //return a warning value for useing same gmail as owner gmail
                                      if (controller.search.value ==
                                          userInfoController.userEmail.value) {
                                        return const Center(
                                          child:
                                              Text("This email already exist"),
                                        );
                                      }

                                      return SizedBox(
                                        height: 50.h,
                                        width: double.infinity,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: data.length,
                                          itemBuilder: (context, index) {
                                            String email = data[index]["email"];
                                            return ListTile(
                                              leading: SizedBox(
                                                width: 45.w,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: CachedNetworkImage(
                                                    imageUrl: data[index]
                                                        ["piclink"],
                                                  ),
                                                ),
                                              ),
                                              title: Text(data[index]["name"]),
                                              subtitle: Text(email),
                                              trailing: InkWell(
                                                onTap: () {
                                                  controller
                                                      .shareDocumentWithUser(
                                                    originalNoteId: docID,
                                                    sharedUserMail: email,
                                                  );
                                                  emailTxtEditingController
                                                      .clear();
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 26.h,
                                                  width: 70.w,
                                                  decoration: BoxDecoration(
                                                    color: primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.w),
                                                  ),
                                                  child: Text(
                                                    "Share",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16.sp),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }),
                              if (controller.search.value.isNotEmpty)
                                SizedBox(
                                  height: 30.h,
                                ),
                            ],
                          );
                        }),
                        Obx(() {
                          return StreamBuilder(
                            stream: controller.shareMemberGmail.isNotEmpty
                                ? FirebaseFirestore.instance
                                    .collection("userInfo")
                                    .where("email",
                                        whereIn: controller.shareMemberGmail)
                                    .snapshots()
                                : const Stream<QuerySnapshot>.empty(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
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
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  String email = data[index]["email"];
                                  String piclink = data[index]["piclink"];
                                  String name = data[index]["name"];
                                  return ListTile(
                                      leading: SizedBox(
                                        width: 45.w,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: CachedNetworkImage(
                                            imageUrl: piclink,
                                          ),
                                        ),
                                      ),
                                      title: Text(name),
                                      subtitle: Text(email),
                                      trailing: email ==
                                              userInfoController.userEmail.value
                                          ? const Text("Owner")
                                          : IconButton(
                                              onPressed: () {
                                                controller.removeSharedGmail(
                                                    docID, email);
                                              },
                                              icon: const Icon(
                                                  FontAwesomeIcons.xmark)));
                                },
                              );
                            },
                          );
                        })
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
