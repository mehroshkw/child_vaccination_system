import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../../../constants/local_storage.dart';
import '../../../../reusable_widgets/const_function.dart';

class AddFamilyMemberController extends GetxController{
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

  // uploadToFirestore() async {
  //
  //   var uuid = const Uuid();
  //
  //   String email = LocalStorage.getString("email");
  //   isLoading(true);
  //   await FirebaseFirestore.instance.collection("family_members").doc().set({
  //     "name": nameC.text.trim(),
  //     "relationship": relationshipC.text.trim(),
  //     "gender": genderC.text.toLowerCase().trim(),
  //     "address": addressC.text.trim(),
  //     "cnic_bform": cnic_bFormC.text.trim(),
  //     "dob": dobC.text.trim(),
  //     "email": email,
  //     "id": uuid.v4(),
  //   }).then((value) {
  //     isLoading(false);
  //     showToast("Family Member Added");
  //     Get.back();
  //   }).catchError((e) {
  //     isLoading(false);
  //     showToast("Something went wrong!");
  //   });
  // }


  uploadToFirestore() async {
    var uuid = const Uuid();

    String email = LocalStorage.getString("email");
    String cnicBForm = cnic_bFormC.text.trim();
    String memberId = uuid.v4();


    // Check if a family member with the same CNIC/B-Form already exists
    final querySnapshot = await FirebaseFirestore.instance
        .collection("family_members")
        .where("email", isEqualTo: email)
        .where("cnic_bform", isEqualTo: cnicBForm)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      showToast("This family member is already added.");
    } else {
      isLoading(true);
      await FirebaseFirestore.instance.collection("family_members").doc(memberId).set({
        "name": nameC.text.trim(),
        "relationship": relationshipC.text.trim(),
        "gender": genderC.text.toLowerCase().trim(),
        "address": addressC.text.trim(),
        "cnic_bform": cnicBForm,
        "dob": dobC.text.trim(),
        "email": email,
        "id": memberId,
      }).then((value) {
        isLoading(false);
        showToast("Family Member Added");
        Get.back();
      }).catchError((e) {
        isLoading(false);
        showToast("Something went wrong!");
      });
    }
  }



}