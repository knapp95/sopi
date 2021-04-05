import 'package:flutter/material.dart';
import 'package:sopi/models/user/user_model.dart';
import 'package:sopi/ui/shared/shared_styles.dart';

class AssetEmployeeWidget extends StatelessWidget {
  final UserModel employee;
  final Function onDeleteHandler;

  AssetEmployeeWidget(this.employee, {this.onDeleteHandler});

  @override
  Widget build(BuildContext context) {
    return Chip(
      deleteIconColor: Colors.red,
      onDeleted:
          onDeleteHandler != null ? () => onDeleteHandler(employee.uid) : null,
      backgroundColor: Colors.white,
      shape: shapeDialog,
      elevation: defaultElevation,
      avatar: ClipOval(
        child: SizedBox(
          width: 46,
          height: 46,
          child: Image.network(
            employee.profilePhoto,
            fit: BoxFit.cover,
          ),
        ),
      ),
      label: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(employee.username),
      ),
    );
  }
}
