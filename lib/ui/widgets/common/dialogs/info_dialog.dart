import 'package:flutter/material.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/ui/shared/shared_styles.dart';

class InfoDialog extends StatelessWidget {
  final String title;
  final String content;

  InfoDialog({
    this.title,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      content: Text(getNotEmptyValue(content),
      ),
      actions: [
        cancelDialogButton,
      ],
    );
  }
}
