import 'package:flutter/material.dart';
import 'package:sopi/models/generic/generic_response_model.dart';
import 'package:sopi/widgets/notifications/bottom_notification.dart';

bool containsIgnoreCase(String string1, String string2) {
  return string1?.toLowerCase()?.contains(string2?.toLowerCase());
}

Future<void> showBottomNotification(
    BuildContext context, GenericResponseModel responseMessage) async {
  Scaffold.of(context, nullOk: true)?.hideCurrentSnackBar();
  Scaffold.of(context, nullOk: true)?.showSnackBar(
    BottomNotification(responseMessage).build(context),
  );
}
