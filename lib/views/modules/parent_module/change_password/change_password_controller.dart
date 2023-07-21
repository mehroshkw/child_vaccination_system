import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../reusable_widgets/const_function.dart';
import '../../../../constants/local_storage.dart';

class ChangePasswordController extends GetxController {
  final TextEditingController oldPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  String email = LocalStorage.getString("email");

  final formKey = GlobalKey<FormState>();
  var isLoading = false.obs;

  Future<void> validate() async {
    if (formKey.currentState!.validate()) {
      changePassword(email, oldPassword.text, newPassword.text);
    }
  }

  Future<void> changePassword(String email, String oldPin, String newPin) async {
    isLoading.value = true;
    final querySnapshot =
        await FirebaseFirestore.instance.collection('parents').where('email', isEqualTo: email).limit(1).get();

    if (querySnapshot.size > 0) {
      final document = querySnapshot.docs[0];
      final documentId = document.id;
      final existingPin = document.get('password');

      if (existingPin == oldPin) {
        await FirebaseFirestore.instance.collection('parents').doc(documentId).update({'password': newPin});

        showToast('Password Changed Successfully');
        oldPassword.clear();
        newPassword.clear();
        confirmPassword.clear();
        Get.back();
        isLoading.value = false;
      } else {
        isLoading.value = false;
        showToast('Invalid Old Password');
      }
    } else {
      isLoading.value = false;
      showToast('Something Went Wrong While Changing Password');
    }
  }
}
