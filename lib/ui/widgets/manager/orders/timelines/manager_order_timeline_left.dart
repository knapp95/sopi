import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sopi/common/scripts.dart';

class ManagerOrderTimelineLeft extends StatefulWidget {
  @override
  _ManagerOrderTimelineLeftState createState() =>
      _ManagerOrderTimelineLeftState();
}

class _ManagerOrderTimelineLeftState extends State<ManagerOrderTimelineLeft> {
  Timer _timer;
  bool _isInit = true;
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (_isInit) {
      _isInit = false;
      _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    }
  }

  void _getTime() {
    setState(() {
      now = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ..._buildTimelineBeforeNow(),
        Container(color: Colors.red, child: _buildSingleTime(now)),
        ..._buildTimelineAfterNow(),
      ],
    );
  }

  Widget _buildSingleTime(DateTime time) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        formatDateToString(
          time,
          format: 'HH:mm',
        ),
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  List<Widget> _buildTimelineBeforeNow() {
    DateTime maxBeforeNowDate = DateTime(now.year, now.month, now.day,
        now.hour - 1, now.minute, now.second, now.millisecond, now.microsecond);
    List<Widget> timelineBeforeNow = [];
    while (now.isAfter(maxBeforeNowDate)) {
      timelineBeforeNow.add(_buildSingleTime(maxBeforeNowDate));
      maxBeforeNowDate = maxBeforeNowDate.add(Duration(minutes: 10));
    }
    return timelineBeforeNow;
  }

  List<Widget> _buildTimelineAfterNow() {
    DateTime maxBeforeAfterDate = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour + 3,
      now.minute + 30,
    );
    DateTime nowTmp = now;
    List<Widget> timelineAfterNow = [];
    while (nowTmp.isBefore(maxBeforeAfterDate)) {
      nowTmp = nowTmp.add(Duration(minutes: 10));
      timelineAfterNow.add(_buildSingleTime(nowTmp));
    }
    return timelineAfterNow;
  }
}
