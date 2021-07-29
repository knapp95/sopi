import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';

class ConfirmDialog extends StatelessWidget {
  final String content;

  const ConfirmDialog(this.content, {Key? key}) : super(key: key);

  Future<void> _submit() async {
    Get.back(result: true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: shapeDialog,
      elevation: defaultElevation,
      title: const Text('Question'),
      content: Text(content),
      actions: [
        backDialogButton,
        submitDialogButton(_submit),
      ],
    );
  }
}
