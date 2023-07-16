import 'package:child_vaccination_system/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  const CustomAppBar(
      {super.key,
        required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18
        ),
      ),
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius:  BorderRadius.vertical(
          bottom:  Radius.circular(30.0),
        ),
      ),
    );
  }
}
