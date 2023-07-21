import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../constants/local_storage.dart';

class HospitalDashboardController extends GetxController {
  var isLoading = false.obs;
  var isApproved = false.obs;
  var isSortingAscending = false.obs;
  final String id = LocalStorage.getString("id");


  toggleIsApproved() {
    isApproved.value = !isApproved.value;
  }

  Future<void> updateAppointmentStatus() async {
    String id = LocalStorage.getString("id");
    CollectionReference appointmentsCollection = FirebaseFirestore.instance.collection('appointments');
    QuerySnapshot querySnapshot = await appointmentsCollection.where('hospitalId', isEqualTo: id).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentReference documentRef = querySnapshot.docs.first.reference;
      String newStatus = isApproved.value ? 'approved' : 'cancelled';

      await documentRef.update({'appointmentStatus': newStatus});
    }
  }

  Stream<QuerySnapshot>?  appointmentsStream;

  @override
  void onInit() {
    appointmentsStream = FirebaseFirestore.instance
        .collection('appointments')
        .where('hospitalId', isEqualTo: LocalStorage.getString("id"))
        .orderBy('appointmentDate') // Initial sorting by appointment date
        .snapshots();
    super.onInit();
  }


  void toggleSortOrder() {
      isSortingAscending.value = !isSortingAscending.value;
      // Re-fetch the data with the updated sorting order
      appointmentsStream = FirebaseFirestore.instance
          .collection('appointments')
          .where('hospitalId', isEqualTo: id)
          .orderBy('appointmentDate', descending: !isSortingAscending.value)
          .snapshots();
  }
}
