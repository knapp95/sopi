import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sopi/models/generic/generic_response_model.dart';
import 'package:sopi/ui/widgets/common/notifications/bottom_notification.dart';

bool? containsIgnoreCase(String string1, String string2) {
  return string1.toLowerCase().contains(string2.toLowerCase());
}

Color get randomColor => Color(Random().nextInt(0xffffffff));

DateTime getRoundingTime({DateTime? sourceDate}) {
  final DateTime time = sourceDate ?? DateTime.now();
  late int minuteTmp;
  if (time.minute < 9) {
    minuteTmp = time.minute % 10 < 5 ? 0 : 5;
  } else {
    minuteTmp = int.parse(
        '${firstDigit(time.minute)}${time.minute % 10 < 5 ? '0' : '5'}');
  }
  return DateTime(
    time.year,
    time.month,
    time.day,
    time.hour,
    minuteTmp,
  );
}

int firstDigit(int x) {
  int firstDigit = x;
  while (firstDigit > 9) {
    firstDigit = firstDigit ~/ 10;
  }
  return firstDigit;
}

Future<void> showBottomNotification(
    BuildContext? context, GenericResponseModel responseMessage) async {
  try {
    ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      BottomNotification(responseMessage).build(context) as SnackBar,
    );
  } catch (e) {
    rethrow;
  }
}

String fixedDouble(double? value, [int fractionDigits = 2]) {
  final String? fixedDouble = value?.toStringAsFixed(fractionDigits);
  return fixedDouble ?? '0,00';
}

String formatDateToString(DateTime? date, {String format = 'yyyy-MM-dd'}) {
  String result = '';
  if (date != null) {
    result = DateFormat(format).format(date);
  }
  return result;
}

String durationInMinutes(Duration? duration) {
  if (duration == null) return '';
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  final String twoDigitMinutes =
      twoDigits((duration.inHours * 60) + duration.inMinutes.remainder(60));
  final String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return '$twoDigitMinutes:$twoDigitSeconds';
}

Color getColorFromHash(String hashColor) {
  return Color(int.parse(hashColor.replaceFirst('#', '0xff')));
}
