import 'package:flutter/material.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';

class ColorBoxWidget extends StatelessWidget {
  final Color color;
  final String? label;

  const ColorBoxWidget(this.color, [this.label, Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getBoxDecoration(color),
      width: 50,
      height: 50,
      child: label != null
          ? Center(
              child: Text(
                label ?? '',
                style: const TextStyle(fontSize: 30, color: Colors.white),
              ),
            )
          : null,
    );
  }
}
