import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppButtonStyle {
  AppButtonStyle._();

  static final elevated = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,

    foregroundColor: Colors.white,

    minimumSize: const Size(double.infinity, 55),

    elevation: 5,

    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  );

  static final outlined = OutlinedButton.styleFrom(
    foregroundColor: AppColors.primary,

    minimumSize: const Size(double.infinity, 55),

    side: const BorderSide(color: AppColors.primary),

    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  );
}
