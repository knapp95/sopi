import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ClientOrderProcessingEmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset(
          'assets/animations/thinking_women.json',
        ),
        Text(
          'You don\'t have any order.',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black12),
        ),
      ],
    );
  }
}
