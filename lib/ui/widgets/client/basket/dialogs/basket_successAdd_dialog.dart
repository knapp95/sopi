import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';

class BasketSuccessAddDialog extends StatelessWidget {
  final int? orderNumber;

  BasketSuccessAddDialog(this.orderNumber);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: shapeDialog,
      elevation: defaultElevation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset('assets/animations/success.json', repeat: false),
          Text(
            'Your\'s order #$orderNumber',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize20,
                color: primaryColor),
          ),
          backDialogButton,
        ],
      ),
    );
  }
}
