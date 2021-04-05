import 'package:flutter/material.dart';
import 'package:sopi/ui/shared/shared_styles.dart';
class AssetEmployeeUnassignedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: Colors.white,
      shape: shapeDialogRed,
      elevation: defaultElevation,
      avatar: ClipOval(
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(
            Icons.warning,
            color: Colors.red,
          ),
        ),
      ),
      label: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Not assigned employee',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
