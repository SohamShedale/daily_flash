import 'package:daily_flash/core/theme/app_colors.dart';
import 'package:daily_flash/core/theme/app_textstyles.dart';
import 'package:flutter/material.dart';

class AppName extends StatelessWidget {
  const AppName({super.key, this.isCenter = true});
  final bool isCenter;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Text('Daily', style: AppTextStyles.appName),
        Text('Flash', style: AppTextStyles.appName.copyWith(color: AppColors.blue)),
      ],
    );
  }
}
