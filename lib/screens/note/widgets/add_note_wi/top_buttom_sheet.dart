import 'package:chatnote/Colors/colors.dart';
import 'package:chatnote/root%20methods/user_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_container.dart';

class TopButtonBottomSheet extends StatelessWidget {
  final String? docId;
  const TopButtonBottomSheet({super.key, required this.docId});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height / 3,
      width: double.infinity,
      color: primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyContainerWithIconTxt(
              icon: "asset/other_img/trash.svg",
              ontap: () {
                Uf.doc.collection("userNotes").doc(docId).delete();
                navigator!.pop();
                navigator!.pop();
              },
              txt: "Delete"),
          MyContainerWithIconTxt(
              icon: "asset/note_top_add/copy.svg", ontap: () {}, txt: "Copy"),
          MyContainerWithIconTxt(
              icon: "asset/note_top_add/share.svg", ontap: () {}, txt: "Share"),
        ],
      ),
    );
  }
}
