import 'package:child_vaccination_system/constants/app_colors.dart';
import 'package:child_vaccination_system/views/modules/admin_module/admin_login.dart';
import 'package:child_vaccination_system/views/modules/hospital_module/hospital_login/hospital_login.dart';
import 'package:child_vaccination_system/views/modules/parent_module/login_sign_up/parent_login.dart';
import 'package:child_vaccination_system/views/reusable_widgets/app_button.dart';
import 'package:child_vaccination_system/views/reusable_widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/local_storage.dart';

class MainScreen extends StatelessWidget {
  static const String route = '/main_screen';

  void saveUserType(bool isClient) {
    LocalStorage().setIsParent(!isClient);
  }

  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: const CustomAppBar(title: "Choose User Role"),
        body: SizedBox(
            height: height,
            width: width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 45,
                          width: width / 1.5,
                          child: AppButton(
                              color: AppColors.primaryColor,
                              label: "Parent",
                              onPressed: () => {saveUserType(true), Get.to(const ParentLoginScreen())}))),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 45,
                          width: width / 1.5,
                          child: AppButton(
                              color: AppColors.primaryColor,
                              label: "Hospital",
                              onPressed: () {
                                saveUserType(true);
                                Get.to(const HospitalLoginScreen());
                              }))),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 45,
                          width: width / 1.5,
                          child: AppButton(
                              color: AppColors.primaryColor,
                              label: "Admin",
                              onPressed: () => Get.to(const AdminLoginScreen()))))
                ])));
  }
}
