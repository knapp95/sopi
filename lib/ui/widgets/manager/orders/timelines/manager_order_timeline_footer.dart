import 'package:flutter/material.dart';
class ManagerOrderTimelineFooter extends StatelessWidget {
  final String name;
  final String iconPath;

  ManagerOrderTimelineFooter(this.name, this.iconPath);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Image.asset(
          'assets/images/$iconPath',
        ),
      ),
    );
  }
}
