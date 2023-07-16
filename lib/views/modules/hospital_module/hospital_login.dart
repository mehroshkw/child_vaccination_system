import 'package:child_vaccination_system/reusable_widgets/app_text.dart';
import 'package:child_vaccination_system/views/modules/admin_module/add_hospital.dart';
import 'package:child_vaccination_system/views/modules/parent_module/login_sign_up/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../controllers/auth_controller.dart';
import '../../../reusable_widgets/app_button.dart';
import '../../../reusable_widgets/app_textfield.dart';
import '../../../reusable_widgets/custom_appbar.dart';

class HospitalLoginScreen extends StatefulWidget {
  static const String route = '/hospital_login_screen';

  const HospitalLoginScreen({Key? key}) : super(key: key);

  @override
  State<HospitalLoginScreen> createState() => _HospitalLoginScreenState();
}

class _HospitalLoginScreenState extends State<HospitalLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  final authController = Get.put(AuthController());

  Future<void> validate() async {
    if (_formKey.currentState!.validate()) {
      authController.hospitalLogin(
          email: emailC.text.trim(), password: passwordC.text.trim(), context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: const CustomAppBar(title: "Hospital Login"),
        body: Obx(() {
          return authController.isHospitalLogin.value
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
                          label: 'Hospital Email',
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
                          }
                        ),
                        CustomTextFormField(
                          controller: passwordC,
                          label: 'Password',
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
                    height: 50,
                    width: width / 1.3,
                    child: AppButton(
                      label: AppStrings.LOGIN,
                      onPressed: () {
                        validate();
                      },
                      color: AppColors.primaryColor,
                      elevation: 2,
                      borderColor: AppColors.primaryWhite,
                    )),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  const AppText(
                      text: "Don't Have a Registered Hospital?", color: AppColors.textColor),
                  TextButton(onPressed: ()=> Get.to(const AddHospitalScreen()), child: const AppText(text: "Register Now", color: AppColors.primaryColor,))
                ])
              ]);
  } )
    );
  }
}
