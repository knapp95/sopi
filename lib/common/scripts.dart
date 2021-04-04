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
  return value?.toStringAsFixed(fractionDigits);
}

String formatDateToString(DateTime date, {format = 'yyyy-MM-dd'}) {
  String result;
  if (date != null) {
    result = DateFormat(format).format(date);
  }
  return result;
}
