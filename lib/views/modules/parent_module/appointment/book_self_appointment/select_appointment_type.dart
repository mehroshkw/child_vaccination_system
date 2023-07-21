import 'package:child_vaccination_system/constants/app_colors.dart';
import 'package:child_vaccination_system/constants/app_images.dart';
import 'package:child_vaccination_system/reusable_widgets/app_button.dart';
import 'package:child_vaccination_system/reusable_widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../book_family_appointment/book_family_appointment.dart';
import 'book_self_appointment.dart';

class AppointmentType extends StatelessWidget {
  const AppointmentType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const CustomAppBar(title: "Choose Appointment Type"),
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Image.asset(
              AppImages.ICON,
              height: height / 3,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            SizedBox(
                height: 45,
                width: width / 1.5,
                child: AppButton(
                    color: AppColors.primaryColor,
                    label: "Book Appointment For Yourself",
                    onPressed: () => Get.to(BookSelfAppointmentScreen()))),
            const SizedBox(height: 20),
            SizedBox(
                height: 45,
                width: width / 1.5,
                child: AppButton(
                    color: AppColors.primaryColor,
                    label: "Book Appointment For Family Member",
                    onPressed: () => Get.to(BookFamilyAppointment()))),
          ],
        ),
      ),
    );
  }
}
