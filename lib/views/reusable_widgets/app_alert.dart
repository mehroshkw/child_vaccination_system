import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'app_heading.dart';

class AppAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;

  const AppAlertDialog({super.key,
    required this.title,
    required this.message,
    this.buttonText = 'OK',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: AppHeading(text: title, textColor: AppColors.primaryColor),
      content: Text(message),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
          ),
          child: Text(
            buttonText,
            style: const TextStyle(
              color: AppColors.primaryWhite,
            ),
          ),
          onPressed: () => {},
        ),
      ],
    );
  }
}
