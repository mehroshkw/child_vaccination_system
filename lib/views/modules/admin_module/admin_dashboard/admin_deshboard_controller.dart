import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../constants/local_storage.dart';

class AdminDashboardController extends  GetxController{
  var isApproved = false.obs;

  toggleIsApproved() {
    isApproved.value = !isApproved.value;
  }

  Future<void> updateHospitalStatus(String id) async {

    CollectionReference appointmentsCollection = FirebaseFirestore.instance.collection('hospitals');
    QuerySnapshot querySnapshot = await appointmentsCollection.where('id', isEqualTo: id).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentReference documentRef = querySnapshot.docs.first.reference;
      String newStatus = isApproved.value ? 'approved' : 'blocked';
      print(newStatus);
       await documentRef.update({'status': newStatus});

    }
  }
}