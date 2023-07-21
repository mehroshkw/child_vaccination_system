import 'package:child_vaccination_system/views/modules/parent_module/appointment/book_family_appointment/select_hospital.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_strings.dart';
import '../book_family_appointment/book_family_appointment_controller.dart';
import '../../../../../reusable_widgets/app_button.dart';
import '../../../../../reusable_widgets/custom_appbar.dart';
import '../../../../../reusable_widgets/progress_indicator.dart';

class BookSelfAppointmentScreen extends StatelessWidget {
  const BookSelfAppointmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookFamilyAppointmentController());
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: const CustomAppBar(title: "Book Appointment for Family"),
        body: Obx(() {
          return  controller.isLoading.value
              ? const Center(child: LoaderWidget())
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
                                  return "Enter Patient Name";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  hintText: "Patient Name",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                        AppColors.primaryGreyColor),
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.primaryColor),
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  )))),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                              controller: controller.familyMemberC,
                              validator: (title) {
                                if (title!.isEmpty) {
                                  return "Enter Patient CNIC";
                                } else {
                                  return null;
                                }
                              },
                              maxLength: 13,
                              decoration: InputDecoration(
                                  hintText: "Patient CNIC",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                        AppColors.primaryGreyColor),
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.primaryColor),
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  )))),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: () async {
                                var data = await Get.to(
                                        () => const SelectHospital());
                                controller.hospitalIdC.text = data;
                              },
                              child: TextFormField(
                                  validator: (category) {
                                    if (category!.isEmpty) {
                                      return "Select Hospital";
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: controller.hospitalIdC,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      hintText:
                                      "Select Hospital",
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: AppColors
                                                .primaryGreyColor),
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color:
                                            AppColors.primaryColor),
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ))))),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: controller.phoneC,
                              validator: (price) {
                                if (price!.isEmpty) {
                                  return AppStrings.ENTER_PHONE;
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  hintText: AppStrings.PHONE,
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                        AppColors.primaryGreyColor),
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.primaryColor),
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  )))),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                              validator: (desc) {
                                if (desc!.isEmpty) {
                                  return "Enter Vaccine Name";
                                } else {
                                  return null;
                                }
                              },
                              controller: controller.vaccineC,
                              maxLines: 1,
                              decoration: InputDecoration(
                                  hintText: "Vaccine Name",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                        AppColors.primaryGreyColor),
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.primaryColor),
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  )))),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.datetime,
                          textInputAction: TextInputAction.next,
                          controller: controller.appointmentDate,
                          readOnly: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter time for appointment";
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
                                controller.appointmentDate.text = formattedTime;
                              }
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Timings",
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

                    ])),
                SizedBox(
                    width: size.width * 0.6,
                    child: AppButton(
                      label: "Book Appointment",
                      onPressed: () {
                        if (controller.formKey.currentState!.validate()) {
                          controller.uploadToFirestore();
                        }
                      },
                      color: AppColors.primaryColor,
                      elevation: 2,
                      borderColor: AppColors.primaryWhite,
                    )),
              ]));
        }));
  }
}
