import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primaryColor = Color.fromRGBO(81, 79, 155, 1);
}

MaterialColor generateMaterialColor([Color color = AppColors.primaryColor]) {
  return MaterialColor(color.value, {
    50: color,
    100: color,
    200: color,
    300: color,
    400: color,
    500: color,
    600: color,
    700: color,
    800: color,
    900: color,
  });
}
