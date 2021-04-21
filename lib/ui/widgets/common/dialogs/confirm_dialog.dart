import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';

class ConfirmDialog extends StatelessWidget {
  final String content;

  ConfirmDialog(this.content);

  Future<void> _submit() async {
    Get.back(result: true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: shapeDialog,
      elevation: defaultElevation,
      title: Text('Question'),
      content: Text(content),
      actions: [
        backDialogButton,
        TextButton(
          onPressed: _submit,
          child: Text(
            'Confirm',
            style: TextStyle(color: primaryColor),
          ),
        ),
      ],
    );
  }
}
