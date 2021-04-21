import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sopi/models/generic/generic_response_model.dart';
import 'package:sopi/ui/widgets/common/notifications/bottom_notification.dart';
import 'package:get/get.dart';

bool containsIgnoreCase(String string1, String string2) {
  return string1?.toLowerCase()?.contains(string2?.toLowerCase());
}

Future<void> showBottomNotification(
    BuildContext context, GenericResponseModel responseMessage) async {
  try {
    ScaffoldMessenger.of(Get.context).hideCurrentSnackBar();
    ScaffoldMessenger.of(Get.context).showSnackBar(
      BottomNotification(responseMessage).build(context),
    );
  } catch (e) {
    throw e;
  }
}

String getNotEmptyValue(String value) {
  if (value != null) {
    return value;
  }
  return '';
}

bool isNullOrEmpty(dynamic object) {
  return object == null || object.isEmpty;
}

String fixedDouble(double value, [fractionDigits = 2]) {
  String fixedDouble = value?.toStringAsFixed(fractionDigits);
  return fixedDouble ?? '0,00';
}

String formatDateToString(DateTime date, {format = 'yyyy-MM-dd'}) {
  String result;
  if (date != null) {
    result = DateFormat(format).format(date);
  }
  return result;
}

String durationInMinutes(Duration duration) {
  if (duration == null) return '';
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes =
      twoDigits((duration.inHours * 60) + duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return '$twoDigitMinutes:$twoDigitSeconds';
}
