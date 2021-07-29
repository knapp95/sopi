import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmployeeOrderProcessingEmptyWidget extends StatelessWidget {
  final IconData icon;
  final String statusLabel;

  const EmployeeOrderProcessingEmptyWidget(
      {this.icon = Icons.calendar_today,
      this.statusLabel = 'No processing order',
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(child: Lottie.asset('assets/animations/lazy_cat.json')),
          Text(
            statusLabel,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black12),
          ),
        ],
      ),
    );
  }
}
