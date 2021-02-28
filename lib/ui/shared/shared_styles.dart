import 'package:flutter/material.dart';
import 'package:get/get.dart';

const RoundedRectangleBorder shapeDialog = const RoundedRectangleBorder(
  borderRadius: const BorderRadius.all(
    Radius.circular(8.0),
  ),
);

/// SIZED BOX
const SizedBox formSizedBoxHeight = SizedBox(height: 10);
const SizedBox formSizedBoxWidth = SizedBox(width: 10);

FlatButton cancelDialogButton = FlatButton(
  child: Text(
    'Cancel',
  ),
  onPressed: () => Get.back(),
);
