import 'package:flutter/material.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';

class ColorBoxWidget extends StatelessWidget {
  final Color color;
  final String? label;

  ColorBoxWidget(this.color, [this.label]);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getBoxDecoration(color),
      width: 50,
      height: 50,
      child: this.label != null
          ? Center(
              child: Text(
                this.label ?? '',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            )
          : null,
    );
  }
}
