import 'package:flutter/material.dart';

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
      content: content != null
          ? Text(
              content,
            )
          : null,
      actions: [
        FlatButton(
          child: Text(
            'Close',
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),

      ],
    );
  }
}
