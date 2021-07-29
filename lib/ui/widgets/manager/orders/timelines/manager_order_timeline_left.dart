import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/models/assets/asset_model.dart';
import 'package:sopi/models/assets/timeline/asset_timeline_settings_model.dart';
import 'package:sopi/ui/shared/app_colors.dart';

enum Timeline { before, after }

class ManagerOrderTimelineLeft extends StatelessWidget {
  ManagerOrderTimelineLeft(this._time, {Key? key}) : super(key: key);
  final DateTime _time;
  final AssetTimelineSettingsModel _assetTimelineSettingsModel =
      Provider.of<AssetModel>(Get.context!).assetTimelineSettings!;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        top: 52,
        right: 8,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ..._buildTimeline(Timeline.before),
          Container(
            color: primaryColor,
            child: _buildSingleTime(
              _time,
              Colors.white,
            ),
          ),
          ..._buildTimeline(Timeline.after),
        ],
      ),
    );
  }

  Widget _buildSingleTime(DateTime time, [Color? fontColor]) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: primaryColor),
          left: BorderSide(color: primaryColor),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          formatDateToString(
            time,
            format: 'HH:mm',
          ),
          style: TextStyle(
            color: fontColor ?? Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTimeline(Timeline timeline) {
    DateTime time = timeline == Timeline.before
        ? _assetTimelineSettingsModel.availableStartTimeline
        : _assetTimelineSettingsModel.availableEndTimeline;

    DateTime nowTmp = _time;
    final List<Widget> timelineWidgets = [];
    if (timeline == Timeline.before) {
      while (nowTmp.isAfter(time)) {
        timelineWidgets.add(_buildSingleTime(time));
        time = time.add(
            Duration(minutes: _assetTimelineSettingsModel.differenceInMinutes));
      }
    } else if (timeline == Timeline.after) {
      while (nowTmp.isBefore(time)) {
        nowTmp = nowTmp.add(
            Duration(minutes: _assetTimelineSettingsModel.differenceInMinutes));
        timelineWidgets.add(_buildSingleTime(nowTmp));
      }
    }
    return timelineWidgets;
  }
}
