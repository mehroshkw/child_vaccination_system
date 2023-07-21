import 'package:child_vaccination_system/views/modules/parent_module/child/add_child/add_family_member_controller.dart';
import 'package:child_vaccination_system/reusable_widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_strings.dart';
import 'update_child_controller.dart';
import '../../../../../reusable_widgets/app_button.dart';
import '../../../../../reusable_widgets/custom_appbar.dart';
import '../../../../../reusable_widgets/progress_indicator.dart';

class UpdateChild extends StatefulWidget {
  final String genderC;
  final String id;
  final String dobC;
  final String relationshipC;
  final String addressC;
  final String nameC;
  final String cnic_bFormC;

   UpdateChild({Key? key, required this.genderC, required this.dobC, required this.relationshipC, required this.addressC, required this.nameC, required this.cnic_bFormC, required this.id}) : super(key: key);

  @override
  State<UpdateChild> createState() => _UpdateChildState();
}

class _UpdateChildState extends State<UpdateChild> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(UpdateChildController());


@override
  void initState() {
  controller.genderC.text = widget.genderC;
  controller.dobC.text = widget.dobC;
  controller.relationshipC.text = widget.relationshipC;
  controller.addressC.text = widget.addressC;
  controller.nameC.text = widget.nameC;
  controller.cnic_bFormC.text = widget.cnic_bFormC;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: const CustomAppBar(title: "Update Family"),
        body: Obx(() {
          return controller.isLoading.value
              ? const Center(child: LoaderWidget())
              : SingleChildScrollView(
              child: Column(children: [
                Form(
                    key: _formKey,
                    child: Column(children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                              controller: controller.nameC,
                              validator: (title) {
                                if (title!.isEmpty) {
                                  return "Enter Full Name";
                                } else {
                                  return null;
                                }
                              },
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  hintText: "Full Name",
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
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppStrings.ENTER_ADDRESS;
                              } else {
                                return null;
                              }
                            },
                            controller: controller.addressC,
                            decoration: InputDecoration(
                                hintText: "Add Address",
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: AppColors.primaryGreyColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: AppColors.primaryColor),
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.datetime,
                          textInputAction: TextInputAction.next,
                          controller: controller.dobC,
                          readOnly: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter date of birth of family member";
                            } else {
                              return null;
                            }
                          },
                          onTap: () {
                            // Show date picker when the text field is tapped
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1990),
                              lastDate: DateTime.now(),
                            ).then((selectedDate) {
                              // Update the text field's value with the selected date
                              if (selectedDate != null) {
                                controller.dobC.text = DateFormat('dd/MM/yyyy').format(selectedDate);
                              }
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "dd/mm/yyyy",
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
                                return "Enter CNIC/B-form number of the family member";
                              } else {
                                return null;
                              }
                            },
                            controller: controller.cnic_bFormC,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            maxLength: 13,
                            decoration: InputDecoration(
                                hintText: "CNIC/B-form Number",
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: AppColors.primaryGreyColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: AppColors.primaryColor),
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          )),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: AppText(text: "Select Gender", color: AppColors.primaryVariant,)),
                      ),
                      Row(
                          children: [
                            SizedBox(
                              width: size.width/2,
                              child: RadioListTile(
                                title: const Text('Male'),
                                value: 'Male',
                                activeColor: AppColors.primaryColor,
                                groupValue: controller.gender.value,
                                onChanged: (value) {
                                  controller.setGender(value!);
                                },
                              ),
                            ),
                            SizedBox(
                              width: size.width/2,
                              child: RadioListTile(
                                title: const Text('Female'),
                                value: 'Female',
                                activeColor: AppColors.primaryColor,
                                groupValue: controller.gender.value,
                                onChanged: (value) {
                                  controller.setGender(value!);
                                },
                              ),
                            ),
                          ]
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: AppText(
                              text: "Select Relationship",
                              color: AppColors.primaryVariant,
                            )),
                      ),
                      Row(children: [
                        SizedBox(
                          width: size.width / 2,
                          child: RadioListTile(
                            title: const Text('Son'),
                            value: 'Son',
                            activeColor: AppColors.primaryColor,
                            groupValue: controller.relationship.value,
                            onChanged: (value) {
                              controller.setRelationship(value!);
                            },
                          ),
                        ),
                        SizedBox(
                          width: size.width / 2,
                          child: RadioListTile(
                            title: const Text('Daughter'),
                            value: 'Daughter',
                            activeColor: AppColors.primaryColor,
                            groupValue: controller.relationship.value,
                            onChanged: (value) {
                              controller.setRelationship(value!);
                            },
                          ),
                        ),
                      ]),
                    ])),
                SizedBox(
                    width: size.width * 0.6,
                    child: AppButton(
                      label: "Upload",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          controller.updateInFirestore(widget.id);
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
