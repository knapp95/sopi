import 'package:json_annotation/json_annotation.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/models/assets/timeline/asset_timeline_settings_default_model.dart';
import 'package:sopi/services/settings/settings_service.dart';

part 'asset_timeline_settings_model.g.dart';

@JsonSerializable()
class AssetTimelineSettingsModel {
  static const id = 'timeline';
  final _settingsService = SettingsService.singleton;
  int? selectedDifferenceInMinutes;
  double? selectedRangeForwards;
  double? selectedRangeBackwards;

  int get differenceInMinutes =>
      selectedDifferenceInMinutes ??
      AssetTimelineSettingsDefaultModel.differenceInMinutes;

  double get rangeForwards =>
      selectedRangeForwards ?? AssetTimelineSettingsDefaultModel.rangeForwards;

  double get rangeBackwards =>
      selectedRangeBackwards ??
      AssetTimelineSettingsDefaultModel.rangeBackwards;

  AssetTimelineSettingsModel();

  factory AssetTimelineSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AssetTimelineSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetTimelineSettingsModelToJson(this);

  DateTime getRangeDate(double range) {
    final int flooredValue = range.floor();
    final double decimalValue = range - flooredValue;
    final DateTime now = DateTime.now();
    final DateTime rangeDate = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour + flooredValue,
      now.minute + (decimalValue * 60).toInt(),
    );
    return getRoundingTime(sourceDate: rangeDate);
  }

  DateTime get availableStartTimeline => getRangeDate(rangeBackwards);

  DateTime get availableEndTimeline => getRangeDate(rangeForwards);

  Future<void> update({
    int? selectedDifferenceInMinutes,
    double? selectedRangeForwards,
    double? selectedRangeBackwards,
  }) async {
    this.selectedDifferenceInMinutes = selectedDifferenceInMinutes;
    this.selectedRangeForwards = selectedRangeForwards;
    this.selectedRangeBackwards = selectedRangeBackwards;
    final data = toJson();
    await _settingsService.updateDoc(AssetTimelineSettingsModel.id, data);
  }
}
