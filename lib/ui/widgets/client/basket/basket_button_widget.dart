import 'package:flutter/material.dart';
import 'package:sopi/ui/shared/app_colors.dart';

class BasketButtonWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final Color color;
  final Color backgroundColor;
  final Function onPressedHandler;

  BasketButtonWidget(this.title, this.subTitle,
      {this.color = Colors.black,
      this.backgroundColor = primaryColor,
      this.onPressedHandler});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(backgroundColor: this.backgroundColor),
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
      onPressed: onPressedHandler,
    );
  }
}
