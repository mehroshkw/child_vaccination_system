import 'dart:async';
import 'package:child_vaccination_system/views/modules/hospital_module/hospital_dashboard/hospital_dashboard.dart';
import 'package:child_vaccination_system/views/modules/parent_module/parent_dashboard/ParentDashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_images.dart';
import '../constants/local_storage.dart';
import 'main_screen.dart';
import 'modules/admin_module/admin_dashboard/adminDashborad.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  getLoginType() {
    String userRole = LocalStorage.getString("userRole");
    if (userRole != "") {
      if (userRole == "admin") {
        Future.delayed(const Duration(seconds: 3), () => Get.offAll(const AdminDashboard()));
      } else if (userRole == "parent") {
        Future.delayed(const Duration(seconds: 3), () => Get.offAll(const ParentDashboard()));
      } else if (userRole == 'hospital') {
        Future.delayed(const Duration(seconds: 3),
                () => Get.offAll(const HospitalDashboard()));
      }
    } else {
      Future.delayed(const Duration(seconds: 3), () => Get.offAll(const MainScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    getLoginType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Image.asset(AppImages.APP_LOGO),
    ));
  }
}
