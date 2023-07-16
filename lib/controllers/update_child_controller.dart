import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/const_function.dart';
import '../constants/local_storage.dart';

class UpdateChildController extends GetxController {
  var isLoading = false.obs;

  TextEditingController genderC = TextEditingController();
  TextEditingController dobC = TextEditingController();
  TextEditingController relationshipC = TextEditingController();
  TextEditingController addressC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController cnic_bFormC = TextEditingController();

  var gender = 'Male'.obs;
  var relationship = 'Son'.obs;

  void setGender(String value) {
    gender.value = value;
    genderC.text = gender.value;
  }

  void setRelationship(String value) {
    relationship.value = value;
    relationshipC.text = relationship.value;
  }

  updateInFirestore(String memberId) async {
    String email = LocalStorage.getString("email");
    String cnicBForm = cnic_bFormC.text.trim();

    // Check if the family member with the provided memberId exists
    final querySnapshot = await FirebaseFirestore.instance.collection("family_members").doc(memberId).get();

    if (querySnapshot.exists) {
      isLoading(true);
      await FirebaseFirestore.instance.collection("family_members").doc(memberId).update({
        "name": nameC.text.trim(),
        "relationship": relationshipC.text.trim(),
        "gender": genderC.text.trim(),
        "address": addressC.text.trim(),
        "cnic_bform": cnicBForm,
        "dob": dobC.text.trim(),
        "email": email,
      }).then((value) {
        isLoading(false);
        showToast("Family Member Updated");
        Get.back();
      }).catchError((e) {
        isLoading(false);
        showToast("Something went wrong!");
      });
    } else {
      showToast("Family Member not found");
    }
  }
}
