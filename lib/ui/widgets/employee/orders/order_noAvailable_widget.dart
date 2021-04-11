import 'package:flutter/material.dart';

class OrderNoAvailableWidget extends StatelessWidget {
  final IconData icon;
  final String statusLabel;

  OrderNoAvailableWidget({
    this.icon = Icons.calendar_today,
    this.statusLabel = 'No prepare orders schedule',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: null,
        icon: Icon(icon),
        label: Text(statusLabel),
      ),
    );
  }
}
