import 'package:child_vaccination_system/views/main_screen.dart';
import 'package:child_vaccination_system/views/modules/hospital_module/hospital_dashboard/hospital_dashboard.dart';
import 'package:child_vaccination_system/views/modules/parent_module/parent_dashboard/ParentDashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_strings.dart';
import '../../constants/local_storage.dart';
import '../reusable_widgets/const_function.dart';
import 'admin_module/admin_dashboard/admin_dashborad.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isParentLogin = false.obs;
  var isAdminLogin = false.obs;
  var isHospitalLogin = false.obs;
  var isServiceProviderLogin = false.obs;

  Future<void> registerUser({
    required String email,
    required String name,
    required String password,
    required String cnic,
    required String address,
    required String phone,
  }) async {
    isLoading(true);
    final snapshot = await FirebaseFirestore.instance.collection('parents').doc(email).get();

    if (!snapshot.exists) {
      final data = {
        "name": name,
        "email": email,
        "password": password,
        "cnic": cnic,
        "address": address,
        "phone": phone,
        "userRole": "parent",
      };

      FirebaseFirestore.instance.collection('parents').doc(email).set(data).then((_) {
        showToast(AppStrings.ACCOUNT_CREATED);
        isLoading(false);
        Get.offAll(() => const MainScreen());
      }).catchError((onError) {
        isLoading(false);
        showToast(AppStrings.SMTHNG_WENT_WRONG);
      });
    } else {
      isLoading(false);
      showToast(AppStrings.USER_ALREADY_EXIST);
    }
  }

  parentLogin({required String email, required String password, required BuildContext context}) async {
    isParentLogin(true);
    final snapshot = await FirebaseFirestore.instance.collection('parents').doc(email).get();
    if (snapshot.exists && snapshot.get('password') == password) {
      LocalStorage.saveString("userRole", snapshot.get("userRole").toString());
        LocalStorage.saveString("email", email);
        LocalStorage.saveString("address", snapshot.get('address').toString());
        LocalStorage.saveString("cnic", snapshot.get('cnic').toString());
        LocalStorage.saveString("name", snapshot.get('name').toString());
        LocalStorage.saveString("phone", snapshot.get('phone').toString());
        showToast(AppStrings.LOGING_IN);
      isParentLogin(false);
        Get.offAll(() => const ParentDashboard());
    } else {
      isParentLogin(false);
      showToast(AppStrings.INVALID);
    }
  }

  adminLogin({required String email, required String password, required BuildContext context}) async {
    isAdminLogin(true);
    final snapshot = await FirebaseFirestore.instance.collection('admin').doc(email).get();
    if (snapshot.exists && snapshot.get('password') == password) {
      if (snapshot.get('userRole') == 'admin') {
        LocalStorage.saveString("userRole", "admin");
        LocalStorage.saveString("email", email);
        showToast(AppStrings.LOGING_IN);
        isAdminLogin(false);
        Get.offAll(() => const AdminDashboard());
      } else {
        isAdminLogin(false);
        showToast(AppStrings.NOT_REGISTERED_Admin);
      }
    } else {
      isAdminLogin(false);
      showToast(AppStrings.INVALID);
    }
  }

  hospitalLogin({required String email, required String password, required BuildContext context}) async {
    isHospitalLogin(true);
    final snapshot = await FirebaseFirestore.instance
        .collection('hospitals')
        .where('email', isEqualTo: email)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      final String status = doc.get('status').toString();
      if (status == 'approved') {
        // Save user data to LocalStorage
        LocalStorage.saveString("name", doc.get("name").toString());
        LocalStorage.saveString("email", email);
        LocalStorage.saveString("address", doc.get('address').toString());
        LocalStorage.saveString("privateGovt", doc.get('privateGovt').toString());
        LocalStorage.saveString("timingsFrom", doc.get('timingsFrom').toString());
        LocalStorage.saveString("timingsTo", doc.get('timingsTo').toString());
        LocalStorage.saveString("id", doc.get('id').toString());
        LocalStorage.saveString("status", doc.get('status').toString());
        LocalStorage.saveString("phone", doc.get('phone').toString());
        LocalStorage.saveString("userRole", 'hospital');
        showToast(AppStrings.LOGING_IN);
        showToast(AppStrings.LOGING_IN);
        isHospitalLogin(false);
        Get.offAll(() => const HospitalDashboard());
      } else {
        isHospitalLogin(false);
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Account Not Approved'),
              content: const Text('Your Hospital Account is not approved yet by the admin. Please wait for Admin approval'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      isHospitalLogin(false);
      showToast(AppStrings.INVALID);
    }
  }

  Future<void> logoutUser() async {
    LocalStorage.removeAll();
    Get.offAll(const MainScreen());
  }
}
