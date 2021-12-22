import 'package:flutter/material.dart';
import 'package:phyllo_connect_example/constants/app_colors.dart';

class Loader extends StatelessWidget {
  final bool isBackground;
  final bool visible;
  final bool isExpanded;

  const Loader(
      {Key? key,
      this.isBackground = false,
      this.visible = true,
      this.isExpanded = false})
      : super(key: key);

  factory Loader.loading() => const Loader();

  factory Loader.loadingWithBackground(bool visible,
          {bool isBackground = true, bool isExpanded = true}) =>
      Loader(
          isBackground: isBackground, visible: visible, isExpanded: isExpanded);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Visibility(
      visible: visible,
      child: Center(
        child: Container(
          height: isExpanded ? size.height : 80,
          width: isExpanded ? size.width : 80,
          color:
              isBackground ? Colors.white.withOpacity(0.4) : Colors.transparent,
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
            ),
          ),
        ),
      ),
    );
  }
}
