import 'package:sopi/common/scripts.dart';

/// In feature can be configured by user
class AssetTimelineSettings {
  static const differenceInMinutes = 15;
  static const rangeHoursForwards = 3;
  static const rangeHoursBackwards = 1;

  static DateTime get availableStartTimeline {
    DateTime availableStartTimeline = DateTime(
      roundingNow.year,
      roundingNow.month,
      roundingNow.day,
      roundingNow.hour - AssetTimelineSettings.rangeHoursBackwards,
      roundingNow.minute,
    );
    return availableStartTimeline;
  }

  static DateTime get availableEndTimeline {
    DateTime availableEndTimeline = DateTime(
      roundingNow.year,
      roundingNow.month,
      roundingNow.day,
      roundingNow.hour + AssetTimelineSettings.rangeHoursForwards,
      roundingNow.minute,
    );
    return availableEndTimeline;
  }
}
