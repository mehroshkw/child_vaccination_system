import 'package:child_vaccination_system/views/modules/parent_module/change_password/change_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../constants/app_colors.dart';
import '../../../reusable_widgets/app_button.dart';
import '../../../reusable_widgets/app_textfield.dart';
import '../../../reusable_widgets/custom_appbar.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final controller = Get.put(ChangePasswordController());
    return Scaffold(
      appBar: const CustomAppBar(title: "Change Password"),
      body: Obx(() {
        return  controller.isLoading.value
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              const SizedBox(height: 10),
              Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        label: "Old Password",
                        controller: controller.oldPassword,
                        hintText: "Old Password",
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your old Password';
                          }
                          return null;
                        },
                      ),
                      CustomTextFormField(
                        label: "New Password",
                        controller: controller.newPassword,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your new Password';
                          } else if (value.length > 8) {
                            return 'Password should be 8 digits';
                          }
                          return null;
                        },
                      ),
                      CustomTextFormField(
                        label: "Confirm Password",
                        controller: controller.confirmPassword,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter confirm Password';
                          } else if (value.length > 8) {
                            return 'Password should be 8 digits';
                          } else if (value != controller.newPassword.text) {
                            return "Password do not match";
                          }
                          return null;
                        },
                      ),
                    ],
                  )),
              SizedBox(
                  height: 50,
                  width: width / 1.3,
                  child: AppButton(
                    label: "Change Password",
                    onPressed: () {
                      controller.validate();
                    },
                    color: AppColors.primaryColor,
                    elevation: 2,
                    borderColor: AppColors.primaryWhite,
                  )),
              const SizedBox(
                height: 20,
              )
            ]
          )
        );
      }),
    );
  }
}