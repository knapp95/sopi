import 'package:flutter/material.dart';
import 'package:sopi/models/generic/generic_response_model.dart';
import 'package:sopi/ui/widgets/common/notifications/bottom_notification.dart';
import 'package:get/get.dart';

bool containsIgnoreCase(String string1, String string2) {
  return string1?.toLowerCase()?.contains(string2?.toLowerCase());
}

Future<void> showBottomNotification(
    BuildContext context, GenericResponseModel responseMessage) async {
  try {
    Scaffold.of(Get.context, nullOk: true)?.hideCurrentSnackBar();
    Scaffold.of(Get.context, nullOk: true)?.showSnackBar(
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