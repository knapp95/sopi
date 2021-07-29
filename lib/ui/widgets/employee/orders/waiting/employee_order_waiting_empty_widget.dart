import 'package:flutter/material.dart';

class EmployeeOrderWaitingEmptyWidget extends StatelessWidget {
  const EmployeeOrderWaitingEmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: null,
        icon: const Icon(Icons.calendar_today),
        label: const Text('Empty prepare orders schedule.'),
      ),
    );
  }
}
