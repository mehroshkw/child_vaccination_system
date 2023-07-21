import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_strings.dart';
import '../../auth_controller.dart';
import '../../../../reusable_widgets/app_button.dart';
import '../../../../reusable_widgets/app_textfield.dart';
import '../../../../reusable_widgets/custom_appbar.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController cnicC = TextEditingController();
  final TextEditingController addressC = TextEditingController();
  final TextEditingController phnC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final authController = Get.put(AuthController());
  bool isLoading = false;
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

  Future<void> validate() async {
    if (_formKey.currentState!.validate()) {
      authController.registerUser(
          email: emailC.text.trim(),
          name: nameC.text,
          password: passwordC.text.trim(),
          cnic: cnicC.text,
          address: addressC.text,
          phone: phnC.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:const CustomAppBar(title: AppStrings.CREATE_ACCOUNT),
      body: Obx(() {
        return authController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              CustomTextFormField(
                                controller: nameC,
                                label: AppStrings.FULL_NAME,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.ENTER_NAME;
                                  }
                                  return null;
                                },
                              ),
                              CustomTextFormField(
                                controller: emailC,
                                label: AppStrings.EMAIL,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.ENTER_EMAIL;
                                  } else if (!value.contains("@") ||
                                      !value.contains(".com")) {
                                    return AppStrings.ENTER_VALID_EMAIL;
                                  }
                                  return null;
                                },
                              ),
                              CustomTextFormField(
                                controller: passwordC,
                                label: AppStrings.ENTER_PASSWORD,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password.';
                                  } else if (value.length < 8) {
                                    return 'Password should be at least 8 characters long.';
                                  } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$').hasMatch(value)) {
                                    return 'One uppercase letter, one lowercase letter, and one digit must be used';
                                  }
                                  return null;
                                },
                              ),
                              CustomTextFormField(
                                maxLength: 13,
                                controller: cnicC,
                                label: AppStrings.CNIC,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.ENTER_CNIC;
                                  } else if (value.length > 13 ||
                                      value.length < 13) {
                                    return AppStrings.ENTER_VALID_CNIC;
                                  }
                                  return null;
                                },
                              ),
                              CustomTextFormField(
                                controller: addressC,
                                label: AppStrings.ADDRESS,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.ENTER_ADDRESS;
                                  }
                                  return null;
                                },
                              ),
                              CustomTextFormField(
                                controller: phnC,
                                label: AppStrings.PHONE,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.ENTER_PHONE;
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
                            label: "Register",
                            onPressed: () {
                              validate();
                            },
                            color: AppColors.primaryColor,
                            elevation: 2,
                            borderColor: AppColors.primaryWhite,
                          )),
                      const SizedBox(height: 20,)
                    ],
                  ),
                );
      }),
    );
  }
}
