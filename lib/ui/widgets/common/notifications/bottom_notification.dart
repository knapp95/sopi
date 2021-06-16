import 'package:flutter/material.dart';
import 'package:sopi/models/generic/generic_response_model.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';

class BottomNotification extends StatelessWidget {
  final GenericResponseModel responseMessage;

  BottomNotification(this.responseMessage);

  @override
  Widget build(BuildContext? context) {
    return SnackBar(
      elevation: defaultElevation,
      backgroundColor: responseMessage.correct ? primaryColor : Colors.red,
      content: Container(
        child: Text(
          responseMessage.message!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      duration: Duration(
        seconds: responseMessage.correct ? 2 : 4,
      ),
    );
  }
}
