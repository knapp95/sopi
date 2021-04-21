import 'package:flutter/material.dart';

class EmployeeOrderWaitingEmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: null,
        icon: Icon(Icons.calendar_today),
        label: Text('Empty prepare orders schedule.'),
      ),
    );
  }
}
