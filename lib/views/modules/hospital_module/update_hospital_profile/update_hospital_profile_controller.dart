import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_strings.dart';
import '../../../../reusable_widgets/const_function.dart';
import '../../../../constants/local_storage.dart';

class UpdateHospitalProfileController extends GetxController {
  var isLoading = false.obs;

  TextEditingController phoneC = TextEditingController();
  TextEditingController timingsFromC = TextEditingController();
  TextEditingController timingsToC = TextEditingController();
  TextEditingController addressC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController publicPrivateC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String email = LocalStorage.getString("email");
  String name = LocalStorage.getString("name");
  String address = LocalStorage.getString("address");
  String timingsFrom = LocalStorage.getString("timingsFrom");
  String timingsTo = LocalStorage.getString("timingsTo");
  String publicPrivate = LocalStorage.getString("privateGovt");
  String phone = LocalStorage.getString("phone");

    @override
  void onInit() {
      emailC.text = email;
      phoneC.text = phone;
      timingsFromC.text = timingsFrom;
      timingsToC.text = timingsTo;
      addressC.text = address;
      nameC.text = name;
      publicPrivateC.text = publicPrivate;
      super.onInit();
  }
  updateInFirestore() async {
    // Check if the hospital with the provided email exists
    final querySnapshot = await FirebaseFirestore.instance
        .collection("hospitals")
        .where("email", isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String id = querySnapshot.docs.first.id;
      isLoading(true);
      await FirebaseFirestore.instance
          .collection("hospitals")
          .doc(id)
          .update({
        "name": nameC.text.trim(),
        "address": addressC.text.trim(),
        "privateGovt": publicPrivateC.text.toUpperCase().trim(),
        "timingsFrom": timingsFromC.text.trim(),
        "timingsTo": timingsToC.text.trim(),
        "phone": phoneC.text.trim(),
        "email": emailC.text.trim(),
        "password": passwordC.text,
      })
          .then((value) {
        isLoading(false);
        showToast("Hospital Updated");
        Get.back();
      })
          .catchError((e) {
        isLoading(false);
        showToast("Something went wrong!");
      });
    } else {
      showToast("Hospital not found");
    }
  }


}