import 'package:child_vaccination_system/views/modules/parent_module/appointment/select_family_member.dart';
import 'package:child_vaccination_system/views/modules/parent_module/appointment/select_hospital.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_strings.dart';
import '../../../../controllers/book_family_appointment.dart';
import '../../../../reusable_widgets/app_button.dart';
import '../../../../reusable_widgets/custom_appbar.dart';
import '../../../../reusable_widgets/progress_indicator.dart';

class BookFamilyAppointment extends StatelessWidget {
  const BookFamilyAppointment({Key? key}) : super(key: key);


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
                            child: InkWell(
                                onTap: () async {
                                  var data = await Get.to(() => const SelectFamilyMember());
                                  if (data != null && data is Map<String, dynamic>) {
                                    controller.familyMemberC.text = data["cnic_bform"];
                                    controller.nameC.text = data["name"];
                                  }
                                },
                                child: TextFormField(
                                    validator: (category) {
                                      if (category!.isEmpty) {
                                        return "Select Family Member";
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: controller.nameC,
                                    enabled: false,
                                    decoration: InputDecoration(
                                        labelText:
                                        "Patient Name",
                                        hintText: "Tap to Select Family Member",
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
                                  controller: controller.familyMemberC,
                                  validator: (title) {
                                    if (title!.isEmpty) {
                                      return "Enter Patient CNIC";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Patient CNIC/B-Form #",
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
                                  // onTap: () async {
                                  //   var data = await Get.to(
                                  //           () => const SelectHospital());
                                  //   controller.hospitalIdC.text = data;
                                  // },
                                  onTap: () async {
                                    var data = await Get.to(() => const SelectHospital());
                                    if (data != null && data is Map<String, dynamic>) {
                                      controller.hospitalNameC.text = data["hostpitalName"];
                                      controller.hospitalIdC.text = data["hospitalId"];
                                    }
                                  },
                                  child: TextFormField(
                                      validator: (category) {
                                        if (category!.isEmpty) {
                                          return "Select Hospital";
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: controller.hospitalNameC,
                                      enabled: false,
                                      decoration: InputDecoration(
                                          labelText:
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
                                      labelText: AppStrings.PHONE,
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
                                      labelText: "Vaccine Name",
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
                              validator: (price) {
                                if (price!.isEmpty) {
                                  return "Enter date of appointment";
                                } else {
                                  return null;
                                }
                              },
                              onTap: () {
                                // Show date picker when the text field is tapped
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2024),
                                ).then((selectedDate) {
                                  // Update the text field's value with the selected date
                                  if (selectedDate != null) {
                                    controller.appointmentDate.text = DateFormat('dd/MM/yyyy').format(selectedDate);
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                labelText: "Appointment Date",
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
                          label: "Book Now",
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
