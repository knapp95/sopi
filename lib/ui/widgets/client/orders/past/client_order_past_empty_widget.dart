import 'package:flutter/material.dart';

class ClientOrderPastEmptyWidget extends StatelessWidget {
  const ClientOrderPastEmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: null,
        icon: const Icon(Icons.calendar_today),
        label: const Text('Empty past orders list.'),
      ),
    );
  }
}
