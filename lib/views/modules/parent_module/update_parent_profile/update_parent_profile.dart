import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_strings.dart';
import 'update_parent_profile_controller.dart';
import '../../../../reusable_widgets/app_button.dart';
import '../../../../reusable_widgets/app_textfield.dart';
import '../../../../reusable_widgets/custom_appbar.dart';
import '../change_password/change_password.dart';

class UpdateParentProfile extends StatelessWidget {
  const UpdateParentProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final controller = Get.put(UpdateParentProfileController());
    return Scaffold(
        appBar: const CustomAppBar(title: 'Update Profile'),
        body: Obx(() {
          return controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      const SizedBox(height: 20),
                      const SizedBox(height: 10),
                      Form(
                          key: controller.formKey,
                          child: Column(children: [
                            CustomTextFormField(
                                label: AppStrings.FULL_NAME,
                                controller: controller.nameC,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.ENTER_NAME;
                                  }
                                  return null;
                                }),
                            CustomTextFormField(
                                label: AppStrings.CNIC,
                                // maxLength: 13,
                                controller: controller.cnicC,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.ENTER_CNIC;
                                  } else if (value.length > 13 || value.length < 13) {
                                    return AppStrings.ENTER_VALID_CNIC;
                                  }
                                  return null;
                                }),
                            CustomTextFormField(
                                label: AppStrings.ADDRESS,
                                controller: controller.addressC,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.ENTER_ADDRESS;
                                  }
                                  return null;
                                }),
                            CustomTextFormField(
                                label: AppStrings.PHONE,
                                controller: controller.phnC,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.ENTER_PHONE;
                                  }
                                  return null;
                                })
                          ])),
                      SizedBox(
                          height: 50,
                          width: width / 1.3,
                          child: AppButton(
                              label: 'Save',
                              onPressed: () => controller.validate(),
                              color: AppColors.primaryColor,
                              elevation: 2,
                              borderColor: AppColors.primaryWhite)),
                      const SizedBox(height: 20),
                      SizedBox(
                          height: 50,
                          width: width / 1.3,
                          child: AppButton(
                              label: 'Change Password',
                              onPressed: () => Get.to(ChangePassword()),
                              color: AppColors.primaryColor,
                              elevation: 2,
                              borderColor: AppColors.primaryWhite))
                    ]));
        }));
  }
}
