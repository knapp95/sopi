import 'package:flutter/material.dart';
import 'package:sopi/models/generic/generic_response_model.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';

class BottomNotification extends StatelessWidget {
  final GenericResponseModel responseMessage;

  const BottomNotification(this.responseMessage, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext? context) {
    return SnackBar(
      elevation: defaultElevation,
      backgroundColor: responseMessage.correct ? primaryColor : Colors.red,
      content: Text(
        responseMessage.message!,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      duration: Duration(
        seconds: responseMessage.correct ? 2 : 4,
      ),
    );
  }
}
