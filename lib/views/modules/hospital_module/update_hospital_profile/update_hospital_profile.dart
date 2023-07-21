import 'package:child_vaccination_system/views/modules/hospital_module/update_hospital_profile/update_hospital_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_strings.dart';
import '../../../reusable_widgets/app_button.dart';
import '../../../reusable_widgets/custom_appbar.dart';


class UpdateHospitalProfile extends StatefulWidget {
  const UpdateHospitalProfile({Key? key}) : super(key: key);

  @override
  State<UpdateHospitalProfile> createState() => _UpdateHospitalProfileState();
}

class _UpdateHospitalProfileState extends State<UpdateHospitalProfile> {
  final controller = Get.put(UpdateHospitalProfileController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Update Hospital Profile'),
      body: Obx(() {
        return controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(children: [
                Form(
                    key: controller.formKey,
                    child: Column(children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                              controller: controller.nameC,
                              validator: (title) {
                                if (title!.isEmpty) {
                                  return "Enter Hospital Name";
                                } else {
                                  return null;
                                }
                              },
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  hintText: "Hospital Name",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: AppColors.primaryGreyColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: AppColors.primaryColor),
                                    borderRadius: BorderRadius.circular(10),
                                  )))),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                              controller: controller.emailC,
                              validator: (email) {
                                if (email!.isEmpty) {
                                  return AppStrings.ENTER_EMAIL;
                                } else if (!email.contains("@")) {
                                  return AppStrings.ENTER_VALID_EMAIL;
                                } else if (!email.contains(".com")) {
                                  return AppStrings.ENTER_VALID_EMAIL;
                                } else {
                                  return null;
                                }
                              },
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              readOnly: true,
                              decoration: InputDecoration(
                                  hintText: "Hospital Email",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: AppColors.primaryGreyColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: AppColors.primaryColor),
                                    borderRadius: BorderRadius.circular(10),
                                  )))),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                              controller: controller.addressC,
                              validator: (title) {
                                if (title!.isEmpty) {
                                  return "Enter Hospital Address";
                                } else {
                                  return null;
                                }
                              },
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  hintText: "Address",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: AppColors.primaryGreyColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: AppColors.primaryColor),
                                    borderRadius: BorderRadius.circular(10),
                                  )))),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.datetime,
                          textInputAction: TextInputAction.next,
                          controller: controller.timingsFromC,
                          readOnly: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter opening time of hospital";
                            } else {
                              return null;
                            }
                          },
                          onTap: () {
                            // Show time picker when the text field is tapped
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((selectedTime) {
                              // Update the text field's value with the selected time
                              if (selectedTime != null) {
                                final formattedTime = selectedTime.format(context);
                                controller.timingsFromC.text = formattedTime;
                              }
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Timings From",
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: AppColors.primaryGreyColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: AppColors.primaryColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.datetime,
                          textInputAction: TextInputAction.next,
                          controller: controller.timingsToC,
                          readOnly: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Closing time of hospital";
                            } else {
                              return null;
                            }
                          },
                          onTap: () {
                            // Show time picker when the text field is tapped
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((selectedTime) {
                              // Update the text field's value with the selected time
                              if (selectedTime != null) {
                                final formattedTime = selectedTime.format(context);
                                controller.timingsToC.text = formattedTime;
                              }
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Timings To",
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: AppColors.primaryGreyColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: AppColors.primaryColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Phone Number";
                            } else {
                              return null;
                            }
                          },
                          controller: controller.phoneC,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: "Phone Number",
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: AppColors.primaryGreyColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: AppColors.primaryColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Govt or Private?";
                            } else if (value != "Govt" && value != "Private") {
                              return "Enter Govt or Private";
                            } else {
                              return null;
                            }
                          },
                          controller: controller.publicPrivateC,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: "Private/Govt",
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: AppColors.primaryGreyColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: AppColors.primaryColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      )
                    ])),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: AppButton(
                        label: "Save",
                        onPressed: () {
                          if (controller.formKey.currentState!.validate()) {
                            controller.updateInFirestore();
                          }
                        },
                        color: AppColors.primaryColor,
                        elevation: 2,
                        borderColor: AppColors.primaryWhite))
              ]));
      }),
    );
  }
}
