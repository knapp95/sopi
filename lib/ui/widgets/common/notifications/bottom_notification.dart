import 'package:flutter/material.dart';
import 'package:sopi/models/generic/generic_response_model.dart';

class BottomNotification extends StatelessWidget {
  final GenericResponseModel responseMessage;

  BottomNotification(this.responseMessage);

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      backgroundColor: responseMessage.correct ? Colors.blue : Colors.red,
      content: Text(
        responseMessage.message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      duration: Duration(
        seconds: responseMessage.correct ? 2 : 4,
      ),
    );
  }
}
