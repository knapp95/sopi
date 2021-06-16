import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/models/assets/asset_timeline_settings.dart';

class ManagerOrderTimelineLeft extends StatefulWidget {
  @override
  _ManagerOrderTimelineLeftState createState() =>
      _ManagerOrderTimelineLeftState();
}

enum Timeline { BEFORE, AFTER }

class _ManagerOrderTimelineLeftState extends State<ManagerOrderTimelineLeft> {
  late Timer _timer;
  bool _isInit = true;
  DateTime now = roundingNow;

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
      now = roundingNow;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        top: 58,
        right: 8,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ..._buildTimeline(Timeline.BEFORE),
          Container(color: Colors.red, child: _buildSingleTime(now)),
          ..._buildTimeline(Timeline.AFTER),
        ],
      ),
    );
  }

  Widget _buildSingleTime(DateTime time) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        formatDateToString(
          time,
          format: 'HH:mm',
        )!,
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  List<Widget> _buildTimeline(Timeline timeline) {
    DateTime time = timeline == Timeline.BEFORE
        ? AssetTimelineSettings.availableStartTimeline
        : AssetTimelineSettings.availableEndTimeline;
    DateTime nowTmp = now;
    List<Widget> timelineWidgets = [];
    if (timeline == Timeline.BEFORE) {
      while (nowTmp.isAfter(time)) {
        timelineWidgets.add(_buildSingleTime(time));
        time = time
            .add(Duration(minutes: AssetTimelineSettings.differenceInMinutes));
      }
    } else if (timeline == Timeline.AFTER) {
      while (nowTmp.isBefore(time)) {
        nowTmp = nowTmp
            .add(Duration(minutes: AssetTimelineSettings.differenceInMinutes));
        timelineWidgets.add(_buildSingleTime(nowTmp));
      }
    }
    return timelineWidgets;
  }
}
