import 'package:flutter/material.dart';
import 'package:sopi/models/user/user_model.dart';

class AssetEmployeeWidget extends StatelessWidget {
  final UserModel employee;

  AssetEmployeeWidget(this.employee);

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: Colors.white,
      avatar: ClipOval(
        child: SizedBox(
          width: 40,
          height: 40,
          child: Image.network(
            employee.profilePhoto!,
            fit: BoxFit.cover,
          ),
        ),
      ),
      label: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(employee.username!),
      ),
    );
  }
}
