import 'package:flutter/material.dart';
import 'package:get/get.dart';

showScaleDialog(Widget dialog) {
  return showGeneralDialog(
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: dialog,
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 200),
    context: Get.context!,
    // ignore: missing_return
    pageBuilder: (_, __, ___) {
      return dialog;
    },
  );
}
