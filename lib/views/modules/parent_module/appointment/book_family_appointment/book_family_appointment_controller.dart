import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../../../reusable_widgets/const_function.dart';
import '../../../../../constants/local_storage.dart';

class BookFamilyAppointmentController extends GetxController{
  var isLoading = false.obs;

  final formKey = GlobalKey<FormState>();

  TextEditingController phoneC = TextEditingController();
  TextEditingController appointmentDate = TextEditingController();
  TextEditingController familyMemberC = TextEditingController();
  TextEditingController hospitalIdC = TextEditingController();
  TextEditingController hospitalNameC = TextEditingController();
  TextEditingController vaccineC = TextEditingController();
  TextEditingController nameC = TextEditingController();

  uploadToFirestore() async {

    var uuid = const Uuid();
    String id = uuid.v4();
    String email = LocalStorage.getString("email");
    isLoading(true);
    await FirebaseFirestore.instance.collection("appointments").doc(id).set({
      "name": nameC.text.trim(),
      "patientCNIC": familyMemberC.text.trim(),
      "hospitalId": hospitalIdC.text.trim(),
      "hospitalName": hospitalNameC.text.trim(),
      "appointmentDate": appointmentDate.text.trim(),
      "vaccineName": vaccineC.text.trim(),
      "phone": phoneC.text.trim(),
      "email": email,
      "appointmentStatus": 'pending',
      "id": id,
    }).then((value) {
      isLoading(false);
      showToast("Appointment Booked");
      Get.back();
    }).catchError((e) {
      isLoading(false);
      showToast("Something went wrong!");
    });
  }


}