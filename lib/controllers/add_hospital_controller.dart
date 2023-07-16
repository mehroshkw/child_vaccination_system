import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../constants/const_function.dart';
import '../constants/local_storage.dart';

class AddHospitalController extends GetxController {
  var isLoading = false.obs;

  TextEditingController phoneC = TextEditingController();
  TextEditingController timingsFromC = TextEditingController();
  TextEditingController timingsToC = TextEditingController();
  TextEditingController addressC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController publicPrivateC = TextEditingController();

  uploadToFirestore() async {
    var uuid = const Uuid();
    String id = uuid.v4();
    String userRole = LocalStorage.getString("userRole");
    isLoading(true);
    await FirebaseFirestore.instance.collection("hospitals").doc(id).set({
      "name": nameC.text.trim(),
      "address": addressC.text.trim(),
      "privateGovt": publicPrivateC.text.toUpperCase().trim(),
      "timingsFrom": timingsFromC.text.trim(),
      "timingsTo": timingsToC.text.trim(),
      "phone": phoneC.text.trim(),
      "email": emailC.text.trim(),
      "password": passwordC.text,
      "status": userRole == 'admin' ? "approved" : "pending",
      "id": id,
    }).then((value) {
      isLoading(false);
      showToast("Hospital Added");
      Get.back();
    }).catchError((e) {
      isLoading(false);
      showToast("Something went wrong!");
    });
  }
}
