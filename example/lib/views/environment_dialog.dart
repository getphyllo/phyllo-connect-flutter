import 'package:flutter/material.dart';
import 'package:phyllo_connect_example/constants/app_colors.dart';
import 'package:phyllo_connect_example/constants/environment.dart';
import 'package:phyllo_connect_example/views/primary_button.dart';

Future<Environment?> showEnvironmentChangeDialog(
    BuildContext context, Environment environment) async {
  List<Environment> environments = Environment.values;

  Environment selectedEnvironment = environment;

  return await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        elevation: 0,
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5, left: 10, bottom: 12),
                    child: Text(
                      'Change Environment',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Column(
                    children: List.generate(environments.length, (index) {
                      var type = environments[index];
                      var selected = type == selectedEnvironment;
                      return RadioListTile(
                        value: type,
                        dense: true,
                        groupValue: selectedEnvironment,
                        contentPadding: EdgeInsets.zero,
                        activeColor: AppColors.primaryColor,
                        title: Text(
                          type.environment.name.toCapitalize(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color:
                                selected ? AppColors.primaryColor : Colors.black54,
                          ),
                        ),
                        selected: selected,
                        onChanged: (value) {
                          setState(() {
                            selectedEnvironment = value as Environment;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DialogButton(
                        label: 'Cancel',
                        backgroundColor: Colors.white,
                        color: AppColors.primaryColor,
                        onPressed: () {
                          Navigator.pop(context, null);
                        },
                      ),
                      const SizedBox(width: 15),
                      DialogButton(
                        label: 'Submit',
                        onPressed: () {
                          Navigator.pop(context, selectedEnvironment);
                        },
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

extension StringExtension on String {
  String toCapitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
