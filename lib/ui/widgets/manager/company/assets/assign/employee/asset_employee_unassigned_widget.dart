import 'package:flutter/material.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';

class AssetEmployeeUnassignedWidget extends StatelessWidget {
  const AssetEmployeeUnassignedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Chip(
        backgroundColor: Colors.white,
        shape: shapeDialogRed,
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
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Not assigned employee',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
