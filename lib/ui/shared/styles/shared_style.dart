import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sopi/ui/shared/app_colors.dart';

const RoundedRectangleBorder shapeDialog = RoundedRectangleBorder(
  side: BorderSide(color: primaryColor),
  borderRadius: defaultRadius,
);

const RoundedRectangleBorder shapeDialogRed = RoundedRectangleBorder(
    side: BorderSide(color: Colors.red), borderRadius: defaultRadius);

const RoundedRectangleBorder shapeCard = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(16.0),
  ),
);

/// SIZED BOX
const SizedBox formSizedBoxHeight = SizedBox(height: 10);
const SizedBox formSizedBoxWidth = SizedBox(width: 10);

///FONT SIZE
const double fontSize10 = 10;
const double fontSize20 = 20;
const double fontSize40 = 40;

const BorderRadius defaultRadius = BorderRadius.all(Radius.circular(8.0));

/// ELEVATION
const double defaultElevation = 8;

const TextStyle mainTimeStyle =
    TextStyle(fontSize: fontSize20, fontWeight: FontWeight.bold);

TextButton backDialogButton = TextButton(
  onPressed: () => Get.back(),
  child: const Text(
    'Back',
    style: TextStyle(color: primaryColor),
  ),
);

TextButton submitDialogButton(VoidCallback onSubmitHandler) {
  return TextButton(
    onPressed: onSubmitHandler,
    child: const Text(
      'Submit',
      style: TextStyle(color: primaryColor),
    ),
  );
}

BoxDecoration getBoxDecoration(Color color,
    {double withOpacity = 0.7,
    bool all = true,
    double topLeft = 0.0,
    double topRight = 0.0,
    double bottomLeft = 0.0,
    double bottomRight = 0.0}) {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [
        color.withOpacity(withOpacity),
        color,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: all
        ? defaultRadius
        : BorderRadius.only(
            topLeft: Radius.circular(topLeft),
            topRight: Radius.circular(topRight),
            bottomLeft: Radius.circular(bottomLeft),
            bottomRight: Radius.circular(bottomRight),
          ),
  );
}

Container getRoundedSquareButton(int label) {
  return Container(
    width: 30,
    height: 30,
    decoration: getBoxDecoration(Colors.grey),
    child: Center(
      child: Text(
        '$label',
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
