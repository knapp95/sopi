import 'package:flutter/material.dart';

class OrderNoAvailableWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white10,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, color: Colors.black12),
            SizedBox(width: 10),
            Text(
              'No upcoming orders scheduled',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black12),
            ),
          ],
        ),
      ),
    );
  }
}
