import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_strings.dart';
import '../../../../reusable_widgets/const_function.dart';
import '../../../../constants/local_storage.dart';

class UpdateParentProfileController extends GetxController {
  var isLoading = false.obs;

  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController pinC = TextEditingController();
  final TextEditingController cnicC = TextEditingController();
  final TextEditingController addressC = TextEditingController();
  final TextEditingController phnC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

  String email = LocalStorage.getString("email");
  String name = LocalStorage.getString("name");
  String address = LocalStorage.getString("address");
  String cnic = LocalStorage.getString("cnic");
  String phone = LocalStorage.getString("phone");

  @override
  void onInit() {
    super.onInit();
    // Set the initial values of the TextEditingController from shared pref
    nameC.text = name;
    emailC.text = email;
    addressC.text = address;
    cnicC.text = cnic;
    phnC.text = phone;
  }

  Future<void> validate() async {
    if (formKey.currentState!.validate()) {
      updateUserProfile(
        name: nameC.text,
        cnic: cnicC.text,
        address: addressC.text,
        phone: phnC.text,
      );
    }
  }

  Future<void> updateUserProfile({
    required String name,
    required String cnic,
    required String address,
    required String phone,
  }) async {
    isLoading(true);
    final snapshot = await FirebaseFirestore.instance
        .collection('parents')
        .doc(email)
        .get();
    if (snapshot.exists) {
      final updateData = {
        "name": name,
        "cnic": cnic,
        "address": address,
        "phone": phone,
      };

      FirebaseFirestore.instance
          .collection('parents')
          .doc(email)
          .update(updateData)
          .then((value) {
        // Update the values in shared preferences
        LocalStorage.saveString("name", name);
        LocalStorage.saveString("address", address);
        LocalStorage.saveString("cnic", cnic);
        LocalStorage.saveString("phone", phone);

        showToast('Profile Updated');
        isLoading(false);
        Get.back(result: true);
      }).catchError((onError) {
        isLoading(false);
        showToast(AppStrings.SMTHNG_WENT_WRONG);
      });
    } else {
      isLoading(false);
      showToast('Profile Not Found');
    }
  }
}