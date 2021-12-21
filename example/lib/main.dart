import 'package:flutter/material.dart';
import 'package:phyllo_connect_example/constants/app_colors.dart';
import 'package:phyllo_connect_example/views/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Phyllo Connect Example',
      theme: _getThemeData(),
      home: const MyHomePage(),
    );
  }

  ThemeData _getThemeData() {
    return ThemeData(
      primaryColor: AppColors.primary,
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      splashColor: Colors.white.withOpacity(0.2),
      highlightColor: Colors.white.withOpacity(0.2),
      unselectedWidgetColor: Colors.grey.shade400,
      checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(width: 1, color: Colors.grey.shade400),
        ),
      ),
      colorScheme:
          ColorScheme.fromSwatch(primarySwatch: generateMaterialColor())
              .copyWith(secondary: AppColors.primary),
    );
  }
}
