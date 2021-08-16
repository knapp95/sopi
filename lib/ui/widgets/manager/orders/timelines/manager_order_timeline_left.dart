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
          _buildSingleTime(
            _time,
            true,
          ),
          ..._buildTimeline(Timeline.after),
        ],
      ),
    );
  }

  Widget _buildSingleTime(DateTime time, [bool timeIsNow = false]) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: primaryColor),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          children: [
            Container(
              color: primaryColor,
              width: 15,
              height: 1,
            ),
            Padding(
              padding: timeIsNow
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(right: 12.0),
              child: Row(
                children: [
                  if (timeIsNow)
                    const Icon(Icons.arrow_forward_ios,
                        size: 12, color: primaryColor),
                  Text(
                    formatDateToString(
                      time,
                      format: 'HH:mm',
                    ),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
