import 'package:chatnote/root%20methods/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CollaborateController extends GetxController {
  var userController = Get.find<UserController>();
  RxString docId = "".obs;
  RxList<dynamic> shareMemberGmail = [].obs;
  RxString ownerGmail = "".obs;
  RxString search = "".obs;
  final firestore = FirebaseFirestore.instance;

  getSearchValue(String value) {
    search.value = value;
  }

  getShareUserGmails(String originalNoteId) async {
    //Get the share_member_gmail user data first to update it

    var data = await userController.noteDoc.value
        .collection("userNotes")
        .doc(originalNoteId)
        .get();

    // Check if the data exists and if "share_member_gmail" is a list
    if (data.exists && data.data()!['share_member_gmail'] is List) {
      // If it is a list, get the existing list from data and add sharedUserMail to it
      shareMemberGmail.value = data.data()!['share_member_gmail'];
    } else {
      // Handle the case when the data or the list doesn't exist
      print("No data found or share_member_gmail is not a list.");
    }
  }

  Future<void> shareDocumentWithUser({
    required String originalNoteId,
    required String sharedUserMail,
  }) async {
    try {
      // Update shareMemberGmail
      shareMemberGmail.add(sharedUserMail);

      //update some of the note fields to track data
      userController.noteDoc.value
          .collection("userNotes")
          .doc(originalNoteId)
          .update({"share": true, "share_member_gmail": shareMemberGmail});
      search.value = "";
    } on Exception catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  removeSharedGmail(String originalNoteId, String gmailToRemove) {
    getShareUserGmails(originalNoteId);
    shareMemberGmail.remove(gmailToRemove);
    //update some of the note fields to track data
    userController.noteDoc.value
        .collection("userNotes")
        .doc(originalNoteId)
        .update({"share": true, "share_member_gmail": shareMemberGmail});
  }

  Future<String> getOwnerGmail({
    required String originalNoteId,
  }) async {
    var doc = await userController.noteDoc.value
        .collection("userNotes")
        .doc(originalNoteId)
        .get();

    return ownerGmail.value = doc["ownerGmail"];
  }
}
