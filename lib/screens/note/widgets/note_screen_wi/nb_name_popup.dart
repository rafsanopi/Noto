import 'package:chatnote/root%20methods/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../Colors/colors.dart';
import '../../controller/note_controller.dart';

class NoteBookName extends StatelessWidget {
  final bool isupdate;
  final String notebookName;
  final String id;

  const NoteBookName(
      {super.key, this.isupdate = false, this.notebookName = "", this.id = ""});

  @override
  Widget build(BuildContext context) {
    var noteController = Get.find<NoteController>();
    var userController = Get.find<UserController>();

    return GetBuilder<NoteController>(builder: (controller) {
      return CupertinoAlertDialog(
        title: Text(
          isupdate ? "Update or Delete" : 'Set notebook name',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        content: Padding(
          padding: EdgeInsets.all(8.w),
          child: Material(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(10),
              child: TextFormField(
                controller: isupdate == true
                    ? noteController.noteBookNameController.value =
                        TextEditingController(text: notebookName)
                    : noteController.noteBookNameController.value,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: secondaryColor, // Custom focus border color
                      width: 2.0,
                    ),
                  ),
                  hintText: 'type a name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      5,
                    ),
                    borderSide: const BorderSide(
                      color: Colors.black, // Set the border color
                      width: 2.0, // Set the border width
                    ),
                  ),
                ),
              )),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () {
              noteController.noteBookNameController.value.clear();

              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          if (isupdate)
            CupertinoDialogAction(
              onPressed: () async {
                try {
                  await userController.doc.value
                      .collection("notebooks")
                      .doc(id)
                      .update({
                    "name": controller.noteBookNameController.value.text
                  });
                } finally {
                  noteController.noteBookNameController.value.clear();

                  noteController.getNoteBooks();
                  navigator!.pop();
                }
              },
              child: const Text('Update'),
            ),
          if (isupdate)
            CupertinoDialogAction(
              onPressed: () async {
                try {
                  await userController.doc.value
                      .collection("notebooks")
                      .doc(id)
                      .delete();
                  controller.deleteDocumentWithValue(notebookName);
                } finally {
                  noteController.noteBookNameController.value.clear();

                  noteController.getNoteBooks();
                  navigator!.pop();
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          if (!isupdate)
            CupertinoDialogAction(
              onPressed: () {
                noteController.saveNotebooksName();
                noteController.getNoteBooks();
                noteController.noteBookNameController.value.clear();
              },
              child: const Text('Save'),
            ),
        ],
      );
    });
  }
}
