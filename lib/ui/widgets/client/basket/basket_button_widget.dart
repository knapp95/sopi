import 'package:flutter/material.dart';
import 'package:sopi/ui/shared/app_colors.dart';

class BasketButtonWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final Color color;
  final Color backgroundColor;
  final Function? onPressedHandler;

  const BasketButtonWidget(this.title, this.subTitle,
      {this.color = Colors.black,
      this.backgroundColor = primaryColor,
      this.onPressedHandler,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(backgroundColor: backgroundColor),
      onPressed: onPressedHandler as void Function()?,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: color),
          ),
          Text(subTitle, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
