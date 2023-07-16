import 'package:child_vaccination_system/reusable_widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../controllers/auth_controller.dart';
import '../../../reusable_widgets/app_button.dart';
import '../../../reusable_widgets/app_textfield.dart';
import '../../../reusable_widgets/custom_appbar.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  final authController = Get.put(AuthController());

  Future<void> validate() async {
    if (_formKey.currentState!.validate()) {
      authController.adminLogin(email: emailC.text.trim(), password: passwordC.text.trim(), context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: const CustomAppBar(title: "Admin Login"),
        body: Obx(() {
          return authController.isAdminLogin.value
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              CustomTextFormField(
                                controller: emailC,
                                label: AppStrings.USER_EMAIL,
                                keyboardType: TextInputType.emailAddress,
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
                              ),
                              CustomTextFormField(
                                controller: passwordC,
                                label: AppStrings.USER_PASSWORD,
                                keyboardType: TextInputType.text,
                                validator: (pin) {
                                  if (pin!.isEmpty) {
                                    return AppStrings.ENTER_PASSWORD;
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ],
                          )),
                      SizedBox(
                          height: 45,
                          width: width / 1.3,
                          child: AppButton(
                            label: AppStrings.LOGIN,
                            onPressed: () {
                              validate();
                            },
                            color: AppColors.primaryColor,
                            elevation: 2,
                            borderColor: AppColors.primaryWhite,
                          ))
                    ]);
        }));
  }
}
