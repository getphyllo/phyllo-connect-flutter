import 'package:flutter/material.dart';
import 'package:phyllo_connect_example/constants/app_colors.dart';

class AppButton extends StatelessWidget {
  final String label;
  final double height;
  final double? width;
  final VoidCallback onPressed;

  const AppButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.height = 48,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    return MaterialButton(
      child: Text(
        label,
        style: const TextStyle(fontSize: 15, letterSpacing: 0.5),
      ),
      elevation: 0,
      textColor: Colors.white,
      color: AppColors.primary,
      highlightElevation: 0,
      height: height,
      minWidth: width ?? mq.size.width,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onPressed: onPressed,
    );
  }
}
