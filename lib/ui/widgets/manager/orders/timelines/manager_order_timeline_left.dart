import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/models/assets/asset_model.dart';
import 'package:sopi/models/assets/timeline/asset_timeline_settings_model.dart';

enum Timeline { BEFORE, AFTER }

class ManagerOrderTimelineLeft extends StatelessWidget {
  final DateTime _time;
  final AssetTimelineSettingsModel _assetTimelineSettingsModel =
      Provider.of<AssetModel>(Get.context!).assetTimelineSettings!;

  ManagerOrderTimelineLeft(this._time);

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
          Container(color: Colors.red, child: _buildSingleTime(_time)),
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
        ),
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  List<Widget> _buildTimeline(Timeline timeline) {
    DateTime time = timeline == Timeline.BEFORE
        ? _assetTimelineSettingsModel.availableStartTimeline
        : _assetTimelineSettingsModel.availableEndTimeline;

    DateTime nowTmp = _time;
    List<Widget> timelineWidgets = [];
    if (timeline == Timeline.BEFORE) {
      while (nowTmp.isAfter(time)) {
        timelineWidgets.add(_buildSingleTime(time));
        time = time.add(
            Duration(minutes: _assetTimelineSettingsModel.differenceInMinutes));
      }
    } else if (timeline == Timeline.AFTER) {
      while (nowTmp.isBefore(time)) {
        nowTmp = nowTmp.add(
            Duration(minutes: _assetTimelineSettingsModel.differenceInMinutes));
        timelineWidgets.add(_buildSingleTime(nowTmp));
      }
    }
    return timelineWidgets;
  }
}
